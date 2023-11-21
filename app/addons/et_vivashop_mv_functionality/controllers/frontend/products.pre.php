<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'view') {
	if (Registry::get('addons.et_vivashop_mv_functionality.et_product_link')=="vendor"){
		$product = fn_get_product_data(
		    $_REQUEST['product_id'],
		    $auth,
		    CART_LANGUAGE,
		    '',
		    true,
		    true,
		    true,
		    true,
		    fn_is_preview_action($auth, $_REQUEST),
		    true,
		    false,
		    true
		);

		if ($product['company_id']){
			$company_id=$product['company_id'];
			$has_microstore=fn_et_vivashop_mv_functionality_has_microstore($company_id);
			if ($has_microstore){

				$req=$_REQUEST;
				unset($req['dispatch']);
				unset($req['product_id']);
				$params='';
				foreach ($req as $key => $value) {
					$params.="&$key=$value";
				}

				return array(CONTROLLER_STATUS_REDIRECT, 'companies.product_view&product_id='.$product['product_id'].'&company_id='.$product['company_id'].$params);
			}
		}
	}
}