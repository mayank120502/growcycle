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

use Tygh\Enum\Addons\CpNewBuyingTypes\ProductBuyingTypes;
use Tygh\Enum\Addons\CpCustomPrice\CpCustomPriceFilterField;
use Tygh\Enum\ObjectStatuses;
use Tygh\Enum\ProductZeroPriceActions;
use Tygh\Enum\SiteArea;
use Tygh\Enum\YesNo;

defined('BOOTSTRAP') || die('Access denied');

/* HOOKS */

/**
 * Change SQL parameters for product data select
 *
 * @param int    $product_id      Product ID
 * @param string $field_list      List of fields for retrieving
 * @param string $join            String with the complete JOIN information (JOIN type, tables and fields) for an SQL-query
 * @param array  $auth            Array with authorization data
 * @param string $lang_code       Two-letter language code (e.g. 'en', 'ru', etc.)
 * @param string $condition       Condition for selecting product data
 * @param string $price_usergroup Condition for usergroup prices
 */
function fn_cp_custom_price_get_product_data($product_id, &$field_list, $join, $auth, $lang_code, $condition, $price_usergroup)
{
    $field_list .= ', companies.cp_buying_types as cp_vendor_buying_types';
}

/**
 * Particularize product data
 *
 * @param array  $product_data List with product fields
 * @param array  $auth         Array with authorization data
 * @param bool   $preview      Is product previewed by admin
 * @param string $lang_code    2-letter language code (e.g. 'en', 'ru', etc.)
 */
function fn_cp_custom_price_get_product_data_post(&$product_data, $auth, $preview, $lang_code)
{
    if (fn_cp_custom_price_check_access_custom_price($product_data)) {
        $product_data['cp_access_custom_price'] = YesNo::YES;
    } else {
        $product_data['cp_access_custom_price'] = YesNo::NO;
        $product_data['cp_custom_price'] = YesNo::NO;
    }

    if (
        AREA == SiteArea::STOREFRONT
        && !empty($product_data['cp_custom_price'])
        && $product_data['cp_custom_price'] == YesNo::YES
    ) {
        $product_data['cp_buying_types'] = ProductBuyingTypes::CONTACT_VENDOR;
    }
}

/**
 * Changes selected products
 *
 * @param array  $products  Array of products
 * @param array  $params    Product search params
 * @param string $lang_code Language code
 */
function fn_cp_custom_price_get_products_post(&$products, $params, $lang_code)
{
    if (AREA == SiteArea::STOREFRONT) {
        foreach ($products as $key => &$product) {
            if (
                !empty($product['cp_custom_price'])
                && $product['cp_custom_price'] == YesNo::YES
            ) {
                $product['cp_buying_types'] = ProductBuyingTypes::CONTACT_VENDOR;
            }
        }
    }
}

/**
 * Changes product filter fields data
 *
 * @param array $filters Product filter fields
 */
function fn_cp_custom_price_get_product_filter_fields(&$filters)
{
    $filters[CpCustomPriceFilterField::FILTER_FIELD_ID] = [
        'db_field' => 'cp_custom_price',
        'table' => 'products',
        'description' => 'cp_custom_price.filter',
        'condition_type' => 'C',
        'map' => [
            'cp_exclude_custom_price' => YesNo::YES,
        ]
    ];
}

/**
 * This hook allows to extend products filtering params
 * @param array $params           request params
 * @param array $filters          filters list
 * @param array $selected_filters selected filter variants
 * @param array $filter_fields    filter by product's field type of filter schema
 * @param array $filter           current filter's data
 * @param array $structure        current filter's schema
 */
function fn_cp_custom_price_generate_filter_field_params(&$params, $filters, $selected_filters, $filter_fields, $filter, $structure)
{
    if (
        AREA == SiteArea::STOREFRONT
        && isset($filter['field_type'])
        && $filter['field_type'] == CpCustomPriceFilterField::FILTER_FIELD_ID
    ) {
        foreach ($filter_fields[CpCustomPriceFilterField::FILTER_FIELD_ID]['map'] as $param => $value) {
            $params[$param] = $value;
        }
    }
}

 /**
 * Changes additional params for selecting products
 *
 * @param array  $params    Product search params
 * @param array  $fields    List of fields for retrieving
 * @param array  $sortings  Sorting fields
 * @param string $condition String containing SQL-query condition possibly prepended with a logical operator (AND or OR)
 * @param string $join      String with the complete JOIN information (JOIN type, tables and fields) for an SQL-query
 * @param string $sorting   String containing the SQL-query ORDER BY clause
 * @param string $group_by  String containing the SQL-query GROUP BY field
 * @param string $lang_code Two-letter language code (e.g. 'en', 'ru', etc.)
 * @param array  $having    HAVING condition
 */
function fn_cp_custom_price_get_products($params, $fields, $sortings, &$condition, &$join, $sorting, $group_by, $lang_code, $having)
{
    if (
        AREA == SiteArea::STOREFRONT
        && !empty($params['cp_exclude_custom_price'])
    ) {
        if (!strrpos($join, 'prices')) {
            $join .= db_quote(' LEFT JOIN ?:product_prices as prices ON prices.product_id = products.product_id AND prices.lower_limit = ?i AND prices.usergroup_id = ?i', 1, 0);
        }
        $condition .= db_quote(' AND IF(products.cp_custom_price = ?s, products.cp_price_to > ?i OR prices.price > ?i, 1=1)', YesNo::YES, 0, 0);
    }
}

/**
 * Update product data (running before fn_update_product() function)
 *
 * @param array   $product_data Product data
 * @param int     $product_id   Product identifier
 * @param string  $lang_code    Two-letter language code (e.g. 'en', 'ru', etc.)
 * @param boolean $can_update   Flag, allows addon to forbid to create/update product
 */
function fn_cp_custom_price_update_product_pre(&$product_data, $product_id, $lang_code, $can_update)
{
    if (
        isset($product_data['cp_custom_price'])
        && !fn_cp_custom_price_check_access_custom_price($product_data)
    ) {
        $product_data['cp_custom_price'] = YesNo::NO;
    }
}

/**
 * Update product data (running after fn_update_product() function)
 *
 * @param array  $product_data Product data
 * @param int    $product_id   Product integer identifier
 * @param string $lang_code    Two-letter language code (e.g. 'en', 'ru', etc.)
 * @param bool   $create       Flag determines if product was created (true) or just updated (false).
 */
function fn_cp_custom_price_update_product_post($product_data, $product_id, $lang_code, $create)
{
    if (
        isset($product_data['master_product_id'])
        && $product_data['master_product_id'] != 0
    ) {
        $max_price_to_for_custom_price_product = db_get_field('SELECT MAX(cp_price_to) FROM ?:products WHERE master_product_id = ?i AND cp_custom_price = ?s AND status = ?s', $product_data['master_product_id'], YesNo::YES, ObjectStatuses::ACTIVE);
        if (!empty($max_price_to_for_custom_price_product)) {
            $update_data['cp_custom_price'] = YesNo::YES;
            $update_data['cp_price_to'] = $max_price_to_for_custom_price_product;
            db_query('UPDATE ?:products SET ?u WHERE product_id = ?i', $update_data , $product_data['master_product_id']);
        } else {
            db_query('UPDATE ?:products SET cp_custom_price = ?s WHERE product_id = ?i', YesNo::NO, $product_data['master_product_id']);
        }
    }
}

/**
 * Update company data (running after fn_update_company() function)
 *
 * @param array  $company_data Company data
 * @param int    $company_id   Company integer identifier
 * @param string $lang_code    Two-letter language code (e.g. 'en', 'ru', etc.)
 * @param string $action       Flag determines if company was created (add) or just updated (update).
 */
function fn_cp_custom_price_update_company($company_data, $company_id, $lang_code, $action)
{
    if (
        !empty($company_data['cp_buying_types'])
        && strrpos($company_data['cp_buying_types'], ProductBuyingTypes::CONTACT_VENDOR) === false
        && strrpos($company_data['cp_buying_types'], ProductBuyingTypes::START_ORDER) === false
    ) {
        $products = db_get_array('SELECT products.* FROM ?:products as products WHERE cp_custom_price = ?s AND cp_buying_types = ?s AND company_id = ?i', YesNo::YES, ProductBuyingTypes::VENDOR_DEFAULT, $company_id);
        if (!empty($products)) {
            foreach ($products as $key => &$product) {
                $product['cp_custom_price'] = YesNo::NO;
            }
            db_replace_into('products', $products, true);
        }
    }
}

function fn_cp_custom_price_pre_add_to_wishlist(&$product_data, $wishlist, $auth)
{
    if (!empty($product_data)) {
        foreach ($product_data as &$product) {
            $product_data_custom_price = fn_cp_custom_price_get_data_custom_price_by_product_id($product['product_id']);
            $product['extra']['cp_custom_price'] = $product_data_custom_price['cp_custom_price']; 
            $product['extra']['cp_price_to'] = $product_data_custom_price['cp_price_to'];
            $product['extra']['master_product_id'] = $product_data_custom_price['master_product_id'];
        }
    }
}

/**
 * Executed when a product is added to cart, once the price of the product is determined.
 * Allows to change the price of the product in the cart.
 *
 * @param array     $product_data       List of products data
 * @param array     $cart               Array of cart content and user information necessary for purchase
 * @param array     $auth               Array of user authentication data (e.g. uid, usergroup_ids, etc.)
 * @param bool      $update             Flag, if true that is update mode. Usable for order management
 * @param int       $_id                Cart item identifier
 * @param array     $data               Current product data
 * @param int       $product_id         Product identifier
 * @param int       $amount             Product quantity
 * @param float     $price              Product price
 * @param string    $zero_price_action  Flag, determines the action when the price of the product is 0
 * @param bool      $allow_add          Flag, determines if product can be added to cart
 */
function fn_cp_custom_price_add_product_to_cart_get_price($product_data, $cart, $auth, $update, $_id, $data, $product_id, $amount, $price, &$zero_price_action, $allow_add)
{
    $product_data = fn_cp_custom_price_get_data_custom_price_by_product_id($product_id);
    if ($product_data['cp_custom_price'] == YesNo::YES) {
        $zero_price_action = ProductZeroPriceActions::ALLOW_ADD_TO_CART;
    }
}

/* HOOKS END */

function fn_cp_custom_price_get_custom_price_status($product_id)
{
    $custom_price_status =  db_get_field('SELECT cp_custom_price FROM ?:products WHERE product_id = ?i', $product_id);

    return $custom_price_status == YesNo::YES ? true : false;
}

function fn_cp_custom_price_get_products_with_custom_price()
{
    $products = db_get_fields('SELECT product_id FROM ?:products WHERE cp_custom_price = ?s', YesNo::YES);

    return $products;
}

function fn_cp_custom_price_check_access_custom_price($product)
{
    $cp_buying_types = [];

    if (!empty($product['cp_buying_types'])) {
        if (!is_array($product['cp_buying_types'])) {
            $cp_buying_types = explode(',', $product['cp_buying_types']);
        } else {
            $cp_buying_types = $product['cp_buying_types'];
        }
    }

    if (
        (!empty($product['cp_buying_types'])
            && (in_array(ProductBuyingTypes::CONTACT_VENDOR, $cp_buying_types)
                || in_array(ProductBuyingTypes::START_ORDER, $cp_buying_types)))
        || ((in_array(ProductBuyingTypes::VENDOR_DEFAULT, $cp_buying_types)
            || empty($cp_buying_types))
            && !empty($product['cp_vendor_buying_types'])
            && (strrpos($product['cp_vendor_buying_types'], ProductBuyingTypes::CONTACT_VENDOR) !== false
                || strrpos($product['cp_vendor_buying_types'], ProductBuyingTypes::START_ORDER) !== false))
    ) {
        $access = true;
    } else {
        $access = false;
    }

    return $access;
}

function fn_cp_custom_price_get_data_custom_price_by_product_id($product_id)
{
    $product_data_custom_price = db_get_row('SELECT cp_custom_price, cp_price_to, master_product_id FROM ?:products WHERE product_id = ?i', $product_id);

    return $product_data_custom_price;
}