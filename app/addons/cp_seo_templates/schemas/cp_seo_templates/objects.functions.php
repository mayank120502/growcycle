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

function fn_cp_st_get_products($template = [])
{
    $products = [];
    $item_ids = fn_cp_st_get_product_ids($template);
    if (!empty($item_ids) || $item_ids === null) {
        $object_params = [
            'custom_extend' => ['page_title', 'meta_data', 'product_name', 'description', 'full_description', 'categories'],
            'sort_by' => 'timestamp'
        ];
        if (!empty($item_ids)) {
            $object_params['pid'] = $item_ids;
        }
        $lang_code = !empty($template['lang_code']) ? $template['lang_code'] : CART_LANGUAGE;
        $step = 100;
        $page = 1;
        while (true) {
            $object_params['page'] = $page;
            list($finded_products, $search) = fn_get_products($object_params, $step, $lang_code);
            if (empty($finded_products)) {
                break;
            }
            $products = array_merge($products, $finded_products);
            $page++;
        }
    }
    return $products;
}

function fn_cp_st_step_products($template = [], $page = 1, $step = 100)
{
    $params = [
        'page'              => $page,
        'items_per_page'    => $step
    ];
    $item_ids = fn_cp_st_get_product_ids($template, $params);
    $products = [];
    if (!empty($item_ids) || $item_ids === null) {
        $object_params = [
            'custom_extend'     => ['page_title', 'meta_data', 'product_name', 'description', 'full_description', 'categories'],
            'sort_by'           => 'product_id',
            'sort_order'        => 'asc',
            'show_all_products' => true
        ];
        if (!empty($item_ids)) {
            $object_params['pid'] = $item_ids;
        }
        if ($item_ids === null) {
            $object_params = array_merge($object_params, $params);
        }
        $lang_code = !empty($template['lang_code']) ? $template['lang_code'] : CART_LANGUAGE;
        
        list($products) = fn_get_products($object_params, $step, $lang_code);
    }
    return $products;
}

function fn_cp_st_total_products($template)
{
    $params = [
        'page' => 1,
        'items_per_page' => 1
    ];
    $count = 0;
    fn_cp_st_get_product_ids($template, $params, $count);
    return $count;
}

function fn_cp_st_get_product_ids($template, $params = [], &$count = 0)
{
    $item_ids = null;
    if (!empty($template['conditions']['conditions'])) {
        $query_conditions = $query_joins = [];
        $condition_data = $template['conditions'];
        $set = !empty($condition_data['set']) ? $condition_data['set'] : 'all';
        $unite_operator = ($set == 'all') ? ' AND ' : ' OR ';
        foreach ($condition_data['conditions'] as $condition) {
            if (empty($condition['value'])) {
                continue;
            }
            $type = !empty($condition['condition']) ? $condition['condition'] : 'P';
            $db_operator = (!empty($condition['operator']) && $condition['operator'] == 'nin') ? 'NOT IN' : 'IN';
            $item_ids = is_array($condition['value']) ? $condition['value'] : explode(',', $condition['value']);
            if ($type == 'C') {
                $query_joins[$type] = db_quote(' LEFT JOIN ?:products_categories as pc ON products.product_id = pc.product_id');
                $query_conditions[] = db_quote('pc.category_id ?p (?n)', $db_operator, $item_ids);
            } else {
                $query_conditions[] = db_quote('products.product_id ?p (?n)', $db_operator,  $item_ids);
            }
        }
        $limit = '';
        if (!empty($params['items_per_page'])) {
            $page = !empty($params['page']) ? $params['page'] : 1;
            $limit = db_paginate($page, $params['items_per_page']);
        }
        
        $lang_code = !empty($template['lang_code']) ? $template['lang_code'] : CART_LANGUAGE;
        
        list($fields, $join, $pr_condition) = fn_get_products(['get_conditions' => true, 'show_all_products' => true], 0, $lang_code);
        $join .= implode(' ', $query_joins);
        $last_conditions = ' AND (' . implode($unite_operator, $query_conditions) . ')' . $pr_condition;

        $item_ids = db_get_fields(
            'SELECT DISTINCT SQL_CALC_FOUND_ROWS products.product_id FROM ?:products as products ?p WHERE 1 ?p ?p',
            $join, $last_conditions, $limit
        );

        $count = db_get_found_rows();
    } else {
        $count = db_get_field('SELECT COUNT(product_id) FROM ?:products');
    }
    return $item_ids;
}


function fn_cp_st_update_product_data($object_data, $tag_data = [], $template = [])
{
    if (empty($object_data['product_id'])) {
        return;
    }
    $product_id = $object_data['product_id'];
    $lang_code = !empty($template['lang_code']) ? $template['lang_code'] : CART_LANGUAGE;
    $condition = db_quote(' AND product_id = ?i AND lang_code = ?s', $product_id, $lang_code);
    db_query('UPDATE ?:product_descriptions SET ?u WHERE 1 ?p', $tag_data, $condition);

    if (fn_allowed_for('ULTIMATE') && fn_ult_is_shared_product($product_id) == 'Y') {
        if (!empty($template['company_id'])) {
            $condition .= db_quote(' AND company_id = ?i', $template['company_id']);
        } else {
            return;
        }
        db_query('UPDATE ?:ult_product_descriptions SET ?u WHERE 1 ?p', $tag_data, $condition);
    }
    if (!empty($tag_data['seo_name'])
        && (Registry::get('addons.seo.single_url') != 'Y' || $lang_code == CART_LANGUAGE)
    ) {
        $object_data['seo_name'] = fn_generate_name($tag_data['seo_name']);
        fn_seo_update_object($object_data, $product_id, 'p', $lang_code);
    }
}

function fn_cp_st_get_categories($template = [])
{
    $categories = [];
    $item_ids = null;
    if (!empty($template['conditions']['conditions'])) {
        $query_conditions = [];
        $condition_data = $template['conditions'];
        $set = !empty($condition_data['set']) ? $condition_data['set'] : 'all';
        $unite_operator = ($set == 'all') ? ' AND ' : ' OR ';
        foreach ($condition_data['conditions'] as $condition) {
            if (empty($condition['value'])) {
                continue;
            }
            $db_operator = (!empty($condition['operator']) && $condition['operator'] == 'nin') ? 'NOT IN' : 'IN';
            $item_ids = is_array($condition['value']) ? $condition['value'] : explode(',', $condition['value']);
            $query_conditions[] = db_quote('category_id ?p (?n)', $db_operator, $item_ids);
        }
        $company_condition = !empty($template['company_id']) ? db_quote(' AND company_id = ?i', $template['company_id']) : '';
        $item_ids = db_get_fields(
            'SELECT DISTINCT category_id FROM ?:categories WHERE 1 ?p AND (?p)',
            $company_condition, implode($unite_operator, $query_conditions)
        );
    }

    if (!empty($item_ids) || $item_ids === null) {
        $object_params = [
            'simple'                => false,
            'group_by_level'        => false,
            'cp_for_seo_templates'  => true,
            'company_ids'           => !empty($template['company_id']) ? $template['company_id'] : ''
            //'limit' => 0,
            //'items_per_page' => 0,
        ];
        if (!empty($item_ids)) {
            $object_params['item_ids'] = implode(',', $item_ids);
        }
        $lang_code = !empty($template['lang_code']) ? $template['lang_code'] : CART_LANGUAGE;
        list($categories) = fn_get_categories($object_params, $lang_code);
    }

    return $categories;
}

function fn_cp_st_update_category_data($object_data, $tag_data = [], $template = [])
{
    if (empty($object_data['category_id'])) {
        return;
    }
    $category_id = $object_data['category_id'];
    $lang_code = !empty($template['lang_code']) ? $template['lang_code'] : CART_LANGUAGE;
    $condition = db_quote(' AND category_id = ?i AND lang_code = ?s', $category_id, $lang_code);
    db_query('UPDATE ?:category_descriptions SET ?u WHERE 1 ?p', $tag_data, $condition);

    if (!empty($tag_data['seo_name'])
        && (Registry::get('addons.seo.single_url') != 'Y' || $lang_code == CART_LANGUAGE)
    ) {
        $object_data['seo_name'] = fn_generate_name($tag_data['seo_name']);
        fn_seo_update_object($object_data, $category_id, 'c', $lang_code);
    }
}

function fn_cp_st_get_pages($template = [])
{
    $pages = [];
    $item_ids = null;
    if (!empty($template['conditions']['conditions'])) {
        $query_conditions = [];
        $condition_data = $template['conditions'];
        $set = !empty($condition_data['set']) ? $condition_data['set'] : 'all';
        $unite_operator = ($set == 'all') ? ' AND ' : ' OR ';
        foreach ($condition_data['conditions'] as $condition) {
            if (empty($condition['value'])) {
                continue;
            }
            $db_operator = (!empty($condition['operator']) && $condition['operator'] == 'nin') ? 'NOT IN' : 'IN';
            $item_ids = is_array($condition['value']) ? $condition['value'] : explode(',', $condition['value']);
            $query_conditions[] = db_quote('page_id ?p (?n)', $db_operator, $item_ids);
        }
        $company_condition = !empty($template['company_id']) ? db_quote(' AND company_id = ?i', $template['company_id']) : '';
        $item_ids = db_get_fields(
            'SELECT DISTINCT page_id FROM ?:pages WHERE 1 ?p AND (?p)',
            $company_condition, implode($unite_operator, $query_conditions)
        );
    }

    if (!empty($item_ids) || $item_ids === null) {
        $object_params = [
            'item_ids'  => !empty($item_ids) ? implode(',', $item_ids) : '',
            'simple'    => false
        ];
        if (fn_allowed_for('ULTIMATE')) {
            $object_params['cp_seo_this_company_id'] = !empty($template['company_id']) ? $template['company_id'] : 0;
        }
        $lang_code = !empty($template['lang_code']) ? $template['lang_code'] : CART_LANGUAGE;
        list($pages) = fn_get_pages($object_params, 0, $lang_code);
    }

    return $pages;
}

function fn_cp_st_update_page_data($object_data, $tag_data = [], $template = [])
{
    if (empty($object_data['page_id'])) {
        return;
    }
    $page_id = $object_data['page_id'];
    $lang_code = !empty($template['lang_code']) ? $template['lang_code'] : CART_LANGUAGE;
    $condition = db_quote(' AND page_id = ?i AND lang_code = ?s', $page_id, $lang_code);
    db_query('UPDATE ?:page_descriptions SET ?u WHERE 1 ?p', $tag_data, $condition);

    if (!empty($tag_data['seo_name'])
        && (Registry::get('addons.seo.single_url') != 'Y' || $lang_code == CART_LANGUAGE)
    ) {
        $object_data['seo_name'] = fn_generate_name($tag_data['seo_name']);
        fn_seo_update_object($object_data, $page_id, 'a', $lang_code);
    }
}

function fn_cp_st_get_features($template = array())
{
    $feature_variants = array();
    $item_ids = null;
    if (!empty($template['conditions']['conditions'])) {
        $query_conditions = array();
        $condition_data = $template['conditions'];
        foreach ($condition_data['conditions'] as $condition) {
            if (empty($condition['value'])) {
                continue;
            }
            if (!empty($item_ids)) {
                $item_ids[] = $condition['value'];
            } else {
                $item_ids = array($condition['value']);
            }
        }
    }

    if (!empty($item_ids)) {
        $company_id = fn_get_runtime_company_id();
        $lang_code = !empty($template['lang_code']) ? $template['lang_code'] : CART_LANGUAGE;
        $feature_names = db_get_hash_single_array(
            'SELECT feature_id, description FROM ?:product_features_descriptions WHERE feature_id IN (?n) AND lang_code = ?s',
            array('feature_id', 'description'), $item_ids, $lang_code
        );
        foreach ($item_ids as $item_id) {
            $object_params = array(
                'feature_id' => $item_id,
                'get_images' => false
            );
            list($finded_variants) = fn_get_product_feature_variants($object_params, 0, $lang_code);
            if (empty($finded_variants)) {
                continue;
            }
            foreach ($finded_variants as &$f_variant) {
                if (empty($f_variant['feature_id'])) {
                    continue;
                }
                $feature_id = $f_variant['feature_id'];
                $f_variant['feature'] = !empty($feature_names[$feature_id]) ? $feature_names[$feature_id] : '';
                $f_variant['company_id'] = $company_id;
            }
            $feature_variants = array_merge($feature_variants, $finded_variants);
        }
    }
    return $feature_variants;
}

function fn_cp_st_update_feature_data($object_data, $tag_data = array(), $template = array())
{
    if (empty($object_data['variant_id'])) {
        return;
    }
    $variant_id = $object_data['variant_id'];
    $lang_code = !empty($template['lang_code']) ? $template['lang_code'] : CART_LANGUAGE;
    $condition = db_quote(' AND variant_id = ?i AND lang_code = ?s', $variant_id, $lang_code);
    db_query('UPDATE ?:product_feature_variant_descriptions SET ?u WHERE 1 ?p', $tag_data, $condition);

    if (!empty($tag_data['seo_name'])
        && (Registry::get('addons.seo.single_url') != 'Y' || $lang_code == CART_LANGUAGE)
    ) {
        $object_data['seo_name'] = fn_generate_name($tag_data['seo_name']);
        fn_seo_update_object($object_data, $variant_id, 'e', $lang_code);
    }
}
