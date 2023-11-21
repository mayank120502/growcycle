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

if(!defined('BOOTSTRAP')) {die('Access denied');}

if ($mode == 'm_update') {

    $allow_fields = [
        'cp_st_h1'          => __('cp_seo_custom_h1'),
        'cp_st_custom_bc'   => __('cp_seo_custom_breadcrumb'),
    ];
    $field_names = Registry::get('view')->getTemplateVars('field_names');
    $filled_groups = Registry::get('view')->getTemplateVars('filled_groups');
    $field_groups = Registry::get('view')->getTemplateVars('field_groups');
    
    foreach ($allow_fields as $field_key => $field_name) {
        if (!isset($field_names[$field_key])) {
            continue;
        }
        $field_groups['A'][$field_key] = 'products_data';
        $filled_groups['A'][$field_key] = $field_name;
        unset($field_names[$field_key]);
    }
    
    Tygh::$app['view']->assign('field_groups', $field_groups);
    Tygh::$app['view']->assign('filled_groups', $filled_groups);
    Tygh::$app['view']->assign('field_names', $field_names);
}

if ($mode == 'update') {
    Registry::set('navigation.tabs.cp_seo_meta', [
        'title' => __('cp_seo_subheader'),
        'js'    => true
    ]);
}
