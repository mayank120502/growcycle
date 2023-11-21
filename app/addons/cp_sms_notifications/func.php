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
use Tygh\Template\Mail\Template;
use Tygh\Template\Mail\Context;
use Tygh\Template\Collection;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

//
// Hooks
//

function fn_cp_sms_notifications_change_order_status($status_to, $status_from, $order_info, $force_notification, $order_statuses, $place_order)
{
    if (!empty($order_info['phone'])
        && !empty($order_info['cp_sms_receive']) && $order_info['cp_sms_receive'] == 'Y'
    ) {
        $notification = fn_cp_sn_get_notification('order_status', $status_to);
        if (!empty($notification['content'])) {
            $order_info['status'] = $status_to;
            $content = fn_cp_sn_prepare_notification_content($notification, $order_info);
            fn_cp_sn_send_sms_notification('order_status', $order_info['phone'], $content, $order_info);
        }
    }
}

function fn_cp_sms_notifications_tools_change_status($params, $result)
{
    if (empty($params['table']) || $params['table'] != 'shipments'
        || empty($params['status']) || $params['status'] != 'S'
    ) {
        return;
    }

    $notification = fn_cp_sn_get_notification('shipment');
    if (!empty($notification['content'])) {
        list($shipments, ) = fn_get_shipments_info($params);
        $shipment = reset($shipments);
        $order_info = fn_get_order_info($shipment['order_id'], false, true, true);
        if (!empty($order_info['phone'])) {
            $content = fn_cp_sn_prepare_notification_content($notification, $order_info);
            fn_cp_sn_send_sms_notification('shipment', $order_info['phone'], $content, $order_info);
        }
    }
}

//
// Common functions
//

function fn_cp_sn_get_action_notifications($action, $lang_code = DESCR_SL)
{
    $company_id = fn_get_runtime_company_id();
    $join = $condition = '';
    $join = db_quote(
        ' LEFT JOIN ?:cp_sms_notification_descriptions as descr'
        . ' ON descr.notification_id = notifications.notification_id AND descr.lang_code = ?s', $lang_code
    );
    $condition = db_quote(' notifications.action = ?s', $action);
    if (!empty($company_id)) {
        $condition .= db_quote(' AND notifications.company_id = ?i', $company_id);
    }
    $data = db_get_hash_array(
        'SELECT * FROM ?:cp_sms_notifications as notifications ?p WHERE ?p',
        'object_key', $join, $condition
    );
    if (!empty($data['notification_id'])) {
        $data['extra'] = !empty($data['extra']) ? unserialize($data['extra']) : array();
    }
    return $data;
}

function fn_cp_sn_get_notification($action, $object_key = '', $lang_code = DESCR_SL)
{
    $join = $condition = '';
    $join = db_quote(
        ' LEFT JOIN ?:cp_sms_notification_descriptions as descr'
        . ' ON descr.notification_id = notifications.notification_id AND descr.lang_code = ?s', $lang_code
    );
    $condition = db_quote(' notifications.action = ?s AND object_key = ?s AND status = ?s', $action, $object_key, 'A');
    
    $company_id = fn_get_runtime_company_id();
    if (!empty($company_id)) {
        $condition .= db_quote(' AND notifications.company_id = ?i', $company_id);
    }

    $data = db_get_row(
        'SELECT * FROM ?:cp_sms_notifications as notifications ?p WHERE ?p',
        $join, $condition
    );
    if (!empty($data['notification_id'])) {
        $data['extra'] = !empty($data['extra']) ? unserialize($data['extra']) : array();
    }
    return $data;
}


function fn_cp_sn_update_notification($action, $data, $lang_code = DESCR_SL)
{
    $company_id = fn_get_runtime_company_id();
    $object_key = !empty($data['object_key']) ? $data['object_key'] : '';
    $notification_id = db_get_field(
        'SELECT notification_id FROM ?:cp_sms_notifications'
        . ' WHERE action = ?s AND object_key = ?s AND company_id = ?i',
        $action, $object_key, $company_id
    );
    $data['company_id'] = $company_id;
    $data['action'] = $action;
    $data['extra'] = !empty($data['extra']) ? serialize($data['extra']) : '';
    if (empty($notification_id)) { // Create
        $notification_id = db_query('INSERT INTO ?:cp_sms_notifications ?e', $data);
        $data['notification_id'] = $notification_id;
        foreach (fn_get_translation_languages() as $data['lang_code'] => $_v) {
            db_query('REPLACE INTO ?:cp_sms_notification_descriptions ?e', $data);
        }
    } else { // Update
        db_query('UPDATE ?:cp_sms_notifications SET ?u WHERE notification_id = ?i', $data, $notification_id);
        db_query(
            'UPDATE ?:cp_sms_notification_descriptions SET ?u WHERE notification_id = ?i AND lang_code = ?s',
            $data, $notification_id, $lang_code
        );
    }
    return $notification_id;
}

function fn_cp_sn_prepare_notification_content($notification, $data, $lang_code = DESCR_SL)
{
    if (empty($notification['content'])) {
        return '';
    }
    $content = $notification['content'];
    $area = 'C';
    $renderer = Tygh::$app['template.renderer'];
    $rend_template = new Template();
    $used_placeholders = $renderer->retrieveVariables($content);
    $placeholders = fn_cp_get_sms_notification_placeholders($notification['action']);
    $placeholder_values = fn_cp_sn_get_placeholder_values($content, $data, $placeholders, $used_placeholders, $lang_code);

    $rend_template->setTemplate($content);
    $context = new Context($placeholder_values, $area, $lang_code);
    $collection = new Collection($context->data);
    try {
        $content = $renderer->renderTemplate($rend_template, $context, $collection);
        $content = str_replace(array("\n", "\r"), ' ', $content);
    } catch (Exception $e) {
        $content = '';
    }

    $content = trim(preg_replace('/\s{2,}/', ' ', $content));

    return $content;
}

function fn_cp_sn_send_sms_notification($action, $phone, $content, $data = array(), $extra = array())
{
    if (function_exists('fn_cp_sms_send_by_service')) {
        $sended = fn_cp_sms_send_by_service($phone, $content);
    }
    if (!empty($sended)) {
        fn_cp_sn_add_log_event($action, array(
            'phone' => preg_replace('/[^\d]+/', '', $phone),
            'content' => $content,
            'user_id' => !empty($data['user_id']) ? $data['user_id'] : '',
            'order_id' => !empty($data['order_id']) ? $data['order_id'] : 0,
            'company_id' => !empty($data['company_id']) ? $data['company_id'] : 0,
            'extra' => !empty($extra) ? serialize($extra) : ''
        ));
    }
    return $sended;
}

function fn_cp_sn_get_logs($params, $items_per_page = 0)
{
    $default_params = array(
        'items_per_page' => $items_per_page,
        'page' => 1
    );
    $params = array_merge($default_params, $params);

    $fields = array (
        '?:cp_sms_logs.*',
        '?:users.firstname',
        '?:users.lastname',
        '?:users.user_id'
    );

    $params['company_id'] = isset($params['company_id']) ? $params['company_id'] : fn_get_runtime_company_id();

    $join = $condition = $sortings = $limit = '';

    $join = db_quote(' LEFT JOIN ?:users ON ?:cp_sms_logs.sender_id = ?:users.user_id');
    
    if (!empty($params['company_id'])) {
        $condition .= db_quote(' AND ?:cp_sms_logs.company_id = ?i', $params['company_id']);
    }
    
    if (!empty($params['action'])) {
        $condition .= db_quote(' AND ?:cp_sms_logs.action = ?s', $params['action']);
    }

    if (isset($params['user_id'])) {
        $condition .= db_quote(' AND ?:cp_sms_logs.user_id = ?i', $params['user_id']);
    }

    if (isset($params['order_id'])) {
        $condition .= db_quote(' AND ?:cp_sms_logs.order_id = ?i', $params['order_id']);
    }

    if (isset($params['q_user']) && fn_string_not_empty($params['q_user'])) {
        $user_names = array_filter(explode(' ', $params['q_user']));
        foreach ($user_names as $user_name) {
            $condition .= db_quote(
                ' AND (?:users.firstname LIKE ?l OR ?:users.lastname LIKE ?l)',
                "%{$user_name}%", "%{$user_name}%"
            );
        }
    }

    if (!empty($params['period']) && $params['period'] != 'A') {
        list($time_from, $time_to) = fn_create_periods($params);
        $condition .= db_quote(
            ' AND (?:cp_sms_logs.timestamp >= ?i AND ?:cp_sms_logs.timestamp <= ?i)',
            $time_from, $time_to
        );
    }

    $sortings = array(
        'timestamp' => '?:cp_sms_logs.timestamp',
        'action' => '?:cp_sms_logs.action',
        'phone' => '?:cp_sms_logs.phone',
        'user' => array('?:users.lastname', '?:users.firstname')
    );
    
    $sorting = db_sort($params, $sortings, 'timestamp', 'desc');

    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field(
            'SELECT COUNT(DISTINCT(?:cp_sms_logs.log_id)) FROM ?:cp_sms_logs ?p WHERE 1 ?p',
            $join, $condition
        );
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }

    $logs = db_get_hash_array(
        'SELECT ?p FROM ?:cp_sms_logs ?p WHERE 1 ?p ?p ?p', 'log_id',
        implode(', ', $fields), $join, $condition, $sorting, $limit
    );
    
    return array($logs, $params);
}

function fn_cp_sn_get_placeholder_values($template, $data, $placeholders, $used_placeholders = array(), $lang_code = CART_LANGUAGE)
{
    if (empty($placeholders)) {
        return array();
    }
    $placeholder_values = array();
    foreach ($placeholders as $pl_key => $pl_data) {
        if (!empty($pl_data['is_group'])) {
            foreach ($used_placeholders as $used_pl) {
                if (strpos($used_pl, $pl_key) === false) {
                    continue;
                }
                $placeholder_values[$used_pl] = '';
                if (!empty($pl_data['get_function']) && function_exists($pl_data['get_function'])) {
                    $data['cp_placeholder'] = $used_pl;
                    $placeholder_values[$used_pl] = call_user_func($pl_data['get_function'], $data);
                }
            }
            $placeholder_values[$pl_key] = '';
            continue;
        } elseif (!empty($used_placeholders) && !in_array($pl_key, $used_placeholders)) {
            continue;
        }

        if (!empty($pl_data['get_function']) && function_exists($pl_data['get_function'])) {
            $placeholder_values[$pl_key] = call_user_func($pl_data['get_function'], $data);
        } else {
            $field = !empty($pl_data['field']) ? $pl_data['field'] : $pl_key;
            $placeholder_value = !empty($data[$field]) ? $data[$field] : '';
            if (!empty($pl_data['proccess_function']) && function_exists($pl_data['proccess_function'])) {
                $placeholder_value = call_user_func($pl_data['proccess_function'], $placeholder_value);
            }
            $placeholder_values[$pl_key] = $placeholder_value;
        }
    }
    return $placeholder_values;
}

function fn_cp_sn_add_log_event($action, $data = array())
{
    $default_data = array(
        'action' => $action,
        'timestamp' => TIME,
        'sender_id' => Tygh::$app['session']['auth']['user_id'],
        'company_id' => fn_get_runtime_company_id()
    );

    $data = array_merge($default_data, $data);

    $log_id = db_query('INSERT INTO ?:cp_sms_logs ?e', $data);
    return $log_id;
}

function fn_cp_sn_delete_logs($log_ids = array(), $delete_all = false)
{
    if ($delete_all || !empty($log_ids)) {
        $company_id = fn_get_runtime_company_id();
        $condition = !empty($log_ids) ? db_quote(' AND log_id IN (?n)', $log_ids) : '';
        db_query('DELETE FROM ?:cp_sms_logs WHERE company_id = ?i ?p', $company_id, $condition);
    }
}

function fn_cp_get_sms_notification_placeholders($type = 'O')
{
    $all_placeholders = fn_get_schema('cp_sms_notifications', 'placeholders');

    $placeholders = array();
    $placeholders = !empty($all_placeholders[$type]) ? $all_placeholders[$type] : array();
    foreach ($placeholders as $pl_key => &$pl_data) {
        if (empty($pl_data['is_group'])) {
            continue;
        }
        $pl_data['variables'] = array();
        if (!empty($pl_data['variables_function']) && function_exists($pl_data['variables_function'])) {
            $pl_data['variables'] = call_user_func($pl_data['variables_function']);
        }
    }
    return $placeholders;
}

function fn_cp_sn_get_sms_actions()
{
    $all_actions = array(
        'manual' => __('cp_sn_action_manual_send')
    );

    $schema_actions = fn_get_schema('cp_sms_notifications', 'actions');
    foreach ($schema_actions as $action_key => $action) {
        $all_actions[$action_key] = !empty($action['title']) ? $action['title'] : '';
    }
    return $all_actions;
}
