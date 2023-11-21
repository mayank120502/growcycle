<?php

use Tygh\Registry;

if ($mode=="load"){

	if (isset($_REQUEST['tab_id'])){
		$tab_id=$_REQUEST['tab_id'];
		$params=array(
			'tab_id'=>$tab_id
		);

		$item=fn_et_get_featured_product_banner_tab($params);
		if (!empty($item)) {
			Tygh::$app['view']->assign('item', $item[0]);
			Tygh::$app['view']->assign('tab_link_id', $_REQUEST['tab_link_id']);
			Tygh::$app['view']->assign('tab_content_id', $_REQUEST['tab_content_id']);
			Tygh::$app['view']->display('addons/et_featured_product_banner_tabs/components/tab_content.tpl');
		}else{
			fn_set_notification("E","result","no items");
		}
	}
	exit;
}