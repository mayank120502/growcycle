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
    if ($mode == 'login') {
        if (defined('AJAX_REQUEST')) {
            if (fn_notification_exists('extra', 'successful_login')) {
                $redirect_url = '';
                if (!empty($_REQUEST['success_return_url'])) {
                    $redirect_url = $_REQUEST['success_return_url'];

                } elseif (!empty($_REQUEST['return_url'])) {
                    $redirect_url = $_REQUEST['return_url'];
                }
                return fn_cp_otp_controller_do_redirect($redirect_url, true);
            }
        }
    }
    return;
}

if ($mode == 'login_form') {
    if (defined('AJAX_REQUEST')) {
        if (!empty($_REQUEST['cp_otp_message'])) {
            fn_cp_otp_display_popup_notification('login');
            exit;
        }
        if (!empty($_REQUEST['is_popup'])) {
            Registry::get('view')->display('views/auth/popup_login_form.tpl');
            exit;
        }
    }
}