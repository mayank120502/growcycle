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

$schema = [
    'index' => [ // controller
        'index' => [ // mode
            'use_lastmod' => 'H'
        ]
    ],
    'products' => [
        'view' => [
            'noindex_hidden'    => 'P',
            'noindex_product'   => ['without_price', 'without_stock'],
            'use_lastmod'       => 'P',
            'canonical'         => 'P',
            'object_noindex'    => 'P',
            'front_object'      => 'product'
        ]
    ],
    'categories' => [
        'view' => [
            'hide_description'          => 'C',
            'noindex_hidden'            => 'C',
            'noindex_without_products'  => 'C',
            'use_lastmod'               => 'C',
            'canonical'                 => 'C',
            'object_noindex'            => 'C',
            'front_object'              => 'category_data'
        ]
    ],
    'pages' => [
        'view' => [
            'noindex_hidden'=> 'A',
            'use_lastmod'   => 'A',
            'canonical'     => 'A',
            'object_noindex'=> 'A',
            'front_object'  => 'page'
        ]
    ],
    'product_features' => [
        'view' => [
            'hide_description'          => 'E',
            'noindex_without_products'  => 'E',
            'front_object'              => 'variant_data'
        ]
    ],
];

return $schema;