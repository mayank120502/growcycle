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

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    return;
}

if ($mode == 'checkout') {
    if (defined('AJAX_REQUEST') && !empty(Tygh::$app['session']['cart']['user_data']['user_exists'])) {
        $ajax_vars = Tygh::$app['ajax']->getAssignedVars();
        if (!empty($ajax_vars['cp_show_login'])) {
            Tygh::$app['session']['cart']['user_data']['user_exists'] = false;
            fn_delete_notification('default_checkout_exists_popup');
        }
    }
}
if (defined('AJAX_REQUEST') && !empty(Tygh::$app['session']['cart']['user_data']['user_exists'])) {
    if (fn_notification_exists('extra', 'error_checkout_user_exists')) {
        fn_delete_notification('error_checkout_user_exists');
        fn_set_notification('E', __('error'), __('cp_otp_phone_mail_exists'));
    }
}