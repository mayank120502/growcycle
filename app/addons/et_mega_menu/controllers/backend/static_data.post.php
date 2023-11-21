<?php
use Tygh\Registry;
if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
  return;
}

if ($mode == 'update') {
  $static_data = Registry::get('view')->getTemplateVars('static_data');

  $et_data=fn_et_mega_menu_get_et_menu($static_data['param_id'],DESCR_SL);

  if (is_array($et_data)){
	  $static_data['et_menu_id']=$et_data['et_menu_id'];
	  $static_data['et_menu']=$et_data['data'];

	  Registry::get('view')->assign('static_data', $static_data);
	}
}