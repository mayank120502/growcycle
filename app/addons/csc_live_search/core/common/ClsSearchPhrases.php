<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			http://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
use Tygh\Registry;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
class ClsSearchPhrases{
	public static function _get_search_phrases($params, $items_per_page=20, $lang_code = DESCR_SL){
		 $default_params = [			
			'items_per_page'=> $items_per_page,
			'page'   => 1,
			'sort_by'=>'phrase',
			'sort_order'=>'asc'
		]; 
		$params = array_merge($default_params, $params);
		$sortings = array(
			'phrase_id'=>'?:csc_live_search_phrases.phrase_id',
			'phrase'=>'?:csc_live_search_phrases.phrase',		
			'timestamp'=>'?:csc_live_search_phrases.timestamp',
			'lang_code'=>'?:csc_live_search_phrases.lang_code',
			'status'=>'?:csc_live_search_phrases.status',
		);
		$data = array();
		if (!empty($params['period']) && $params['period'] != 'A') {
			list($data['time_from'], $data['time_to']) = fn_create_periods($params);
		} else {
		   $data['time_from'] =$data['time_to'] = 0;
		}		
		$condition=$join="";
		
		if (Registry::get('runtime.company_id')){
			$condition .=db_quote(" AND company_id = ?i", Registry::get('runtime.company_id'));	
		}	
		if (!empty($data['time_from'])){
			$condition .=db_quote(" AND timestamp > ?i", $data['time_from']);
		}
		if (!empty($data['time_to'])){
			$condition .=db_quote(" AND timestamp < ?i", $data['time_to']);
		}
		
		if (!empty($params['q'])){
			$condition .=db_quote(" AND (phrase LIKE ?l OR search_phrases LIKE ?l)", "%".$params['q']."%", "%".$params['q']."%");
		}
		if (!empty($params['lang_code'])){
			$condition .=db_quote(" AND lang_code=?s", $params['lang_code']);
		}			
		
		$params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:csc_live_search_phrases
		$join WHERE 1 $condition");
		
		$limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);		
		$sorting = db_sort($params, $sortings);	
		
		$search_phrases = db_get_array("SELECT * FROM ?:csc_live_search_phrases $join
			WHERE 1 $condition GROUP BY ?:csc_live_search_phrases.phrase_id $sorting $limit");
		return array($search_phrases, $params);
	}
	public static function _update_phrase($phrase_data, $phrase_id=0){	
		//fn_print_die($phrase_data);
		if (empty($phrase_data['product_ids'])){
			$phrase_data['product_ids']=[];	
		}
		asort($phrase_data['product_ids']);
		$phrase_data['product_ids'] =implode(',', array_keys($phrase_data['product_ids']));
		
		$is_exist = db_get_field("SELECT phrase_id FROM ?:csc_live_search_phrases WHERE phrase LIKE ?l AND phrase_id!=?i AND lang_code=?s", $phrase_data['phrase'], $phrase_id, $phrase_data['lang_code']);
		
		if (!$is_exist){		
			if ($phrase_id) {				
				db_query("UPDATE ?:csc_live_search_phrases SET ?u WHERE phrase_id=?i", $phrase_data, $phrase_id);
			}else{
				$phrase_data['timestamp']=TIME;
				$phrase_data['user_id']=$_SESSION['auth']['user_id'];
				$phrase_id = db_query("INSERT INTO ?:csc_live_search_phrases ?e", $phrase_data);	
			}
		}else{
			fn_set_notification('E', __('warning'), __('cls.phrase_allready_exists', ['[phrase]'=>$phrase_data['phrase']]));			
		}
		return $phrase_id;
	}	
	public static function _delete_search_phrase($phrase_id){
		db_query("DELETE FROM ?:csc_live_search_phrases WHERE phrase_id=?i", $phrase_id);		
		return true;
	}
	public static function _m_delete_phrases($phrase_ids=[]){
		db_query("DELETE FROM ?:csc_live_search_phrases WHERE phrase_id IN (?a)", $phrase_ids);		
		return true;
	}
	public static function _get_search_phrase_data($phrase_id=0){
		$phrase_data = db_get_row("SELECT * FROM ?:csc_live_search_phrases WHERE phrase_id=?i", $phrase_id);
		return $phrase_data;
	}
	
	public static function _get_phrases_for_search($phrase, $lang_code){
		$phrases = db_get_array("SELECT phrase as q FROM ?:csc_live_search_phrases WHERE phrase LIKE ?l AND phrase NOT LIKE ?l AND lang_code=?s LIMIT 10", $phrase.'%', $phrase, $lang_code);
		return $phrases;
	}
	
	public static function _get_featured_products($phrase, $lang_code){
		$product_ids = db_get_field("SELECT product_ids FROM ?:csc_live_search_phrases WHERE phrase LIKE ?l AND lang_code=?s", $phrase, $lang_code);
		if ($product_ids){
			return explode(',', $product_ids);
		}
		return false;
	}	
		
}