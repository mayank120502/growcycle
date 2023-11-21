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

$schema = array(
    'S' => array(
        'title' => 'custom',
        'type' => 'input',
        'tooltip' => 'cp_so_canonical_other_text'
    ),
    'P' => array(
        'link' => 'products.view?product_id=[object_id]',
        'title' => 'product',
        'type' => 'picker',
        'picker_props' => array(
            'picker' => 'pickers/products/picker.tpl',
            'params' => array(
                'multiple' => false,
                'type' => 'single',
            )
        )
    ),
    'C' => array(
        'link' => 'categories.view?category_id=[object_id]',
        'title' => 'category',
        'type' => 'picker',
        'picker_props' => array(
            'picker' => 'pickers/categories/picker.tpl',
            'params' => array(
                'multiple' => false,
                'use_keys' => 'N',
                'view_mode' => 'mixed',
            ),
        )
    ),
    'A' => array(
        'link' => 'pages.view?page_id=[object_id]',
        'title' => 'page',
        'type' => 'picker',
        'picker_props' => array(
            'picker' => 'pickers/pages/picker.tpl',
            'params' => array(
                'multiple' => false,
                'type' => 'mixed'
            ),
        )
    )
);

return $schema;