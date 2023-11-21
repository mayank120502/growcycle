<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			https://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
use Tygh\CscLiveSearch;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
$schema = array(   
	'general' => array(
		'ttl_search_elements'=>array(
			'type' => 'title',				
		),
		'search_products'=>array(
			'type' => 'checkbox',
			'default'=>'Y',
			'label_class'=>'clsBold'				
		),			
			'products_per_page'=>array(
				'type' => 'input',
				'default'=>'10',
				'show_when'=>['search_products'=>['Y']]					
			),				
			'out_stock_end'=>array(
				'type' => 'checkbox',
				'default'=>'Y',
				'show_when'=>['search_products'=>['Y']]
			),	
			'increase_popularity'=>array(
				'type' => 'checkbox',
				'default'=>'Y',
				'show_when'=>['search_products'=>['Y']]					
			),	
			'sort_by'=>array(
				'type' => 'selectbox',
				'default'=>'cls_rel_pop|asc',
				'variants'=>AREA=="A" ? CscLiveSearch::_get_sort_by() : [],
				'show_when'=>['search_products'=>['Y']]					
			),
			'suggest_products_categories'=>array(
				'type' => 'checkbox',
				'default'=>'Y',
				'tooltip'=>true,
				'show_when'=>['search_products'=>['Y']]				
			),
			'group_by_root_cats'=>array(
				'type' => 'checkbox',
				'default'=>'N',
				'tooltip'=>true,
				'show_when'=>['suggest_products_categories'=>['Y']],
				'label_class'=>'clsLevel2'			
			),		
			'suggest_corrections'=>array(
				'type' => 'checkbox',
				'default'=>'Y',
				'tooltip'=>true,
				'show_when'=>['search_products'=>['Y']]				
			),
			/*'suggest_prediction'=>array(
				'type' => 'checkbox',
				'default'=>'N',
				'tooltip'=>true,
				'show_when'=>['search_products'=>['Y']]				
			),
			'prediction_key'=>array(
				'type' => 'input',
				'required'=>true,
				'default'=>'',
				'tooltip'=>true,
				'show_when'=>['suggest_prediction'=>['Y']]				
			),*/
				
		'search_categories'=>array(
			'type' => 'checkbox',
			'default'=>'Y',
			'label_class'=>'clsBold'				
		),			
			'cats_limit'=>array(
				'type' => 'input',
				'default'=>'5',
				'show_when'=>['search_categories'=>['Y']]					
			),	
			'search_on_category_name'=>array(
				'type' => 'checkbox',
				'default'=>'Y',
				'show_when'=>['search_categories'=>['Y']]			
			),	
			'search_on_category_metakeywords'=>array(
				'type' => 'checkbox',
				'default'=>'N',
				'show_when'=>['search_categories'=>['Y']]					
			),	
			'show_parent_category'=>array(
				'type' => 'checkbox',
				'default'=>'N',
				'show_when'=>['search_categories'=>['Y']]						
			),
			'clsm_show_parent_level'=>array(
				'type' => 'input',
				'default'=>'1', 
				'tooltip'=>true,
				'show_when'=>['show_parent_category'=>['Y']],
				'label_class'=>'clsLevel2'								
			),	
			'clsm_redirect_category'=>array(
				'type' => 'checkbox',
				'default'=>'N',
				'tooltip'=>true,
				'show_when'=>['search_categories'=>['Y']]						
			),
			
			
				
		
		'search_brands'=>array(
			'type' => 'checkbox',
			'label_class'=>'clsBold'			
		),		
			'brands_limit'=>array(
				'type' => 'input',
				'default'=>'5',
				'show_when'=>['search_brands'=>['Y']]					
			),	
		
			'brands_feature_id'=>array(
				'type' => 'selectbox',
				'variants'=>AREA=="A" ? CscLiveSearch::_get_brands() : [],
				'show_when'=>['search_brands'=>['Y']]			
			),
			
		'search_vendors'=>['type'=>'hidden'],
		'vendors_limit'=>['type'=>'hidden'],	
		'search_blog'=>[
			'type' => 'checkbox',
			'label_class'=>'clsBold'		
		],
		'search_pages'=>[
			'type' => 'checkbox',
			'label_class'=>'clsBold'		
		],		
		'pb_limit'=>[
			'type' => 'input',
			'default'=>'5',
			'show_when'=>true,
					
		],
				
		
		/*'ttl_function'=>array(
			'type' => 'title',			
		),*/
		
		//search phrases hidden settings			
		'suggest_phrases'=>array(
			'type' => 'hidden',
			'default'=>'1'			
		),
		'show_phrases_rec_products'=>array(
			'type' => 'hidden',
			'default'=>'1'			
		),
		'use_stop_words'=>array(
			'type' => 'hidden',
			'default'=>'0'				
		),
		'use_synonyms'=>array(
			'type' => 'hidden',
			'default'=>'0'			
		),
		'syn_partial_match'=>array(
			'type' => 'hidden',
			'default'=>'0'			
		),		
		'enable_history'=>array(
			'type' => 'hidden',
			'default'=>'1'			
		),			
					
	),
	'search_settings' => array(
		'search_on_general_title'=>array(
			'type' => 'title'					
		),
		'search_on_name'=>array(
			'type' => 'checkbox',
			'default'=>'Y'			
		),
		'search_on_pcode'=>array(
			'type' => 'checkbox',			
		),
		'search_on_product_id'=>array(
			'type' => 'checkbox',			
		),	
		'search_on_keywords'=>array(
			'type' => 'checkbox',			
		),
		'search_on_options'=>array(
			'type' => 'checkbox',			
		),	
		'search_on_features'=>array(
			'type' => 'checkbox',			
		),			
		'search_by_features'=>array(
			'type' => 'select2',
			'dispatch'=>'product_features.get_features_list',
			'mode'=>'multiple',
			'variants'=> AREA=="A" ? CscLiveSearch::_get_features() : [],
			'show_when'=>['search_on_features'=>['Y']],
			'variant_name_function'=>'fn_get_feature_name',
			'tooltip'=>true		
		),
		'search_on_tags'=>array(
			'type' => 'hidden',
			'default'=>'N'				
		),
		
		'search_on_general_title_no_speed'=>array(
			'type' => 'title',
			'tooltip'=>true					
		),
			
		'search_on_metakeywords'=>array(
			'type' => 'checkbox'			
		),	
		'search_on_metatitle'=>array(
			'type' => 'checkbox',			
		),	
		'search_on_metadesc'=>array(
			'type' => 'checkbox',			
		),
		
		'search_on_description'=>array(
			'type' => 'checkbox',			
		),	
		'search_on_short_description'=>array(
			'type' => 'checkbox',			
		),		
		
		
		'search_general_title'=>array(
			'type' => 'title'					
		),		
		'characters_limit'=>array(
			'type' => 'input',
			'default'=>'3'				
		),	
		'autoredirect'=>array(
			'type' => 'checkbox',
			'tooltip'=>true			
		),
		'block_enter_press'=>array(
			'type' => 'checkbox',
			'tooltip'=>true					
		),
		'anti_csrf'=>array(
			'type' => 'checkbox',
			'default'=>'Y',
			'tooltip'=>true					
		)
	)			 	 	 	
);

if (PRODUCT_EDITION=="ULTIMATE"){
	$schema['storefronts']= array(
		'ttl_serch_on_storefronts'=>array(
			'type' => 'title',					
		),	
		'search_storefront_categories'=>array(
			'type' => 'checkbox',
			'default'=>'N',
			'tooltip'=>true						
		),	
		'allow_storefronts'=>array(
			'type' => 'select2',
			'mode'=>'multiple',
			'variants'=> AREA=="A" ? CscLiveSearch::_get_storefronts() : [],
			'tooltip'=>true					
		),
	);	
}

if (AREA=="A" && Tygh\Registry::get('addons.tags.status')=="A"){
	$schema['search_settings']['search_on_tags']=[
		'type' => 'checkbox',
		'default'=>'N'	
	];	
}

if (AREA=="A" && Tygh\Registry::get('addons.product_variations.status')=="A"){
	$schema['search_settings']['search_variation']=[
		'type' => 'selectbox',
		'variants'=>[
			'N'=>__('cls.dont_search_variation'),
			'Y'=>__('cls.search_variation_show_main'),
			'A'=>__('cls.search_variation_show_all'),			
		],
		'tooltip'=>true,	
		'default'=>'N'	
	];
}



if (PRODUCT_EDITION=="MULTIVENDOR"){
	$schema['multivendor']['search_vendors'] = array(
		'type' => 'checkbox',
		'label_class'=>'clsBold'			
	);
	$schema['multivendor']['vendors_limit'] = array(
		'type' => 'input',
		'default'=>'5',
		'show_when'=>['search_vendors'=>['Y']]			
	);
	
	$schema['multivendor']['vendor_history_access'] = array(
		'type' => 'selectbox',
		'default'=>'D',
		'variants'=> [
			'D'=>__('cls.not_display'),
			'C'=>__('cls.display_only_by_clicks'),					
			'A'=>__('cls.display_all')
		],			
	);
}




return $schema;