<?php

$addon_id = 'cp_json_ld';
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

$permissions_data = array(
    array(
        'privilege' => 'view_cp_json_ld_company',
        'is_default' => 'Y',
        'section_id' => 'addons'
    ),
    array(
        'privilege' => 'manage_cp_json_ld_company',
        'is_default' => 'Y',
        'section_id' => 'addons'
    )
);

foreach ($permissions_data as $data) {
    db_query("REPLACE INTO ?:privileges ?e", $data);
}

if (version_compare(PRODUCT_VERSION, '4.10', '>=')) {
    $privileges = array('manage_cp_json_ld_company', 'view_cp_json_ld_company');
    db_query('UPDATE ?:privileges SET group_id = ?s WHERE privilege IN (?a)', $addon_id, $privileges);
    db_query('UPDATE ?:privileges SET is_view = ?s WHERE privilege = ?s', 'Y', 'view_cp_json_ld_company');
}
