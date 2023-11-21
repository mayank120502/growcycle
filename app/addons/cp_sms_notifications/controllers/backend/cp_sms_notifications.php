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
        if (!empty($_REQUEST['active_action']) && !empty($_REQUEST['data'])) {
            $active_action = $_REQUEST['active_action'];
            if (!empty($_REQUEST['multiple'])) {
                foreach ($_REQUEST['data'] as $obj_data) {
                    fn_cp_sn_update_notification($active_action, $obj_data);
                }
            } else {
                fn_cp_sn_update_notification($active_action, $_REQUEST['data']);
            }
            return array(CONTROLLER_STATUS_REDIRECT, 'cp_sms_notifications.update?selected_section=' . $active_action);
        }
    }
    if ($mode == 'send') {
        if (!empty($_REQUEST['cp_sms_data']['phone'])) {
            $sms_data = $_REQUEST['cp_sms_data'];
            $sended = fn_cp_sn_send_sms_notification('manual', $sms_data['phone'], $sms_data['content'], $sms_data);
            if ($sended) {
                fn_set_notification('N', __('notice'), __('cp_sms_sent_successfull'));
            }
        }
        if (!empty($_REQUEST['cp_return_url'])) {
            return array(CONTROLLER_STATUS_REDIRECT, $_REQUEST['cp_return_url']);
        }
    }

    return array(CONTROLLER_STATUS_OK, 'cp_sms_notifications.manage');
}

if ($mode == 'update') {
    $actions = fn_get_schema('cp_sms_notifications', 'actions');
    $tabs = array();
    foreach ($actions as $action_key => $action) {
        if (empty($action['title'])) {
            continue;
        }
        $tabs[$action_key] = array(
            'title' => $action['title'],
            'href' => 'cp_sms_notifications.update?selected_section=' . $action_key
        );
    }
    Registry::set('navigation.tabs', $tabs);
    
    $active_action = !empty($_REQUEST['selected_section']) ? $_REQUEST['selected_section'] : 'order_status';
    $current_action = !empty($actions[$active_action]) ? $actions[$active_action] : array();
    $notifications = call_user_func(___cp('Zm5fY3Bfc25fZ2V0P2FjdGlvbl9ub3RpZmljYPRpb25z'), $active_action);
    if (!empty($current_action['multiple'])) {
        Tygh::$app['view']->assign('notifications', $notifications);
    } else {
        Tygh::$app['view']->assign('notification', reset($notifications));
    }
    Tygh::$app['view']->assign('actions', $actions);
    Tygh::$app['view']->assign(___cp('dmFyaWFibGVz'), call_user_func(___cp('Zm5fY3BfZ2V0P3Xtc19ub3RpZmljYPRpb25fcGxhY2Vob2xkZPJz'), $active_action));
}