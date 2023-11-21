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

include_once(__DIR__ . '/dynamic_placeholders.functions.php');

$schema = [ 
    'pagination' => [
        'get_function' => 'fn_cp_st_get_pagination_placeholder',
        'position' => 100,
        'fields' => ['custom_h1', 'cp_st_custom_bc','page_title', 'meta_description', 'meta_keywords']
    ],
    'storefront' => [
        'get_function' => 'fn_cp_st_get_storefront_placeholder',
        'position' => 200,
        'fields' => ['custom_h1', 'cp_st_custom_bc','page_title', 'meta_description', 'meta_keywords']
    ]
];

return $schema;
