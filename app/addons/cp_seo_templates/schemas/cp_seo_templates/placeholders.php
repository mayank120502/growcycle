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

include_once(__DIR__ . '/placeholders.functions.php');

$schema = [ 
    'P' => [
        'product' => [
            'title' => __('product_name'),
            'field' => 'product'
        ],
        'product_code' => [
            'title' => __('sku'),
            'field' => 'product_code'
        ],
        'amount' => [
            'title' => __('products_amount'),
            'field' => 'amount'
        ],
        'price' => [
            'title'         => __('price'),
            'get_function'  => 'fn_cp_st_get_product_price'
        ],
        'list_price' => [
            'title'             => __('list_price_short'),
            'field'             => 'list_price',
            'proccess_function' => 'fn_format_price'
        ],
        'full_description' => [
            'title'         => __('full_description'),
            'get_function'  => 'fn_cp_st_get_product_full_description'
        ],
        'short_description' => [
            'title'         => __('short_description'),
            'get_function'  => 'fn_cp_st_get_product_short_description'
        ],
        'currency' => [
            'title'         => __('currency'),
            'get_function'  => 'fn_cp_st_get_currency'
        ], 
        'currency_symbol' => [
            'title'         => __('currency_sign'),
            'get_function'  => 'fn_cp_st_get_currency_symbol'
        ],
        'category' => [
            'title'         => __('cp_main_product_category'),
            'get_function'  => 'fn_cp_st_get_product_main_category'
        ],
        'category_path' => [
            'title'         => __('cp_seo_category_path'),
            'get_function'  => 'fn_cp_st_get_product_category_path'
        ],
       'feature' => [
            'title'                 => __('features'),
            'is_group'              => true,
            'variables_function'    => 'fn_cp_st_get_feature_variables',
            'get_function'          => 'fn_cp_st_get_product_feature'
        ],
        'storefront'    => [
            'is_dynamic'    => true,
            'title'         => __('storefront'),
            'get_function'  => 'fn_cp_st_set_storefront_pl'
        ]
    ],
    'C' => [
        'category' => [
            'title' => __('category_name'),
            'field' => 'category'
        ],
        'parent_category' => [
            'title'         => __('parent_category'),
            'get_function'  => 'fn_cp_st_get_category_parent'
        ],
        'max_price' => [
            'title'         => __('cp_st_max_price'),
            'get_function'  => 'fn_cp_st_get_category_products_max_price'
        ],
        'min_price' => [
            'title'         => __('cp_st_min_price'),
            'get_function'  => 'fn_cp_st_get_category_products_min_price'
        ],
        'currency' => [
            'title'         => __('currency'),
            'get_function'  => 'fn_cp_st_get_currency'
        ], 
        'currency_symbol' => [
            'title'         => __('currency_sign'),
            'get_function'  => 'fn_cp_st_get_currency_symbol'
        ],
        'products_amount' => [
            'title'         => __('products_amount'),
            'get_function'  => 'fn_cp_st_get_category_products_amount'
        ],
        'description' => [
            'title'         => __('description'),
            'get_function'  => 'fn_cp_st_get_object_description'
        ],
        'storefront'    => [
            'is_dynamic'    => true,
            'title'         => __('storefront'),
            'get_function'  => 'fn_cp_st_set_storefront_pl'
        ],
        'pagination'    => [
            'is_dynamic'    => true,
            'tooltip'       => __('cp_st_pagination_descr', ['[href]' => fn_url('languages.translations?q=cp_st_page_title_placeholder')]),
            'title'         => __('cp_st_pagination_txt'),
            'get_function'  => 'fn_cp_st_set_pagination_pl'
        ],
    ],
    'A' => [
        'page' => [
            'title' => __('page_name'),
            'field' => 'page'
        ],
        'parent_page' => [
            'title'         => __('parent_page'),
            'get_function'  => 'fn_cp_st_get_page_parent'
        ],
        'description' => [
            'title'         => __('description'),
            'get_function'  => 'fn_cp_st_get_object_description'
        ],
        'storefront'    => [
            'is_dynamic'    => true,
            'title'         => __('storefront'),
            'get_function'  => 'fn_cp_st_set_storefront_pl'
        ],
    ],
    'E' => [
        'variant' => [
            'title' => __('variant_name'),
            'field' => 'variant'
        ],
        'feature' => [
            'title' => __('feature_name'),
            'field' => 'feature'
        ],
        'max_price' => [
            'title'         => __('cp_st_max_price'),
            'get_function'  => 'fn_cp_st_get_variant_products_max_price'
        ],
        'min_price' => [
            'title'         => __('cp_st_min_price'),
            'get_function'  => 'fn_cp_st_get_variant_products_min_price'
        ],
        'currency' => [
            'title'         => __('currency'),
            'get_function'  => 'fn_cp_st_get_currency'
        ], 
        'currency_symbol' => [
            'title'         => __('currency_sign'),
            'get_function'  => 'fn_cp_st_get_currency_symbol'
        ],
        'products_amount' => [
            'title'         => __('products_amount'),
            'get_function'  => 'fn_cp_st_get_variant_products_amount'
        ],
        'description' => [
            'title'         => __('description'),
            'get_function'  => 'fn_cp_st_get_object_description'
        ],
        'storefront'    => [
            'is_dynamic'    => true,
            'title'         => __('storefront'),
            'get_function'  => 'fn_cp_st_set_storefront_pl'
        ],
        'pagination'    => [
            'is_dynamic'    => true,
            'tooltip'       => __('cp_st_pagination_descr', ['[href]' => fn_url('languages.translations?q=cp_st_page_title_placeholder')]),
            'title'         => __('cp_st_pagination_txt'),
            'get_function'  => 'fn_cp_st_set_pagination_pl'
        ]
    ]
];
if (fn_allowed_for('MULTIVENDOR')) {
    $schema['P']['company']    = [
        'title'         => __('vendor'),
        'get_function'  => 'fn_cp_st_get_company_name'
    ];
    $schema['A']['company']    = [
        'title'         => __('vendor'),
        'get_function'  => 'fn_cp_st_get_company_name'
    ];
}

return $schema;
