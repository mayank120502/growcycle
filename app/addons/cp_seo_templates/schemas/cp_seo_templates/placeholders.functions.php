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

function fn_cp_st_set_storefront_pl($object_data)
{
    return '{{ storefront }}';
}

function fn_cp_st_set_pagination_pl($object_data)
{
    return '{{ pagination }}';
}

function fn_cp_st_get_object_description($object_data)
{
    if (empty($object_data['description'])) {
        return '';
    }
    return strip_tags($object_data['description']);
}

function fn_cp_st_get_product_full_description($object_data)
{
    if (empty($object_data['full_description'])) {
        return '';
    }
    return strip_tags($object_data['full_description']);
}

function fn_cp_st_get_product_short_description($object_data)
{
    if (empty($object_data['short_description'])) {
        return '';
    }
    return strip_tags($object_data['short_description']);
}

function fn_cp_st_get_product_category_path($object_data)
{
    $result = '';
    if (empty($object_data['main_category'])) {
        return '';
    }
    $lang_code = !empty($object_data['lang_code']) ? $object_data['lang_code'] : CART_LANGUAGE;
    
    $cat_path = db_get_field("SELECT id_path FROM ?:categories WHERE category_id = ?i", $object_data['main_category']);
    if (!empty($cat_path)) {
        $cat_path = explode('/', $cat_path);
        if (!empty($cat_path)) {
            $cats_names = db_get_fields("SELECT category FROM ?:category_descriptions WHERE category_id IN (?n) AND lang_code = ?s ORDER BY FIELD (category_id, ?n)", $cat_path, $lang_code, $cat_path);
            if (!empty($cats_names)) {
                $result = implode('/', $cats_names);
            }
        }
    }
    return $result;
}

function fn_cp_st_get_company_name($object_data)
{
    if (empty($object_data['company_id'])) {
        return '';
    }
    return fn_get_company_name($object_data['company_id']);
}

function fn_cp_st_get_currency($object_data)
{
    return CART_PRIMARY_CURRENCY;
}

function fn_cp_st_get_currency_symbol($object_data)
{
    $currencies = Tygh\Registry::get('currencies');
    $currency = $currencies[CART_PRIMARY_CURRENCY];
    return !empty($currency['symbol']) ? $currency['symbol'] : '';
}

function fn_cp_st_get_product_price($object_data)
{
    if (empty($object_data['product_id'])) {
        return '';
    }
    $useless_auth = array();
    $price = fn_get_product_price($object_data['product_id'], 1, $useless_auth);
    return fn_format_price($price);
}

function fn_cp_st_get_product_main_category($object_data)
{
    if (empty($object_data['main_category'])) {
        return '';
    }
    $lang_code = !empty($object_data['lang_code']) ? $object_data['lang_code'] : CART_LANGUAGE;
    return db_get_field(
        'SELECT category FROM ?:category_descriptions WHERE category_id = ?i AND lang_code = ?s',
        $object_data['main_category'], $lang_code
    );
}


function fn_cp_st_get_feature_name($object_data)
{
    if (empty($object_data['feature_id'])) {
        return '';
    }
    $lang_code = !empty($object_data['lang_code']) ? $object_data['lang_code'] : CART_LANGUAGE;
    return db_get_field(
        'SELECT description FROM ?:product_features_descriptions WHERE feature_id = ?i AND lang_code = ?s',
        $object_data['feature_id'], $lang_code
    );
}

function fn_cp_st_get_feature_variables($lang_code = DESCR_SL)
{
    $features = db_get_array(
        'SELECT descr.feature_id, descr.description FROM ?:product_features as features'
        . ' LEFT JOIN ?:product_features_descriptions as descr ON descr.feature_id = features.feature_id AND lang_code = ?s'
        . ' WHERE features.feature_type != ?s ORDER BY feature_id ASC',
        $lang_code, 'G'
    );
    $feature_variables = array();
    if (!empty($features)) {    
        foreach ($features as $feature) {
            $key = 'feature_' . $feature['feature_id'];
            $feature_variables[$key] = array(
                'title' => $feature['description']
            );
        }
    }
    return $feature_variables;
}

function fn_cp_st_get_product_feature($object_data)
{
    if (empty($object_data['product_id']) || empty($object_data['cp_placeholder'])) {
        return '';
    }
    $feature_id = intval(str_replace('feature_', '', $object_data['cp_placeholder']));
    $lang_code = !empty($object_data['lang_code']) ? $object_data['lang_code'] : CART_LANGUAGE;
    $value = '';
    $variant = db_get_row(
        'SELECT variant_id, value FROM ?:product_features_values WHERE product_id = ?i AND feature_id = ?i AND lang_code = ?s',
        $object_data['product_id'], $feature_id, $lang_code
    );
    if (!empty($variant['value'])) {
        $value = $variant['value'];
    } elseif (!empty($variant['variant_id'])) {
        $value = db_get_field(
            'SELECT variant FROM ?:product_feature_variant_descriptions WHERE variant_id = ?i AND lang_code = ?s',
            $variant['variant_id'], $lang_code
        );
    }
    return $value;
}

function fn_cp_st_get_category_parent($object_data)
{
    if (empty($object_data['parent_id'])) {
        return;
    }
    $lang_code = !empty($object_data['lang_code']) ? $object_data['lang_code'] : CART_LANGUAGE;
    $category_id = $object_data['parent_id'];
    static $category_names = array();
    if (empty($category_names[$lang_code][$category_id])) {
        $category_names[$lang_code][$category_id] = fn_get_category_name($category_id, $lang_code);
    }
    return $category_names[$lang_code][$category_id];
}

function fn_cp_st_get_page_parent($object_data)
{
    if (empty($object_data['parent_id'])) {
        return '';
    }
    $lang_code = !empty($object_data['lang_code']) ? $object_data['lang_code'] : CART_LANGUAGE;
    $page_id = $object_data['parent_id'];
    static $page_names = array();
    if (empty($page_names[$lang_code][$page_id])) {
        $page_names[$lang_code][$page_id] = fn_get_page_name($page_id, $lang_code);
    }
    return $page_names[$lang_code][$page_id];
}

function fn_cp_st_get_category_products_max_price($object_data)
{
    if (empty($object_data['category_id'])) {
        return '';
    }
    return fn_cp_st_get_object_products_info('C', $object_data['category_id'], 'max_price');
}

function fn_cp_st_get_category_products_min_price($object_data)
{
    if (empty($object_data['category_id'])) {
        return '';
    }
    return fn_cp_st_get_object_products_info('C', $object_data['category_id'], 'min_price');
}

function fn_cp_st_get_category_products_amount($object_data)
{
    if (empty($object_data['category_id'])) {
        return '';
    }
    return fn_cp_st_get_object_products_info('C', $object_data['category_id'], 'count');
}

function fn_cp_st_get_variant_products_max_price($object_data)
{
    if (empty($object_data['variant_id'])) {
        return '';
    }
    return fn_cp_st_get_object_products_info('E', $object_data['variant_id'], 'max_price');
}

function fn_cp_st_get_variant_products_min_price($object_data)
{
    if (empty($object_data['variant_id'])) {
        return '';
    }
    return fn_cp_st_get_object_products_info('E', $object_data['variant_id'], 'min_price');
}

function fn_cp_st_get_variant_products_amount($object_data)
{
    if (empty($object_data['variant_id'])) {
        return '';
    }
    return fn_cp_st_get_object_products_info('E', $object_data['variant_id'], 'count');
}

function fn_cp_st_get_object_products_info($object_type, $object_id, $param_type)
{
    $params = array(
        'sort_by'       => 'price',
        'sort_order'    => ($param_type == 'min_price') ? 'asc' : 'desc',
        'price_from'    => 0.01
    );
    if ($object_type == 'C') {
        $params['cid'] = $object_id;
        $params['subcats'] = (Tygh\Registry::get('settings.General.show_products_from_subcategories') == 'Y') ? 'Y' : '';
    } elseif ($object_type == 'E') {
        $params['variant_id'] = $object_id;
    }
    list($products, $search) = fn_get_products($params, 1);
    $result = '';
    if ($param_type == 'min_price' || $param_type == 'max_price') {
        $product = reset($products);
        $result = !empty($product['price']) ? fn_format_price($product['price']) : 0;
    } else {
        $result = !empty($search['total_items']) ? $search['total_items'] : 0;
    }
    return $result;
}
