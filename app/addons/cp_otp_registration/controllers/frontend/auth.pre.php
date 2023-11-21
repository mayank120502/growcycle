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
        $user_data = !empty($_REQUEST['user_data']) ? $_REQUEST['user_data'] : [];
        if (!empty($user_data['phone'])) {
            $_REQUEST['user_login'] = preg_replace("/[^\d]+/", '', $user_data['phone']);
        } elseif (!empty($user_data['email'])) {
            $_REQUEST['user_login'] = $user_data['email'];
        }
        if (defined('AJAX_REQUEST')) {
            if (!empty($_REQUEST['redirect_url']) && isset($_REQUEST['obj_id'])) {
                $_REQUEST['success_return_url'] = $_REQUEST['redirect_url'];
                $_REQUEST['redirect_url'] = 'auth.login_form?cp_otp_message=1&obj_id=' . $_REQUEST['obj_id'];
            }
        }
    }
    return; 
}

if ($mode == 'recover_password') {
    if (Registry::get('addons.cp_otp_registration.exclude_email') == 'Y') {
        return [CONTROLLER_STATUS_REDIRECT, 'auth.login_form'];
    }
}