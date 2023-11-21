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

//
// Hooks
//

function fn_cp_seo_templates_get_products($params, &$fields, &$sortings, $condition, $join, $sorting, $group_by, $lang_code, $having)
{
    if (AREA == 'A' && in_array('product_name', $params['extend'])) {
        $fields['cp_st_h1'] = 'descr1.cp_st_h1';
        $fields['cp_st_custom_bc'] = 'descr1.cp_st_custom_bc';
    }
    $sortings['product_id'] = 'products.product_id';
}

function fn_cp_seo_templates_get_pages($params, $join, &$condition, $fields, $group_by, $sortings, $lang_code)
{
    if (!empty($params['cp_seo_this_company_id'])) {
        $condition .= db_quote(" AND ?:pages.company_id = ?i", $params['cp_seo_this_company_id']);
    }
}

function fn_cp_seo_templates_delete_company(&$company_id)
{
    if (fn_allowed_for('ULTIMATE')) {
        $tpl_ids = db_get_fields("SELECT template_id FROM ?:cp_seo_templates WHERE company_id = ?i", $company_id);

        foreach ($tpl_ids as $template_id) {
            fn_cp_delete_seo_template($template_id);
        }
    }
}

function fn_cp_seo_templates_get_product_fields(&$fields)
{
    $fields[] = array(
        'name' => '[data][cp_st_h1]',
        'text' => __('cp_seo_custom_h1'),
        'field' => 'cp_st_h1'
    );
    $fields[] = array(
        'name' => '[data][cp_st_custom_bc]',
        'text' => __('cp_seo_custom_breadcrumb'),
        'field' => 'cp_st_custom_bc'
    );
}

function fn_cp_seo_templates_get_categories($params, $join, $condition, &$fields, $group_by, $sortings, $lang_code)
{
    if (!empty($params['cp_for_seo_templates'])) {
        $fields[] = '?:category_descriptions.description';
        $fields[] = '?:category_descriptions.page_title';
        $fields[] = '?:category_descriptions.meta_keywords';
        $fields[] = '?:category_descriptions.meta_description';
    }
}

function fn_cp_seo_templates_dispatch_before_display()
{
    if (AREA != 'C') {
        return;
    }
    $params = $_REQUEST;

    $remove_spaces = (Registry::get('addons.cp_seo_templates.auto_remove_many_spaces') == 'Y') ? true : false;
    $controller = Registry::get('runtime.controller');
    $mode = Registry::get('runtime.mode');
    $st_check = fn_get_schema('cp_seo_templates', 'st_check');
    $general_pl = fn_get_schema('cp_seo_templates', 'placeholders');
    
    if (empty($st_check[$controller][$mode])) {
        return;
    }

    $current_check = $st_check[$controller][$mode];

    if (!empty($general_pl[$current_check])) {
        $d_placeholders = fn_get_schema('cp_seo_templates', 'dynamic_placeholders');
        $d_placeholders = array_intersect_key($d_placeholders, array_filter($general_pl[$current_check]));
        // Sort placeholders by position
        uasort($d_placeholders, function($a, $b) {
            $a_pos = !empty($a['position']) ? $a['position'] : 0;
            $b_pos = !empty($b['position']) ? $b['position'] : 0;
            return $a_pos > $b_pos;
        });
    
        $view = Tygh::$app['view'];
        $field_values = [];
        $avail_fields = ['custom_h1', 'cp_st_custom_bc', 'page_title', 'meta_description', 'meta_keywords'];
        foreach ($d_placeholders as $pl_key => $placeholder) {
            // Get placeholder value
            $pl_value = !empty($placeholder['get_function']) && is_callable($placeholder['get_function'])
                ? call_user_func_array($placeholder['get_function'], [$params])
                : '';
            if (empty($placeholder['fields'])) {
                continue;
            }
            // Fill meta-tags
            foreach ($placeholder['fields'] as $field) {
                if (isset($avail_fields) && !in_array($field, $avail_fields)) { // check add-on settings
                    continue;
                }
                $field_value = isset($field_values[$field]) ? $field_values[$field] : $view->getTemplateVars($field);
                if ($field == 'custom_h1' && $controller == 'products' && $mode == 'view') {
                    $prod_data = $view->getTemplateVars('product');
                    if (!empty($prod_data['cp_st_h1']) && strpos($prod_data['cp_st_h1'] , '{{ ' . $pl_key . ' }}') !== false) {
                        $prod_data['cp_st_h1'] = str_replace('{{ ' . $pl_key . ' }}', $pl_value, $prod_data['cp_st_h1']);
                        Tygh::$app['view']->assign('product', $prod_data);
                    }
                }
                if ($field == 'cp_st_custom_bc') {
                    $bc = $view->getTemplateVars('breadcrumbs');
                    if (!empty($bc)) {
                        $refresh_bc = false;
                        foreach($bc as &$bc_item) {
                            if (strpos($bc_item['title'] , '{{ ' . $pl_key . ' }}') !== false) {
                                $bc_item['title'] = str_replace('{{ ' . $pl_key . ' }}', $pl_value, $bc_item['title']);
                                $refresh_bc = true;
                            }
                        }
                        if (!empty($refresh_bc)) {
                            Tygh::$app['view']->assign('breadcrumbs', $bc);
                        }
                    }
                }
                if (empty($field_value)) {
                    continue;
                }
                //fn_add_breadcrumb(!empty($object_data['cp_st_custom_bc']) ? $object_data['cp_st_custom_bc'] : $object_data['cp_st_h1']);
                $field_values[$field] = str_replace('{{ ' . $pl_key . ' }}', $pl_value, $field_value);
                if ($remove_spaces) {
                    $field_values[$field] = trim(preg_replace('/\s{2,}/', ' ', $field_values[$field]));
                }
            }
        }
        if (!empty($field_values)) {
            Tygh::$app['view']->assign($field_values);
        }
    }
}

//
// Base functions
//

function fn_cp_st_get_dynamic_placeholder_values($avail_placeholders, $params = array())
{
    if (empty($avail_placeholders)) {
        return array();
    }
    $pl_values = array();
    foreach ($placeholders as $pl_key => $placeholder) {
        if (!in_array($pl_key, $avail_placeholders)) {
            continue;
        }
        if (!empty($placeholder['get_function']) && is_callable($placeholder['get_function'])) {
            $value = call_user_func_array($placeholder['get_function'], array($params));
            if (!empty($value)) {
                $pl_values[$pl_key] = $value;
            }
        }   
    }
    return $pl_values;
}


function fn_cp_get_seo_templates($params, $items_per_page = 0, $lang_code = DESCR_SL)
{
    $default_params = array(
        'items_per_page' => $items_per_page,
        'page' => 1
    );
    $params = array_merge($default_params, $params);

    $fields = array (
        '?:cp_seo_templates.*',
        '?:cp_seo_templates_content.*'
    );

    $params['company_id'] = isset($params['company_id']) ? $params['company_id'] : Registry::get('runtime.company_id');

    $join = $condition = $sortings = $group = $limit = '';

    $join .= db_quote(' LEFT JOIN ?:cp_seo_templates_content ON ?:cp_seo_templates_content.template_id = ?:cp_seo_templates.template_id AND lang_code = ?s', $lang_code);
    
    if (!empty($params['name'])) {
        $condition .= db_quote(' AND ?:cp_seo_templates_content.name LIKE ?l', '%' . $params['name'] . '%');
    }

    if (!empty($params['status'])) {
        $condition .= db_quote(' AND ?:cp_seo_templates.status = ?s', $params['status']);
    }
    
    if (!empty($params['type'])) {
        $condition .= db_quote(' AND ?:cp_seo_templates.type = ?s', $params['type']);
    }

    if (isset($params['company_id'])) {
        $condition .= db_quote(' AND ?:cp_seo_templates.company_id = ?i', $params['company_id']);
    }

    $sortings = array(
        'name' => '?:cp_seo_templates_content.name',
        'priority' => '?:cp_seo_templates.priority',
        'type' => '?:cp_seo_templates.type',
        'status' => '?:cp_seo_templates.status',
    );
    
    $sorting = db_sort($params, $sortings, 'priority', 'desc');

    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field(
            'SELECT COUNT(DISTINCT(?:cp_seo_templates.template_id)) FROM ?:cp_seo_templates ?p WHERE 1 ?p', $join, $condition
        );
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }

    $templates = db_get_hash_array(
        'SELECT ?p FROM ?:cp_seo_templates ?p WHERE 1 ?p ?p ?p ?p', 'template_id',
        implode(', ', $fields), $join, $condition, $group, $sorting, $limit
    );

    return array($templates, $params);
}

function fn_cp_get_seo_template_data($template_id, $lang_code = DESCR_SL)
{   
    $template = db_get_row(
        'SELECT templates.*, content.* FROM ?:cp_seo_templates as templates'
        . ' LEFT JOIN ?:cp_seo_templates_content as content ON content.template_id = templates.template_id'
        . ' WHERE templates.template_id = ?i AND content.lang_code = ?s', $template_id, $lang_code
    );

    if (!empty($template)) {
        $template['conditions'] = !empty($template['conditions']) ? unserialize($template['conditions']) : array();
        $template['settings'] = !empty($template['settings']) ? unserialize($template['settings']) : array();
        if (!empty($template['extra'])) {
            $extra = unserialize($template['extra']);
            $template = array_merge($extra, $template);
        }
    }

    return $template;
}

function fn_cp_update_seo_template($template_id, $data, $lang_code = DESCR_SL)
{
    $default_data = array(
        'company_id' => isset($data['company_id']) ? $data['company_id'] : fn_get_runtime_company_id(),
        'priority' => 0,
        'is_default' => 'N'
    );
    
    $data = array_merge($default_data, $data);

    if (!fn_allowed_for('MULTIVENDOR') && empty($data['company_id'])) {
        $data['company_id'] = fn_get_default_company_id();
    }
    
    if (isset($data['conditions'])) {
        $data['conditions'] = !empty($data['conditions']) && is_array($data['conditions']) ? serialize($data['conditions']) : '';
    }
    if (isset($data['settings'])) {
        $data['settings'] = !empty($data['settings']) && is_array($data['settings']) ? serialize($data['settings']) : '';
    }
    if (isset($data['extra'])) {
        $data['extra'] = !empty($data['extra']) && is_array($data['extra']) ? serialize($data['extra']) : '';
    }
    
    if (empty($template_id)) { // Create
        $template_id = db_query('INSERT INTO ?:cp_seo_templates ?e', $data);

        $data['template_id'] = $template_id;
        foreach (fn_get_translation_languages() as $data['lang_code'] => $_v) {
            db_query('REPLACE INTO ?:cp_seo_templates_content ?e', $data);
        }
    } else { // Update
        db_query('UPDATE ?:cp_seo_templates SET ?u WHERE template_id = ?i', $data, $template_id);
        db_query('UPDATE ?:cp_seo_templates_content SET ?u WHERE template_id = ?i AND lang_code = ?s', $data, $template_id, $lang_code);
    }

    return $template_id;
}

function fn_cp_clone_seo_template($template_id)
{
    $data = db_get_row('SELECT * FROM ?:cp_seo_templates WHERE template_id = ?i', $template_id);
    unset($data['template_id']);
    $data['status'] = 'D';

    if (empty($data)) {
        return false;
    }

    $cloned_template_id = db_query('INSERT INTO ?:cp_seo_templates ?e', $data);

    // Clone descriptions
    $lang_templates = db_get_array('SELECT * FROM ?:cp_seo_templates_content WHERE template_id = ?i', $template_id);
    foreach ($lang_templates as $template) {
        $template['template_id'] = $cloned_template_id;
        $template['name'] .= ' [CLONE]';
        db_query('INSERT INTO ?:cp_seo_templates_content ?e', $template);
    }

    return $cloned_template_id;
}

function fn_cp_delete_seo_template($template_id)
{
    db_query('DELETE FROM ?:cp_seo_templates WHERE template_id = ?i', $template_id);
    db_query('DELETE FROM ?:cp_seo_templates_objects WHERE template_id = ?i', $template_id);
    db_query('DELETE FROM ?:cp_seo_templates_content WHERE template_id = ?i', $template_id);
}

// Common functions

function fn_cp_st_apply_all_seo_templates($params = array(), $set_notification = false)
{
    $company_id = fn_get_runtime_company_id();
    $company_condition = !empty($company_id) ? db_quote(' AND company_id = ?i', $company_id) : '';
    $template_ids = db_get_fields(
        'SELECT template_id FROM ?:cp_seo_templates WHERE status = ?s ?p ORDER BY priority ASC',
        'A', $company_condition
    );
    foreach ($template_ids as $template_id) {
        fn_cp_st_apply_seo_template($template_id, $set_notification);
    }
}

function fn_cp_st_apply_seo_template($template_id, $set_notification = false)
{
    $lang_codes = fn_cp_st_get_lang_codes();
    $step = 10;

    foreach ($lang_codes as $lang_code) {
        $template = fn_cp_get_seo_template_data($template_id, $lang_code);
        if (empty($template['type'])) {
            continue;
        }

        $type = $template['type'];
        $objects_schema = fn_get_schema('cp_seo_templates', 'objects');
        $object_schema = !empty($objects_schema[$type]) ? $objects_schema[$type] : array();
        $placeholders = fn_cp_get_seo_template_placeholders($type);
        $template['step'] = $step;
        if (!empty($set_notification) && !isset($scale_is_set)) {
            if (!empty($object_schema['total_function']) && function_exists($object_schema['total_function'])) {
                $total_items = call_user_func($object_schema['total_function'], $template);
                $steps_count = ceil($total_items  / $step);
                fn_set_progress('step_scale', !empty($steps_count) ? $steps_count * count($lang_codes) + 1 : $step);
            } else {
                fn_set_progress('step_scale', $step);
            }
            $scale_is_set = true;
        }
        if (empty($object_schema) || empty($object_schema['fields'])) {
            continue;
        }

        $objects = array();
        $k_title = !empty($object_schema['title']) ? $object_schema['title'] : $type;
        if (!empty($object_schema['step_function']) && function_exists($object_schema['step_function']) && isset($steps_count)) {
            $page = 1;
            for ($k = 0; $k < $steps_count; $k++) {
                $objects = call_user_func($object_schema['step_function'], $template, $k + 1, $step);
                if (empty($objects)) {
                    break;
                }
                if (!empty($set_notification)) {
                    $k_from = $k * $step + 1;
                    $k_to = ($k + 1) * $step;
                    fn_set_progress('echo', "{$lang_code}: {$k_title} {$k_from} - {$k_to} <br />");
                }
                fn_cp_st_apply_objects_seo_template($template, $objects, $object_schema, $placeholders, $lang_code, false);
            }

        } elseif (!empty($object_schema['get_function']) && function_exists($object_schema['get_function'])) {
            if (!empty($set_notification)) {
                fn_set_progress('echo', "{$lang_code}: {$k_title} " . __('cp_st_receive_data'));
            }
            $objects = call_user_func($object_schema['get_function'], $template);
            if (empty($objects)) {
                continue;
            }
            fn_cp_st_apply_objects_seo_template($template, $objects, $object_schema, $placeholders, $lang_code, $set_notification);
        }
    }
    if (function_exists('fn_cp_am_log_event')) {
        fn_cp_am_log_event('cp_seo_templates', 'generate', array(
            'template_id' => $template_id
        ));
    }
}

function fn_cp_st_apply_objects_seo_template($template, $objects, $object_schema, $placeholders, $lang_code = CART_LANGUAGE, $set_notification = false)
{
    $area = 'C';
    $k = 0;
    $step = !empty($template['step']) ? $template['step'] : 100;
    $k_title = !empty($object_schema['title']) ? $object_schema['title'] : $template['type'];
    $remove_spaces = (Registry::get('addons.cp_seo_templates.auto_remove_many_spaces') == 'Y') ? true : false;
    $allowed_fields = fn_get_schema('cp_seo_templates', 'fields');
    $renderer = Tygh::$app['template.renderer'];
    $rend_template = new Template();
    foreach ($objects as $object_data) {
        $object_data['lang_code'] = $lang_code;
        $rendered_data = array();
        $use_fields = array();
        foreach ($object_schema['fields'] as $tag_key => $tag_field) {
            if (empty($tag_field) || empty($allowed_fields[$tag_key])
                || empty($template['settings']['update']) || !in_array($tag_key, $template['settings']['update'])
            ) {
                continue;
            }
            $object_field = is_string($tag_field) ? $tag_field : $tag_key;
            if ((empty($template['settings']['override']) || $template['settings']['override'] != 'Y')
                && !empty($object_data[$object_field])
            ) {
                continue;
            }
            $use_fields[$object_field] = !empty($template[$tag_key]) ? $template[$tag_key] : '';
        }

        $used_placeholders = $renderer->retrieveVariables(implode(PHP_EOL, $use_fields));

        if(empty($used_placeholders)){
            $used_placeholders = array();
            preg_match_all('/\{{([^}]*)\}}/', implode(PHP_EOL, $use_fields), $matches);

            foreach ($matches[1] as $key => $field) {
                $used_placeholders[] = trim($field); 
            }
        }
        //crutch for placeholder without filters
        foreach($used_placeholders as $pl) {
            if (strpos($pl, '|') !== false) {
                $no_modif = explode('|', $pl);
                if (!empty($no_modif[0]) && !in_array($no_modif[0], $used_placeholders)) {
                    $used_placeholders[] = $no_modif[0];
                }
            }
        }
        //
        $placeholder_values = fn_cp_st_get_placeholder_values($template, $object_data, $placeholders, $used_placeholders, $lang_code);
        
        $context = new Context($placeholder_values, $area, $lang_code);
        $collection = new Collection($context->data);
        
        foreach ($use_fields as $object_field => $content) {
            if (empty($content)) {
                continue;
            }
            $rend_template->setTemplate($content);
            
            try {
                $content = $renderer->renderTemplate($rend_template, $context, $collection);
                $content = str_replace(array("\n", "\r"), ' ', $content);
            } catch (Exception $e) {
                $content = '';
            }

            if ($remove_spaces) {
                $content = trim(preg_replace('/\s{2,}/', ' ', $content));
            }

            if (!empty($content)) {
                $rendered_data[$object_field] = $content;
            }
        }
        if (!empty($object_schema['update_function']) && function_exists($object_schema['update_function'])) {
            $object_data['lang_code'] = $lang_code;
            call_user_func($object_schema['update_function'], $object_data, $rendered_data, $template);
        }
        if (!empty($set_notification)) {
            if ($k % $step == 0) {
                $k_from = $k + 1;
                $k_to = $k + $step;
                fn_set_progress('echo', "{$lang_code}: {$k_title} {$k_from} - {$k_to} <br />");
            }
            $k++;
        }
    }
}

// Objects functions for seo templates

function fn_cp_get_seo_template_placeholders($type = 'P')
{
    $all_placeholders = fn_get_schema('cp_seo_templates', 'placeholders');

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

function fn_cp_st_get_placeholder_values($template, $data, $placeholders, $used_placeholders = array(), $lang_code = CART_LANGUAGE)
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

// Common functions

function fn_cp_st_get_lang_codes()
{
    static $lang_codes = array();
    if (empty($lang_codes)) {
        $lang_codes = fn_get_translation_languages();
        $lang_codes = !empty($lang_codes) ? array_keys($lang_codes) : array(DESCR_SL);
    }
    return $lang_codes;
}

function fn_cp_st_get_brand_features($lang_code = CART_LANGUAGE)
{
    $comp_condition = '';
    if (fn_allowed_for('ULTIMATE')) {
        $company_id = Registry::get('runtime.company_id');
        if (!empty($company_id)) {
            $comp_condition = db_quote(' AND features.company_id = ?i', $company_id);
        }
    }
    return db_get_hash_single_array(
        'SELECT descr.feature_id, descr.description FROM ?:product_features_descriptions as descr'
        . ' LEFT JOIN ?:product_features as features ON features.feature_id = descr.feature_id'
        . ' WHERE features.feature_type = ?s AND lang_code = ?s ?p',
        ['feature_id', 'description'], 'E', $lang_code, $comp_condition
    );
}


// Addon.xml functions
function fn_cp_seo_templates_cron_info()
{
    $company_id = Registry::get('runtime.company_id');
    $simple_ult = Registry::get('runtime.simple_ultimate');
    if (!empty($company_id) || $simple_ult || fn_allowed_for('MULTIVENDOR')) {
        $dir            = Registry::get('config.dir.root');
        $url            = Registry::get('config.current_location');
        $admin_index    = Registry::get('config.admin_index');
        $company_id     = !empty($simple_ult) ? fn_get_default_company_id() : $company_id;
        $cron_key       = Registry::get('addons.cp_seo_templates.cron_key');
        
        if (fn_allowed_for('MULTIVENDOR')) {
            $more_args_php = $more_args_link = '';
        } else {
            $more_args_php  = '--company_id=' . $company_id . ' --switch_company_id=' . $company_id;
            $more_args_link = '&company_id=' . $company_id . '&switch_company_id=' . $company_id;
        }
        $hint = '<strong>' . __('cp_seo_cron_info_hint') . ':</strong><br />';
        $hint .= '<a href="' . $url . '/' . $admin_index . '?dispatch=cp_seo_templates.cron_apply' . $more_args_link . '&access_key=' . $cron_key . '" class="btn btn-primary cm-ajax cm-comet">' . __('cp_apply_seo_templates') . '</a>';
        $hint .= '<br /><strong>' . __('cp_seo_cron_hint_2') . ':</strong><br />';
        $hint .= '1) php ' . $dir . '/' . $admin_index . ' --dispatch=cp_seo_templates.cron_apply ' . $more_args_php . ' --access_key=' . $cron_key .'<br />';
        $hint .= '2) curl ' . $url . '/' . $admin_index . '?dispatch=cp_seo_templates.cron_apply' . $more_args_link . '&access_key=' . $cron_key;
        
    
        return $hint;
    } else {
        return __('cp_st_select_store');
    }
}

function fn_install_cp_seo_templates()
{
    $objects_schema = fn_get_schema('cp_seo_templates', 'objects', 'php', true);
    $fields = fn_get_schema('cp_seo_templates', 'fields', 'php', true);
    $company_ids = fn_allowed_for('ULTIMATE') ? fn_get_all_companies_ids() : [0];
    foreach ($company_ids as $company_id) {
        foreach ($objects_schema as $obj_type => $object_schema) {
            if (empty($object_schema['fields'])) {
                continue;
            }
            $data = array(
                'company_id' => $company_id,
                'status' => 'D',
                'priority' => 100,
                'is_default' => 'Y',
                'type' => $obj_type,
                'name' => !empty($object_schema['title']) ? $object_schema['title'] : 'Template '. $obj_type
            );
            $fields = array_intersect_key($fields, $object_schema['fields']);
            foreach ($fields as $field_key => $field) {
                $data[$field_key] = !empty($field['default_value'][$obj_type]) ? $field['default_value'][$obj_type] : '';
            }
            fn_cp_update_seo_template(0, $data);
        }
    }
}

function fn_cp_st_dynamic_pl_lang_variables()
{
    return __('cp_st_lang_go_to_link', array(
        '[link]' => fn_url('languages.translations?q=cp_st_dynamic_template', 'A')
    ));
}

function fn_cp_seo_assign_object_h1($object_type, $object_data = array())
{
    if (!empty($object_data['cp_st_h1']) && $object_type != 'p') {
        Tygh::$app['view']->assign('custom_h1', $object_data['cp_st_h1']);
    }
    $bc = Registry::get('view')->getTemplateVars('breadcrumbs');
    if (!empty($bc) && (!empty($object_data['cp_st_custom_bc']) || !empty($object_data['cp_st_h1']))) {
        array_pop($bc);
        Tygh::$app['view']->assign('breadcrumbs', $bc);
        fn_add_breadcrumb(!empty($object_data['cp_st_custom_bc']) ? $object_data['cp_st_custom_bc'] : $object_data['cp_st_h1']);
    }
    
    return true;
}

function fn_cp_seo_get_h1_product($product_id, $auth = [])
{
    $data = [];
    if (!empty($product_id)) {
        $lang_code = !empty($auth['lang_code']) ? $auth['lang_code'] : CART_LANGUAGE;
        $data = db_get_row("SELECT cp_st_h1 FROM ?:product_descriptions WHERE product_id = ?i AND lang_code = ?s", $product_id, $lang_code);
    }
    return $data;
}

if (fn_allowed_for('ULTIMATE')) {
    function fn_cp_seo_templates_ult_check_store_permission($params, &$object_type, &$object_name, &$table, &$key, &$key_id)
    {
        if (Registry::get('runtime.controller') == 'cp_seo_templates' && !empty($params['template_id'])) {
            $key = 'template_id';
            $key_id = $params[$key];
            $table = 'cp_seo_templates';
            $object_name = db_get_field("SELECT name FROM ?:cp_seo_templates_content WHERE template_id = ?i AND lang_code = ?s", $key_id, DESCR_SL);
            $object_type = __('cp_seo_subheader');
        }
    }
}