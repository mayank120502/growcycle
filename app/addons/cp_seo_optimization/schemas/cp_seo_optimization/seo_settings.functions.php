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

//
// Noindex
//

function fn_cp_seo_check_product_hidden($params)
{
    $product_id = fn_cp_seo_check_get_product_id($params);
    if (!empty($product_id)) {
        $status = db_get_field('SELECT status FROM ?:products WHERE product_id = ?i', $product_id);
        return ($status == 'H') ? true : false;
    }
    return false;
}

function fn_cp_seo_check_category_hidden($params)
{
    if (!empty($params['category_id'])) {
        $status = db_get_field('SELECT status FROM ?:categories WHERE category_id = ?i', $params['category_id']);
        return ($status == 'H') ? true : false;
    }
    return false;
}

function fn_cp_seo_check_page_hidden($params)
{
    if (!empty($params['page_id'])) {
        $status = db_get_field('SELECT status FROM ?:pages WHERE page_id = ?i', $params['page_id']);
        return ($status == 'H') ? true : false;
    }
    return false;
}

function fn_cp_seo_check_without_products($params)
{
    $search = Tygh::$app['view']->getTemplateVars('search');
    return (!empty($search) && empty($search['total_items'])) ? true : false;
}

function fn_cp_seo_check_product_without_price()
{
    $product = (array) fn_cp_seo_check_get_static_data('product');
    return (isset($product['price']) && $product['price'] == 0) ? true : false;
}

function fn_cp_seo_check_product_without_stock()
{
    $product = (array) fn_cp_seo_check_get_static_data('product');
    return (isset($product['amount']) && $product['amount'] == 0) ? true : false;
}

//
// Pagination
//

function fn_cp_seo_check_pagination($params)
{
    return (!empty($params['page']) && $params['page'] > 1) ? true : false;
}

//
// Hide description
//

function fn_cp_seo_remove_category_description($params)
{
    if (!empty($params['category_id'])) {
        $category = (array) fn_cp_seo_check_get_static_data('category_data');
        if (!empty($category['description'])) {
            $category['description'] = '';
            Tygh::$app['view']->assign('category_data', $category);
        }
    }
}

function fn_cp_seo_remove_variant_description($params)
{
    if (!empty($params['variant_id'])) {
        $variant = (array) fn_cp_seo_check_get_static_data('variant_data');
        if (!empty($variant['description'])) {
            $variant['description'] = '';
            $variant['image_pair'] = [];
            Tygh::$app['view']->assign('variant_data', $variant);
        }
    }
}

//
// Last-Modified
//

function fn_cp_seo_check_homepage_lastmod($params, &$extra)
{
    $extra['lastmod'] = fn_cp_seo_get_start_day_time();
    return true;
}

function fn_cp_seo_check_product_lastmod($params, &$extra)
{
    $product_id = fn_cp_seo_check_get_product_id($params);
    if (!empty($product_id)) {
        if (Registry::get('addons.cp_seo_optimization.lastmod_time') == 'update') {
            $lastmod = db_get_field(
                'SELECT updated_timestamp FROM ?:products WHERE product_id = ?i', $product_id
            );
        } else {
            $lastmod = fn_cp_seo_get_start_day_time();
        }
        if (!empty($lastmod) && is_numeric($lastmod)) {
            $extra['lastmod'] = $lastmod;
            return true;
        }
    }
    return false;
}

function fn_cp_seo_check_category_lastmod($params, &$extra)
{
    if (!empty($params['category_id'])) {
        if (Registry::get('addons.cp_seo_optimization.lastmod_time') == 'update') {
            $lastmod = db_get_field(
                'SELECT cp_seo_lastmod FROM ?:categories WHERE category_id = ?i',
                intval($params['category_id'])
            );
        } else {
            $lastmod = fn_cp_seo_get_start_day_time();
        }
        if (!empty($lastmod) && is_numeric($lastmod)) {
            $extra['lastmod'] = $lastmod;
            return true;
        }
    }
    return false;
}

function fn_cp_seo_check_page_lastmod($params, &$extra)
{
    if (!empty($params['page_id'])) {
        if (Registry::get('addons.cp_seo_optimization.lastmod_time') == 'update') {
            $lastmod = db_get_field(
                'SELECT cp_seo_lastmod FROM ?:pages WHERE page_id = ?i',
                intval($params['page_id'])
            );
        } else {
            $lastmod = fn_cp_seo_get_start_day_time();
        }
        if (!empty($lastmod) && is_numeric($lastmod)) {
            $extra['lastmod'] = $lastmod;
            return true;
        }
    }
    return false;
}

//
// Canonical
//

function fn_cp_seo_check_product_canonical($params, &$extra)
{   
    $product_id = fn_cp_seo_check_get_product_id($params);
    if (!empty($product_id)) {
        $canonical = fn_cp_seo_get_object_canonical('P', $product_id);
        if (!empty($canonical)) {
            $extra['canonical'] = $canonical;
            return true;
        }
    }
    return false;
}

function fn_cp_seo_check_category_canonical($params, &$extra)
{   
    if (!empty($params['category_id'])) {
        $canonical = fn_cp_seo_get_object_canonical('C', $params['category_id']);
        if (!empty($canonical)) {
            $extra['canonical'] = $canonical;
            return true;
        }
    }
    return false;
}

function fn_cp_seo_check_page_canonical($params, &$extra)
{   
    if (!empty($params['page_id'])) {
        $canonical = fn_cp_seo_get_object_canonical('A', $params['page_id']);
        if (!empty($canonical)) {
            $extra['canonical'] = $canonical;
            return true;
        }
    }
    return false;
}

//
// Object noindex
//

// function fn_cp_seo_check_product_noindex($params)
// {
//     $product_id = fn_cp_seo_check_get_product_id($params);
//     if (!empty($product_id)) {
//         return fn_cp_seo_get_object_noindex('P', $product_id);
//     }
//     return false;
// }
// 
// function fn_cp_seo_check_category_noindex($params)
// {
//     if (!empty($params['category_id'])) {
//         return fn_cp_seo_get_object_noindex('C', $params['category_id']);
//     }
//     return false;
// }
// 
// function fn_cp_seo_check_page_noindex($params)
// {
//     if (!empty($params['page_id'])) {
//         return fn_cp_seo_get_object_noindex('A', $params['page_id']);
//     }
//     return false;
// }

//
// Common
//

function fn_cp_seo_check_get_static_data($temlate_field)
{
    static $data = [];
    if (!isset($data[$temlate_field])) {
        $data[$temlate_field] = Tygh::$app['view']->getTemplateVars($temlate_field);
    }
    return $data[$temlate_field];
}

function fn_cp_seo_check_get_product_id($params)
{
    if (empty($params['product_id'])) {
        return 0;
    }
    $product_id = $params['product_id'];
    if (Registry::get('addons.product_variations.status') == 'A') {
        $v_product_map = Tygh\Addons\ProductVariations\ServiceProvider::getProductIdMap();
        if ($v_product_map->isChildProduct($product_id)) {
            $product_id = $v_product_map->getParentProductId($product_id);
        }
    }
    if (Registry::get('addons.master_products.status') == 'A') {
        $m_product_map = Tygh\Addons\MasterProducts\ServiceProvider::getProductIdMap();
        if ($m_product_map->isVendorProduct($product_id)) {
            $product_id = $m_product_map->getMasterProductId($product_id);
        }
    }
    return intval($product_id);
}
