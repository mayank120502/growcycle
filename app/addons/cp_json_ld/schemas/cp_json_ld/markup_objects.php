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
    'search' => [
        'type'          => 'search', // object type in fn_cp_json_ld_get_data
        'get_function'  => 'fn_cp_json_ld_search_markup_data', // function to get formatted data for fn_cp_json_ld_get_data
        'add_if_empty'  => [
            'content'   => '<meta name="google" content="nositelinkssearchbox" />', // add content if there is no data
            'no_format' => true
        ]
    ],
    'company' => [
        'type'          => 'company',
        'get_function'  => 'fn_cp_json_ld_company_markup_data',
        //'extra' => ['special' => true], // if you need to add special markup to tpl
        //'allow_empty' => true // adds markup even if there is no data
    ],
    'product' => [
        'type'          => 'product',
        'get_function'  => 'fn_cp_json_ld_product_markup_data'
    ],
    'breadcrumbs' => [
        'type'          => 'breadcrumbs',
        'get_function'  => 'fn_cp_json_ld_breadcrumbs_markup_data'
    ],
];

if (Tygh\Registry::get('addons.blog.status') == 'A') {
    $schema['blog'] = [
        'type'          => 'blog',
        'get_function'  => 'fn_cp_json_ld_blog_markup_data',
        'extra_setting' => [ // display the setting on json_ld addon settings page
            'descr' => __('blog')
        ]
    ];
}

return $schema;