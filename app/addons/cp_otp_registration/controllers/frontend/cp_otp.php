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

    if ($mode == 'pre_verification') {
    
        if (!defined('AJAX_REQUEST')) {
            return [CONTROLLER_STATUS_NO_PAGE];
        }
        $phone = !empty($_REQUEST['phone']) ? $_REQUEST['phone'] : '';
        if (!empty($_REQUEST['redir_dispatch']) && $_REQUEST['redir_dispatch'] == 'companies') {
            $redir_url = 'companies.apply_for_vendor';
            $tpl = 'addons/cp_otp_registration/views/companies/cp_phone_verification.tpl';
        } else {
            $redir_url = 'profiles.add';
            $tpl = 'addons/cp_otp_registration/views/profiles/cp_phone_verification.tpl';
        }
        if (strlen($phone) < CP_OTP_MIN_PHONE_NUM) {
            fn_set_notification('E', __('warning'), __('cp_correct_phone_format'));
            return fn_cp_otp_controller_do_redirect($redir_url, false, true);
        }
        $exists_user_id = fn_cp_otp_find_user_by_phone($phone);
        $user_id = !empty($auth['user_id']) ? $auth['user_id'] : 0;
        if (!empty($exists_user_id) && $exists_user_id != $user_id) {
            fn_set_notification('E', __('error'), __('cp_exist_phone_error'));
            return fn_cp_otp_controller_do_redirect($redir_url, false, true);
        } else {
            $user_data = ['phone' => $phone];
            $otp_type = !empty($_REQUEST['otp_type']) ? $_REQUEST['otp_type'] : 'register';
            $send_result = fn_cp_otp_send_code($user_data, $otp_type, $send_error);
            if (empty($send_result)) {
                fn_set_notification('E', __('error'), __('cp_otp_send_fail'));
                return fn_cp_otp_controller_do_redirect($redir_url, false, true);
            }
            Tygh::$app['view']->assign('obj_id', !empty($_REQUEST['obj_id']) ? $_REQUEST['obj_id'] : '');
            Tygh::$app['view']->assign('otp_type', $otp_type);
            Tygh::$app['view']->assign('phone', $phone);
            Tygh::$app['view']->display($tpl);
        }
        exit;
    }
}
if ($mode == 'pre_verification') {
    if (!defined('AJAX_REQUEST')) {
        return [CONTROLLER_STATUS_NO_PAGE];
    }
    $phone = !empty($_REQUEST['phone']) ? $_REQUEST['phone'] : '';
    if (strlen($phone) < CP_OTP_MIN_PHONE_NUM) {
        fn_set_notification('E', __('warning'), __('cp_correct_phone_format'));
        return fn_cp_otp_controller_do_redirect('profiles.add', false, true);
    }
    $otp_type = !empty($_REQUEST['otp_type']) ? $_REQUEST['otp_type'] : 'register';
    Tygh::$app['view']->assign('obj_id', !empty($_REQUEST['obj_id']) ? $_REQUEST['obj_id'] : '');
    Tygh::$app['view']->assign('otp_type', $otp_type);
    Tygh::$app['view']->assign('phone', $phone);
    Tygh::$app['view']->assign('redir_dispatch', !empty($_REQUEST['redir_dispatch']) ? $_REQUEST['redir_dispatch'] : '');
    
}