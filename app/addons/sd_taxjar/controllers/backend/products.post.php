<?php
 use Tygh\Registry; defined('BOOTSTRAP') or die('Access denied'); if ($_SERVER['REQUEST_METHOD'] == 'POST') { return array(CONTROLLER_STATUS_OK); } if ($mode == 'update') { $product_data = Tygh::$app['view']->getTemplateVars('product_data'); $runtime_company_id = fn_get_runtime_company_id(); Tygh::$app['view']->assign(array( 'sd_taxjar_products_tax_codes' => fn_sd_taxjar_get_saved_products_tax_codes(), 'countries' => fn_get_simple_countries(true, CART_LANGUAGE), 'states' => fn_get_all_states(), 'show_get_taxjar_taxes' => (($runtime_company_id == 0 || $runtime_company_id == $product_data['company_id']) && fn_allowed_for('ULTIMATE') || fn_allowed_for('MULTIVENDOR') ) )); } elseif ($mode == 'manage') { $sd_taxjar_products_tax_codes = fn_sd_taxjar_get_saved_products_tax_codes(); if (!empty($sd_taxjar_products_tax_codes)) { $selected_fields = Tygh::$app['view']->getTemplateVars('selected_fields'); $selected_fields[] = array( 'name' => '[data][products_tax_codes]', 'text' => __('addons.sd_taxjar.product_tax_code') ); Tygh::$app['view']->assign('selected_fields', $selected_fields); } } elseif ($mode == 'm_update') { $selected_fields = Tygh::$app['session']['selected_fields']; $field_groups = Tygh::$app['view']->getTemplateVars('field_groups'); $filled_groups = Tygh::$app['view']->getTemplateVars('filled_groups'); $field_names = Tygh::$app['view']->getTemplateVars('field_names'); $field_codes = array('addons.sd_taxjar.--'); $codes = fn_sd_taxjar_get_saved_products_tax_codes(); foreach ($codes as $cod) { $field_codes[$cod['product_tax_code']] = 'addons.sd_taxjar.' . $cod['product_tax_code']; } if (!empty($selected_fields['data']['products_tax_codes'])) { $field_groups['S']['product_tax_code'] = array( 'name' => 'products_data', 'variants' => $field_codes ); $filled_groups['S']['product_tax_code'] = __('addons.sd_taxjar.product_tax_code'); unset($field_names['products_tax_codes']); unset($field_codes); unset($codes); } Tygh::$app['view']->assign(array( 'field_groups' => $field_groups, 'filled_groups' => $filled_groups, 'field_names' => $field_names )); } 