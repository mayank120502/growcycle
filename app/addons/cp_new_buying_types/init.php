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

defined('BOOTSTRAP') || die('Access denied');

fn_register_hooks(
    'get_product_data'
    , 'get_product_data_post'
    , 'get_products'
    , 'load_products_extra_data'
    , 'get_products_post'
    , 'get_company_data_post'
    , 'update_product_pre'
    , 'update_company_pre'
    , 'redirect_complete'
    , 'render_block_pre'
    , 'summary_get_payment_method'
    , 'change_order_status'
    , 'checkout_place_orders_pre_route'
    , 'delete_order'
    , 'checkout_update_steps_pre'
    , 'extract_cart'
    , 'save_cart_content_post'
    , 'get_orders'
);

Registry::set('config.storage.cp_order_attachments', [
    'prefix'  => 'cp_order_attachments',
    'secured' => true,
    'dir'     => Registry::get('config.dir.var')
]);
