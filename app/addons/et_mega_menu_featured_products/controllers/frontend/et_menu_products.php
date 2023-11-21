<?php

use Tygh\Registry;

	
if ($mode=="et_load"){

	$category_id=$_REQUEST['category_id'];
	if (fn_allowed_for('ULTIMATE') && Registry::get('runtime.company_id')) 
	{
	  $company_id = Registry::get('runtime.company_id');
	}else{
		$company_id=0;
	}

	$data=fn_get_et_category_menu_settings($category_id,CART_LANGUAGE,$company_id,true);

	if (!empty($data)) {
		Tygh::$app['view']->assign('et_menu', $data);
		Tygh::$app['view']->assign('container_id', $_REQUEST['container_id']);
		Tygh::$app['view']->display('addons/et_mega_menu/components/products.tpl');
	}
	exit;
}