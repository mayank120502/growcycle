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

//
// Hooks
//

function fn_cp_otp_registration_settings_variants_image_verification_use_for(&$objects)
{
    $objects['cp_otp'] = __('cp_otp_use_for_otp');
}

function fn_cp_otp_registration_auth_routines($request, $auth, $field, &$condition, $user_login)
{
    if (empty($user_login)) {
        $condition .= ' AND 0';
    } elseif (strpos($user_login, '@') === false) {
        $mask_phones = fn_cp_otp_get_masked_phones($user_login);
        $condition .= !empty($mask_phones) ? db_quote(' OR phone IN (?a)', $mask_phones) : '';
    }
}

function fn_cp_otp_registration_get_user_short_info_pre($user_id, &$fields, $condition, $join, $group_by) 
{
    $fields[] = 'phone';
}

function fn_cp_otp_registration_update_user_pre($user_id, &$user_data, $auth, $ship_to_another, &$notify_user)
{
    if (!empty($user_data['email']) && fn_checkout_is_email_address_fake($user_data['email'])) {
        if (Registry::get('addons.cp_otp_registration.use_fake_email') != 'Y') {
            $user_data['email'] = '';
        }
        $notify_user = '';
    }

    if (empty($user_id) && fn_cp_otp_check_verified($user_data['phone'],'register') || AREA == 'A') {
        $user_data['cp_phone_verified'] = 'Y';
    }

    if (!empty($user_data['phone'])) {
        if (AREA == 'C' && !empty($user_id)) {
            $old_phone = db_get_field("SELECT `phone` FROM ?:users WHERE `user_id`=?i", $user_id);
            if ($old_phone != $user_data['phone']) {
                $user_data['cp_phone_verified'] = 'N';
            }
        }
        $user_data['phone'] = fn_cp_otp_phone_only_numbers($user_data['phone']);
    }
}

function fn_cp_otp_registration_send_order_notification($order_info, $edp_data, &$force_notification, $notified, $send_order_notification)
{
    if (!fn_validate_email($order_info['email'])) {
        $force_notification['C'] = false;

        if (Registry::get('addons.cp_otp_registration.email_error') == 'Y') {
            fn_set_notification('W', __('important'), __('cp_warning_empty_email'));
        }
    }
}

function fn_cp_otp_registration_get_users($params, &$fields, $sortings, $condition, $join, $auth)
{
    $fields[] = '?:users.phone';
}

function fn_cp_otp_registration_update_profile($action, $user_data, $current_user_data)
{
    if (empty($user_data['email']) && Registry::get('addons.cp_otp_registration.email_error') == 'Y') {
        fn_set_notification('W', __('important'), __('cp_otp_receive_notifications_text'));
    }
}

function fn_cp_otp_registration_is_user_exists_post($user_id, $user_data, &$is_exist)
{
    $allow_modes = ['update_steps','customer_info','place_order'];
    $cart = Tygh::$app['session']['cart'];
    $skip_next = false;
    if (AREA == 'C' && Registry::get('addons.cp_otp_registration.guest_order') == 'Y' && Registry::get('runtime.controller') == 'checkout' && in_array(Registry::get('runtime.mode'), $allow_modes)) {
        if (!isset($cart['guest_checkout'])) {
            $is_anonymous_checkout_allowed = Registry::get('settings.Checkout.disable_anonymous_checkout') !== 'Y';
            $cart['guest_checkout'] = $is_anonymous_checkout_allowed && !$user_id;
        }
        if (!empty($cart['guest_checkout']) ) {
            $is_exist = 0;
            $skip_next = true;
        }
    }
    if (empty($skip_next) && !empty($user_data['phone']) && AREA != 'A') {
        $user_phone = fn_cp_otp_phone_only_numbers($user_data['phone']);

        if (!preg_match('/^[+-\[\]\(\)0-9]+$/', $user_phone)) {
            fn_set_notification('W', __('warning'), __('cp_correct_phone_format'), '', 'cp_correct_phone_format');
            $is_exist = true;
        } else {
            if (empty($user_id)) {
                $show_login = defined('AJAX_REQUEST') && Registry::get('runtime.controller') == 'checkout' ? true : false;
                $exists_user_id = fn_cp_otp_find_user_by_phone($user_phone);
                if (!empty($exists_user_id)) {
                    if ($show_login) {
                        Tygh::$app['ajax']->assign('phone', $user_phone);
                        Tygh::$app['ajax']->assign('cp_show_login', true);
                    } else {
                        fn_set_notification('E', __('error'), __('cp_exist_phone_error'), '', 'cp_exist_phone_error');
                    }
                    $is_exist = true;
                } else {
                    $exists_user_id = fn_cp_otp_find_user_by_email($user_data['email']);
                    if (!empty($exists_user_id) && $show_login) {
                        Tygh::$app['ajax']->assign('email', $user_data['email']);
                        Tygh::$app['ajax']->assign('cp_show_login', true);
                        $is_exist = true;
                    }
                }
            } elseif (!empty($user_id)) {
                $current_phone = db_get_field('SELECT phone FROM ?:users WHERE user_id = ?i', $user_id);
                if (!empty($current_phone) && $user_phone != $current_phone) {
                    $exists_user_id = db_get_fields(
                        'SELECT user_id FROM ?:users WHERE phone = ?s AND user_id != ?i',
                        $user_phone, $user_id
                    );
                    if (!empty($exists_user_id)) {
                        fn_set_notification('E', __('error'), __('cp_exist_phone_error'), '', 'cp_exist_phone_error');
                        $is_exist = true;
                    }
                }
            }
        }
    }
}

function fn_cp_otp_registration_set_notification_pre(&$type, &$title, &$message, &$message_state, &$extra, $init_message)
{
    $default_exists_popup = ($type == 'I' && $title == __('checkout.email_exists.popup.title')) ? true : false;
    if (!empty($extra) && ($extra == 'user_exist' || $extra == 'error_checkout_user_exists')
        || $default_exists_popup
    ) {
        if ($default_exists_popup) {
            $extra = 'default_checkout_exists_popup';
        }
        if (fn_notification_exists('extra', 'cp_correct_phone_format')) {
            fn_delete_notification('cp_correct_phone_format');

            $type = 'W';
            $title = __('warning');
            $message = __('cp_correct_phone_format');
            $message_state = '';
            $extra = 'cp_correct_phone_format';
        } elseif (fn_notification_exists('extra', 'cp_exist_phone_error')) {
            fn_delete_notification('cp_exist_phone_error');

            $type = 'E';
            $title = __('error');
            $message = __('cp_exist_phone_error');
            $message_state = '';
            $extra = 'cp_exist_phone_error';
        }
    }

    if ($type == 'N' && $message == __('successful_login')) {
        $extra = 'successful_login';
    }

    if (empty($extra)) {
        $cart = Tygh::$app['session']['cart'];
        
        if (!empty($cart['user_data']['phone'])) {
            $not_message = __('error_invalid_emails', ['[emails]' => $cart['user_data']['phone']]);

            if ($message == $not_message) {
                $extra = 'cp_newsletters';
            }
        }
    }
}

function fn_cp_otp_registration_pre_place_order(&$cart, $allow, $product_groups)
{
    // for newsletters addon
    $not_message = __('error_invalid_emails', ['[emails]' => $cart['user_data']['phone']]);
    $notifications = fn_get_notifications();

    foreach ($notifications as $k => $v) {
        if ($v['message'] == $not_message && !empty($v['extra'])) {
            fn_delete_notification($v['extra']);
        }
    }
}

function fn_cp_otp_registration_user_logout_after($auth)
{
    Tygh::$app['session']['cp_otp'] = [];
}

//
// Common functions
//

function fn_cp_otp_assign_phone_verified($user_id, $params = [])
{
    return db_query('UPDATE ?:users SET cp_phone_verified = ?s WHERE user_id = ?i', 'Y', $user_id);
}

function fn_cp_otp_apply_phone_mask($phone, $mask = '')
{
    if (!empty($mask)) {
        $mask_split = preg_split('//u', $mask, NULL, PREG_SPLIT_NO_EMPTY);
        $phone_split = preg_split('//u', $phone, NULL, PREG_SPLIT_NO_EMPTY);
        $i = 0;
        foreach ($mask_split as $k => $v) {
            if ($v == '#') {
                $mask_split[$k] = isset($phone_split[$i]) ? $phone_split[$i] : '';
                $i++;
            } elseif (isset($phone_split[$i]) && $v == $phone_split[$i]) {
                $i++;
            }
        }
        return ($i == strlen($phone)) ? implode('', $mask_split) : '';
    } else {
        return '+' . $phone;
    }
}

function fn_cp_otp_find_and_apply_mask($phone)
{
    $mask_phones = fn_cp_otp_get_masked_phones($phone);
    return reset($mask_phones);
}

function fn_cp_otp_find_user_by_phone($phone)
{
    // Generate all posible phone variants in DB
    $mask_phones = fn_cp_otp_get_masked_phones($phone);
    $user_id = db_get_field('SELECT user_id FROM ?:users WHERE phone IN (?a)', $mask_phones);

    return $user_id;
}

function fn_cp_otp_get_masked_phones($phone, $add_clean = true)
{
    $phone = fn_cp_otp_phone_only_numbers($phone);
    $mask_phones = [];
    if (Registry::get('settings.Appearance.phone_validation_mode') == 'international_format') {
        $phone_masks = fn_cp_otp_get_phone_masks();
        foreach ($phone_masks as $mask_data) {
            if (empty($mask_data['mask'])) {
                continue;
            }
            $mask_phone = fn_cp_otp_apply_phone_mask($phone, $mask_data['mask']);
            if (!empty($mask_phone)) {
                $mask_phones[] = $mask_phone;
            }
        }
    }
    if ($add_clean) {
        $mask_phones[] = fn_cp_otp_apply_phone_mask($phone, ''); // + with numbers
        $mask_phones[] = $phone; // only numbers
    }

    return $mask_phones;
}

function fn_cp_otp_get_phone_masks()
{
    static $phone_masks;
    $phone_masks = isset($phone_masks) ? $phone_masks : fn_get_phone_masks(false);
    return $phone_masks;
}

function fn_cp_otp_find_user_by_email($email)
{
    $user_id = db_get_field('SELECT user_id FROM ?:users WHERE email = ?s', trim($email));

    return $user_id;
}

function fn_cp_otp_send_code($user_data, $type = 'register', &$error)
{
    if (!function_exists('___cp')) {
        return false;
    }
    $user_id = 0;
    $auth_type = '';
    $code_sended = false;  // FALSE
    $cpv1 = ___cp('cGhvbmU');
    $cpv2 = ___cp('ZW1haWw');
    $code = call_user_func(___cp('Zm5fY3Bfb3RwP2dlbmVyYPRlP2XvZGU'));
    if (!empty($user_data[$cpv1])) {
        $auth_type = $cpv1;
        $user_id = call_user_func(___cp('Zm5fY3Bfb3RwP2ZpbmRfdPXlcl9ieV9waG9uZQ'), $user_data[$cpv1]);
        if (function_exists('fn_cp_sms_send_by_service')
            && (!empty($user_id) || $type == 'register' || fn_cp_otp_allow_fast_registration())
        ) {
            $phone = fn_cp_otp_phone_only_numbers($user_data[$cpv1]);
            $sms_message = __('cp_otp_code_sms_text', array('[code]' => $code));
            $code_sended = fn_cp_sms_send_by_service($phone, $sms_message);
        } else {
            $error = 'phone_not_exists';
        }
    } elseif (!empty($user_data[$cpv2])) {
        $auth_type = $cpv2;
        $user_id = call_user_func(___cp('Zm5fY3Bfb3RwP2ZpbmRfdPXlcl9ieV9lbWFpbA'), $user_data[$cpv2]);
        if (!empty($user_id) || $type == 'register') {
            $code_sended = fn_cp_otp_send_code_mail($user_data[$cpv2], $code);
        } else {
            $error = 'email_not_exists';
        }
    }

    if ($code_sended) {
        Tygh::$app['session']['cp_otp'][$type] = array(
            'code' => $code,
            'time' => TIME,
            'auth_type' => $auth_type,
            'to' => !empty($user_data[$auth_type]) ? $user_data[$auth_type] : '',
            'user_id' => $user_id
        );
        return true;
    }

    return false;
}

function fn_cp_otp_send_code_mail($email, $code, $lang_code = CART_LANGUAGE)
{
    $mailer = Tygh::$app['mailer'];
    $mailer->send(array(
        'to' => $email,
        'from' => 'default_company_users_department',
        'data' => array(
            'code' => $code
        ),
        'template_code' => 'cp_otp_code_notification',
        'tpl' => 'addons/cp_otp_registration/notification.tpl',
        'company_id' => Registry::get('runtime.company_id'),
    ), 'C', $lang_code);

    return true;
}

function fn_cp_otp_validate_code($code, $type = 'register', &$user_id)
{
    $settings = Registry::get('addons.cp_otp_registration');
    $check_attempts = !empty($settings['code_attempts']) ? intval($settings['code_attempts']) : 0;
    $check_time = !empty($settings['code_valid_time']) ? floatval($settings['code_valid_time']) * 60 : 0;
    $code = is_array($code) ? implode('', $code) : $code;

    $verification = & Tygh::$app['session']['cp_otp'][$type];
    $verification['time'] = !empty($verification['time']) ? intval($verification['time']) : 0;
    $verification['attempts'] = !empty($verification['attempts']) ? intval($verification['attempts']) : 0;
    
    // Fail checks by display priority
    $checks = array(
        'time' => (empty($check_time) || $verification['time'] + $check_time > TIME),
        'attempts' => (empty($check_attempts) || $verification['attempts'] < $check_attempts),
        'code' => (!empty($verification['code']) && $verification['code'] == $code)
    );
    $fail_reason = array_search(false, $checks);
    if (empty($fail_reason)) {
        $verification['code'] = '';
        $verification['verified'] = true;
        $user_id = $verification['user_id'];

        return true;
    } else {
        $verification['fail_reason'] = $fail_reason;
    }
    $verification['attempts']++;

    return false;
}

function fn_cp_otp_get_verify_fail_reason($type = 'register')
{
    $otp_data = & Tygh::$app['session']['cp_otp'][$type];
    if (!empty($otp_data['fail_reason'])) {
        $fail_reason = $otp_data['fail_reason'];
        $otp_data['fail_reason'] = '';
        return $fail_reason;
    } else {
        return '';
    }
}

function fn_cp_otp_allow_fast_registration()
{
    $result = false;
    if (Registry::get('addons.cp_otp_registration.login_type') == 'otp'
        && Registry::get('addons.cp_otp_registration.fast_registration') == 'Y'
        || Registry::get('runtime.cp_fast_registration') == true
    ) {
        $result = true;
    }
    return $result;
}

function fn_cp_otp_check_verified($phone, $type = 'register')
{
    $otp_data = !empty(Tygh::$app['session']['cp_otp'][$type]) ? Tygh::$app['session']['cp_otp'][$type] : [];
    $phone = fn_cp_otp_phone_only_numbers($phone);
    return !empty($otp_data['verified']) && !empty($otp_data['to']) && ($phone == $otp_data['to']);
}

function fn_cp_otp_phone_only_numbers($phone)
{
    return $phone;
}

function fn_cp_otp_generate_code()
{
    return random_int(1000, 9999);
}

function fn_cp_otp_generate_password($chars_count = 8)
{
    $password = ''; 
    $chars = 'qazxswedcvfrtgbnhyujmkiolp1234567890QAZXSWEDCVFRTGBNHYUJMKIOLP'; 

    $size = strlen($chars) - 1; 
    for ($i = 0; $i < $chars_count; $i++) { 
        $password .= $chars[rand(0, $size)]; 
    }

    return $password;
}

function fn_cp_otp_get_avail_countries()
{
    static $countries = null;
    if (!isset($countries)) {
        $countries_list = fn_get_simple_countries(true);
        $countries = array_keys($countries_list);
    }
    return $countries;
}

function fn_cp_otp_controller_do_redirect($redirect_url = '', $force_redirect = false, $default_notifications = false)
{
    if (defined('AJAX_REQUEST')) {
        if ($force_redirect) {
            Tygh::$app['ajax']->assign('non_ajax_notifications', true);
            Tygh::$app['ajax']->assign('force_redirection', fn_url($redirect_url));
        
        } elseif (!$default_notifications) {
            $otp_type = ($redirect_url == 'auth.login_form') ? 'login' : 'register';
            fn_cp_otp_display_popup_notification($otp_type);
        }
        exit;
    } else {
        return array(CONTROLLER_STATUS_REDIRECT, $redirect_url);
    }
}

function fn_cp_otp_display_popup_notification($otp_type = '')
{
    if (!defined('AJAX_REQUEST')) {
        return;
    }
    $fail_reason = !empty($otp_type) ? fn_cp_otp_get_verify_fail_reason($otp_type) : '';
    $notifications = & Tygh::$app['session']['notifications'];
    if (!empty($fail_reason)) {
        $message =  __('cp_otp_verification_fail_' . $fail_reason);
    } else {
        foreach ($notifications as $n_key => $notif) {
            if (!empty($notif['type']) && $notif['type'] == 'E') {
                $message = $notif['message'];
                break;
            }
        }
    }
    if (!empty($message)) {
        $notifications = [];
        Tygh::$app['ajax']->assign('cp_otp_fail', $fail_reason);
        Tygh::$app['ajax']->result_ids[] = 'cp_otp_fail_message*';

        Tygh::$app['view']->assign('cp_otp_fail_message', $message);
        Tygh::$app['view']->display('addons/cp_otp_registration/components/otp_fail_message.tpl');
    }
}

function fn_cp_otp_user_password_verify($user, $password, $salt)
{
    if (function_exists('fn_user_password_verify')) {
        fn_user_password_verify((int) $user['user_id'], $password, (string) $user['password'], (string) $salt);
    } else {
        return fn_generate_salted_password($password, $salt) === $user['password'] ? true : false;
    }
}

//
// addon.xml functions
//

function fn_install_cp_otp_registration()
{
    $profile_fields = fn_get_profile_fields('C');
    foreach ($profile_fields as $section => $profile_field) {
        foreach ($profile_field as $field_id => $v) {
            if (in_array($v['field_name'], array('b_phone', 's_phone'))) {
                $p_field_data = array(
                    'checkout_required' => 'N',
                    'checkout_show' => 'N',
                    'profile_required' => 'N',
                    'profile_show' => 'N'
                );
                db_query("UPDATE ?:profile_fields SET ?u WHERE field_id = ?i", $p_field_data, $field_id);
            } elseif ($v['field_name'] == 'phone') {
                $p_field_data = array(
                    'checkout_required' => 'Y',
                    'checkout_show' => 'Y',
                    'profile_required' => 'Y',
                    'profile_show' => 'Y'
                );
                db_query("UPDATE ?:profile_fields SET ?u WHERE field_id = ?i", $p_field_data, $field_id);
            }
        }
    }    
}

function fn_uninstall_cp_otp_registration()
{
    $profile_fields = fn_get_profile_fields('C');
    foreach ($profile_fields as $section => $profile_field) {
        foreach ($profile_field as $field_id => $v) {
            if ($v['field_name'] == 'email') {
                $e_field_data = array(
                    'checkout_required' => 'Y',
                    'checkout_show' => 'Y'
                );
                db_query("UPDATE ?:profile_fields SET ?u WHERE field_id = ?i", $e_field_data, $field_id);
            }
        }
    }
}

function fn_cp_otp_registration_create_company_admin($company_data, $fields, $notify, &$user)
{
    if (!empty($user['phone'])) {
        $user['cp_phone_verified'] = 'Y';
    }
}


function fn_cp_otp_registration_message_texts()
{
    $messages = array(
        'SMS' => 'cp_otp_code_sms_text',
        'E-mail' => 'cp_otp_code_email_text'
    );
    $str = __('cp_otp_message_texts_title') . ':<br />';
    foreach ($messages as $type => $lang_var) {
        $url = fn_url('languages.translations?q=' . $lang_var);
        $str .= "<strong>{$type}:</strong> {$lang_var} <a href=\"{$url}\" target=\"_blank\">" . __('edit') . "</a><br />";
    }
    return $str;
}

function fn_settings_variants_addons_cp_otp_registration_comfirm_on()
{
    $data = [];
    if (Registry::get('addons.call_requests.status') == 'A') {
        $data['CR'] = __('call_requests');
    }
    return $data; 
}


function fn_cp_otp_send_code_no_user_check($user_data, $type = 'register', &$error)
{
    $user_id = 0;
    $auth_type = '';
    $code_sent = false;  // FALSE

    $code = call_user_func(___cp('Zm5fY3Bfb3RwP2dlbmVyYPRlP2XvZGU'));
    if (!empty($user_data["phone"]) && !empty($user_data['user_id'])) {
        $auth_type = "phone";
        $user_id = $user_data['user_id'];
        if (function_exists('fn_cp_sms_send_by_service') && !empty($user_id)
        ) {
            $phone = preg_replace('/[^\d]+/', '', $user_data["phone"]);
            $sms_message = __('cp_otp_code_sms_text', array('[code]' => $code));
            $code_sent = fn_cp_sms_send_by_service($phone, $sms_message);
        } else {
            $error = 'phone_not_exists';
        }
    } else {
        $error = 'not_valid_params';
    }

    if ($code_sent) {
        Tygh::$app['session']['cp_otp'][$type] = array(
            'code' => $code,
            'time' => TIME,
            'auth_type' => $auth_type,
            'to' => !empty($user_data[$auth_type]) ? $user_data[$auth_type] : '',
            'user_id' => $user_id
        );
        return true;
    }

    return false;
}