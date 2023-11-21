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

include_once(__DIR__ . '/markup_objects.functions.php');

$schema = [
    'homepage' => [
        'get_function' => 'fn_cp_open_graph_homepage_markup_data',
        'og_type' => 'website'
    ],
    'category' => [
        'get_function' => 'fn_cp_open_graph_category_markup_data',
        'og_type' => 'website'
    ],
    'product' => [
        'get_function' => 'fn_cp_open_graph_product_markup_data',
        'og_type' => 'website'
    ],
    'page' => [
        'get_function' => 'fn_cp_open_graph_page_markup_data',
        'og_type' => 'website'
    ]
];

if (Tygh\Registry::get('addons.blog.status') == 'A') {
    $schema['blog'] = [
        'get_function' => 'fn_cp_open_graph_blog_markup_data',
        'og_type' => 'article',
        'extra_setting' => [ // display the setting on open_graph addon settings page
            'descr' => __('blog')
        ]
    ];
}

return $schema;