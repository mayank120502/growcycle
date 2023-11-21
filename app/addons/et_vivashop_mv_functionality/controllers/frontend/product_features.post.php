<?php

use Tygh\Registry;
defined('BOOTSTRAP') or die('Access denied');

if ($mode === 'compare') {
	if (Registry::get('addons.et_vivashop_mv_functionality.et_product_link')=="vendor"){
		$comparison_data=Tygh::$app['view']->getTemplateVars('comparison_data');
		if (isset($comparison_data) && !empty($comparison_data)){
			$products=$comparison_data['products'];
			foreach ($products as $key => $product) {
				if ($product['company_id']){
			    $product['company_has_store']=fn_et_vivashop_mv_functionality_has_microstore($product['company_id']);

			    $comparison_data['products'][$key]=$product;
			  }
			}
			Tygh::$app['view']->assign('comparison_data', $comparison_data);
		}
	}
}