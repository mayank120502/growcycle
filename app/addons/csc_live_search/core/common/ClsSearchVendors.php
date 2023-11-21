<?php
use Tygh\CscLiveSearch;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
class ClsSearchVendors{	
	public static function _get_vendors($params){		
		$vendors=[];
		$company_id = fn_cls_get_current_company_id($params);			
		$ls_settings = CscLiveSearch::_get_option_values(true, $company_id);

		$limit='';
		if ($ls_settings['vendors_limit']){
			$limit="LIMIT {$ls_settings['vendors_limit']}";
		}
		$join='';
		$condition = db_quote(" AND ?:companies.status=?s", 'A');
		
		if (version_compare(PRODUCT_VERSION, '4.9.3', '>') && !empty($params['runtime_storefront_id'])){
			$company_ids = fn_cls_get_storefront_company_ids($params['runtime_storefront_id']);
			if ($company_ids){			
				$condition .= db_quote(' AND ?:companies.company_id IN (?a)', $company_ids);
			}
		}		
		
		$phrase_condition = [db_quote("?:companies.company LIKE ?l", "%$params[q]%")];
		fn_cls_hook_function('hooks_get_vendors', $ls_settings, $company_id, $params, $join, $condition, $phrase_condition, $limit);
		$condition .=' AND ('.implode(' OR ', $phrase_condition).')';
		$vendors=db_get_array("SELECT company_id, company 
			FROM ?:companies 
			$join
			WHERE 1 $condition $limit");	
					
		return $vendors;
	}
}