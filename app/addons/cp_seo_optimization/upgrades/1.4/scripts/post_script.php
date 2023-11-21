<?php

$addon_id = 'cp_seo_optimization';
$addon_scheme = Tygh\Addons\SchemesManager::clearInternalCache($addon_id);
$addon_scheme = Tygh\Addons\SchemesManager::getScheme($addon_id);

if (function_exists('fn_get_addon_settings_values')
    && function_exists('fn_get_addon_settings_vendor_values')
) {
    $setting_values = $settings_vendor_values = array();
    $settings_values = fn_get_addon_settings_values($addon_id);
    $settings_vendor_values = fn_get_addon_settings_vendor_values($addon_id);

    fn_update_addon_settings($addon_scheme, true, $settings_values, $settings_vendor_values);
} else {
    fn_update_addon_settings($addon_scheme, true);
}

$all_links = db_get_array("SELECT * FROM ?:cp_seo_links");
if (!empty($all_links)) {
    foreach($all_links as $link) {
        if (!empty($link['no_index']) && $link['no_index'] == 'Y' && !empty($link['object_id']) && !empty($link['type'])) {
            if ($link['type'] == 'P') {
                db_query("UPDATE ?:products SET cp_seo_no_index = ?s, cp_seo_use_addon = ?s WHERE product_id = ?i", 'Y', 'N', $link['object_id']);
            } elseif ($link['type'] == 'C') {
                db_query("UPDATE ?:categories SET cp_seo_no_index = ?s, cp_seo_use_addon = ?s WHERE category_id = ?i", 'Y', 'N', $link['object_id']);
            } elseif ($link['type'] == 'A') {
                db_query("UPDATE ?:pages SET cp_seo_no_index = ?s, cp_seo_use_addon = ?s WHERE page_id = ?i", 'Y', 'N', $link['object_id']);
            }
        }
    }
}

db_query("REPLACE INTO ?:privileges (privilege, is_default, section_id, group_id, is_view) VALUES ('view_cp_seo_opt', 'Y', 'addons', 'cp_seo_optimization', 'Y')");
db_query("REPLACE INTO ?:privileges (privilege, is_default, section_id, group_id, is_view) VALUES ('manage_cp_seo_opt', 'Y', 'addons', 'cp_seo_optimization', 'N')");

$rules = fn_get_schema('cp_seo_optimization', 'seo_index_pages');
if (fn_allowed_for('MULTIVENDOR')) {
    $rules['companies.apply_for_vendor'] = 'Y';
}
if (!empty($rules)) {
    if (fn_allowed_for('ULTIMATE')) {
        $companies = db_get_fields("SELECT company_id FROM ?:companies");
    } else {
        $companies[] = 0;
    }
    foreach($companies as $com_id) {
        foreach($rules as $dip => $val) {
            $put_data = [
                'dispatch'  => $dip,
                'rule'      => $val,
                'company_id'=> $com_id
            ];
            db_query("INSERT INTO ?:cp_seo_index_rules ?e", $put_data);
        }
    }
}