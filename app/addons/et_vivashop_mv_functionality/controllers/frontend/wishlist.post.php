<?php

use Tygh\Registry;
defined('BOOTSTRAP') or die('Access denied');

if ($mode === 'view') {
	if (Registry::get('addons.et_vivashop_mv_functionality.et_product_link')=="vendor"){
		$products=Tygh::$app['view']->getTemplateVars('products');
		foreach ($products as $key => $product) {
			if ($product['company_id']){
		    $product['company_has_store']=fn_et_vivashop_mv_functionality_has_microstore($product['company_id']);

		    $products[$key]=$product;
		  }
		}
		Tygh::$app['view']->assign('products', $products);
	}
}