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

$menu = array(
    'attrs' => array(
        'class'=>'is-addon'
    ),
    'href' => 'cp_seo_templates.manage',
    'position' => 510,
);

if (isset($schema['central']['cart_power_addons'])) {
    $schema['central']['cart_power_addons']['items']['cp_seo_templates'] = $menu;
} else {
    $schema['central']['website']['items']['cp_seo_templates'] = $menu;
}

return $schema;
