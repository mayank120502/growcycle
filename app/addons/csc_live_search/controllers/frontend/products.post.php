<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			http://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
use Tygh\Registry;
use Tygh\CscLiveSearch;
if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode=="search" && !defined('AJAX_REQUEST')){
	$ls_settings = CscLiveSearch::_get_option_values();	
	if ($ls_settings['autoredirect']=="Y"){
		$_view = CscLiveSearch::_view();
		$search = $_view->getTemplateVars('search');	
		if ($search['total_items']==1){		
			$products = $_view->getTemplateVars('products');
			$product = reset($products);
			return array(CONTROLLER_STATUS_REDIRECT, 'products.view?product_id='.$product['product_id']);			
		}
	}	
	$params= Tygh::$app['view']->getTemplateVars('search');	 
	ClsSearchProducts::_save_requests_found_products($params, $ls_settings);
}