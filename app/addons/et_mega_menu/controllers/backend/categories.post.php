<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    return;
}

if ($mode == 'update') {

  $category_data = Registry::get('view')->getTemplateVars('category_data');
  $categ_id = $category_data['category_id'];
  $lang_code = $category_data['lang_code'];
  if (fn_allowed_for('ULTIMATE') && Registry::get('runtime.company_id')){
    $company_id         = $category_data['company_id'];
    $et_menu            = fn_get_et_category_menu_settings($categ_id,$lang_code,$company_id);
  }else{
    $et_menu            = fn_get_et_category_menu_settings($categ_id,$lang_code);
  }

  if (fn_allowed_for('MULTIVENDOR') || fn_allowed_for('ULTIMATE') && Registry::get('runtime.company_id')) {
  	Registry::set('navigation.tabs.et_menu', array (
	    'title' => __("et_mega_menu"), 
	    'js' => true
  	));
    Registry::get('view')->assign('et_menu', $et_menu);
  }

  $fillings=fn_et_vivashop_settings_get_product_fillings();
  Tygh::$app['view']->assign('et_menu_product_fillings', $fillings);
}
