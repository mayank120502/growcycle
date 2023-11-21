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

function fn_settings_variants_addons_cp_seo_templates_dp_pagination_use_fields()
{
    return fn_cp_st_get_meta_fields('pagination');
}

function fn_settings_variants_addons_cp_seo_templates_dp_storefront_use_fields()
{
    return fn_cp_st_get_meta_fields('storefront');
}

function fn_cp_st_get_meta_fields($pl_key)
{
    static $placeholders = null;
    if (!isset($placeholders)) {
        $placeholders = fn_get_schema('cp_seo_templates', 'dynamic_placeholders', 'php', true);
    }
    $fields = array();
    if (!empty($placeholders[$pl_key]['fields'])) {
        foreach ($placeholders[$pl_key]['fields'] as $f_key => $f_val) {
            if (empty($f_val)) {
                continue;
            }
            $fields[$f_key] = __($f_key);
        }
    }
    return $fields;
}