<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			http://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
use Tygh\Registry;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
class ClsSynonyms{
	public static function _get_synonyms($params, $items_per_page=20, $lang_code = DESCR_SL){
		 $default_params = [			
			'items_per_page'=> $items_per_page,
			'page'   => 1,
			'sort_by'=>'phrase',
			'sort_order'=>'asc'
		]; 
		$params = array_merge($default_params, $params);
		$sortings = array(
			'synonym_id'=>'?:csc_live_search_synonyms.synonym_id',
			'phrase'=>'?:csc_live_search_synonyms.phrase',		
			'timestamp'=>'?:csc_live_search_synonyms.timestamp',
			'lang_code'=>'?:csc_live_search_synonyms.lang_code',
			'status'=>'?:csc_live_search_synonyms.status',
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
		
		$params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:csc_live_search_synonyms
		$join WHERE 1 $condition");
		
		$limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);		
		$sorting = db_sort($params, $sortings);	
		
		$synonyms = db_get_array("SELECT * FROM ?:csc_live_search_synonyms $join
			WHERE 1 $condition GROUP BY ?:csc_live_search_synonyms.synonym_id $sorting $limit");
			
		foreach ($synonyms as &$synonym){
			$synonym['synonyms'] = json_decode($synonym['synonyms'], true); 	
		}	
		
		return array($synonyms, $params);
	}
	public static function _update_synonym($synonym_data, $synonym_id=0){
		$synonym_data['synonyms'] = str_replace('array()', '', $synonym_data['synonyms']);
		$is_exist = db_get_field("SELECT synonym_id FROM ?:csc_live_search_synonyms WHERE phrase LIKE ?l AND synonym_id!=?i AND lang_code=?s", $synonym_data['phrase'], $synonym_id, $synonym_data['lang_code']);
		
		if (!$is_exist){	
			if ($synonym_id) {				
				db_query("UPDATE ?:csc_live_search_synonyms SET ?u WHERE synonym_id=?i", $synonym_data, $synonym_id);
			}else{
				$synonym_data['timestamp']=TIME;
				$synonym_data['user_id']=$_SESSION['auth']['user_id'];
				$synonym_id = db_query("INSERT INTO ?:csc_live_search_synonyms ?e", $synonym_data);	
			}
		}else{
			fn_set_notification('E', __('warning'), __('cls.phrase_allready_exists', ['[phrase]'=>$synonym_data['phrase']]));		
		}
		return $synonym_id;
	}	
	public static function _delete_synonym($synonym_id){
		db_query("DELETE FROM ?:csc_live_search_synonyms WHERE synonym_id=?i", $synonym_id);		
		return true;
	}
	public static function _m_delete_synonyms($synonym_ids=[]){
		db_query("DELETE FROM ?:csc_live_search_synonyms WHERE synonym_id IN (?a)", $synonym_ids);		
		return true;
	}
	public static function _get_synonym_data($synonym_id=0){
		$synonym_data = db_get_row("SELECT * FROM ?:csc_live_search_synonyms WHERE synonym_id=?i", $synonym_id);		
		$synonym_data['synonyms'] = json_decode($synonym_data['synonyms'], true); 
		return $synonym_data;
	}	
	public static function _get_search_synonyms($q, $ls_settings, $params){		
		static $synonyms;	
		if (!empty($ls_settings['use_synonyms'])){		
			if (!isset($synonyms[$q])){	
				$q = trim(db_quote("?s", $q), "'");
				if ($ls_settings['syn_partial_match']){				
					$condition = db_quote(" AND synonyms LIKE '%\"{$q}%'");
				}else{
					$condition = db_quote(" AND synonyms LIKE '%\"{$q}\"%'");
				}			
				$synonyms[$q] = db_get_fields("SELECT phrase FROM ?:csc_live_search_synonyms WHERE lang_code=?s AND status=?s $condition", $params['lang_code'], 'A');
			}
			return $synonyms[$q];			
		}
		return [];		
	}	
}