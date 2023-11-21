<?php
use Tygh\Registry;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
if ($_SERVER['REQUEST_METHOD'] == 'POST') { return; }

if ($mode == 'update') {
  $category_data = Registry::get('view')->getTemplateVars('category_data');

  $et_category_banner = fn_get_et_category_banner($category_data['category_id'],$category_data['lang_code']);

  if (!empty($et_category_banner)) {
    if (fn_allowed_for('MULTIVENDOR') || fn_allowed_for('ULTIMATE') && Registry::get('runtime.company_id')) {
    	Registry::set('navigation.tabs.et_category_banner', array (
  	    'title' => __("et_category_banner"),
  	    'js' => true
    	));
      Registry::get('view')->assign('et_category_banner', $et_category_banner);
    }
  }

}
