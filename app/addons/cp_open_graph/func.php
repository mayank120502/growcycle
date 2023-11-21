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

//
// Hooks
//

function fn_cp_open_graph_update_product_post($product_data, $product_id, $lang_code, $create)
{
    $data_type = isset($product_data['cp_og_data_type']) ? $product_data['cp_og_data_type'] : CP_OG_DATA_AUTO;
    if ($data_type == CP_OG_DATA_MANUAL) {
        fn_cp_og_save_manual_data($product_data['cp_og_data']);
    } else {
        fn_cp_og_remove_manual_data($product_id, 'product');
    }

    return true;
}

function fn_cp_open_graph_delete_product_post($product_id, $product_deleted)
{
    fn_cp_og_remove_manual_data($product_id, 'product');
}


function fn_cp_open_graph_update_page_post($page_data, $page_id, $lang_code, $create, $old_page_data)
{
    $data_type = isset($page_data['cp_og_data_type']) ? $page_data['cp_og_data_type'] : CP_OG_DATA_AUTO;
    if ($data_type == CP_OG_DATA_MANUAL) {
        fn_cp_og_save_manual_data($page_data['cp_og_data']);
    } else {
        fn_cp_og_remove_manual_data($page_id, 'page');
    }

    return true;
}

function fn_cp_open_graph_delete_page($page_id)
{
    fn_cp_og_remove_manual_data($page_id, 'page');
}

function fn_cp_open_graph_update_category_post($category_data, $category_id, $lang_code)
{
    $data_type = isset($category_data['cp_og_data_type']) ? $category_data['cp_og_data_type'] : CP_OG_DATA_AUTO;
    if ($data_type == CP_OG_DATA_MANUAL) {
        fn_cp_og_save_manual_data($category_data['cp_og_data']);
    } else {
        fn_cp_og_remove_manual_data($category_id, 'category');
    }

    return true;
}

function fn_cp_open_graph_delete_category_after($category_id)
{
    fn_cp_og_remove_manual_data($category_id, 'category');
}

function fn_cp_open_graph_delete_company($company_id)
{
    fn_cp_og_remove_manual_data($company_id, 'homepage');
}

function fn_cp_open_graph_dispatch_before_display()
{
    if (AREA != 'C') {
        return;
    }

    $controller = Registry::get('runtime.controller');
    $mode = Registry::get('runtime.mode');
    $company_id = Registry::get('runtime.company_id');
    $params = $_REQUEST;

    fn_cp_open_graph_add_page_markup($controller, $mode, $company_id, $params);
}

//
// Common fucntions
//

function fn_cp_og_save_manual_data($data, $lang_code = DESCR_SL)
{
    if (empty($data) || empty($data['object_id']) && !fn_allowed_for('MULTIVENDOR') || empty($data['object_type'])) {
        return false;
    }

    $data['lang_code'] = DESCR_SL;

    $is_data_exists = db_get_row(
        "SELECT * FROM ?:cp_og_meta_data WHERE object_id = ?i AND object_type = ?s",
        $data['object_id'], $data['object_type']
    );
    
    if (!empty($is_data_exists)) {
        db_query("REPLACE INTO ?:cp_og_meta_data ?e", $data);
    } else {
        foreach (fn_get_translation_languages() as $data['lang_code'] => $_v) {
            db_query("INSERT INTO ?:cp_og_meta_data ?e", $data);
        }
    }

    fn_attach_image_pairs(CP_OG_IMG_PAIR_PREFIX . 'image_' . $data['object_type'], CP_OG_IMG_PAIR_PREFIX . $data['object_type'], $data['object_id'], $lang_code);
    
    $multi_images = fn_get_schema('cp_open_graph', 'sn_fields');
    if (!empty($multi_images)) {
        foreach($multi_images as $m_img) {
            if (!empty($m_img['prefix'])) {
                fn_attach_image_pairs($m_img['prefix'] . 'image_' . $data['object_type'], $m_img['prefix'] . $data['object_type'], $data['object_id'], $lang_code);
            }
        }
    }

    return true;
}

function fn_cp_og_remove_manual_data($obj_id, $obj_type)
{
    if (empty($obj_id) || empty($obj_type)) {
        return false;
    }

    db_query("DELETE FROM ?:cp_og_meta_data WHERE object_type = ?s AND object_id = ?i", $obj_type, $obj_id);
    fn_delete_image_pairs($obj_id, CP_OG_IMG_PAIR_PREFIX . $obj_type, 'M');

    return true;
}

function fn_cp_og_data_strip_description($description)
{
    $description = html_entity_decode($description);
    $description = trim(strip_tags(preg_replace('/\s\s+/', ' ', $description)));
    $max_length = defined('CP_OG_DESCRIPTION_MAX_LENGTH') ? CP_OG_DESCRIPTION_MAX_LENGTH : 0;
    if (!empty($max_length) && strlen($description) > $max_length) {
        $description = rtrim($description, '!,.-');
        $description = CP_USE_MBSTRING ? mb_substr($description, 0, $max_length - 3) : substr($description, 0, $max_length - 3);
        $description .= '...';
    }
    return $description;
}

function fn_cp_og_get_default_homepage_data($company_id, $lang_code = DESCR_SL)
{
    if (fn_allowed_for('MULTIVENDOR')) {
        $storefront = Tygh::$app['storefront'];
        $default_data = array(
            'title' => $storefront->name,
            'object_id' => $storefront->storefront_id,
            'object_type' => 'homepage'
        );
    } else {
        $site_name = fn_get_company_name($company_id);
        $default_data = array(
            'title' => !empty($site_name) ? $site_name : Registry::get('settings.Company.company_name'),
            'object_id' => $company_id,
            'object_type' => 'homepage'
        );
    }
    return $default_data;
}

function fn_cp_og_get_locales()
{
    static $init_cache = false;

    $cache_name = 'cp_og_locales_cache_static';
    $condition = array('languages', 'country_code');

    if (!$init_cache) {
        Registry::registerCache($cache_name, $condition, Registry::cacheLevel('static'), true);
        $init_cache = true;
    }

    $locale_list = Registry::get($cache_name);

    if (empty($locale_list)) {
        $locale_list = db_get_hash_single_array("SELECT lang_code, country_code FROM ?:languages", array('lang_code', 'country_code'));
        //cache
        Registry::set($cache_name, $locale_list);
    }

    return $locale_list;
}

function fn_cp_og_get_company_logo($company_id)
{
    $logos = fn_allowed_for('ULTIMATE') ? fn_get_logos($company_id) : fn_get_logos();
    $image = isset($logos['theme']['image']) ? $logos['theme']['image'] : array();

    return $image;
}

function fn_cp_og_get_manual_data($object_type, $object_id, $lang_code = CART_LANGUAGE)
{
    $obj_data = db_get_row(
        'SELECT * FROM ?:cp_og_meta_data WHERE object_type = ?s AND object_id = ?i AND lang_code = ?s',
        $object_type, $object_id, $lang_code
    );
    if (empty($obj_data)) {
        return array();
    }
    $image_pair = fn_get_image_pairs($object_id, CP_OG_IMG_PAIR_PREFIX . $object_type, 'M', true, true, $lang_code);
    
    $data = [
        'object_type'   => isset($obj_data['object_type']) ? $obj_data['object_type'] : '',
        'object_id'     => isset($obj_data['object_id']) ? $obj_data['object_id'] : '',
        'title'         => isset($obj_data['cp_og_title']) ? $obj_data['cp_og_title'] : '',
        'description'   => isset($obj_data['cp_og_description']) ? $obj_data['cp_og_description'] : '',
        'image'         => !empty($image_pair['detailed']) ? $image_pair['detailed'] : array(),
        'is_manual'     => true
    ];

    if (AREA != 'C') {
        $data['image_pair'] = $image_pair;
    }
    $multi_images = fn_get_schema('cp_open_graph', 'sn_fields');
    if (!empty($multi_images)) {
        $data['og_images'] = [];
        foreach($multi_images as $m_key => $m_img) {
            if (!empty($m_img['prefix'])) {
                $data['og_images'][$m_key] = fn_get_image_pairs($object_id, $m_img['prefix'] . $object_type, 'M', true, true, $lang_code);
            }
        }
    }

    return $data;
}

function fn_cp_open_graph_add_page_markup($controller, $mode, $company_id = 0, $params = array())
{
    $allow_markups = fn_get_schema('cp_open_graph', 'markups');
    if (empty($allow_markups[$controller][$mode])) {
        return;
    }
    $current_object = $allow_markups[$controller][$mode];
    $current_objects = is_array($current_object) ? $current_object : array($current_object);
    $params['company_id'] = $company_id;

    $markup_data = array();
    $stop_other = false;
    foreach ($current_objects as $allow_object) {
        $markup_data = fn_cp_og_get_object_data($allow_object, $params, false, $stop_other);
        if (!empty($markup_data) || $stop_other) {
            break; // get first object with data
        }
    }
    if (empty($markup_data)) {
        return;
    }

    $og_markup = fn_cp_prepare_og_meta_data($markup_data);
    
    Tygh::$app['view']->assign('cp_graph_meta_data', $og_markup);
}

function fn_cp_og_get_object_data($object_type, $params = array(), $only_auto = false, &$stop_other = false)
{
    static $markup_objects = null;
    if ($markup_objects === null) {
        $markup_objects = fn_get_schema('cp_open_graph', 'markup_objects');
    }
    $markup_data = array();
    $object = !empty($markup_objects[$object_type]) ? $markup_objects[$object_type] : array();
    if (!empty($object['get_function']) && function_exists($object['get_function'])) {
        if (!empty($object['extra_params'])) {
            $params = array_merge($params, $object['extra_params']);
        }
        $markup_data = call_user_func($object['get_function'], $params, $only_auto);
    }
    if (!empty($markup_data['fake'])) {
        $stop_other = true;
        return [];
    } elseif (empty($markup_data)) {
        return [];
    }
    if (empty($markup_data['type'])) {
        $markup_data['type'] = !empty($object['og_type']) ? $object['og_type'] : 'website';
    }
    if (empty($markup_data['image'])) {
        if (fn_allowed_for('MULTIVENDOR')) {
            $storefront = Tygh::$app['storefront'];
            $theme_logos = fn_get_logos(null,null,null,$storefront->storefront_id);
            if (!empty($theme_logos['theme']['image'])) {
                 $markup_data['image'] = $theme_logos['theme']['image'];
            }
        } else {
            $company_id = !empty($params['company_id']) ? $params['company_id'] : fn_get_runtime_company_id();
            $markup_data['image'] = fn_cp_og_get_company_logo($company_id);
        }
    }
    if (AREA != 'C' && !empty($markup_data['url'])) {
        $markup_data['preview_url'] = !empty($markup_data['preview_url']) ? $markup_data['preview_url'] : CP_OG_FB_DEBUGGER_URL . $markup_data['url'];
    }
    return $markup_data;
}

function fn_cp_prepare_og_meta_data($data = [])
{
    fn_set_hook('cp_open_graph_prepare_data_pre', $data);

    $meta_data = [];
    if (function_exists('___cp')) {
        $cpv1 = ___cp('b2c6c2l0ZV9uYW1l');
        $cpv2 = ___cp('b2c6bG9jYWxl');
        $meta_data = [
            'og:title'          => !empty($data['title']) ? $data['title'] : '',
            'og:description'    => !empty($data['description']) ? $data['description'] : '',
            'og:url'            => !empty($data['url']) ? $data['url'] : '',
            'og:image'          => !empty($data['image']['image_path']) ? $data['image']['image_path'] : '',
            'og:image:width'    => !empty($data['image']['image_x']) ? $data['image']['image_x'] : '',
            'og:image:height'   => !empty($data['image']['image_y']) ? $data['image']['image_y'] : '',
            'og:image:alt'      => !empty($data['image']['alt']) ? $data['image']['alt'] : '',
            'og:type'           => !empty($data['type']) ? $data['type'] : 'website'
        ];
        
        if (!empty($data['og_images'])) {
            foreach($data['og_images'] as $m_key => $m_data) {
                if (!empty($m_data['detailed']['image_path'])) {
                    $meta_data[$m_key . ':image'] = $m_data['detailed']['image_path'];
                    if (!empty($m_data['detailed']['alt'])) {
                        $meta_data[$m_key . ':image:alt'] = $m_data['detailed']['alt'];
                    }
                }
            }
        }
        
        if (fn_allowed_for('ULTIMATE')) {
            $company_id = Registry::ifGet('runtime.company_id', call_user_func(___cp('Zm5fZ2V0P2RlZmF1bHRfY29tcGFueV9pZA')));
            $site_name = fn_get_company_name($company_id);
        } else {
            $storefront = Tygh::$app['storefront'];
            $site_name = $storefront->name;
        }

        $locale_list = call_user_func(___cp('Zm5fY3Bfb2dfZ2V0P2xvY2FsZPM'));
        $lang_code = CART_LANGUAGE;
        $country_code = isset($locale_list[$lang_code]) ? $locale_list[$lang_code] : 'US';

        $meta_data[$cpv1] = !empty($site_name) ? $site_name : Registry::get('settings.Company.company_name');
        $meta_data[$cpv2] = "{$lang_code}_{$country_code}";

        if (!empty($data['extra_fields'])) {
            $extra_fields = fn_cp_og_build_extra_fields_recursive($data['extra_fields']);
            $meta_data = array_merge($meta_data, $extra_fields);
        }
    }
    
    fn_set_hook('cp_open_graph_prepare_data', $meta_data, $data);

    return $meta_data;
}

function fn_cp_og_build_extra_fields_recursive($fields, $prefix = '')
{
    $meta_fields = array();
    foreach ($fields as $field_name => $field) {
        if (empty($field)) {
            continue;
        }
        $current_prefix = !empty($prefix) ? $prefix . ':' : '';
        $current_prefix = !empty($field_name) ? $current_prefix . $field_name : rtrim($current_prefix, ':');
        if (is_array($field)) {
            $child_fields = fn_cp_og_build_extra_fields_recursive($field, $current_prefix);
            $meta_fields = array_merge($meta_fields, $child_fields);
        } else {
            $meta_fields[$current_prefix] = $field;
        }
    }
    return $meta_fields;
}

function fn_cp_og_get_multi_images_scheme()
{
    $multi_images = fn_get_schema('cp_open_graph', 'sn_fields');
    return $multi_images;
}