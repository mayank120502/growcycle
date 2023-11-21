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

$schema['cp_seo_names'] = [
    'permissions' => ['GET' => 'view_cp_seo_opt', 'POST' => 'manage_cp_seo_opt'],
];

$schema['cp_seo_optimization'] = [
    'modes' => [
        'change_type' => [
            'permissions' => 'manage_cp_seo_opt',
        ],
        'add_rule' => [
            'permissions' => 'manage_cp_seo_opt',
        ],
    ],
    'permissions' => ['GET' => 'view_cp_seo_opt', 'POST' => 'manage_cp_seo_opt'],
];

$schema['exim']['modes']['export']['param_permissions']['section']['cp_seo_redirects'] = 'view_cp_seo_opt';
$schema['exim']['modes']['import']['param_permissions']['section']['cp_seo_redirects'] = 'manage_cp_seo_opt';

return $schema;
