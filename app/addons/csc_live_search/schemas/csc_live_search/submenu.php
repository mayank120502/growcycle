<?php
use Tygh\Registry;
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			https://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
if (!defined('BOOTSTRAP')) { die('Access denied'); }
$schema = array(
	'cls.menu'=>array(
		'cls.settings' => array(		
			'dispatch'=>'csc_live_search.settings'
		),
        'cls.styles' => array(		
			'dispatch'=>'csc_live_search.styles'
		),
		'cls.search_history' => array(		
			'dispatch'=>'csc_live_search.history',
			'subitems'=>array(
				'cls.history_per_request' => array(		
					'dispatch'=>'csc_live_search.history.per_request'
				),
				'cls.history_per_word' => array(		
					'dispatch'=>'csc_live_search.history.per_word'
				),
				'cls.history_per_product' => array(		
					'dispatch'=>'csc_live_search.history.per_product'
				),								
				'cls.history_per_user' => array(		
					'dispatch'=>'csc_live_search.history.per_user'
				),
			)
		),
		'cls.search_synonyms' => array(		
			'dispatch'=>'csc_live_search.synonyms'
		),
		'cls.stop_words' => array(		
			'dispatch'=>'csc_live_search.stop_words'
		),
		'cls.search_motivation' => array(		
			'dispatch'=>'csc_live_search.search_motivation'
		),
		'cls.search_phrases' => array(		
			'dispatch'=>'csc_live_search.search_phrases'
		),
		'cls.search_speedup' => array(		
			'dispatch'=>'csc_live_search.speedup',
			'subitems'=>array(
				'cls.search_speedup_settings' => array(		
					'dispatch'=>'csc_live_search.speedup.settings'
				),
				'cls.search_speedup_indexation' => array(		
					'dispatch'=>'csc_live_search.speedup.indexation'
				)				
			)
			
		),
    )	
);

if (fn_allowed_for('MULTIVENDOR') && Registry::get('runtime.company_id')){	
	$schema['cls.menu'] = [
		'cls.search_history'=>$schema['cls.menu']['cls.search_history']
	];
	unset($schema['cls.menu']['cls.search_history']['subitems']['cls.history_per_user']);	
}

return $schema;