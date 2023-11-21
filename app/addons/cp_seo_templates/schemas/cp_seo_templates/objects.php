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

include_once(__DIR__ . '/objects.functions.php');

$schema = [
    'P' => [
        'name'              => 'products',
        'title'             => __('products'),
        'conditions'        => ['P', 'C'],
        'get_function'      => 'fn_cp_st_get_products',
        'step_function'     => 'fn_cp_st_step_products',
        'total_function'    => 'fn_cp_st_total_products',
        'update_function'   => 'fn_cp_st_update_product_data',
        'fields' => [
            'page_title'        => true,
            'meta_description'  => true,
            'meta_keywords'     => true,
            'seo_name'          => true,
            'cp_st_h1'          => true,
            'cp_st_custom_bc'   => true
        ],
    ],
    'A' => [
        'name'              => 'pages',
        'title'             => __('pages'),
        'conditions'        => ['A'],
        'get_function'      => 'fn_cp_st_get_pages',
        'update_function'   => 'fn_cp_st_update_page_data',
        'fields' => [
            'page_title'        => true,
            'meta_description'  => true,
            'meta_keywords'     => true,
            'seo_name'          => true,
            'cp_st_h1'          => true,
            'cp_st_custom_bc'   => true
        ],
    ]
];

$is_vendor = fn_allowed_for('MULTIVENDOR') && !empty(Tygh\Registry::get('runtime.company_id')) ? true : false;

if (!$is_vendor) {
    $schema['C'] = [
        'name'              => 'categories',
        'title'             => __('categories'),
        'conditions'        => ['C'],
        'get_function'      => 'fn_cp_st_get_categories',
        'update_function'   => 'fn_cp_st_update_category_data',
        'fields' => [
            'page_title'        => true,
            'meta_description'  => true,
            'meta_keywords'     => true,
            'seo_name'          => true,
            'cp_st_h1'          => true,
            'cp_st_custom_bc'   => true
        ],
    ];
    $schema['E'] = [
        'name'              => 'features',
        'title'             => __('features'),
        'conditions'        => ['E'],
        'get_function'      => 'fn_cp_st_get_features',
        'update_function'   => 'fn_cp_st_update_feature_data',
        'fields' => [
            'page_title'        => true,
            'meta_description'  => true,
            'meta_keywords'     => true,
            'seo_name'          => true,
            'cp_st_h1'          => true,
            'cp_st_custom_bc'   => true
        ],
    ];
}

return $schema;
