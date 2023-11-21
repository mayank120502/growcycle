<?php 
/*****************************
* Copyright 2021 1st Source IT, LLC
* All rights reserved.
* Permission granted for use as
* long as this copyright notice, associated text and
* links remain in tact.
* Licensed for a single domain and a single instance of EZ-cart.
* Additional licenses can be purchased for additonal sites.
*
* http://www.ez-ms.com
* http://www.ez-om.com
* http://www.1sit.com*
*
* End copyright notification
*/

if( !defined('BOOTSTRAP') ) die('Access denied'); 
use Tygh\Registry;

// Go to Users/Group Minimum Orders to define Group amounts.

// Since the order can be adjusted in the cart and during the various phases of checkout, 
// this check needs to be done on every 'checkout' mode except 'cart'. 
if( $mode != 'cart' && $_SERVER['REQUEST_METHOD'] != 'POST' ) { 
	$my_company_info = array();
	foreach($vendor_info = vendor_min_order_get_companies() as $company_id => $data)
		$company_minimum_amounts[$company_id] = $data['vendor_min_order_amount'];

	$company_ids = array_keys($company_minimum_amounts);
	if( empty($company_minimum_amounts)  ) 
		return array(CONTROLLER_STATUS_OK); // No company minimums
		
	// Accumulate product amounts.
	$cart = &$_SESSION['cart']; 
	$shipping = empty($cart['shipping_cost']) ? 0 : $cart['shipping_cost']; 

	$vendor_product_amounts = array();
	$last_failed_vendor_cid = 0;	// product_id
	
	foreach($cart['products'] as $cid => $p_info) {
		if( !empty($p_info['company_id']) && in_array($p_info['company_id'], $company_ids) ) {	// company has restrictions
			if( !isset($vendor_product_amounts[$p_info['company_id']]['vendor_min_order_amount']) )
				$vendor_product_amounts[$p_info['company_id']]['vendor_min_order_amount'] = 0;
			$vendor_product_amounts[$p_info['company_id']]['vendor_min_order_amount'] += ($p_info['price'] * $p_info['amount']);
			$vendor_product_amounts[$p_info['company_id']]['last_cid'] = $cid;
		}
	}
	
	// Check total price * amounts for company minimums
	foreach($vendor_product_amounts as $company_id => $product_info ) {
		$vendor_min_order_amount = $product_info['vendor_min_order_amount'];
vmo_log("vendor_min_order_amount for company_id=$company_id = $vendor_min_order_amount, minimum_amount={$company_minimum_amounts[$company_id]}");
		if( !empty($company_minimum_amounts[$company_id]) && $company_minimum_amounts[$company_id] > $vendor_min_order_amount ) {	// Fail
			$last_failed_vendor_cid = $vendor_product_amounts[$company_id]['last_cid'];
vmo_log("failed product ({$last_failed_vendor_cid}):".print_r($cart['products'][$last_failed_vendor_cid],true) );
			$currency_symbol = Registry::get('currencies.' . CART_SECONDARY_CURRENCY . '.symbol');
			$msg = str_replace('%[company_name]%', $vendor_info[$company_id]['company'], 
						str_replace('%[amount]%', fn_format_price($company_minimum_amounts[$company_id]),
							str_replace('%[currency_symbol]%', $currency_symbol, __('vendor_min_orders_fail_msg')
										)
									)
								);
			fn_set_notification('E', __("error"), $msg, 'K');
			$dispatch = sprintf("products.view&amp;product_id=%d", $cart['products'][$last_failed_vendor_cid]['product_id']);
		}
	}
	
	if( !empty($dispatch)) {
		return array(CONTROLLER_STATUS_OK, $dispatch);
	}
	
	// Order is more than $my_minimum_order 
}
return array(CONTROLLER_STATUS_OK); 
?>