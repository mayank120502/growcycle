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


$schema = [
    'page_title' => [
        'title'         => __('cp_page_title'),
        'default_value' => [
            'P' => '{{ product }} - ' . __('cp_seo_field_best_price_delivery') . ' | {{ storefront }}',
            'C' => '{{ category }} ' . __('cp_seo_field_buy_from') . ' {{ min_price }}{{ currency_symbol }} ' . __('cp_seo_field_with_delivery') . ' | {{ storefront }}',
            'A' => '{{ page }}',
            'E' => '{{ variant }}'
        ]
    ],
    'meta_description' => [
        'title'         => __('cp_meta_description'),
        'html_params'   => ['rows' => 4],
        'default_value' => [
            'P' => '{{ product }} {{ price }}{{ currency_symbol }} + {{ full_description }}',
            'C' => __('cp_seo_field_buy') . ' {{ category }} ' . __('cp_seo_field_from') . ' {{ min_price }}{{ currency_symbol }} ' . __('cp_seo_field_is_online_store') . ' {{ storefront }}! ' . __('cp_seo_field_combo'),
            'A' => '',
        ]
    ],
    'meta_keywords' => [
        'title'         => __('cp_meta_keywords'),
        'default_value' => [
            'P' => '{{ product|lower }}, {{ category|lower }}',
            'C' => '{{ category }}',
            'A' => '{{ page }}',
            'E' => '{{ variant }}'
        ]
    ],
    'seo_name'  => [
        'title' => __('seo_name')
    ],
    'cp_st_h1'  =>   [
        'title'         => __('cp_seo_custom_h1'),
        'is_extra'      => true,
        'default_value' => [
            'P' => '{{ product }}',
            'C' => '{{ category }}',
            'A' => '{{ page }}',
            'E' => '{{ variant }}'
        ]
    ],
    'cp_st_custom_bc'   =>   [
        'title'         => __('cp_seo_custom_breadcrumb'),
        'is_extra'      => true,
        'default_value' => [
            'P' => '{{ product }}',
            'C' => '{{ category }}',
            'A' => '{{ page }}',
            'E' => '{{ variant }}'
        ]
    ],
];

return $schema;
