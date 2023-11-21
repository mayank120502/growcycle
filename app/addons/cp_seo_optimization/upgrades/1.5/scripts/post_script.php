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

$filts = db_get_array("SELECT * FROM ?:product_filters");
if (!empty($filts)) {
    $reset_f = reset($filts);
    if (!empty($reset_f) && isset($reset_f['cp_seo_index_result'])) {
        db_query("ALTER TABLE ?:product_filters DROP cp_seo_index_result");
    }
}