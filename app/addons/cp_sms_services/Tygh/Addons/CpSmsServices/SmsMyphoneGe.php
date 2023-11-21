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


class SmsMyphoneGe extends ASmsService
{
    private $api_url = 'https://sms.myphone.ge/api/v1/sms/send';
    private $api_key = '';

    public function __construct($params = [])
    {
        $this->api_key = Registry::get('addons.cp_sms_services.service_sms_myphone_ge_api_key');
        $this->from = Registry::get('addons.cp_sms_services.service_sms_myphone_ge_from');
        $this->login = Registry::get('addons.cp_sms_services.service_sms_myphone_ge_login');
    }

    public function send($phones, $message)
    {
        if (empty($this->api_key)) {
            return;
        }

        $request = [
            'receivers' => [
                $phones
            ],
            'sender' => $this->from,
            'text' => $message,
            
        ];

        $response = fn_cp_sms_curl_request(
            $this->api_url, 'GET', $request, ['userpwd' => $this->login . ':' . $this->api_key]
        );
        
        $response = !empty($response) ? json_decode($response, true) : [];

        if (!empty($response['data']['messages'][0]['text'])) {
            return true;
        }
        
        return true;
    }
}
