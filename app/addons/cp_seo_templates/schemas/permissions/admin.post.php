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

$schema['cp_seo_templates'] = [
    'modes' => [
        'update' => [
            'permissions' => [
                'GET' => 'view_cp_seo',
                'POST' => 'manage_cp_seo'
            ],
        ],
        'manage' => [
            'permissions'   => 'view_cp_seo',
        ],
        'add' => [
            'permissions' => 'manage_cp_seo',
        ],
        'cron_apply' => [
            'permissions' => 'manage_cp_seo',
        ],
        'dynamic' => [
            'permissions' => 'manage_cp_seo',
        ]
    ],
    'permissions' => 'manage_cp_seo',
];
$schema['tools']['modes']['update_status']['param_permissions']['table']['cp_seo_templates'] = 'manage_cp_seo';

return $schema;
