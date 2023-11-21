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

class Clickatell extends ASmsService
{
    private $api_url = 'https://platform.clickatell.com/messages/http/send';
    private $api_key = '';
    private $from = '';

    public function __construct($params = array())
    {
        $this->api_key = Registry::get('addons.cp_sms_services.service_clickatell_api_key');
        $this->from = Registry::get('addons.cp_sms_services.service_clickatell_from');
    }

    public function send($phones, $message) 
    {
        if (empty($this->api_key)) {
            return;
        }
        $request = array(
            'apiKey' => $this->api_key,
            'from' => $this->from,
            'to' => $phones,
            'content' => $message
        );
        $response = fn_cp_sms_curl_request($this->api_url, 'GET', $request);

        $response = !empty($response) ? json_decode($response, true) : array();
        if (!empty($response['messages'])) {
            $message = reset($response['messages']);
            if (!empty($message['accepted'])) {
                return true;
            }
        }
        return false;
    }
}