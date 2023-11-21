<?php
use Tygh\CscLiveSearch;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
class ClsSearchBrands{	
	public static function _get_brands($params){		
		$brands=[];
		$company_id = fn_cls_get_current_company_id($params);	
		$ls_settings = CscLiveSearch::_get_option_values(true, $company_id);
		$fields=[
			'v_desc.variant',
			'v_desc.variant_id',
			'f.feature_id '
		];
		
		$sorting = ' ORDER BY v_desc.variant ASC';
		
		$join = "LEFT JOIN ?:product_feature_variants as variants ON variants.variant_id=v_desc.variant_id 
			LEFT JOIN ?:product_features as f ON f.feature_id=variants.feature_id ";
		
		$condition = db_quote("
			AND f.feature_id=?i			
			AND v_desc.lang_code=?s 
			AND v_desc.variant LIKE ?l", $ls_settings['brands_feature_id'], $params['lang_code'], "%$params[q]%");
		$phrase_condition = [db_quote("v_desc.variant LIKE ?l", "%$params[q]%")];
				
		if ($company_id){
			$join .=" LEFT JOIN ?:ult_objects_sharing ON ?:ult_objects_sharing.share_object_id=f.feature_id AND ?:ult_objects_sharing.share_object_type='product_features'";
			$condition .=" AND (f.company_id=$company_id OR ?:ult_objects_sharing.share_company_id=$company_id)";
		}
		$limit='';	
		if ($ls_settings['brands_limit']){
			$limit="LIMIT {$ls_settings['brands_limit']}";
		}				
		fn_cls_hook_function('hooks_get_brands', $ls_settings, $company_id, $params, $fields, $join, $condition, $phrase_condition, $sorting, $limit);		
		$condition .=' AND ('.implode(' OR ', $phrase_condition).')';
		
		$brands=db_get_array("SELECT " . implode(', ', $fields) . "
			FROM ?:product_feature_variant_descriptions as v_desc 
			$join			
			WHERE 1 
			$condition
			GROUP BY v_desc.variant_id 
			$sorting
			$limit");
		return $brands;
	}	
}