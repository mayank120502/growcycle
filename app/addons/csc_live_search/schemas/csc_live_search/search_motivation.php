<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			https://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
if (!defined('BOOTSTRAP')) { die('Access denied'); }
$schema = array(   
	'clsm.general' => array(
		'clsm_title'=>array(
			'type' => 'title'								
		),
		'clsm_status'=>array(
			'type' => 'hidden',
			'default'=>'0'							
		),
		'clsm_motivation_text_'.DESCR_SL=>array(
			'type' => 'template',
			'template'=>'addons/csc_live_search/views/csc_live_search/components/search_motivation_field.tpl',					
			'tooltip'=>true				
		),
	),		 	  	  		 	 	 	
);

return $schema;