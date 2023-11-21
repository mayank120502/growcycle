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

fn_register_hooks(
    'dispatch_before_display',
    'get_pages',
    'get_products_before_select',
    array('get_route', 100),
    'get_route_runtime',
    'render_block_post',
    'seo_get_name_post',
    'validate_sef_object',
    'url_before_get_storefront_location',
    'url_post',
    'update_page_before',
    'update_category_pre',
    'update_product_count_post'
);

$seo_settings = Registry::get('addons.seo');
if (!defined('CP_SEO_PROD_WITH_CAT') && !empty($seo_settings['seo_product_type']) && in_array($seo_settings['seo_product_type'], ['product_category_nohtml','product_category'])) {
    define('CP_SEO_PROD_WITH_CAT', true);
}