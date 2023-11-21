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

use Tygh\Enum\Addons\CpNewBuyingTypes\SendCodeResults;
use Tygh\Enum\NotificationSeverity;
use Tygh\Enum\YesNo;
use Tygh\Registry;

if (AREA != 'C') {
    return;
}

if (!defined('AJAX_REQUEST')) {
    if (!empty($_REQUEST['redirect_url']) || !empty($_REQUEST['return_url'])) {
        $r_url = empty($_REQUEST['redirect_url']) ? $_REQUEST['return_url'] : $_REQUEST['redirect_url'];
        return [CONTROLLER_STATUS_REDIRECT, $r_url];
    }
    return [CONTROLLER_STATUS_NO_PAGE];
}

if ($mode == 'clear_flag') {
    if (!empty(Tygh::$app['session']['cp_login_step']['login'])) {
        if (!empty(Tygh::$app['session']['cp_login_step']['return_url'])) {
            $force_reload_url = Tygh::$app['session']['cp_login_step']['return_url'];
        } else {
            $force_reload_url = '';
        }
    }
    unset(Tygh::$app['session']['cp_login_step'],
        Tygh::$app['session']['cp_target_id']);

    if (isset($force_reload_url)) {
        Tygh::$app['ajax']->assign('force_redirection',
            fn_url($force_reload_url));
    }
    exit;
}

if ($mode == 'start_login') {
    $auth = Tygh::$app['session']['auth'];

    if (!empty($_REQUEST['return_url'])) {
        $return_url = $_REQUEST['return_url'];
    } elseif (!empty($_REQUEST['redirect_url'])) {
        $return_url = $_REQUEST['redirect_url'];
    } else {
        $return_url = '';
    }

    $cp_login_step = [
        'step' => 'email',
        'mode' => 'login',
        'return_url' => $return_url,
    ];

    if (!empty($_REQUEST['target_id'])) {
        $cp_login_step['target_id'] = $_REQUEST['target_id'];
    }

    if (!empty($_REQUEST['chph']) && $_REQUEST['chph'] == YesNo::YES) {
        $cp_login_step['chph'] = YesNo::YES;
    }

    if (!empty($_REQUEST['cp_msg'])) {
        $cp_login_step['msg_type'] = $_REQUEST['cp_msg'];
    }

    if (empty($auth['user_id'])) {
        $cp_mode = 'login';
        $cp_step = 'email';
    } else {
        if (!empty($_REQUEST['target_id'])) {
            $phone_record = fn_cp_nbt_get_phone($auth['user_id']);
            if (empty($phone_record)) {
                fn_set_notification(NotificationSeverity::ERROR,
                    __('error'), __('cp_new_buying_types.contact_administrator'));
                fn_cp_new_buying_types_redirect();

                return [CONTROLLER_STATUS_NO_CONTENT];
            }

            if ($phone_record['cp_phone_verified'] == YesNo::NO) {
                $cp_mode = 'login';
                $cp_step = 'phone';
                $code_sent = fn_cp_nbt_is_code_sent($auth['user_id']);
                Tygh::$app['session']['cp_login_step']['code_sent'] = $code_sent;

                Tygh::$app['view']->assign('phone', $phone_record['phone']);
            }
        } else {
            return [CONTROLLER_STATUS_NO_CONTENT];
        }
    }

    $cp_login_step['mode'] = $cp_mode;
    $cp_login_step['step'] = $cp_step;
    Tygh::$app['session']['cp_login_step'] = $cp_login_step;

    Tygh::$app['view']->display('addons/cp_new_buying_types/views/auth/cp_nbt_popup_content.tpl');

    return [CONTROLLER_STATUS_NO_CONTENT];
}

if ($mode == 'resend_code') {
    if (!defined('AJAX_REQUEST')) {
        return;
    }

    $auth = Tygh::$app['session']['auth'];

    if (empty($auth['user_id'])) {
        return [CONTROLLER_STATUS_NO_CONTENT];
    }

    if (empty(Tygh::$app['session']['cp_login_step'])) {
        Tygh::$app['view']->assign([
            'return_url' => Tygh::$app['session']['cp_login_step']['return_url'],
            'title' => __('authorize_before_order'),
        ]);

        unset(Tygh::$app['session']['cp_login_step']);

        Tygh::$app['view']->display('addons/cp_new_buying_types/views/auth/cp_nbt_popup_content.tpl');

        return [CONTROLLER_STATUS_NO_CONTENT];
    }

    $cp_step = Tygh::$app['session']['cp_login_step']['step'];

    if ($cp_step != 'confirm_code') {
        return [CONTROLLER_STATUS_NO_CONTENT];
    }

    $cp_step = 'phone';
    $cp_mode = 'login';

    $code_sent = fn_cp_nbt_is_code_sent($auth['user_id']);
    Tygh::$app['session']['cp_login_step']['code_sent'] = $code_sent;
    if ($code_sent) {
        $phone = Tygh::$app['session']['cp_login_step']['phone'];
        Tygh::$app['view']->assign('phone', $phone);
    } else {
        $phone = !empty(Tygh::$app['session']['cp_login_step']['phone']) ? Tygh::$app['session']['cp_login_step']['phone'] : '';
        Tygh::$app['view']->assign('phone', $phone);
        Tygh::$app['session']['cp_login_step']['phone'] = $phone;
    }

    Tygh::$app['session']['cp_login_step']['step'] = $cp_step;
    Tygh::$app['session']['cp_login_step']['mode'] = $cp_mode;

    Tygh::$app['view']->assign('phone', $phone);
    Tygh::$app['session']['cp_login_step']['phone'] = $phone;

    Tygh::$app['view']->display('addons/cp_new_buying_types/views/auth/cp_nbt_popup_content.tpl');

    exit;
}

if ($mode == 'continue') {
    if (!defined('AJAX_REQUEST')) {
        return;
    }

    //Tygh::$app['ajax']->assign('non_ajax_notifications', true);

    if (empty(Tygh::$app['session']['cp_login_step'])) {
        Tygh::$app['view']->assign([
            'return_url' => Tygh::$app['session']['cp_login_step']['return_url'],
            'title' => __('authorize_before_order'),
        ]);

        unset(Tygh::$app['session']['cp_login_step']);

        Tygh::$app['view']->display('addons/cp_new_buying_types/views/auth/cp_nbt_popup_content.tpl');

        return [CONTROLLER_STATUS_NO_CONTENT];
    }

    $cp_step = Tygh::$app['session']['cp_login_step']['step'];
    $cp_mode = Tygh::$app['session']['cp_login_step']['mode'];


    $request = $_REQUEST;


    if ($cp_step == 'email') {
        $email = !empty($request['email']) ? $request['email'] : '';
        $remember_me = (!empty($_REQUEST['remember_me']) && $_REQUEST['remember_me'] == YesNo::YES) ? 'Y' : 'N';
        Tygh::$app['session']['cp_login_step']['remember_me'] = $remember_me;
        if (fn_validate_email($email, true)) {

            if (!defined('CP_NBT_DEBUG')) {
                //delay to prevent brute forcing
                sleep(1 + rand(0, 2));
            }

            Tygh::$app['session']['cp_login_step']['email'] = $email;
            if (!fn_cp_nbt_is_email_in_db($email)) {
                //Меняем режим
                Tygh::$app['session']['cp_login_step']['step'] = 'user_data';
                Tygh::$app['session']['cp_login_step']['mode'] = 'register';
            } else {
                Tygh::$app['session']['cp_login_step']['step'] = 'password';
            }

            Tygh::$app['view']->display('addons/cp_new_buying_types/views/auth/cp_nbt_popup_content.tpl');

            return [CONTROLLER_STATUS_NO_CONTENT];

        } else {
            Tygh::$app['view']->assign('email', $email);
        }
    }

    if ($cp_mode == 'login') {
        $auth = Tygh::$app['session']['auth'];

        if ($cp_step == 'password') {

            $password = !empty($request['password']) ? $request['password'] : '';
            if (!empty($password)) {
                $email = Tygh::$app['session']['cp_login_step']['email'];


                if (!defined('CP_NBT_DEBUG')) {
                    //delay to prevent brute forcing
                    sleep(1 + rand(0, 1));
                }

                $user_data = fn_cp_new_buying_types_login($email, $password);
                unset($password, $_REQUEST['user_data']['password'], $request['password']);

                if ($user_data === false) {
                    fn_set_notification(NotificationSeverity::ERROR, __('error'), __('error_incorrect_login'));
                    $cp_mode = 'login';
                    $cp_step = 'email';
                    Tygh::$app['view']->assign('email', $email);
                } else {
                    fn_set_notification(NotificationSeverity::NOTICE, __('notice'), __('successful_login'));
                    Tygh::$app['session']['cp_login_step']['login'] = 'Y';

                    if (!empty(Tygh::$app['session']['cp_login_step']['chph']) &&
                        Tygh::$app['session']['cp_login_step']['chph'] == YesNo::YES &&
                        $user_data['cp_phone_verified'] == YesNo::NO) {
                        $cp_mode = 'login';
                        $cp_step = 'phone';
                        Tygh::$app['view']->assign('phone', $user_data['phone']);
                    } else {
                        fn_cp_new_buying_types_redirect();

                        return [CONTROLLER_STATUS_NO_CONTENT];
                    }
                }
            }
        } elseif ($cp_step == 'phone') {
            $code_sent = fn_cp_nbt_is_code_sent($auth['user_id']);
            Tygh::$app['session']['cp_login_step']['code_sent'] = $code_sent;
            if ($code_sent) {
                $phone = Tygh::$app['session']['cp_login_step']['phone'];
                Tygh::$app['view']->assign('phone', $phone);
            } else {
                $phone = !empty($request['phone']) ? $request['phone'] : '';
                Tygh::$app['view']->assign('phone', $phone);
                Tygh::$app['session']['cp_login_step']['phone'] = $phone;

                $send_result = fn_cp_new_buying_types_send_code($phone);

                switch ($send_result) {
                    case SendCodeResults::SEND_FAILED:
                        fn_set_notification(NotificationSeverity::ERROR,
                            __('error'), __('cp_new_buying_types.cp_otp_send_fail'));
                        break;
                    case SendCodeResults::USER_MUST_BE_LOGGED:
                        fn_set_notification(NotificationSeverity::WARNING,
                            __('warning'), __('cp_new_buying_types.user_must_be_logged_in'));
                        $cp_step = 'email';
                        $cp_mode = 'login';
                        break;
                    case SendCodeResults::INCORRECT_PHONE_FORMAT:
                        fn_set_notification(NotificationSeverity::WARNING,
                            __('warning'), __('cp_new_buying_types.cp_correct_phone_format'));
                        break;
                    default:
                    case SendCodeResults::SUCCESS:
                        $cp_step = 'confirm_code';
                        $cp_mode = 'login';
                        break;
                }

            }
        } elseif ($cp_step == 'confirm_code') {
            if (!isset(Tygh::$app['session']['cp_otp']['confirm_vendor']['code'])) {
                fn_set_notification(NotificationSeverity::ERROR,
                    __('error'), __('cp_new_buying_types.errors_while_confirmation'));
                $cp_step = 'phone';
                $cp_mode = 'login';
            } else {
                if (!empty($request['cp_otp_code'])) {
                    $confirm_code = $request['cp_otp_code'];
                } elseif (!empty($request['code']) && is_array($request['code']) && count($request['code']) == 4) {
                    $confirm_code = implode('', $request['code']);
                }

                if (!isset($confirm_code) || strlen($confirm_code) != 4) {
                    fn_set_notification(NotificationSeverity::ERROR,
                        __('error'), __('cp_new_buying_types.cp_provide_valid_code'));
                    $cp_step = 'confirm_code';
                    $cp_mode = 'login';
                } elseif ($confirm_code != Tygh::$app['session']['cp_otp']['confirm_vendor']['code']) {
                    fn_set_notification(NotificationSeverity::ERROR,
                        __('error'), __('cp_new_buying_types.cp_provide_valid_code'));
                    $cp_step = 'confirm_code';
                    $cp_mode = 'login';
                } elseif (empty($auth['user_id'])) {
                    fn_set_notification(NotificationSeverity::ERROR,
                        __('warning'), __('cp_new_buying_types.user_must_be_logged_in'));
                    $cp_step = 'email';
                    $cp_mode = 'login';
                } else {
                    $phone = Tygh::$app['session']['cp_login_step']['phone'];
                    fn_cp_nbt_make_phone_confirmed($auth['user_id'], $phone);

                    fn_cp_new_buying_types_redirect();

                    return [CONTROLLER_STATUS_NO_CONTENT];
                }
                Tygh::$app['view']->assign('phone', Tygh::$app['session']['cp_login_step']['phone']);
            }
        }
    } elseif ($cp_mode == 'register') {
        if (!fn_cp_new_buying_types_is_valid_user_data_for_registration($request)) {
            $cp_step = 'user_data';
            $cp_mode = 'register';
            Tygh::$app['view']->assign('email', $request['user_data']['email']);
            Tygh::$app['view']->assign('firstname', $request['user_data']['firstname']);
            Tygh::$app['view']->assign('lastname', $request['user_data']['lastname']);

            return [CONTROLLER_STATUS_NO_CONTENT];
        }

        fn_restore_processed_user_password($_REQUEST['user_data'], $_POST['user_data']);

        $user_data = (array)$request['user_data'];
        $user_data['user_login'] = $user_data['email'];

        $auth = Tygh::$app['session']['auth'];

        if (empty($auth['user_id']) && !empty(Tygh::$app['session']['cart']['user_data'])) {
            $user_data += array_filter((array)Tygh::$app['session']['cart']['user_data']);
        }

        $res = fn_update_user($auth['user_id'], $user_data, $auth, !empty($_REQUEST['ship_to_another']), true);

        if ($res) {
            list($user_id, $profile_id) = $res;

            if (
                !empty(Tygh::$app['session']['cart'])
                && !isset(Tygh::$app['session']['cart']['payment_id'])
            ) {
                Tygh::$app['session']['cart']['user_data'] = $_REQUEST['user_data'];
            }

            if (empty(Tygh::$app['session']['cart']['user_data']['profile_id'])) {
                Tygh::$app['session']['cart']['user_data']['profile_id'] = $profile_id;
            }

            // Delete anonymous authentication
            if ($cu_id = fn_get_session_data('cu_id') && !empty($auth['user_id'])) {
                fn_delete_session_data('cu_id');
            }

            Tygh::$app['session']->regenerateID();

        } else {
            fn_save_post_data('user_data');
            fn_delete_notification('changes_saved');
        }

        $redirect_params = array();

        if (!empty($user_id)) {
            if (fn_login_user($user_id) == LOGIN_STATUS_OK) {
                $cp_login_step = Tygh::$app['session']['cp_login_step'];

                if (!empty($cp_login_step['remember_me']) && $cp_login_step['remember_me'] == YesNo::YES) {
                    fn_set_session_data(AREA . '_user_id', $user_data['user_id'], COOKIE_ALIVE_TIME);
                    fn_set_session_data(AREA . '_password', $user_data['password'], COOKIE_ALIVE_TIME);
                }

                fn_set_notification(NotificationSeverity::NOTICE, __('information'), __('text_profile_is_created'));

                if (!empty(Tygh::$app['session']['cp_login_step']['chph']) &&
                    Tygh::$app['session']['cp_login_step']['chph'] == YesNo::YES) {
                    $cp_mode = 'login';
                    $cp_step = 'phone';
                    Tygh::$app['view']->assign('phone', $user_data['phone']);
                    Tygh::$app['session']['cp_login_step']['login'] = 'Y';
                } else {
                    fn_cp_new_buying_types_redirect();

                    return [CONTROLLER_STATUS_NO_CONTENT];
                }
            }
        } else {
            //Some error happened - interrupt
            fn_set_notification(NotificationSeverity::ERROR,
                __('error'), __('cp_new_buying_types.contact_administrator'));
            fn_cp_new_buying_types_redirect(true);

            return [CONTROLLER_STATUS_NO_CONTENT];
        }
    }

    Tygh::$app['session']['cp_login_step']['step'] = $cp_step;
    Tygh::$app['session']['cp_login_step']['mode'] = $cp_mode;

    Tygh::$app['view']->display('addons/cp_new_buying_types/views/auth/cp_nbt_popup_content.tpl');

    exit;
}

/**
 * Sends code to the phone
 *
 * @param string $phone
 *
 * @return int
 */
function fn_cp_new_buying_types_send_code($phone)
{
    if (strlen($phone) < CP_OTP_MIN_PHONE_NUM) {
        return SendCodeResults::INCORRECT_PHONE_FORMAT;
    }

    $auth = Tygh::$app['session']['auth'];
    if (empty($auth['user_id'])) {
        return SendCodeResults::USER_MUST_BE_LOGGED;
    }

    $user_id = $auth['user_id'];

    $user_data = [
        'phone' => $phone,
        'user_id' => $user_id,
    ];

    $type = 'confirm_vendor';
    if (defined('CP_NBT_DEBUG') && CP_NBT_DEBUG) {
        $send_result = true;
        Tygh::$app['session']['cp_otp'][$type] = [
            'code' => '1111',
            'time' => time(),
            'auth_type' => $type,
            'to' => $phone,
            'user_id' => $user_id,
        ];
    } else {
        $send_result = fn_cp_otp_send_code_no_user_check($user_data, $type, $send_error);
    }

    if (empty($send_result)) {
        return SendCodeResults::SEND_FAILED;
    }

    return SendCodeResults::SUCCESS;
}

/**
 * Logs user in
 *
 * @param string $email
 * @param string $password
 *
 * @return false|mixed
 */
function fn_cp_new_buying_types_login($email, $password)
{
    $request = [
        'user_login' => $email,
        'password' => $password,
    ];

    $auth = Tygh::$app['session']['auth'];
    $cp_login_step = Tygh::$app['session']['cp_login_step'];

    list($status, $user_data, $user_login, $password, $salt) = fn_auth_routines($request, $auth);
    if ($status) {
        if (
            !empty($user_data)
            && !empty($password)
            && fn_user_password_verify((int)$user_data['user_id'], $password, (string)$user_data['password'], (string)$salt)
        ) {
            // Regenerate session ID for security reasons
            Tygh::$app['session']->regenerateID();
            //
            // If customer placed orders before login, assign these orders to this account
            //
            if (!empty($auth['order_ids'])) {
                foreach ($auth['order_ids'] as $k => $v) {
                    db_query("UPDATE ?:orders SET ?u WHERE order_id = ?i", array('user_id' => $user_data['user_id']), $v);
                }
            }

            fn_login_user($user_data['user_id'], true);

            if (!empty($cp_login_step['remember_me']) && $cp_login_step['remember_me'] == YesNo::YES) {
                fn_set_session_data(AREA . '_user_id', $user_data['user_id'], COOKIE_ALIVE_TIME);
                fn_set_session_data(AREA . '_password', $user_data['password'], COOKIE_ALIVE_TIME);
            }

            return $user_data;
        }
    }

    return false;
}

/**
 * When all routines are done, redirect customer to the url he came from
 *
 * @return void
 */
function fn_cp_new_buying_types_redirect()
{
    $return_url = !empty(Tygh::$app['session']['cp_login_step']['return_url']) ?
        Tygh::$app['session']['cp_login_step']['return_url'] : '';

    if (isset(Tygh::$app['session']['cp_login_step']['target_id'])) {
        $target_id = Tygh::$app['session']['cp_login_step']['target_id'];

        if (preg_match('/_ajax\d+/', $target_id)) {
            $target_id = preg_replace('/ajax/', '', $target_id);
        }
        Tygh::$app['session']['cp_target_id'] = $target_id;
    }

    unset(Tygh::$app['session']['cp_login_step']);

    Tygh::$app['ajax']->assign('force_redirection',
        fn_url($return_url));
}

/**
 * Checks whether the request data fulfills the registration needs
 *
 * @param array $request
 *
 * @return bool
 */
function fn_cp_new_buying_types_is_valid_user_data_for_registration($request)
{
    if (empty($request['user_data']['email'])) {
        fn_set_notification(NotificationSeverity::WARNING,
            __('warning'), __('error_validator_required', array('[field]' => __('email'))));
        return false;

    } elseif (!fn_validate_email($request['user_data']['email'])) {
        fn_set_notification(NotificationSeverity::WARNING,
            __('error'), __('text_not_valid_email', array('[email]' => $request['user_data']['email'])));
        return false;
    }

    if (empty($request['user_data']['password1']) || empty($request['user_data']['password2'])) {

        if (empty($request['user_data']['password1'])) {
            fn_set_notification(NotificationSeverity::WARNING,
                __('warning'), __('error_validator_required', array('[field]' => __('password'))));
        }

        if (empty($request['user_data']['password2'])) {
            fn_set_notification(NotificationSeverity::WARNING,
                __('warning'), __('error_validator_required', array('[field]' => __('confirm_password'))));
        }
        return false;

    } elseif ($request['user_data']['password1'] !== $request['user_data']['password2']) {
        fn_set_notification(NotificationSeverity::WARNING,
            __('warning'), __('error_validator_password', array('[field2]' => __('password'), '[field]' => __('confirm_password'))));
        return false;
    }

    return true;
}