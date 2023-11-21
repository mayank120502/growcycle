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
    if ($mode == 'update_rule') {
        if (!empty($_REQUEST['rule']['dispatch'])) {
            fn_cp_seo_update_index_rule($_REQUEST['rule'], $_REQUEST['rule_id']);
        }
    }
    if ($mode == 'm_update_rules') {
        if (!empty($_REQUEST['rules'])) {
            fn_cp_seo_m_update_rules($_REQUEST['rules']);
        }
    }
    if ($mode == 'm_delete_rules') {
        if (!empty($_REQUEST['rule_ids'])) {
            foreach($_REQUEST['rule_ids'] as $r_id) {
                fn_cp_seo_delete_rule($r_id);
            }
        }
    }
    if ($mode == 'delete_rule') {
        if (!empty($_REQUEST['rule_id'])) {
            fn_cp_seo_delete_rule($_REQUEST['rule_id']);
        }
    }
    return [CONTROLLER_STATUS_OK, 'cp_seo_optimization.index_rules'];
}

if ($mode == 'change_type') {
    if (!empty($_REQUEST['changed_type'])
        && defined('AJAX_REQUEST')
    ) {
        $object_id = 0;
        $changed_type = $_REQUEST['changed_type'];
        if (!empty($_REQUEST['type']) && $changed_type == $_REQUEST['type']) {
            $object_id = !empty($_REQUEST['object_id']) ? $_REQUEST['object_id'] : 0;
        }
        Tygh::$app['view']->assign('obj_id', !empty($_REQUEST['obj_id']) ? $_REQUEST['obj_id'] : '');
        Tygh::$app['view']->assign('object', ['type' => $changed_type, 'object_id' => $object_id]);
        Tygh::$app['view']->display('addons/cp_seo_optimization/components/object_canonical.tpl');
        exit;
    }
}
if ($mode == 'index_rules') {
    $params = $_REQUEST;
    $rules = fn_get_schema('cp_seo_optimization', 'seo_index_pages');
    list($exist_rules, $search) = fn_cp_seo_get_index_rules($params, 0);
    Tygh::$app['view']->assign('exist_rules', $exist_rules);
    Tygh::$app['view']->assign('search', $search);
    Tygh::$app['view']->assign('schema_rules', $rules);
}
if ($mode == 'add_rule') {
    Tygh::$app['view']->display('addons/cp_seo_optimization/views/cp_seo_optimization/components/add_rule.tpl');
    exit;
}