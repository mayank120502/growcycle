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

function fn_settings_variants_addons_cp_open_graph_feature_brand()
{
    $data = array('' => '---');
    $features_list = fn_cp_og_get_feature_simple_list_for_settings(array('S', 'E', 'T'));

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_open_graph_feature_condition()
{
    $data = array('' => '---');
    $features_list = fn_cp_og_get_feature_simple_list_for_settings(array('S'));

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_open_graph_feature_availability()
{
    $data = array(
        '' => '---',
        'auto' => __('cp_og.auto')
    );
    $features_list = fn_cp_og_get_feature_simple_list_for_settings(array('S'));

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_open_graph_feature_retailer_item_id()
{
    $data = array(
        '' => '---',
        'use_product_id' => __('cp_og.use_product_id'),
        'use_product_code' => __('cp_og.use_product_code')
    );
    $features_list = fn_cp_og_get_feature_simple_list_for_settings();

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_open_graph_feature_item_group_id()
{
    $data = array('' => '---');
    $features_list = fn_cp_og_get_feature_simple_list_for_settings();

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_open_graph_use_markup_for()
{
    $object_variants = array();
    $markup_objects = fn_get_schema('cp_open_graph', 'markup_objects', 'php', true);

    foreach ($markup_objects as $key => $object) {
        if (empty($object['extra_setting'])) {
            continue;
        }
        $object_variants[$key] = !empty($object['extra_setting']['descr']) ? $object['extra_setting']['descr'] : __($key);
    }

    return $object_variants;
}

// Common func
function fn_cp_og_get_feature_simple_list_for_settings($types = array('T'), $lang_code = DESCR_SL)
{
    $features_list = db_get_hash_single_array(
        'SELECT feature_id, description FROM ?:product_features as a'
        . ' LEFT JOIN ?:product_features_descriptions as b USING(feature_id)'
        . ' WHERE a.feature_type IN (?a) AND b.lang_code = ?s',
        array('feature_id', 'description'), $types, $lang_code
    );
    return $features_list;
}