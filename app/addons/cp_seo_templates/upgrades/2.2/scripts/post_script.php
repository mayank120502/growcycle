<?php

use Tygh\Registry;
use Tygh\Settings;

$addon_id = 'cp_seo_templates';
$addon_scheme = Tygh\Addons\SchemesManager::clearInternalCache($addon_id);
$addon_scheme = Tygh\Addons\SchemesManager::getScheme($addon_id);

if (function_exists('fn_get_addon_settings_values')
    && function_exists('fn_get_addon_settings_vendor_values')
) {
    $setting_values = $settings_vendor_values = [];
    $settings_values = fn_get_addon_settings_values($addon_id);
    $settings_vendor_values = fn_get_addon_settings_vendor_values($addon_id);

    fn_update_addon_settings($addon_scheme, true, $settings_values, $settings_vendor_values);
} else {
    fn_update_addon_settings($addon_scheme, true);
}

db_query("UPDATE ?:addons SET conflicts = ?s WHERE addon = ?s", 'cp_h1', 'cp_seo_templates');

$custome_h1 = Registry::get('addons.cp_h1');
if (!empty($custome_h1)) {
    $custome_h1_vers = db_get_field("SELECT version FROM ?:addons WHERE addon = ?s", 'cp_h1');
    $more_update = '';
    if (version_compare($custome_h1_vers, '1.2', '>')) {
        $more_update = ', cp_st_custom_bc = cp_custom_bc';
    }
    db_query("UPDATE ?:product_descriptions SET cp_st_h1 = h1 ?p", $more_update);
    db_query("UPDATE ?:category_descriptions SET cp_st_h1 = h1 ?p", $more_update);
    db_query("UPDATE ?:page_descriptions SET cp_st_h1 = h1 ?p", $more_update);
    db_query("UPDATE ?:product_feature_variant_descriptions SET cp_st_h1 = h1 ?p", $more_update);
    if (fn_allowed_for('ULTIMATE')) {
        db_query("UPDATE ?:ult_product_descriptions SET cp_st_h1 = h1 ?p", $more_update);
    }
    db_query("REPLACE INTO ?:privileges (privilege, is_default, section_id, group_id, is_view) VALUES ('view_cp_seo', 'Y', 'addons', 'cp_seo', 'Y')");
    db_query("REPLACE INTO ?:privileges (privilege, is_default, section_id, group_id, is_view) VALUES ('manage_cp_seo', 'Y', 'addons', 'cp_seo', 'N')");
    
    fn_set_notification('W', __('warning'), __('cp_seo_please_check_settings'));
    
    db_query("UPDATE ?:addons SET status = ?s WHERE addon = ?s", 'D', 'cp_h1');
}

if (fn_allowed_for('MULTIVENDOR')) {
    
    $vendors_templates = db_get_fields("SELECT template_id FROM ?:cp_seo_templates WHERE company_id > ?i", 0);
    if (!empty($vendors_templates)) {
        db_query('DELETE FROM ?:cp_seo_templates WHERE template_id IN (?n)', $vendors_templates);
        db_query('DELETE FROM ?:cp_seo_templates_objects WHERE template_id IN (?n)', $vendors_templates);
        db_query('DELETE FROM ?:cp_seo_templates_content WHERE template_id IN (?n)', $vendors_templates);
    }
}