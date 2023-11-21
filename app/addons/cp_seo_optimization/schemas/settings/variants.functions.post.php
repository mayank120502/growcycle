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

function fn_settings_variants_addons_cp_seo_optimization_hide_description()
{
    return fn_cp_seo_setting_variants('hide_description');
}

function fn_settings_variants_addons_cp_seo_optimization_noindex_hidden()
{
    return fn_cp_seo_setting_variants('noindex_hidden');
}

function fn_settings_variants_addons_cp_seo_optimization_noindex_product()
{
    return fn_cp_seo_setting_variants('noindex_product');
}

function fn_settings_variants_addons_cp_seo_optimization_noindex_without_products()
{
    return fn_cp_seo_setting_variants('noindex_without_products');
}

function fn_settings_variants_addons_cp_seo_optimization_use_lastmod()
{
    return fn_cp_seo_setting_variants('use_lastmod');
}

function fn_settings_variants_addons_cp_seo_optimization_redirect_404()
{
    $vars = [
        '' => __('none'),
        'home' => __('home_page')
    ];
    $condition = '';
    if (fn_allowed_for('ULTIMATE')) {
        $condition .= fn_get_company_condition('?:pages.company_id');
    } else {
        $condition .= db_quote(' AND company_id = 0');
    }
    $pages = db_get_hash_single_array(
        'SELECT CONCAT("A_", ?:pages.page_id) as page_key, page FROM ?:pages'
        . ' LEFT JOIN ?:page_descriptions ON ?:pages.page_id = ?:page_descriptions.page_id'
        . ' WHERE status != ?s AND page_type = ?s ?p', ['page_key', 'page'], 'D', 'T', $condition
    );
    $vars = array_merge($vars, $pages);
    return $vars;
}
