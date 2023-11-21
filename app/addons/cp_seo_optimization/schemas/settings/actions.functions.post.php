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
use Tygh\Settings;

function fn_cp_so_clear_addon_setting_path($value)
{
    return str_replace(array('/', '&', '?', ' '), '', $value);
}

function fn_settings_actions_addons_cp_seo_optimization_product_prefix(&$new_value, $old_value)
{
    if ($new_value != $old_value && !defined('CP_SEO_REFRESH_RUN')) {
        $new_value = fn_cp_so_clear_addon_setting_path($new_value);
        if (Settings::instance()->getValue('product_prefix_301', 'cp_seo_optimization') == 'Y') {
            fn_cp_so_settings_update('p', 'product_prefix', $new_value);
        }
    }
}

function fn_settings_actions_addons_cp_seo_optimization_only_main_category(&$new_value, $old_value)
{
    if ($new_value != $old_value && !defined('CP_SEO_REFRESH_RUN')) {
        if (Settings::instance()->getValue('product_prefix_301', 'cp_seo_optimization') == 'Y') {
            fn_cp_so_settings_update('p', 'product_prefix', $new_value);
        }
    }
}

function fn_settings_actions_addons_cp_seo_optimization_category_prefix(&$new_value, $old_value)
{
    if ($new_value != $old_value && !defined('CP_SEO_REFRESH_RUN')) {
        $new_value = fn_cp_so_clear_addon_setting_path($new_value);
        if (Settings::instance()->getValue('category_prefix_301', 'cp_seo_optimization') == 'Y') {
            fn_cp_so_settings_update('c', 'category_prefix', $new_value);
        }
    }
}

function fn_cp_so_settings_update($type, $option, $new_value)
{
    if (!function_exists('fn_iterate_through_seo_names')) {
        return;
    }

    $old_value = Registry::get('addons.cp_seo_optimization.' . $option);
    fn_iterate_through_seo_names(
        function ($seo_name) use ($option, $old_value, $new_value) {
            // We shouldn't consider null value
            if (false === fn_check_seo_object_exists(
                $seo_name['object_id'], $seo_name['type'], $seo_name['company_id']
            )) {
                fn_delete_seo_name($seo_name['object_id'], $seo_name['type'], '', $seo_name['company_id']);

                return;
            }

            Registry::set('addons.cp_seo_optimization.' . $option, $old_value);
            $url = fn_generate_seo_url_from_schema(array(
                'type' => $seo_name['type'],
                'object_id' => $seo_name['object_id'],
                'lang_code' => $seo_name['lang_code']
            ), false, array(), $seo_name['company_id']);
            
            fn_seo_update_redirect(array(
                'src' => $url,
                'type' => $seo_name['type'],
                'object_id' => $seo_name['object_id'],
                'company_id' => $seo_name['company_id'],
                'lang_code' => $seo_name['lang_code']
            ), 0, false);
        },
        db_quote("type = ?s ?p", $type, fn_get_seo_company_condition('?:seo_names.company_id', $type))
    );
}
