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
    if ($mode == 'clean') {
        fn_cp_sn_delete_logs(array(), true);
    }
    if ($mode == 'm_delete') {
        if (!empty($_REQUEST['log_ids'])) {
            fn_cp_sn_delete_logs($_REQUEST['log_ids']);
        }
    }
    return array(CONTROLLER_STATUS_OK, 'cp_sms_logs.manage');
}

if ($mode == 'manage') {
    list($logs, $search) = fn_cp_sn_get_logs($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));
    
    Tygh::$app['view']->assign('logs', $logs);
    Tygh::$app['view']->assign('search', $search);
    Tygh::$app['view']->assign('all_actions', fn_cp_sn_get_sms_actions());
}