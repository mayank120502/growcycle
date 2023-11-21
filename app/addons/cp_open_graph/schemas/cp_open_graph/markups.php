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

// Set markup for store pages

$schema = [ 
    'index' => [
        'index' => 'homepage'
    ],
    'categories' => [
        'view' => 'category'
    ],
    'products' => [
        'view' => 'product'
    ],
    'pages' => [
        'view' => 'page'
    ]
];

if (Tygh\Registry::get('addons.blog.status') == 'A') {
    $schema['pages']['view'] = ['blog', 'page']; // objects by priority
}

return $schema;