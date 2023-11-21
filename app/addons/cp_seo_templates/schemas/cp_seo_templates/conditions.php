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
    'P' => [
        'title'         => __('products'),
        'operators'     => ['in', 'nin'],
        'type'          => 'picker',
        'picker_props'  => [
            'picker' => 'pickers/products/picker.tpl',
            'params' => [
                'multiple'  => true,
                'type'      => 'links',
            ]
        ]
    ],
    'C' => [
        'title'         => __('categories'),
        'operators'     => ['in', 'nin'],
        'type'          => 'picker',
        'picker_props'  => [
            'picker' => 'pickers/categories/picker.tpl',
            'params' => [
                'multiple'  => true,
                'use_keys'  => 'N',
                'view_mode' => 'table',
            ],
        ]
    ],
    'A' => [
        'title'         => __('pages'),
        'operators'     => ['in', 'nin'],
        'type'          => 'picker',
        'picker_props'  => [
            'picker' => 'pickers/pages/picker.tpl',
            'params' => [
                'multiple'  => true,
                'type'      => 'links'
            ],
        ]
    ],
    'E' => [
        'title'             => __('features'),
        'operators'         => ['eq', 'neq'],
        'type'              => 'select',
        'variants_function' => ['fn_cp_st_get_brand_features'],
    ]
];

if (fn_allowed_for('ULTIMATE')) {
    $schema['A']['use_company'] = true;
}

return $schema;