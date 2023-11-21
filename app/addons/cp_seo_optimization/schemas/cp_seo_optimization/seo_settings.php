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

include_once(__DIR__ . '/seo_settings.functions.php');

use Tygh\Registry;

$pages_title = __('pages') ;
$pages_title .= (Registry::get('addons.blog.status') == 'A') ? ' / ' . __('blog') : '';

$schema = [
    'noindex_params' => Registry::get('addons.cp_seo_optimization.noindex_params'), // noindex pages with specified request params
    'noindex_hidden' => [ // noindex hidden objects
        'action' => 'noindex',
        'items' => [
            'P' => [
                'descr' => __('products'),
                'check_function' => 'fn_cp_seo_check_product_hidden'
            ],
            'C' => [
                'descr' => __('categories'),
                'check_function' => 'fn_cp_seo_check_category_hidden'
            ],
            'A' => [
                'descr' => $pages_title,
                'check_function' => 'fn_cp_seo_check_page_hidden'
            ]
        ]
    ],
    'noindex_product' => [
        'action' => 'noindex',
        'items' => [
            'without_price' => [
                'descr' => __('cp_so_without_price'),
                'check_function' => 'fn_cp_seo_check_product_without_price'
            ],
            'without_stock' => [
                'descr' => __('cp_so_without_stock'),
                'check_function' => 'fn_cp_seo_check_product_without_stock'
            ]
        ]
    ],
    'noindex_without_products' => [
        'action' => 'noindex',
        'check_function' => 'fn_cp_seo_check_without_products',
        'items' => [
            'C' => [
                'descr' => __('categories')
            ],
            'E' => [
                'descr' => __('cp_so_brands')
            ]
        ]
    ],
    'hide_description' => [
        'action' => 'hide_descr',
        'check_function' => 'fn_cp_seo_check_pagination',
        'items' => [
            'C' => [
                'descr' => __('categories'),
                'process_function' => 'fn_cp_seo_remove_category_description',
            ],
            'E' => [
                'descr' => __('cp_so_brands'),
                'process_function' => 'fn_cp_seo_remove_variant_description'
            ]
        ]
    ],
    'use_lastmod' => [
        'action' => 'lastmod',
        'items' => [
            'H' => [
                'descr' => __('home_page'),
                'check_function' => 'fn_cp_seo_check_homepage_lastmod'
            ],
            'P' => [
                'descr' => __('products'),
                'check_function' => 'fn_cp_seo_check_product_lastmod'
            ],
            'C' => [
                'descr' => __('categories'),
                'check_function' => 'fn_cp_seo_check_category_lastmod'
            ],
            'A' => [
                'descr' => $pages_title,
                'check_function' => 'fn_cp_seo_check_page_lastmod'
            ]
        ]
    ],
    'canonical' => [
        'action' => 'canonical',
        'skip_setting_check' => true,
        'items' => [
            'P' => [
                'check_function' => 'fn_cp_seo_check_product_canonical'
            ],
            'C' => [
                'check_function' => 'fn_cp_seo_check_category_canonical'
            ],
            'A' => [
                'check_function' => 'fn_cp_seo_check_page_canonical'
            ]
        ]
    ],
//     'object_noindex' => [
//         'action' => 'noindex',
//         'skip_setting_check' => true,
//         'items' => [
//             'P' => [
//                 'check_function' => 'fn_cp_seo_check_product_noindex'
//             ],
//             'C' => [
//                 'check_function' => 'fn_cp_seo_check_category_noindex'
//             ],
//             'A' => [
//                 'check_function' => 'fn_cp_seo_check_page_noindex'
//             ]
//         ]
//     ]
];

return $schema;