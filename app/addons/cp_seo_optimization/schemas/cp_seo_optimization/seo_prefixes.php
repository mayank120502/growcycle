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

$schema = [];

$settings = Registry::get('addons.cp_seo_optimization');
if (!empty($settings['use_product_prefix']) && $settings['use_product_prefix'] == 'Y') {
    $schema['p'] = [
        'parent' => 'c',
        'name' => !empty($settings['product_prefix']) ? $settings['product_prefix'] : ''
    ];
    if (!empty($settings['only_main_category']) && $settings['only_main_category'] == 'Y') {
        $schema['p']['path_limit'] = -1; // if negative - take from the end
    } elseif (in_array(Registry::get('addons.seo.seo_product_type'), ['product_file_nohtml', 'product_file'])) {
        $schema['p']['path_limit'] = 0;
    }
}

if (!empty($settings['use_category_prefix']) && $settings['use_category_prefix'] == 'Y') {
    $schema['c'] = [
        'parent' => 'c',
        'name' => !empty($settings['category_prefix']) ? $settings['category_prefix'] : ''
    ];
    if (in_array(Registry::get('addons.seo.seo_category_type'), ['file', 'root_category'])) {
        $schema['c']['path_limit'] = 0;
    }
}

return $schema;