<?php
/*****************************************************************************
*                                                        © 2013 Cart-Power   *
*           __   ______           __        ____                             *
*          / /  / ____/___ ______/ /_      / __ \____ _      _____  _____    *
*      __ / /  / /   / __ `/ ___/ __/_____/ /_/ / __ \ | /| / / _ \/ ___/    *
*     / // /  / /___/ /_/ / /  / /_/_____/ ____/ /_/ / |/ |/ /  __/ /        *
*    /_//_/   \____/\__,_/_/   \__/     /_/    \____/|__/|__/\___/_/         *
*                                                                            *
*                                                                            *
* -------------------------------------------------------------------------- *
* This is commercial software, only users who have purchased a valid license *
* and  accept to the terms of the License Agreement can install and use this *
* program.                                                                   *
* -------------------------------------------------------------------------- *
* website: https://store.cart-power.com                                      *
* email:   sales@cart-power.com                                              *
******************************************************************************/

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }


function fn_cp_sms_send_by_service($phones, $message = '')
{
    if (!function_exists('___cp')) {
        return false;
    }
    $service_name = Registry::get(___cp('YWRkb25zLmXwP3Xtc19zZPJ2aWXlcy5zZPJ2aWXl'));
    if (empty($phones) || empty($message) || empty($service_name)) {
        return false;
    }
    
    $phones = call_user_func(___cp('Zm5fY3Bfc21zP3ByZPBhcmVfcGhvbmVz'), $phones);
    $service_class = 'Tygh\Addons\CpSmsServices\\' . fn_cp_sms_to_camel_case($service_name);
    if (class_exists($service_class)) {
        $params = array();
        $service_object = new $service_class($params);
        $result = $service_object->send($phones, $message);
        return $result;
    }
    return false;
}

function fn_cp_sms_curl_request($url, $type = 'GET', $request = array(), $extra = array())
{
    $ch = curl_init();
    
    if (!empty($extra['connect_timeout'])) {
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $extra['connect_timeout']);
    }
    if (!empty($extra['headers'])) {
        curl_setopt($ch, CURLOPT_HTTPHEADER, $extra['headers']);
    }
    if (!empty($extra['userpwd'])) {
        curl_setopt($ch, CURLOPT_USERPWD, $extra['userpwd']);
    }

    curl_setopt($ch, CURLOPT_REFERER, $_SERVER['HTTP_HOST']);

    if ($type == 'GET') {
        curl_setopt($ch, CURLOPT_HTTPGET, 1);
        if (!empty($request)) {
            $url .= '?' . http_build_query($request);
        }
    } elseif ($type == 'POST') {
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
    } else {
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $type);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
    }

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    $response = curl_exec($ch);
    $error = curl_error($ch);
    
    curl_close($ch);

    if (function_exists('fn_cp_am_log_event')) {
        fn_cp_am_log_event('cp_sms_services', 'api_request', array(
            'request' => $request,
            'response' => $response
        ));
    }
    
    return $response;
}

function fn_cp_sms_to_camel_case($str)
{
    return str_replace('_', '', ucwords($str, '_'));
}

function fn_cp_sms_prepare_phones($phones)
{
    $phones = is_array($phones) ? $phones : explode(',', $phones);
    foreach ($phones as &$phone) {
        $phone = preg_replace('/[^\d]+/', '', $phone);
    }
    return implode(',', $phones);
}
