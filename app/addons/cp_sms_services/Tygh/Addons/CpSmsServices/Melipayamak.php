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

namespace Tygh\Addons\CpSmsServices;

use Tygh\Registry;

class Melipayamak extends ASmsService
{
    private $api_url = 'https://rest.payamak-panel.com/api/SendSMS/SendSMS';
    private $login = '';
    private $psw = '';

    public function __construct($params = [])
    {
        $this->login = Registry::get('addons.cp_sms_services.service_melipayamak_login');
        $this->psw = Registry::get('addons.cp_sms_services.service_melipayamak_psw');
    }

    public function send($phones, $message)
    {
        if (empty($this->login) || empty($this->psw)) {
            return;
        }

        $data = [
            'username' => $this->login,
            'password' => $this->psw,
            'to' => $phones,
            'from' => '',
            'text' => $message,
        ];

        $extra['headers'] = [
            'content-type' => 'application/x-www-form-urlencoded'
        ];

        $post_data = http_build_query($data);

        $response = fn_cp_sms_curl_request($this->api_url, 'POST', $post_data, $extra);

        $response = !empty($response) ? json_decode($response, true) : [];

        
        if ($response['RetStatus'] == 1) {
            return true;
        }
        
        return false;
    }
}