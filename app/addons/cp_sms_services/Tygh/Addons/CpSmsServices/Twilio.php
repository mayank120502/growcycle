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

class Twilio extends ASmsService
{
    private $api_url = 'https://api.twilio.com/2010-04-01/Accounts/';
    private $sid = '';
    private $auth_token = '';
    private $messaging_service_sid = '';
    private $from = '';

    public function __construct($params = array())
    {
        $this->sid = Registry::get('addons.cp_sms_services.service_twilio_account_sid');
        $this->auth_token = Registry::get('addons.cp_sms_services.service_twilio_auth_token');
        $this->messaging_service_sid = Registry::get('addons.cp_sms_services.service_twilio_messaging_service_sid');        
        $this->from = Registry::get('addons.cp_sms_services.service_twilio_from');
    }

    public function send($phones, $message) 
    {
        if (empty($this->sid) || empty($this->auth_token)  || empty($this->messaging_service_sid)) {
            return;
        }

        $url = $this->api_url . $this->sid . '/Messages.json';
        $extra['userpwd'] = $this->sid . ':' . $this->auth_token;

        $request = [
            'MessagingServiceSid' => $this->messaging_service_sid,
            'From' => $this->from,
            'To' => '+' . $phones,
            'Body' => $message
        ];

        $post_data = http_build_query($request);

        $response = fn_cp_sms_curl_request($url, 'POST', $post_data, $extra);
        $response = !empty($response) ? json_decode($response, true) : array();
        
        if (!empty($response['status']) && $response['status'] == 'accepted') {
            return true;
        }

        return false;
    }
}