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

function fn_settings_variants_addons_cp_json_ld_feature_brand()
{
    $data = ['' => '---'];
    $features_list = fn_cp_jld_get_feature_simple_list_for_settings(['S', 'E', 'T']);

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_json_ld_feature_condition()
{
    $data = ['' => '---'];
    $features_list = fn_cp_jld_get_feature_simple_list_for_settings(['S']);

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_json_ld_feature_material()
{
    $data = [
        '' => '---',
    ];
    $features_list = fn_cp_jld_get_feature_simple_list_for_settings(['S']);

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_json_ld_feature_color()
{
    $data = [
        '' => '---',
    ];
    $features_list = fn_cp_jld_get_feature_simple_list_for_settings(['S']);

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_json_ld_feature_pattern()
{
    $data = [
        '' => '---',
    ];
    $features_list = fn_cp_jld_get_feature_simple_list_for_settings(['S']);

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_json_ld_feature_availability()
{
    $data = [
        ''      => '---',
        'auto'  => __('cp_json_ld.auto')
    ];
    $features_list = fn_cp_jld_get_feature_simple_list_for_settings(['S']);

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_json_ld_feature_retailer_item_id()
{
    $data = [
        '' => '---',
        'use_product_id'    => __('cp_json_ld.use_product_id'),
        'use_product_code'  => __('cp_json_ld.use_product_code')
    ];
    $features_list = fn_cp_jld_get_feature_simple_list_for_settings();

    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_json_ld_feature_gtin8()
{
    return fn_cp_jld_get_gtin_variants();
}

function fn_settings_variants_addons_cp_json_ld_feature_gtin12()
{
    return fn_cp_jld_get_gtin_variants();
}

function fn_settings_variants_addons_cp_json_ld_feature_gtin13()
{
    return fn_cp_jld_get_gtin_variants();
}

function fn_settings_variants_addons_cp_json_ld_feature_gtin14()
{
    return fn_cp_jld_get_gtin_variants();
}

function fn_settings_variants_addons_cp_json_ld_feature_mpn()
{
    return fn_cp_jld_get_gtin_variants();
}

function fn_settings_variants_addons_cp_json_ld_review_qty()
{
    $data = ['' => __('none')];

    $discussion_settings = Registry::get('addons.discussion');

    $posts_qty = isset($discussion_settings['product_posts_per_page']) ? $discussion_settings['product_posts_per_page'] : '';


    if (empty($posts_qty) && !empty($discussion_settings)) {
        $posts_qty = 15;
        $data['all'] = __("all");
    }

    if (!empty($posts_qty)) {
        for ($i = 1; $i <= $posts_qty; $i++) {
            $data[$i] = $i;
        }
    }

    return $data;
}

function fn_settings_variants_addons_cp_json_ld_company_markup_page($lang_code = DESCR_SL)
{
    $data = ['none' => '---'];
    $pages_list = db_get_hash_single_array(
        "SELECT a.page_id, b.page FROM ?:pages as a"
        . " LEFT JOIN ?:page_descriptions as b USING(page_id) WHERE a.page_type = ?s AND b.lang_code = ?s",
        ['page_id', 'page'], 'T', $lang_code
    );

    foreach ($pages_list as $key => $value) {
        $data[$key] = $value;
    }

    return $data;
}

function fn_settings_variants_addons_cp_json_ld_use_markup_for()
{
    $object_variants = [];
    $markup_objects = fn_get_schema('cp_json_ld', 'markup_objects', 'php', true);

    foreach ($markup_objects as $key => $object) {
        if (empty($object['extra_setting'])) {
            continue;
        }
        $object_variants[$key] = !empty($object['extra_setting']['descr']) ? $object['extra_setting']['descr'] : __($key);
    }

    return $object_variants;
}

// Common func
function fn_cp_jld_get_feature_simple_list_for_settings($types = ['T'], $lang_code = DESCR_SL)
{
    $features_list = db_get_hash_single_array(
        'SELECT feature_id, description FROM ?:product_features as a'
        . ' LEFT JOIN ?:product_features_descriptions as b USING(feature_id)'
        . ' WHERE a.feature_type IN (?a) AND b.lang_code = ?s',
        ['feature_id', 'description'], $types, $lang_code
    );
    return $features_list;
}

function fn_cp_jld_get_gtin_variants()
{
    $data = [
        '' => '---',
        'use_product_code' => __('cp_json_ld.use_product_code')
    ];
    $features_list = fn_cp_jld_get_feature_simple_list_for_settings();
    
    $data = fn_array_merge($data, $features_list);
    return $data;
}

function fn_settings_variants_addons_cp_json_ld_store_type()
{
    $data = [
        ''                      => __('none'),
        'AutoPartsStore'        => 'AutoPartsStore',
        'BikeStore'             => 'BikeStore',
        'BookStore'             => 'BookStore',
        'ClothingStore'         => 'ClothingStore',
        'ComputerStore'         => 'ComputerStore',
        'ConvenienceStore'      => 'ConvenienceStore',
        'DepartmentStore'       => 'DepartmentStore',
        'ElectronicsStore'      => 'ElectronicsStore',
        'Florist'               => 'Florist',
        'FurnitureStore'        => 'FurnitureStore',
        'GardenStore'           => 'GardenStore',
        'GroceryStore'          => 'GroceryStore',
        'HardwareStore'         => 'HardwareStore',
        'HobbyShop'             => 'HobbyShop',
        'HomeGoodsStore'        => 'HomeGoodsStore',
        'JewelryStore'          => 'JewelryStore',
        'LiquorStore'           => 'LiquorStore',
        'MensClothingStore'     => 'MensClothingStore',
        'MobilePhoneStore'      => 'MobilePhoneStore',
        'MovieRentalStore'      => 'MovieRentalStore',
        'MusicStore'            => 'MusicStore',
        'OfficeEquipmentStore'  => 'OfficeEquipmentStore',
        'OutletStore'           => 'OutletStore',
        'PawnShop'              => 'PawnShop',
        'PetStore'              => 'PetStore',
        'ShoeStore'             => 'ShoeStore',
        'SportingGoodsStore'    => 'SportingGoodsStore',
        'TireShop'              => 'TireShop',
        'ToyStore'              => 'ToyStore',
        'WholesaleStore'        => 'WholesaleStore'
    ];
    return $data;
}
