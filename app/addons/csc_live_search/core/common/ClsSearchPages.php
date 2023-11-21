<?php
use Tygh\CscLiveSearch;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
class ClsSearchPages{	
	public static function _get_pages($params, $types=['B']){		
		$pages=[];
		$company_id = fn_cls_get_current_company_id($params);			
		$ls_settings = CscLiveSearch::_get_option_values(false, $company_id);
		$limit='';
		if ($ls_settings['pb_limit']){
			$limit="LIMIT {$ls_settings['pb_limit']}";
		}
		$join = db_quote(" LEFT JOIN ?:page_descriptions ON ?:page_descriptions.page_id=?:pages.page_id ");
		$condition = db_quote(" AND ?:pages.status=?s AND ?:pages.page_type IN (?a) AND ?:page_descriptions.lang_code=?s", 'A', $types, $params['lang_code']);	
		
		if ($company_id) {
			$condition .=" AND ?:pages.company_id=$company_id";
		}		
		
		$phrase_condition = [db_quote("?:page_descriptions.page LIKE ?l", "%$params[q]%")];		
		
		
		fn_cls_hook_function('hooks_get_pages', $ls_settings, $company_id, $params, $join, $condition, $phrase_condition, $limit);
		$condition .=' AND ('.implode(' OR ', $phrase_condition).')';
								
		$pages=db_get_array("SELECT ?:page_descriptions.page, ?:page_descriptions.page_id  
		FROM  ?:pages 
		$join
		WHERE 1 $condition $limit");			
		return $pages;
	}
}