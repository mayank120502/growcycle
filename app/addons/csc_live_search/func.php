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
require_once(DIR_ROOT . '/app/addons/csc_live_search/core/common/functions.php');
require_once(DIR_ROOT . '/app/addons/csc_live_search/core/common/ClsSearchProducts.php');
require_once(DIR_ROOT . '/app/addons/csc_live_search/core/common/ClsSearchSpeedup.php');
require_once(DIR_ROOT . '/app/addons/csc_live_search/core/common/ClsSynonyms.php');
require_once(DIR_ROOT . '/app/addons/csc_live_search/core/common/ClsStopWords.php');

function fn_cls_get_index_fields(){
	return [
		'variant'=>'product_feature_variant_descriptions',
		'variant_name'=>'product_option_variants_descriptions',	
		'product_code'=>'products',
		'product'=>'product_descriptions',
		//'search_words'=>'product_descriptions',
		'meta_keywords'=>'product_descriptions'
	];
}

function fn_cls_install(){
	$indexes_fields = fn_cls_get_index_fields();
	foreach ($indexes_fields as $field=>$table){
		$indexes = db_get_hash_array("SHOW INDEX FROM ?:{$table}", 'Column_name');	
		if (empty($indexes[$field])){			
			db_query("ALTER TABLE ?:{$table} ADD INDEX `cls_{$field}` (`{$field}`);");
		}
	}
	/* Speed-UP */
	for ($i = 0; $i < 10; $i++) {
		db_query("CREATE TABLE IF NOT EXISTS `?:csc_search_speedup_products_clusters_{$i}` (
			  `product_id` bigint(8) NOT NULL,
			  `cluster_id` mediumint(8) NOT NULL,
			  UNIQUE KEY `product_id_cluster_id` (`product_id`,`cluster_id`),
			  KEY `product_id` (`product_id`),
			  KEY `cluster_id` (`cluster_id`)
			) DEFAULT CHARSET=utf8");
	}
	if (!fn_cls_copy_init_file()){
		fn_set_notification('W', __('warning'), __('cls.installation_warning', ['[url]'=>fn_url('csc_live_search.settings')]));
	}
	/*Privilages*/
	if (version_compare(PRODUCT_VERSION, '4.10.1', '<')){
		db_query("REPLACE INTO ?:privileges (privilege, is_default, section_id) VALUES ('manage_csc_live_search', 'N', 'addons')");
		db_query("REPLACE INTO ?:privileges (privilege, is_default, section_id) VALUES ('view_csc_live_search', 'N', 'addons')");
	}else{
		db_query("REPLACE INTO ?:privileges (privilege, is_default, section_id, group_id, is_view) VALUES ('manage_csc_live_search', 'N', 'addons', 'csc_live_search', 'N')");
		db_query("REPLACE INTO ?:privileges (privilege, is_default, section_id, group_id, is_view) VALUES ('view_csc_live_search', 'N', 'addons', 'csc_live_search', 'Y')");		
	}
	fn_rm(DIR_ROOT."/var/cache");
}
function fn_cls_uninstall(){
	$indexes_fields = fn_cls_get_index_fields();
	foreach ($indexes_fields as $field=>$table){
		$indexes = db_get_hash_array("SHOW INDEX FROM ?:{$table}", 'Key_name');
		$indexes = array_keys($indexes);
		foreach ($indexes as $index_name){
			if (strpos($index_name, 'cls_')!==false){
				db_query("ALTER TABLE ?:{$table} DROP INDEX {$index_name}");	
			}	
		}
	}	
	/* Speed-UP */
	for ($i = 0; $i < 10; $i++) {
		db_query("DROP TABLE IF EXISTS `?:csc_search_speedup_products_clusters_{$i}`");
	}
	/*Privilages*/
	db_query("DELETE FROM ?:privileges WHERE privilege IN ('manage_csc_live_search', 'view_csc_live_search')");
	
}

function fn_cls_copy_init_file(){	
	$result = fn_copy(DIR_ROOT . '/app/addons/csc_live_search/core/install/cls.php', DIR_ROOT.'/cls.php');
	@chmod(DIR_ROOT.'/cls.php', 0755);
	return $result;
		
}

function fn_cls_get_init_file() {
	$file = DIR_ROOT . '/app/addons/csc_live_search/core/install/cls.php';
	if (file_exists($file)) {	  
	  if (ob_get_level()) {
		ob_end_clean();
	  }	 
	  header('Content-Description: File Transfer');
	  header('Content-Type: application/octet-stream');
	  header('Content-Disposition: attachment; filename=' . basename($file));
	  header('Content-Transfer-Encoding: binary');
	  header('Expires: 0');
	  header('Cache-Control: must-revalidate');
	  header('Pragma: public');
	  header('Content-Length: ' . filesize($file));	  
	  readfile($file);
	  exit;
	}
}


function fn_cls_check_installation(){	
	if (!file_exists(DIR_ROOT.'/cls.php')){		
		return false;
	}
	return true;		
}

function  fn_csc_live_search_get_route(&$req, $result, $area, $is_allowed_url){	
	if (!empty($req['rid'])){
		if (!empty($req['product_id'])){								
			$increase_popularity = db_get_field("SELECT value FROM ?:csc_live_search WHERE name=?s", 'increase_popularity');						
			db_query("REPLACE INTO ?:csc_live_search_q_products ?e", ['rid'=>$req['rid'], 'pid'=>$req['product_id']]);
			$qid = db_get_field("SELECT qid FROM ?:csc_live_search_q_requests WHERE rid=?i", $req['rid']);
			//fn_print_die($req['rid']);			
			if ($increase_popularity=="Y" && $qid){
				$popularity = db_get_field("SELECT popularity FROM ?:csc_live_search_popularity WHERE product_id=?i AND qid=?i", $req['product_id'], $qid);
				
				if (is_numeric($popularity)){				
					db_query("UPDATE ?:csc_live_search_popularity SET popularity=?i WHERE product_id=?i AND qid=?i", $popularity + 1, $req['product_id'], $qid);				
				}else{
					$popularity = array('product_id'=>$req['product_id'], 'qid'=>$qid, 'popularity'=>1);
					db_query("INSERT INTO ?:csc_live_search_popularity ?e", $popularity);
				}				
			}
		}		
		unset($req['rid']);
	}
}

function fn_cls_get_settings(){
	return CscLiveSearch::_get_option_values();
}
function fn_csc_live_search_get_products_pre(&$params, $items_per_page, $lang_code){	
	$addon= CscLiveSearch::_get_option_values();
	if (!empty($params['q']) && (AREA=="C" || $addon['clss_admin_status'])){		
		$params['cls_q']=$params['q'];
		unset($params['q']);		
		if (empty($_REQUEST['sort_by'])){		
			list($params['sort_by'], $params['sort_order']) = explode('|', $addon['sort_by']);			
		}
		if (!empty($params['sort_order'])){
			$params['sort_order'] = str_replace(['descasc', 'ascdesc'], ['desc', 'asc'], $params['sort_order']);	
		}			
	}
}

function fn_csc_live_search_get_products_before_select($params, &$join, &$condition, $u_condition, $inventory_join_cond, $sortings, $total, $items_per_page, $lang_code, $having){	
}

function fn_csc_live_search_get_products(&$params, &$fields, &$sortings, &$condition, &$join, &$sorting, $group_by, $lang_code, $having){
	
	$sortings["ls_popularity"] = "?:csc_live_search_popularity.popularity";
	$sortings["clicks"] = "clsClicks";
	$sortings["phrases"] = "clsPhrases";
	if ($params['sort_by']=="ls_popularity"){			
		$join .= db_quote(" LEFT JOIN ?:csc_live_search_popularity ON ?:csc_live_search_popularity.product_id=products.product_id ");
	}	
	
	if (!empty($params['cls_clicked_products'])){
		$join_cond ='';
		if (!empty($params['lang_code'])){
			$join_cond = db_quote(" AND clsqr.lang_code=?s", $params['lang_code']);	
		}
		$join .=db_quote(" INNER JOIN ?:csc_live_search_q_products as clsqp ON products.product_id=clsqp.pid
			LEFT JOIN ?:csc_live_search_q_requests as clsqr ON clsqr.rid=clsqp.rid $join_cond 			
		");
		if (!empty($params['qid'])){
			$condition .=db_quote(" AND clsqr.qid=?i", $params['qid']);
		}
		if (!empty($params['cls_uid'])){
			$condition .=db_quote(" AND clsqr.user_id=?i", $params['cls_uid']);
		}		
		$fields[]="COUNT(DISTINCT(clsqp.rid)) as clsClicks";
		$fields[]="COUNT(DISTINCT(clsqr.qid)) as clsPhrases";		
	}
	
	if (!empty($params['cls_q'])){		
		$runtime_company_id = !empty($params['runtime_company_id']) ? $params['runtime_company_id'] : Registry::get('runtime.company_id');
		$params['q'] = $params['cls_q'];
		$params['lang_code'] = $lang_code;
		$params['runtime_uid'] = !empty($_SESSION['auth']['user_id']) ? $_SESSION['auth']['user_id'] : 0;
		$ls_settings= CscLiveSearch::_get_option_values();		
		
		list($params['rid'], $params['qid']) = ClsSearchProducts::_save_search_statistic($params, $runtime_company_id, $ls_settings);
		
		if (Registry::get('addons.warehouses.status')=="A"){			
			$params['warehouses_destination_id'] = fn_cls_get_destination_id_by_product_params(array());					
		}		
		$sortings = ClsSearchProducts::_get_sortings($params);
				
		if (($params['sort_by']=="cls_rel_pop" || $params['sort_by']=="cls_rel") && !empty($params['qid'])){
			$fields[]='lsp.popularity';
		}		
		if (AREA=="A" && $ls_settings['clss_admin_status']){
			$ls_settings['clss_status']=true;	
		}	
		
		if ($ls_settings['clss_status'] && $ls_settings['speedup_level']=='hard'){					
			list($_join, $_condition) = ClsSearchSpeedup::_get_search_conditions($params['q'], $ls_settings['speedup_cluster_size'], $ls_settings);
			$join .= $_join;
			$condition .= $_condition;			
		}		
		$join = ClsSearchProducts::_get_joins($params, $ls_settings, $runtime_company_id, $join);			
		$condition = ClsSearchProducts::_get_conditions($params, $ls_settings, $condition);		
	}
}


function fn_csc_live_search_get_users($params, &$fields, &$sortings, &$condition, &$join, $auth){	
	if (!empty($params['cls_clicks'])){
		$fields[]="COUNT(DISTINCT(clsqp.rid)) as clsClicks";
		$fields[]="COUNT(DISTINCT(clsqr.qid)) as clsPhrases";
		$fields[]="clsqr.timestamp as lastActivity";
		
		$sortings["clicks"] = "clsClicks";
		$sortings["phrases"] = "clsPhrases";
		$sortings["lastActivity"] = "lastActivity";
		$join .=db_quote(" INNER JOIN ?:csc_live_search_q_requests as clsqr ON clsqr.user_id=?:users.user_id
			LEFT JOIN ?:csc_live_search_q_products as clsqp ON clsqr.rid=clsqp.rid			
		");
		
		$data = array();
		if (!empty($params['period']) && $params['period'] != 'A') {
			list($data['time_from'], $data['time_to']) = fn_create_periods($params);
		} else {
		   $data['time_from'] =$data['time_to'] = 0;
		}
		
		if (!empty($data['time_from'])){
			$condition[]=db_quote(" AND clsqr.timestamp > ?i", $data['time_from']);
		}
		if (!empty($data['time_to'])){
			$condition[]=db_quote(" AND clsqr.timestamp < ?i", $data['time_to']);
		}
		
		if (!empty($params['q'])){
			$join .=db_quote(" LEFT JOIN ?:csc_live_search_q_base as clsqb ON clsqr.qid=clsqb.qid");
			$condition[]=db_quote(" AND clsqb.q LIKE ?l", "%{$params['q']}%");
		}
	}
	
}

function fn_csc_live_search_login_user_post($user_id, $cu_id, $udata, $auth, $condition, $result){
	if ($result == LOGIN_STATUS_OK && !empty($auth['user_id'])){
		 $ip = fn_get_ip();
		 db_query("UPDATE ?:csc_live_search_q_requests SET user_id=?i WHERE user_ip=?s AND user_id=?i AND timestamp > ?i", 
		 	$auth['user_id'], $ip['host'], 0, (TIME - 3600*12)
		);
	}
}


function fn_csc_ls_get_wishlist_products(){
	$products = [];	
	if (!empty($_SESSION['wishlist']['products'])){
		foreach ($_SESSION['wishlist']['products'] as $product){				
			$products[$product['product_id']]=1;
		}	
	}
	
	return json_encode($products);
}
function fn_csc_ls_get_cart_products(){	
	$products = [];
	if (!empty($_SESSION['cart']['products'])){
		foreach ($_SESSION['cart']['products'] as $product){
			$products[$product['product_id']]=1;
		}
	}
	return json_encode($products);
}

function fn_csc_ls_get_comparison_list(){	
	$products = [];
	if (!empty($_SESSION['comparison_list'])){		
		foreach ($_SESSION['comparison_list'] as $pid){
			$products[$pid]=1;
		}
	}
	return json_encode($products);
}
function fn_cls_speedup_exim_by_product_id($ids){	
	if (!defined('CSS_SKIP_INDEXATION')){
		foreach($ids as $product){
			ClsSearchSpeedup::_scan_single_product($product['product_id']);
		}
	}
}

function fn_csc_live_search_update_product_post($product_data, $product_id, $lang_code, $create){	
	if (!defined('CSS_SKIP_INDEXATION')){
		 ClsSearchSpeedup::_scan_single_product($product_id);
	}
}
function fn_get_cls_url(){	
	if (defined('HTTPS')){
		$http = fn_csc_check_http_location(Registry::get('config.https_host'), Registry::get('config.https_path'), 'https');			
	}else{
		$http = fn_csc_check_http_location(Registry::get('config.http_host'), Registry::get('config.http_path'), 'http');	
	}	
	return $http.'/cls.php';
}

function fn_csc_check_http_location($host, $path='', $http){
	if (!empty(Registry::get("config.origin_{$http}_location"))){
		$http_location = Registry::get("config.origin_{$http}_location");
		$http_location = str_replace($http.'://', '', $http_location);			
		$host = $host.strstr($http_location, '/');
		$path='';
	}		
	return $http.'://'.$host.$path;	
}

function fn_cls_get_destination_id_by_product_params($params=[]){
	return fn_warehouses_get_destination_id_by_product_params($params);
}

function fn_cls_is_active_promotions(){
	list($promotions, ) =fn_get_promotions([
		'get_hidden'=>true,
		'active'=>true,
		'zone'=>'catalog'
	], 1);
	$tax = false;
	if (Registry::get('settings.Appearance.show_prices_taxed_clean')=="Y"){	
		$tax = db_get_field("SELECT a.tax_id FROM ?:taxes as a WHERE a.price_includes_tax=?s", 'N');
	}
	$currency = false;
	if (Registry::get('addons.csc_product_currency.status')=="A"){
		$currency = true;
	}	 
	return ($promotions || $tax || $currency) ? 'Y' : 'N';	
}
