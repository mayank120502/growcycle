<?php
use Tygh\Registry;
use Tygh\Settings;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'update' && $_SERVER['REQUEST_METHOD'] != 'POST') {
  $company_data = Registry::get('view')->getTemplateVars('company_data');
  if (isset($company_data['company_id'])) {
    
    /* Vendor Info blocks*/
    
    $et_quick_info_block=fn_et_quick_info_get($company_data['company_id'],true);
    if (!empty($et_quick_info_block)){
      Registry::get('view')->assign('et_quick_info_block', $et_quick_info_block);
    }

    Registry::set('navigation.tabs.et_quick_info_block', array (
      'title' => __("et_quick_info_block"),
      'js' => true
    ));
    
  }else{
    return array(CONTROLLER_STATUS_DENIED);
  }
}
