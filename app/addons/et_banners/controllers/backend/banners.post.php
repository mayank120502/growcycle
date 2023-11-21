<?php

use Tygh\Registry;
use Tygh\Settings;

if (!defined('BOOTSTRAP')) { die('Access denied'); }
if ($_SERVER['REQUEST_METHOD']	== 'POST') {
	if ($mode == 'update'){
			fn_et_banners_save_post($_REQUEST, $_REQUEST['banner_id'], DESCR_SL);
	} 
}

if ($mode == 'update' || $mode == 'add') {
	$et_tabs=Registry::get('navigation.tabs');

	$et_tabs['general']=array (
    'title' => __('general'),
    'js' => true
	);

	$et_tabs['phone']= array (
    'title' => __('phone'),
    'js' => true,
  );
	$et_tabs['tablet']= array (
    'title' => __('block_manager.availability.tablet'),
    'js' => true,
  );

	Registry::set('navigation.tabs',$et_tabs);

}