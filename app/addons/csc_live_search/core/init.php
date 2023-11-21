<?php
use Tygh\CscLiveSearch;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
require_once(DIR_ROOT."/app/addons/csc_live_search/core/config.php");
$params = $_REQUEST;
$addons = fn_cls_get_active_addons();

if (!empty($params['mode']) && $params['mode']=="security"){
	header("Cache-Control:max-age=3600");
	$cname = 'cls'.$params['runtime_storefront_id'].$params['runtime_company_id'];	
	if (empty($_COOKIE[$cname])){
		$hash=md5(microtime());
	}else{
		$hash=$_COOKIE[$cname];	
	}
	setcookie($cname, $hash, TIME + SESSION_ALIVE_TIME, '/');	
	$val = md5($hash.$_SERVER['HTTP_HOST'].(SESSION_ALIVE_TIME * 2));
	echo $val;
	exit;
}


$company_id = fn_cls_get_current_company_id($params);
define('CLS_RUNTIME_COMPANY_ID', $company_id);
define('CLS_RUNTIME_STOREFRONT_ID', !empty($params['runtime_storefront_id']) ? $params['runtime_storefront_id'] : 0);
$ls_settings = CscLiveSearch::_get_option_values(true, $company_id);

if (!fn_cls_validate_request($params, $ls_settings)){
	header('HTTP/1.0 403 Forbidden');
	echo json_encode(['error'=>'CSRF Attack detected! Please make sure you have enabled cookies on your internet browser in order to stop receiving error.']);	
	exit;
}
if (!in_array('csc_live_search', $addons)){
	header('HTTP/1.0 403 Forbidden');
	echo json_encode(['error'=>'Live search addon is disabled']);	
	exit;	
}

$def_settings = [
	'page'=>1,
	'cid'=>0
];
$params = array_merge($def_settings, $params);

$products = $products_categories= $categories = $storefront_categories = $brands = $vendors = $blogs = $pages = $corrections = $phrases = $featured_products = [];

if (PRODUCT_EDITION=="MULTIVENDOR" && !empty($params['company_id'])){
	$is_vendor_search = true;
}else{
	$is_vendor_search = false;
}
if (!empty($params['q']) && mb_strlen($params['q']) >= $ls_settings['characters_limit']){
	if ($ls_settings['search_products']=="Y"){	
		list($products, $search) = ClsSearchProducts::_get_products($params, $ls_settings['products_per_page']);		
	}else{
		list($products, $search) = ClsSearchProducts::_get_products($params, 0);		
	}			
	if ($products && $ls_settings['suggest_products_categories']=="Y" && $params['page']==1 && empty($params['category_id'])){		
		$_params = $params;
		$_params['group_by'] = 'categories';
		$_params['current_cid']=0;		
		if (!empty($_params['cid'])){
			$_params['current_cid']	 = $_params['cid'];
			unset($_params['cid']);
		}
		list($products_categories, ) = ClsSearchProducts::_get_products($_params, $ls_settings['products_per_page']);		
	}			
	if (!$products && $ls_settings['suggest_corrections']=="Y"){
		$corrections = ClsYandexSpeller::_get($params['q'], CART_LANGUAGE);	
	}	
	if (empty($params['cid']) && $params['page']==1 && !$is_vendor_search){	
		
		if ($ls_settings['search_categories']=="Y"){	
			$categories = ClsSearchCategories::_get_categories($params);			
		}		
		if ($company_id && $ls_settings['search_storefront_categories']=="Y"){				
			$storefront_categories = ClsSearchCategories::_get_storefront_categories($params);
		}
		if ($ls_settings['search_brands']=="Y" && $ls_settings["brands_feature_id"]){
			$brands = ClsSearchBrands::_get_brands($params);
		}
		if ($ls_settings['search_vendors']=="Y" && !$company_id){			
			$vendors = ClsSearchVendors::_get_vendors($params);
		}
		if ($ls_settings['search_blog']=="Y" || $ls_settings['search_pages']=="Y"){	
			$types=[];
			if ($ls_settings['search_blog']=="Y"){
				$types[]='B';	
			}
			if ($ls_settings['search_pages']=="Y"){
				$types[]='T';
				$types[]='F';
				$types[]='l'; 		
			}
			$pages = ClsSearchPages::_get_pages($params, $types);
		}
	}
}else{
	$search = $params;	
}
if(!empty($params['q']) && $ls_settings['suggest_phrases'] && empty($params['cid']) ){
	$phrases = ClsSearchPhrases::_get_phrases_for_search($params['q'], $params['lang_code']);
}
if(!empty($params['q']) && $ls_settings['show_phrases_rec_products'] && !$is_vendor_search && empty($params['cid'])){
	$pids = ClsSearchPhrases::_get_featured_products($params['q'], $params['lang_code']);
	if (!empty($pids)){
		$_params=$params;
		unset($_params['q']);
		$_params['pids'] = $pids;
		list($featured_products, $_search) = ClsSearchProducts::_get_products($_params, 10);
	}
}
if ($ls_settings['show_price']=="A" && !empty($search['runtime_uid'])){
	$ls_settings['show_price']='Y';
}
if ($ls_settings['show_cart']=="A" && !empty($search['runtime_uid'])){
	$ls_settings['show_cart']='Y';	
}
$response = [
	'items'=>$products,
	'products_categories'=>$products_categories, 
	'categories'=>$categories, 
	'search'=>!empty($search) ? $search : [], 
	'storefront_categories'=>$storefront_categories,
	'brands'=>$brands,
	'vendors'=>$vendors,
	'pages'=>$pages,
	'settings'=>$ls_settings,
	'corrections'=>$corrections,
	'phrases'=>$phrases,
	'featured_products'=>$featured_products
];
	
fn_cls_hook_function('hooks_before_response', $ls_settings, $company_id, $params,  $response);

echo json_encode($response);
die;