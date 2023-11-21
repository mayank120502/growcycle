<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			http://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
use Tygh\Registry;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
class ClsStopWords{
	public static function _get_stop_words($params, $items_per_page=20, $lang_code = DESCR_SL){
		 $default_params = [			
			'items_per_page'=> $items_per_page,
			'page'   => 1,
			'sort_by'=>'phrase',
			'sort_order'=>'asc'
		]; 
		$params = array_merge($default_params, $params);
		$sortings = array(
			'stop_id'=>'?:csc_live_search_stop_words.stop_id',
			'phrase'=>'?:csc_live_search_stop_words.phrase',		
			'timestamp'=>'?:csc_live_search_stop_words.timestamp',
			'lang_code'=>'?:csc_live_search_stop_words.lang_code',
			'status'=>'?:csc_live_search_stop_words.status',
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
			$condition .=db_quote(" AND (phrase LIKE ?l OR synonyms LIKE ?l)", "%".$params['q']."%", "%".$params['q']."%");
		}
		if (!empty($params['lang_code'])){
			$condition .=db_quote(" AND lang_code=?s", $params['lang_code']);
		}			
		
		$params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:csc_live_search_stop_words
		$join WHERE 1 $condition");
		
		$limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);		
		$sorting = db_sort($params, $sortings);	
		
		$stop_words = db_get_array("SELECT * FROM ?:csc_live_search_stop_words $join
			WHERE 1 $condition GROUP BY ?:csc_live_search_stop_words.stop_id $sorting $limit");
			
		foreach ($stop_words as &$stop_word){
			$stop_word['synonyms'] = json_decode($stop_word['synonyms'], true); 	
		}
		
		return array($stop_words, $params);
	}
	public static function _update_stop_word($stop_data, $stop_id=0){		
		$stop_data['synonyms'] = str_replace('array()', '', $stop_data['synonyms']);		
		$is_exist = db_get_field("SELECT stop_id FROM ?:csc_live_search_stop_words WHERE phrase LIKE ?l AND stop_id!=?i AND lang_code=?s", $stop_data['phrase'], $stop_id, $stop_data['lang_code']);
		if (!$is_exist){	
			if ($stop_id) {				
				db_query("UPDATE ?:csc_live_search_stop_words SET ?u WHERE stop_id=?i", $stop_data, $stop_id);
			}else{
				$stop_data['timestamp']=TIME;
				$stop_data['user_id']=$_SESSION['auth']['user_id'];
				$stop_id = db_query("INSERT INTO ?:csc_live_search_stop_words ?e", $stop_data);	
			}
		}else{
			fn_set_notification('E', __('warning'), __('cls.phrase_allready_exists', ['[phrase]'=>$stop_data['phrase']]));			
		}
		return $stop_id;
	}	
	public static function _delete_stop_word($stop_id){
		db_query("DELETE FROM ?:csc_live_search_stop_words WHERE stop_id=?i", $stop_id);		
		return true;
	}
	public static function _m_delete_stop_words($stop_ids=[]){
		db_query("DELETE FROM ?:csc_live_search_stop_words WHERE stop_id IN (?a)", $stop_ids);		
		return true;
	}
	public static function _get_stop_word_data($stop_id=0){
		$stop_data = db_get_row("SELECT * FROM ?:csc_live_search_stop_words WHERE stop_id=?i", $stop_id);		
		$stop_data['synonyms'] = json_decode($stop_data['synonyms'], true); 
		return $stop_data;
	}
	public static function _search_get_stop_words($phrase, $lang_code){
		$stop_words = db_get_field("SELECT synonyms FROM ?:csc_live_search_stop_words WHERE phrase LIKE ?l AND lang_code=?s", $phrase, $lang_code);
		if ($stop_words){
			return 	json_decode($stop_words, true); 
		}
		return [];
	}
}