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

    if ($mode == 'cp_phone_verification') {
        $user_id = 0;
        if (empty($_REQUEST['cp_otp_code']) || !fn_cp_otp_validate_code($_REQUEST['cp_otp_code'], 'register', $user_id)) {
            fn_set_notification('E', __('error'), __('cp_otp_fail_verification'));
            
            return fn_cp_otp_controller_do_redirect('companies.apply_for_vendor');
        }

        Tygh::$app['view']->assign('obj_id', !empty($_REQUEST['obj_id']) ? $_REQUEST['obj_id'] : '');
        Tygh::$app['view']->display('addons/cp_otp_registration/components/phone.tpl');
        exit;
    }
    
    return;  
}

if ($mode == 'cp_phone_verification') {
    if (!defined('AJAX_REQUEST')) {
        return array(CONTROLLER_STATUS_NO_PAGE);
    }
    $phone = !empty($_REQUEST['phone']) ? $_REQUEST['phone'] : '';
    if (strlen($phone) < CP_OTP_MIN_PHONE_NUM) {
        fn_set_notification('E', __('warning'), __('cp_correct_phone_format'));
        return fn_cp_otp_controller_do_redirect('companies.apply_for_vendor', false, true);
    }
    $exists_user_id = fn_cp_otp_find_user_by_phone($phone);
    $user_id = !empty($auth['user_id']) ? $auth['user_id'] : 0;
    if (!empty($exists_user_id) && $exists_user_id != $user_id) {
        fn_set_notification('E', __('error'), __('cp_exist_phone_error'));
        return fn_cp_otp_controller_do_redirect('companies.apply_for_vendor', false, true);
    } else {
        $user_data = array('phone' => $phone);
        $otp_type = !empty($_REQUEST['otp_type']) ? $_REQUEST['otp_type'] : 'register';
        $send_result = fn_cp_otp_send_code($user_data, $otp_type, $send_error);
        if (empty($send_result)) {
            fn_set_notification('E', __('error'), __('cp_otp_send_fail'));
            return fn_cp_otp_controller_do_redirect('companies.apply_for_vendor', false, true);
        }
        Tygh::$app['view']->assign('obj_id', !empty($_REQUEST['obj_id']) ? $_REQUEST['obj_id'] : '');
        Tygh::$app['view']->assign('otp_type', $otp_type);
        Tygh::$app['view']->assign('phone', $phone);
    }
}