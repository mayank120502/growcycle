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

use Tygh\Enum\ProductFeatures;

function fn_settings_variants_addons_cp_sms_services_service()
{
    return [
        ''                  => __('none'),
        'smsc_ru'           => 'smsc.ru',
        'smsc_ua'           => 'smsc.ua',
        'sms_ru'            => 'sms.ru',
        'smsaero_ru'        => 'smsaero.ru',
        'clickatell'        => 'clickatell',
        'beeline'           => 'beeline',
        'sms_myphone_ge'    => 'sms.myphone.ge',
        'melipayamak'       => 'melipayamak',
        'twilio'            => 'twilio'
    ];
}