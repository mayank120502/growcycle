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

class ClsHistory{
	public static function _get_per_request($params, $items_per_page=20){
		$ls_settings = CscLiveSearch::_get_option_values();		
		 $default_params = [			
			'items_per_page'=> $items_per_page,
			'page'   => 1,
			'sort_by'=>'rid',
			'sort_order'=>'desc'
		]; 
		$params = array_merge($default_params, $params);
		$sortings = array(
			'rid'=>'?:csc_live_search_q_requests.rid',
			'search_word'=>'?:csc_live_search_q_base.q',
			'timestamp'=>'?:csc_live_search_q_requests.timestamp',
			'ip'=>'?:csc_live_search_q_requests.user_ip',
			'clicks'=>'count',
			'found_products'=>'found_products',
			'lang_code'=>'?:csc_live_search_q_requests.lang_code',
		);
		
		$data = array();
		if (!empty($params['period']) && $params['period'] != 'A') {
			list($data['time_from'], $data['time_to']) = fn_create_periods($params);
		} else {
		   $data['time_from'] =$data['time_to'] = 0;
		}		
		$condition=$join="";
		if (!empty($data['time_from'])){
			$condition .=db_quote(" AND timestamp>?i", $data['time_from']);
		}
		if (!empty($data['time_to'])){
			$condition .=db_quote(" AND timestamp < ?i", $data['time_to']);
		}
		if (!empty($params['company_id'])){
			$condition .=db_quote(" AND ?:csc_live_search_q_requests.company_id =?i", $params['company_id']);
		}
		
		if (!empty($params['qid'])){
			$condition .=db_quote(" AND ?:csc_live_search_q_requests.qid =?i", $params['qid']);
		}
		if (!empty($params['q'])){
			$condition .=db_quote(" AND (q LIKE ?l OR q LIKE ?l)", $params['q']."%", "% ".$params['q']."%");
		}
		if (!empty($params['ip'])){
			$condition .=db_quote(" AND user_ip LIKE ?l", $params['ip']."%");
		}
		if (!empty($params['lang_code'])){
			$condition .=db_quote(" AND ?:csc_live_search_q_requests.lang_code = ?s", $params['lang_code']);
		}
		if (!empty($params['pid'])){
			$condition .=db_quote(" AND ?:csc_live_search_q_products.pid = ?i", $params['pid']);
		}
		if (!empty($params['user_id'])){
			$condition .=db_quote(" AND ?:csc_live_search_q_requests.user_id = ?i", $params['user_id']);
		}
		
		
		  	 		
		$join .= " LEFT JOIN ?:csc_live_search_q_base ON 
			?:csc_live_search_q_base.qid=?:csc_live_search_q_requests.qid
			LEFT JOIN ?:csc_live_search_q_products ON
			?:csc_live_search_q_products.rid=?:csc_live_search_q_requests.rid";	
		
			
			
		if (fn_allowed_for('MULTIVENDOR') && Registry::get('runtime.company_id') && $ls_settings['vendor_history_access']!='A'){			
			$join .=db_quote(" LEFT JOIN ?:products ON ?:products.product_id=?:csc_live_search_q_products.pid");			
			$condition .=db_quote(" AND ?:products.company_id = ?i", Registry::get('runtime.company_id'));	
		}
		
		$params['total_items'] = db_get_field("SELECT COUNT(DISTINCT ?:csc_live_search_q_requests.rid) FROM ?:csc_live_search_q_requests $join WHERE 1 $condition");
		$limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
		$sorting = db_sort($params, $sortings);	
		$history = db_get_array("SELECT ?:csc_live_search_q_requests.*, ?:csc_live_search_q_base.*, ?:csc_live_search_q_requests.user_ip as user_ip,  COUNT(?:csc_live_search_q_products.pid) as count, GROUP_CONCAT(DISTINCT(?:csc_live_search_q_products.pid) SEPARATOR ',') as pids FROM ?:csc_live_search_q_requests
		$join
		WHERE 1 $condition GROUP BY ?:csc_live_search_q_requests.rid $sorting $limit");		
		
		return array($history, $params);
	}
	
	public static function _get_per_word($params, $items_per_page=20){
		$ls_settings = CscLiveSearch::_get_option_values();		
		$default_params = [			
			'items_per_page'=> $items_per_page,
			'page'   => 1,
			'sort_by'=>'qid',
			'sort_order'=>'desc'
		]; 
		$params = array_merge($default_params, $params);
		$sortings = array(
			'qid'=>'?:csc_live_search_q_base.qid',
			'q'=>'?:csc_live_search_q_base.q',		
			'count'=>'count_requests',
			'clicks'=>'count_products',
			'lang_code'=>'?:csc_live_search_q_base.lang_code',
		);	
		$condition = $join = "";
		
		$data = array();
		if (!empty($params['period']) && $params['period'] != 'A') {
			list($data['time_from'], $data['time_to']) = fn_create_periods($params);
		} else {
		   $data['time_from'] =$data['time_to'] = 0;
		}		
		$condition=$join="";		
		if (!empty($data['time_from'])){
			$condition .=db_quote(" AND timestamp>?i", $data['time_from']);
		}
		if (!empty($data['time_to'])){
			$condition .=db_quote(" AND timestamp < ?i", $data['time_to']);
		}
		if (!empty($params['q'])){
			$condition .=db_quote(" AND (q LIKE ?l OR q LIKE ?l)", $params['q']."%", "% ".$params['q']."%");
		}
		if (!empty($params['company_id'])){
			$condition .=db_quote(" AND ?:csc_live_search_q_base.company_id =?i", $params['company_id']);
		}
		if (!empty($params['pid'])){
			$condition .=db_quote(" AND ?:csc_live_search_q_products.pid =?i", $params['pid']);
		}
		if (!empty($params['user_id'])){
			$condition .=db_quote(" AND ?:csc_live_search_q_requests.user_id =?i", $params['user_id']);
		}
				
		$join = db_quote(" LEFT JOIN ?:csc_live_search_q_requests ON ?:csc_live_search_q_base.qid=?:csc_live_search_q_requests.qid 
			LEFT JOIN ?:csc_live_search_q_products ON ?:csc_live_search_q_products.rid=?:csc_live_search_q_requests.rid");
			
		if (fn_allowed_for('MULTIVENDOR') && Registry::get('runtime.company_id') && $ls_settings['vendor_history_access']!='A'){			
			$join .=db_quote(" LEFT JOIN ?:products ON ?:products.product_id=?:csc_live_search_q_products.pid");			
			$condition .=db_quote(" AND ?:products.company_id = ?i", Registry::get('runtime.company_id'));	
		}	
		
		$params['total_items'] = db_get_field("SELECT COUNT(?:csc_live_search_q_base.qid) FROM ?:csc_live_search_q_base $join WHERE 1 $condition GROUP BY ?:csc_live_search_q_base.qid");		
		$limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
		$sorting = db_sort($params, $sortings);	
		$history = db_get_array("SELECT ?:csc_live_search_q_base.*, COUNT(?:csc_live_search_q_products.pid) as count_products,
			COUNT(DISTINCT ?:csc_live_search_q_requests.rid) as count_requests
			FROM ?:csc_live_search_q_base
			$join
			WHERE 1 $condition GROUP BY ?:csc_live_search_q_base.qid $sorting $limit");
		
		return array($history, $params);
	}
	
	public static function _get_per_product($params, $items_per_page=50){
		$ls_settings = CscLiveSearch::_get_option_values();		
		$default_params = [			
			'items_per_page'=> $items_per_page,
			'page'   => 1,
			'sort_by'=>'ls_popularity',
			'sort_order'=>'desc',
			'cls_clicked_products'=>true
		]; 
		$params = array_merge($default_params, $params);		
		
		list($products, $search) = fn_get_products($params, 50);
				
		return array($products, $search);
	}
	public static function _get_per_user($params, $auth, $items_per_page=50){
		$ls_settings = CscLiveSearch::_get_option_values();		
		 $default_params = [			
			'items_per_page'=> $items_per_page,
			'page'   => 1,
			'sort_by'=>'lastActivity',
			'sort_order'=>'desc',
			'cls_clicks'=>true
		];  
		$params = array_merge($default_params, $params);		
		list($users, $search) = fn_get_users($params, $auth, 50);				
		return array($users, $search);
	}
		
		
}