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

class SmscRu extends ASmsService
{
    private $api_url = 'https://smsc.ru/sys/send.php';
    private $login = '';
    private $psw = '';
    private $sender = '';

    public function __construct($params = array())
    {
        $this->login = Registry::get('addons.cp_sms_services.service_smsc_ru_login');
        $this->psw = Registry::get('addons.cp_sms_services.service_smsc_ru_psw');
        $this->sender = Registry::get('addons.cp_sms_services.service_smsc_ru_from');
    }

    public function send($phones, $message)
    {
        if (empty($this->login) || empty($this->psw)) {
            return;
        }
        $request = array(
            'login' => $this->login,
            'psw' => $this->psw,
            'sender' => $this->sender,
            'phones' => $phones,
            'mes' => $message,
            'fmt' => 3
        );
        $response = fn_cp_sms_curl_request($this->api_url, 'GET', $request);
        $response = !empty($response) ? json_decode($response, true) : array();
        if (empty($response['error'])) {
            return true;
        }
        
        return false;
    }
}