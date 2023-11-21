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
use Tygh\Enum\ObjectStatuses;
use Tygh\Storage;

/**
 * Hook handler: get_product_data
 *
 * @see fn_get_product_data
 **/
function fn_cp_new_buying_types_get_product_data($product_id, &$field_list, $join, $auth, $lang_code, $condition, $price_usergroup)
{
    $field_list .= ', ' . fn_cp_get_product_buying_types_field_init();
}

/**
 * Hook handler: get_product_data_post
 *
 * @see fn_get_product_data
 **/
function fn_cp_new_buying_types_get_product_data_post(&$product_data, $auth, $preview, $lang_code)
{
    $product_data['cp_buying_types'] = explode(',', $product_data['cp_buying_types']);
}

/**
 * Hook handler: get_products
 *
 * @see fn_get_products
 **/
function fn_cp_new_buying_types_get_products($params, &$fields, $sortings, $condition, &$join, $sorting, $group_by, $lang_code, $having)
{
    if (strpos($join, 'LEFT JOIN ?:companies AS companies') === false) {
        $join .= db_quote(' LEFT JOIN ?:companies AS companies ON companies.company_id = products.company_id');
    }
    $fields['cp_buying_types'] = fn_cp_get_product_buying_types_field_init($params['area'], true, 'products');
}

/**
 * Hook handler: load_products_extra_data
 *
 * @see fn_get_products
 **/
function fn_cp_new_buying_types_load_products_extra_data(&$extra_fields, $products, $product_ids, $params, $lang_code)
{
    if (empty($params['only_short_fields'])) {
        $companies_table = 'cp_companies';
        $products_table = '?:products';
        $products_extra_fields = &$extra_fields[$products_table];
        $products_extra_fields['fields']['cp_buying_types'] = fn_cp_get_product_buying_types_field_init(
            $params['area'],
            false,
            $products_table,
            $companies_table
        );

        if (empty($products_extra_fields['join'])) {
            $products_extra_fields['join'] = '';
        }

        $products_extra_fields['join'] .=
            " LEFT JOIN ?:companies AS $companies_table ON $companies_table.company_id = $products_table.company_id";
    }
}

/**
 * Hook handler: get_products_post
 *
 * @see fn_get_products
 **/
function fn_cp_new_buying_types_get_products_post(&$products, $params, $lang_code)
{
    if (empty($products)) {
        return;
    }

    foreach ($products as &$product_data) {
        $product_data['cp_buying_types'] = explode(',', $product_data['cp_buying_types']);
    }
    unset($product_data);
}

/**
 * Hook handler: get_company_data_post
 *
 * @see fn_get_company_data
 **/
function fn_cp_new_buying_types_get_company_data_post($company_id, $lang_code, $extra, &$company_data)
{
    $company_data['cp_buying_types'] = explode(',', $company_data['cp_buying_types']);
}

/**
 * Hook handler: update_product_pre
 *
 * @see fn_update_product
 **/
function fn_cp_new_buying_types_update_product_pre(&$product_data, $product_id, $lang_code, $can_update)
{
    fn_cp_update_buying_types_data($product_data);
}

/**
 * Hook handler: update_company_pre
 *
 * @see fn_update_company
 **/
function fn_cp_new_buying_types_update_company_pre(&$company_data, $company_id, $lang_code, $can_update)
{
    fn_cp_update_buying_types_data($company_data, true);
}

/**
 * Hook handler: redirect_complete
 *
 * @see fn_redirect
 **/
function fn_cp_new_buying_types_redirect_complete($meta_redirect)
{
    fn_cp_return_original_checkout_cart();
}

/**
 * Hook handler: render_block_pre
 *
 * @see \Tygh\BlockManager\RenderManager::renderBlockContent
 **/
function fn_cp_new_buying_types_render_block_pre($block, $block_schema, $params, &$block_content)
{
    if (
        !empty($block['properties']['template'])
        && $block['properties']['template'] === 'blocks/lite_checkout/payment_methods.tpl'
        && fn_cp_check_is_start_order()
    ) {
        $block_content = '';
    }
}

/**
 * Hook handler: summary_get_payment_method
 *
 * @see fn_get_payment_method_data
 **/
function fn_cp_new_buying_types_summary_get_payment_method($payment_id, &$payment)
{
    if (
        (
            fn_cp_check_is_start_order()
            && $payment_id == fn_cp_get_buying_type_payment_id(ProductBuyingTypes::START_ORDER)
        ) || (
            fn_cp_check_is_contact_vendor()
            && $payment_id == fn_cp_get_buying_type_payment_id(ProductBuyingTypes::CONTACT_VENDOR)
        )
    ) {
        $payment['status'] = ObjectStatuses::ACTIVE;
    }
}

/**
 * Hook handler: change_order_status
 *
 * @see fn_change_order_status
 **/
function fn_cp_new_buying_types_change_order_status(
    &$status_to,
    $status_from,
    $order_info,
    $force_notification,
    $order_statuses,
    $place_order
) {
    if ($place_order) {
        if (fn_cp_check_is_start_order()) {
            if ($start_order_status = fn_cp_get_buying_type_order_status(ProductBuyingTypes::START_ORDER)) {
                $status_to = $start_order_status;
            }
        } elseif (fn_cp_check_is_contact_vendor()) {
            if ($contact_vendor_order_status = fn_cp_get_buying_type_order_status(ProductBuyingTypes::CONTACT_VENDOR)) {
                $status_to = $contact_vendor_order_status;
            }
        }
    }
}

/**
 * Hook handler: checkout_place_orders_pre_route
 *
 * @see fn_checkout_place_order
 **/
function fn_cp_new_buying_types_checkout_place_orders_pre_route($cart, $auth, $params)
{
    if (fn_cp_check_is_start_order()) {
        fn_clear_cart(Tygh::$app['session']['cp_start_order_cart']);
    }
}

/**
 * Hook handler: delete_order
 *
 * @see fn_delete_order
 **/
function fn_cp_new_buying_types_delete_order($order_id)
{
    Storage::instance('cp_order_attachments')->deleteDir($order_id);
}

/**
 * Hook handler: checkout_update_steps_pre
 *
 * @see fn_checkout_update_steps
 **/
function fn_cp_new_buying_types_checkout_update_steps_pre($cart, $auth, $params, &$redirect_params)
{
    if (!empty($_REQUEST['start_order'])) {
        $redirect_params['start_order'] = true;
    }
}

/**
 * Hook handler: extract_cart
 *
 * @see fn_extract_cart_content
 **/
function fn_cp_new_buying_types_extract_cart(&$cart, $user_id, $type, $user_type)
{
    if (!empty(Tygh::$app['session']['cp_original_cart'])) {
        $cart = Tygh::$app['session']['cp_start_order_cart'];
    }
}

/**
 * Hook handler: save_cart_content_post
 *
 * @see fn_save_cart_content
 **/
function fn_cp_new_buying_types_save_cart_content_post($cart, $user_id, $type, $user_type)
{
    if ($_REQUEST['dispatch'] === 'checkout.update_steps' && !empty($_REQUEST['start_order'])) {
        Tygh::$app['session']['cp_start_order_cart'] = $cart;
    }
}

/**
 * Hook handler: get_orders
 *
 * @see
 **/
function fn_cp_new_buying_types_get_orders($params, &$fields, $sortings, $condition, $join, $group)
{
    $fields[] = '?:orders.cp_buying_type';
}
