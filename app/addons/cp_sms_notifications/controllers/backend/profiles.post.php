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

if ($mode == 'update') {
    $user = Tygh::$app['view']->getTemplateVars('user_data');
    Registry::set('navigation.tabs.cp_sms_send', array(
        'title' => __('cp_sms_send'),
        'js' => true
    ));
    if (!empty($user['phone']) && Registry::get('addons.cp_sms_notifications.show_manual_send') == 'Y'
        && !empty($user['user_type']) && ($user['user_type'] == 'C')
        && fn_check_permissions('cp_sms_notifications', 'send', 'admin', 'POST')
    ) {
        Tygh::$app['view']->assign('cp_sms_show_send_tab', true);
    }
    if (fn_check_permissions('cp_sms_notifications', 'send', 'admin', 'GET')) {
        Registry::set('navigation.tabs.cp_sms_logs', array(
            'title' => __('cp_sms_logs'),
            'js' => true
        ));
        Tygh::$app['view']->assign('cp_sms_show_log_tab', true);
        Tygh::$app['view']->assign('all_actions', fn_cp_sn_get_sms_actions());
        
        list($logs, $search) = fn_cp_sn_get_logs($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));
        Tygh::$app['view']->assign('cp_sms_logs', $logs);
        Tygh::$app['view']->assign('cp_sms_search', $search);
    }
}
