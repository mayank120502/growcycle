<?php
use Tygh\Registry;
if ($_SERVER['REQUEST_METHOD']=="POST"){
	$product_id = !empty($_REQUEST['product_id']) ? $_REQUEST['product_id'] : 0;
	$product_data = fn_get_product_data($product_id, $auth, CART_LANGUAGE, '', false, false, false, false, false, false);
	if ($product_data){
		if ($mode=="cartAdd" && $product_id){
			if (Registry::get('addons.direct_payments') && Registry::get('addons.direct_payments.status')=="A"){			
				$cart_service = Tygh::$app['addons.direct_payments.cart.service'];
				$cart_service->setCurrentVendorId((int) $product_data['company_id']);			
				$cart_service->loadSessionCart();
			}
			
			$cart = & Tygh::$app['session']['cart'];		
			$data = array(
				$product_data['product_id']=>array(
					'product_id'=>$product_data['product_id'],
					'amount'=>!empty($_REQUEST['amount']) ? $_REQUEST['amount'] : 1,
					'product_options'=>[]
				)
			);		
			fn_add_product_to_cart($data, $cart, $auth);
			fn_save_cart_content($cart, $auth['user_id']);
			$previous_state = md5(serialize($cart['products']));
			$cart['change_cart_products'] = true;
			fn_calculate_cart_content($cart, $auth, 'S', true, 'F', true);
			fn_set_notification('N', __('notice'), __('cls.added_to_cart'));		
				
		}
		if ($mode=="wishAdd" && $product_id){	
			Tygh::$app['session']['wishlist'] = isset(Tygh::$app['session']['wishlist']) ? Tygh::$app['session']['wishlist'] : array();
			$wishlist = & Tygh::$app['session']['wishlist'];
			$auth = & Tygh::$app['session']['auth'];
			$allready_added=false;
			if (!empty($wishlist['products'])){
				foreach ($wishlist['products'] as $_id=>$_product){
					if ($_product['product_id'] == $product_id){
						$allready_added=true;
						break;										
					}
				}
			}
			if ($allready_added){
				unset($wishlist['products'][$_id]);
				//fn_set_notification('N', __('notice'), __('cls.deleted_from_wish'));						
			}else{
				$_id = fn_generate_cart_id($product_id, []);
				$wishlist['products'][$_id]['product_id'] = $product_id;
				$wishlist['products'][$_id]['product_options'] = [];
				$wishlist['products'][$_id]['extra'] = [];
				$wishlist['products'][$_id]['amount'] = 1;
				//fn_set_notification('N', __('notice'), __('cls.added_to_wish'));	
			}
			exit;				
				
		}
		if ($mode=="compAdd"){
			$auth = & Tygh::$app['session']['auth'];	
			Tygh::$app['session']['comparison_list'] = isset(Tygh::$app['session']['comparison_list']) ? Tygh::$app['session']['comparison_list'] : array();
			$comparison_list = & Tygh::$app['session']['comparison_list'];			
			if (($key = array_search($product_id, $comparison_list)) !== false) {
				unset($comparison_list[$key]);
				//fn_set_notification('N', __('notice'), __('cls.deleted_from_comparison'));	
			}else{
				//fn_set_notification('N', __('notice'), __('cls.added_to_comparison'));		
				$comparison_list[] = $product_id;	
			}
			exit;
		}
	}else{
		fn_set_notification('W', __('warning'), __('cls.product_is_not_available'));
		exit;		
	}	
	return array(CONTROLLER_STATUS_REDIRECT, 'checkout.cart');
}

if ($mode=="get_warehouses_destination_id"){
	echo fn_cls_get_destination_id_by_product_params(array());
	exit;
}

if ($mode=='apply_discounts'){
	$pids = explode(',', $_REQUEST['pids']);
	list($products, $s) = fn_get_products([
		'pid'=>$pids,
		'limit'=>count($pids),
		'total'=> count($pids),		
		'load_products_extra_data'=>true,
		'extend'=>['prices', 'categories']
	], count($pids));
	$_products=[];
	if ($products){
		fn_gather_additional_products_data($products, array(
            'get_icon' => false,
            'get_detailed' => false,
            'get_additional' => false,
            'get_options' => true,
            'get_discounts' => true,
            'get_features' => false,
			'detailed_params'=>false,
			'get_taxed_prices'=>true
        ));
		
				
		foreach ($products as $product){
			if (Registry::get('settings.Appearance.show_prices_taxed_clean')=="Y" && !empty($product['taxed_price'])){
				$product['price'] = $product['taxed_price'];	
			}						
			$_products[$product['product_id']]['product_id'] = $product['product_id'];
			$_products[$product['product_id']]['price'] = $product['price'];			
			if (!empty($product['discount'])){
				$_products[$product['product_id']]['list_price'] = !empty($product['original_price']) ? $product['original_price'] : $product['base_price'];					
			}elseif(!empty($product['list_discount'])){
				$_products[$product['product_id']]['list_price'] = $product['list_price'];	
			}			
			if (isset($_products[$product['product_id']]['list_price']) && $_products[$product['product_id']]['list_price'] <= $_products[$product['product_id']]['price']){
				unset($_products[$product['product_id']]['list_price']);
			}		
			ClsSearchProducts::_format_prices($_products[$product['product_id']], CART_SECONDARY_CURRENCY);			
		}			
	}	
	echo json_encode($_products);
	exit;		
}
