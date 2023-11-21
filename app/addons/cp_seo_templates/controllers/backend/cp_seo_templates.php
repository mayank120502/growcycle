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

    $return_url = !empty($_REQUEST['return_url']) ? $_REQUEST['return_url'] : '';

    if ($mode == 'update') {
        if (!empty($_REQUEST['seo_template'])) {
            $template_id = !empty($_REQUEST['template_id']) ? $_REQUEST['template_id'] : 0;
            $template_id = fn_cp_update_seo_template($template_id, $_REQUEST['seo_template']);
            $return_url = 'cp_seo_templates.update?template_id=' . $template_id;
        }
    }
    if ($mode == 'm_update') {
        if (!empty($_REQUEST['seo_templates'])) {
            foreach ($_REQUEST['seo_templates'] as $template_id => $template_data) {
                fn_cp_update_seo_template($template_id, $template_data, DESCR_SL);
            }
        }
    }
    if ($mode == 'delete') {
        if (!empty($_REQUEST['template_id'])) {
            fn_cp_delete_seo_template($_REQUEST['template_id']);
            fn_set_notification('N', __('notice'), __('cp_text_template_delete'));
        }
    }
    if ($mode == 'm_delete') {
        if (!empty($_REQUEST['template_ids'])) {
            foreach ($_REQUEST['template_ids'] as $template_id) {
                fn_cp_delete_seo_template($template_id);
            }
            fn_set_notification('N', __('notice'), __('cp_text_templates_delete'));
        }
    }
    if ($mode == 'apply') {
        if (!empty($_REQUEST['template_id'])) {
            fn_cp_st_apply_seo_template($_REQUEST['template_id'], true);
            fn_set_notification('N', __('notice'), __('cp_text_template_apply'));
        }
    }
    if ($mode == 'm_apply') {
        if (!empty($_REQUEST['template_ids'])) {
            foreach ($_REQUEST['template_ids'] as $template_id) {
                fn_cp_st_apply_seo_template($template_id, true);
            }
            fn_set_notification('N', __('notice'), __('cp_text_templates_apply'));
        }
    }
    if ($mode == 'clone') {
        if (!empty($_REQUEST['template_id'])) {
            $cloned_template_id = fn_cp_clone_seo_template($_REQUEST['template_id']);
            fn_set_notification('N', __('notice'), __('cp_text_template_clone'));
            if (empty($return_url)) {
                $return_url = 'cp_seo_templates.update?template_id=' . $cloned_template_id;
            }
        }
    }
    if ($mode == 'm_clone') {
        if (!empty($_REQUEST['template_ids'])) {
            foreach ($_REQUEST['template_ids'] as $template_id) {
                fn_cp_clone_seo_template($template_id);
            }
            fn_set_notification('N', __('notice'), __('cp_text_templates_clone'));
        }
    }
    
    if (!empty($return_url)) {
        return [CONTROLLER_STATUS_OK, $return_url];
    }
    return [CONTROLLER_STATUS_OK, 'cp_seo_templates.manage'];
}

if ($mode == 'manage') {
    $params = $_REQUEST;
    $params['company_id'] = Registry::get('runtime.company_id');
    
    list($seo_templates, $search) = fn_cp_get_seo_templates($params, Registry::get('settings.Appearance.admin_elements_per_page'));

    Tygh::$app['view']->assign('seo_templates', $seo_templates);
    Tygh::$app['view']->assign('search', $search);

    Tygh::$app['view']->assign('template_types', fn_get_schema('cp_seo_templates', 'objects'));

} elseif ($mode == 'update' || $mode == 'add') {

    $tabs = [
        'general' => [
            'title' => __('general'),
            'js' => true
        ],
        'settings' => [
            'title' => __('settings'),
            'js' => true
        ],
        'condition' => [
            'title' => __('condition'),
            'js' => true
        ]
    ];
    Registry::set('navigation.tabs', $tabs);

    $type = !empty($_REQUEST['type']) ? $_REQUEST['type'] : 'P';
    if (!empty($_REQUEST['template_id'])) {
        $template = fn_cp_get_seo_template_data($_REQUEST['template_id'], DESCR_SL);
        $type = !empty($template['type']) ? $template['type'] : $type;
        Tygh::$app['view']->assign('template', $template);
    }

    $cpv1 = ___cp('Y3Bfc2VvP3RlbPBsYPRlcw');
    $cpv2 = ___cp('dmFyaWFibGVz');
    Tygh::$app['view']->assign($cpv2, call_user_func(___cp('Zm5fY3BfZ2V0P3Xlb190ZW1wbGF0ZV9wbGFjZWhvbGRlcnM'), $type));

    $template_types = call_user_func(___cp('Zm5fZ2V0P3XjaGVtYQ'), $cpv1, 'objects');
    Tygh::$app['view']->assign('template_types', $template_types);

    $conditions = [];
    if (!empty($template_types[$type]['conditions'])) {
        $template_conditions = call_user_func(___cp('Zm5fZ2V0P3XjaGVtYQ'), $cpv1, 'conditions');
        $conditions = array_intersect_key($template_conditions, array_flip($template_types[$type]['conditions']));
    }
    Tygh::$app['view']->assign('conditions', $conditions);
    
    $fields = [];
    if (!empty($template_types[$type]['fields'])) {
        $template_fields = call_user_func(___cp('Zm5fZ2V0P3XjaGVtYQ'), $cpv1, 'fields');
        $fields = array_intersect_key($template_fields, $template_types[$type]['fields']);
    }
    Tygh::$app['view']->assign('fields', $fields);
    
    $available_filters = fn_get_schema('cp_seo_templates', 'filters_and_functions');
    Tygh::$app['view']->assign('twig_filters', $available_filters);

} elseif ($mode == 'dynamic') {

    Tygh::$app['view']->assign('prefix', $_REQUEST['prefix']);
    Tygh::$app['view']->assign('elm_id', $_REQUEST['elm_id']);
    
    $type = !empty($_REQUEST['condition']) ? $_REQUEST['condition'] : 'P';
    Tygh::$app['view']->assign('condition_data', ['condition' => $type]);

    $template_types = fn_get_schema('cp_seo_templates', 'objects');
    Tygh::$app['view']->assign('template_types', $template_types);

    $conditions = [];
    if (!empty($template_types[$type]['conditions'])) {
        $template_conditions = fn_get_schema('cp_seo_templates', 'conditions');
        $conditions = array_intersect_key($template_conditions, array_flip($template_types[$type]['conditions']));
    }
    Tygh::$app['view']->assign('conditions', $conditions);
    
    if (!empty($_REQUEST['template_id'])) {
        $template = fn_cp_get_seo_template_data($_REQUEST['template_id'], CART_LANGUAGE);
        Tygh::$app['view']->assign('template', $template);
    }
}

if ($mode == 'cron_apply') {
    $access_key = !empty($_REQUEST['access_key']) ? $_REQUEST['access_key'] : '';
    $company_id = !empty($_REQUEST['company_id']) ? $_REQUEST['company_id'] : Registry::get('runtime.company_id');

    if ($access_key != Registry::get('addons.cp_seo_templates.cron_key')) {
        exit;
    }

    $set_notification = defined('AJAX_REQUEST') ? true : false;

    fn_cp_st_apply_all_seo_templates(array(), $set_notification);

    if ($set_notification) {
        fn_set_notification('N', __('notice'), __('cp_text_templates_apply'));
    }
    
    exit;
}
