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
    if ($mode == 'update') {
        if (empty($_REQUEST['user_data']['email'])) {
            $_REQUEST['user_data']['email'] = fn_checkout_generate_fake_email_address($_REQUEST['user_data'], TIME);
        }
        if (defined('AJAX_REQUEST')) {
            Tygh::$app['ajax']->assign('non_ajax_notifications', true);
        }
    }

    if ($mode == 'cp_otp_login') {
        $otp_action = !empty($_REQUEST['otp_action']) ? $_REQUEST['otp_action'] : '';
        $check_type = 'login';
        if ($otp_action == 'register') {
            $check_type = 'register';
            Registry::set('runtime.cp_fast_registration', true);
        }
        
        $user_id = 0;

        if (empty($_REQUEST['cp_otp_code']) || !fn_cp_otp_validate_code($_REQUEST['cp_otp_code'], $check_type, $user_id)) {
            fn_set_notification('E', __('error'), __('cp_otp_fail_verification'));
            return fn_cp_otp_controller_do_redirect('auth.login_form');
        }

        if (empty($user_id)) {
            if (empty($auth['user_id'])
                && fn_cp_otp_allow_fast_registration()
            ) {
                $password = fn_cp_otp_generate_password(8);
                $_REQUEST['user_data']['password1'] = $_REQUEST['user_data']['password2'] = $password;

                $user_data = (array) $_REQUEST['user_data'];

                if (empty($auth['user_id']) && !empty(Tygh::$app['session']['cart']['user_data'])) {
                    $user_data = array_merge($user_data, array_filter((array) Tygh::$app['session']['cart']['user_data']));
                }

                list($user_id) = fn_update_user(0, $user_data, $auth, !empty($_REQUEST['ship_to_another']), true);
                if (!$user_id) {
                    $redirect_url = !empty($_REQUEST['return_url']) ? $_REQUEST['return_url'] : '';
                    return fn_cp_otp_controller_do_redirect($redirect_url, true);
                }
            } else {
                fn_set_notification('E', __('error'), __('cp_otp_user_phone_not_exists'));
                return fn_cp_otp_controller_do_redirect('auth.login_form');
            }
        }

        // Regenerate session ID for security reasons
        Tygh::$app['session']->regenerateID();

        // If customer placed orders before login, assign these orders to this account
        if (!empty($auth['order_ids'])) {
            foreach ($auth['order_ids'] as $k => $v) {
                db_query('UPDATE ?:orders SET ?u WHERE order_id = ?i', array('user_id' => $user_id), $v);
            }
        }

        fn_login_user($user_id, true);
        Tygh\Helpdesk::auth();
        fn_set_notification('N', __('notice'), __('successful_login'));

        if (!empty($_REQUEST['user_data']['phone']) && fn_cp_otp_check_verified($_REQUEST['user_data']['phone'], 'login')) {
            fn_cp_otp_assign_phone_verified($user_id); // mark that the number is verified
        }

        $redirect_url = !empty($_REQUEST['return_url']) ? $_REQUEST['return_url'] : '';
        return fn_cp_otp_controller_do_redirect($redirect_url, true);
    }

    if ($mode == 'cp_phone_verification') {
        $user_id = 0;
        if (empty($_REQUEST['cp_otp_code']) || !fn_cp_otp_validate_code($_REQUEST['cp_otp_code'], 'register', $user_id)) {
            fn_set_notification('E', __('error'), __('cp_otp_fail_verification'));
            
            return fn_cp_otp_controller_do_redirect('profiles.add');
        }
        if (!empty($auth['user_id']) && $user_id == $auth['user_id']) {
            fn_cp_otp_assign_phone_verified($user_id);
        }
        Tygh::$app['view']->assign('obj_id', !empty($_REQUEST['obj_id']) ? $_REQUEST['obj_id'] : '');
        Tygh::$app['view']->display('addons/cp_otp_registration/components/phone.tpl');
        exit;
    }

    if ($mode == 'cp_check_otp') {
        $user_data = array();
        if (!empty($_REQUEST['user_data'])) {
            $user_data = $_REQUEST['user_data'];
            if (!empty($user_data['phone'])) {
                $user_data['phone'] = fn_cp_otp_phone_only_numbers($user_data['phone']);
            }
        } elseif (!empty($_REQUEST['resend'])) {
            if (!empty($_REQUEST['phone'])) {
                $user_data = array('phone' => fn_cp_otp_phone_only_numbers($_REQUEST['phone']));
            } elseif (!empty($_REQUEST['email'])) {
                $user_data = array('email' => $_REQUEST['email']);
            }
        } elseif (!empty($_REQUEST['phone'])) {
            $user_data = array('phone' => $_REQUEST['phone']);
        }
        if (empty($user_data)) {
            return;
        }

        $login_type = Registry::get('addons.cp_otp_registration.login_type');
        $otp_type = !empty($_REQUEST['otp_type']) ? $_REQUEST['otp_type'] : 'register';
        $otp_action = !empty($_REQUEST['otp_action']) ? $_REQUEST['otp_action'] : '';
        $required_email = Registry::get('addons.cp_otp_registration.required_email') == "Y";

        if (empty($_REQUEST['resend'])
            && $login_type == 'two_factor'
            && (empty($otp_type) || $otp_type != 'register')
        ) {
            if (!empty($user_data['email'])) {
                $_REQUEST['user_login'] = $user_data['email'];
            } elseif (!empty($_REQUEST['user_data']['phone'])) {
                $_REQUEST['user_login'] = $user_data['phone'];
            }

            fn_restore_processed_user_password($_REQUEST, $_POST);
            list($status, $user, $user_login, $password, $salt) = fn_auth_routines($_REQUEST, $auth);
            if (empty($user) || empty($password)
                || !fn_cp_otp_user_password_verify($user, $password, $salt)
            ) {
                fn_set_notification('E', __('error'), __('error_incorrect_login'));

                return fn_cp_otp_controller_do_redirect('auth.login_form');
            }
        }
        if ($otp_action == 'register') {
            Registry::set('runtime.cp_fast_registration', true);
            if (!empty($user_data['phone']) && fn_cp_otp_find_user_by_phone($user_data['phone'])) {
                fn_set_notification('E', __('error'), __('cp_exist_phone_error'));
                return fn_cp_otp_controller_do_redirect('profiles.add');
            } elseif($required_email && !$_REQUEST['show_email'] && Registry::get('addons.cp_otp_registration.fast_registration') != 'Y') {
                //Registry::set('runtime.cp_fast_registration', false);
                Tygh::$app['view']->assign('need_register', true);
                Tygh::$app['view']->assign('show_email', $required_email);
                Tygh::$app['view']->display('addons/cp_otp_registration/components/otp_verification.tpl');
                return;
            }
        }
        if (!empty($_REQUEST['need_register'])) {
            $otp_type = 'register';
            Tygh::$app['view']->assign('need_register', true);
        }
        $send_result = fn_cp_otp_send_code($user_data, $otp_type, $send_error);
        if (empty($send_result)) {
            if (!empty($send_error)
                && ($send_error == 'phone_not_exists' || $send_error == 'email_not_exists')
            ) {
                if ($send_error == 'phone_not_exists') {
                    fn_set_notification('E', __('error'), __('cp_otp_user_phone_not_exists'));
                } elseif ($send_error == 'email_not_exists') {
                    fn_set_notification('E', __('error'), __('cp_otp_user_email_not_exists'));
                }
                return fn_cp_otp_controller_do_redirect('auth.login_form');
            } else {
                fn_set_notification('E', __('error'), __('cp_otp_send_fail'));
                return fn_cp_otp_controller_do_redirect('auth.login_form');
            }
        }

        $return_dispatch = !empty($_REQUEST['return_dispatch']) ? $_REQUEST['return_dispatch'] : 'profiles.update';

        Tygh::$app['view']->assign('return_dispatch', $return_dispatch);
        Tygh::$app['view']->assign('otp_type', $otp_type);
        Tygh::$app['view']->assign('show_otp', true);
        Tygh::$app['view']->assign('obj_id', !empty($_REQUEST['obj_id']) ? $_REQUEST['obj_id'] : '');
        
        if (defined('AJAX_REQUEST')) {
            if (Registry::get('addons.cp_otp_registration.fast_registration') != 'Y' && $otp_type != 'login') {
                Tygh::$app['view']->assign('show_email', $required_email);
            }
            $auth_field = '';
            if (!empty($user_data['phone'])) {
                $auth_field = 'phone';
                Tygh::$app['view']->assign('phone', $user_data['phone']);
            }
            if (!empty($user_data['email'])) {
                $auth_field = 'email';
                Tygh::$app['view']->assign('email', $user_data['email']);
            }

            if (!empty($_REQUEST['resend']) && $otp_type == 'register') {
                Tygh::$app['view']->display('addons/cp_otp_registration/views/profiles/cp_phone_verification.tpl');
            } else {
                if ($otp_action == 'recover') { // recover password
                    Tygh::$app['view']->assign('login_type', 'otp');
                    Tygh::$app['view']->assign('auth_field', $auth_field);
                    Tygh::$app['view']->assign('return_dispatch', 'profiles.cp_otp_login');
                    Tygh::$app['view']->display('addons/cp_otp_registration/components/auth_form.tpl');
                } else {
                    Tygh::$app['view']->display('addons/cp_otp_registration/components/otp_verification.tpl');
                }
            }
            exit;
        }
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
        return fn_cp_otp_controller_do_redirect('profiles.add', false, true);
    }
    $exists_user_id = fn_cp_otp_find_user_by_phone($phone);
    $user_id = !empty($auth['user_id']) ? $auth['user_id'] : 0;
    if (!empty($exists_user_id) && $exists_user_id != $user_id) {
        fn_set_notification('E', __('error'), __('cp_exist_phone_error'));
        return fn_cp_otp_controller_do_redirect('profiles.add', false, true);
    } else {
        $user_data = array('phone' => $phone);
        $otp_type = !empty($_REQUEST['otp_type']) ? $_REQUEST['otp_type'] : 'register';
        $send_result = fn_cp_otp_send_code($user_data, $otp_type, $send_error);
        if (empty($send_result)) {
            fn_set_notification('E', __('error'), __('cp_otp_send_fail'));
            return fn_cp_otp_controller_do_redirect('profiles.add', false, true);
        }
        Tygh::$app['view']->assign('obj_id', !empty($_REQUEST['obj_id']) ? $_REQUEST['obj_id'] : '');
        Tygh::$app['view']->assign('otp_type', $otp_type);
        Tygh::$app['view']->assign('phone', $phone);
    }
}

if ($mode == 'success_add') {
    if (defined('AJAX_REQUEST')) {
        Tygh::$app['ajax']->assign('force_redirection', fn_url('profiles.success_add'));
        exit;
    }
}
