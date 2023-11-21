<?php
use Tygh\CscLiveSearch;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
class ClsSearchCategories{
	public static function _get_categories($params){		
		$categories =[];
		$company_id = fn_cls_get_current_company_id($params);	
		$ls_settings = CscLiveSearch::_get_option_values(true, $company_id);				
		$join = $condition = $limit = '';
		$fields = [
			"?:category_descriptions.category_id", 
			"?:categories.id_path", 
			"?:categories.level", 
			"?:category_descriptions.category as category"
		];
		
		$cats_where=array();
		if ($ls_settings['search_on_category_name']=="Y"){
			$cats_where[]=db_quote(" ?:category_descriptions.category LIKE ?l", "%$params[q]%");	
		}
		if ($ls_settings['search_on_category_metakeywords']=="Y"){
			$cats_where[]=db_quote(" ?:category_descriptions.meta_keywords LIKE ?l", "%$params[q]%");	
		}
		if ($company_id) {
			$condition .=" AND company_id=$company_id";
		}
		if (version_compare(PRODUCT_VERSION, '4.14.1', '>=') && PRODUCT_EDITION=="MULTIVENDOR" && $params['runtime_storefront_id']){
			$condition .=db_quote(" AND (?:categories.storefront_id=?i OR ?:categories.storefront_id=?i)", $params['runtime_storefront_id'], 0);	
		}		
		if ($ls_settings['cats_limit']){
			$limit="LIMIT {$ls_settings['cats_limit']}";
		}		
		if ($cats_where){
			fn_cls_hook_function('hooks_get_categories', $ls_settings, $company_id, $params, $fields, $join, $condition, $cats_where, $limit);
			
			$condition .=' AND ('.implode(' OR ', $cats_where).')';			
			$condition .= fn_cls_get_usergroups_conditions($params, '?:categories');		
									
			$categories=db_get_array("SELECT " . implode(',', $fields) . " FROM ?:category_descriptions 
			LEFT JOIN ?:categories ON ?:categories.category_id=?:category_descriptions.category_id $join 
			WHERE ?:category_descriptions.lang_code=?s $condition  AND status='A' ORDER BY ?:category_descriptions.category  $limit", $params['lang_code']);
							
			if ($ls_settings['show_parent_category']=="Y"){
				foreach ($categories as &$cat){
					$p_category='';
					$parent_id ='';
					if ($cat['level'] > 1){
						$parents = explode('/', $cat['id_path']);
						if (isset($parents[$ls_settings['clsm_show_parent_level'] - 1]) && $ls_settings['clsm_show_parent_level'] < $cat['level']){
							$parent_id = $parents[$ls_settings['clsm_show_parent_level'] - 1];
							
						}elseif($cat['level'] > 1){
							$parents = array_reverse($parents);
							if (!empty($parents[1])){
								$parent_id	=$parents[1];
							}								
						}
						if ($parent_id){
							$p_category=db_get_field("SELECT category FROM ?:category_descriptions WHERE category_id=?i AND lang_code=?s", $parent_id, $params['lang_code']);	
						}
					}					
					if (!empty($p_category)){
						$cat['category'] = 	$p_category.'/'.$cat['category'];						
					}
				}
			}
		}			
		return $categories;
	}
	public static function _get_storefront_categories($params){		
		$categories =[];
		$company_id = fn_cls_get_current_company_id($params);			
		$ls_settings = CscLiveSearch::_get_option_values(true, $company_id);					
		$search_storefronts = $ls_settings['allow_storefronts'];
		foreach ([$company_id, ''] as $val){
			if (($key = array_search($val, $search_storefronts)) !== false) {
				unset($search_storefronts[$key]);
			}
		}			
		if ($search_storefronts){
			$condition = " AND ?:categories.company_id IN (".implode(',', $search_storefronts).")";
			$categories=db_get_array("SELECT ?:category_descriptions.category_id, 
			?:category_descriptions.category, 
			?:categories.company_id, 
			?:companies.storefront 
			FROM ?:category_descriptions 
			LEFT JOIN ?:categories ON ?:categories.category_id=?:category_descriptions.category_id
			LEFT JOIN ?:companies ON ?:companies.company_id=?:categories.company_id
			WHERE ?:category_descriptions.lang_code=?s $condition 
			AND (?:category_descriptions.category LIKE ?l OR ?:category_descriptions.category LIKE ?l) 
			AND ?:categories.status='A' LIMIT {$ls_settings['cats_limit']}", $params['lang_code'], "$params[q]%", "% $params[q]%");
		}
		foreach ($categories as &$category){
			$category['url'] = 'http://'.$category['storefront'].'/index.php?dispatch=categories.view&category_id='.$category['category_id'];
			unset($category['storefront']);	
		}
						
		return $categories;
	}
	
}
