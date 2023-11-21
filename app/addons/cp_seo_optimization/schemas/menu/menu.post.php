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

$schema['central']['website']['items']['cp_seo_optimization'] = [
    'attrs' => [
        'class'=>'is-addon'
    ],
    'href'      => 'cp_seo_names.manage',
    'position'  => 504,
    'subitems'  => [
        'cp_seo_names_editor' => [
            'href'      => 'cp_seo_names.manage',
            'position'  => 100
        ],
        'cp_seo_index_rules' => [
            'href'      => 'cp_seo_optimization.index_rules',
            'position'  => 200
        ]
    ]
];

$schema['top']['administration']['items']['import_data']['subitems']['cp_seo_redirects'] = [
    'href'      => 'exim.import?section=cp_seo_redirects',
    'position'  => 700
];
$schema['top']['administration']['items']['export_data']['subitems']['cp_seo_redirects'] = [
    'href'      => 'exim.export?section=cp_seo_redirects',
    'position'  => 700
];

return $schema;