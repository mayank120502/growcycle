<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			https://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
if (!defined('BOOTSTRAP')) { die('Access denied'); }
$schema = array(   
	'developers' => array(
		'hooks_get_products'=>array(
			'type' => 'select2',
			'tooltip'=>true,
			'mode'=>'multiple',
			'variants'=>array(
				/* This is example 
				'/app/addons/my_changes/file_name_same_as_function_name.php'=>'Display name on settings page'
				*/
			)			
		),
		'hooks_get_joins'=>array(
			'type' => 'select2',			
			'mode'=>'multiple',
			'variants'=>array(
				/* This is example 
				'/app/addons/my_changes/file_name_same_as_function_name.php'=>'Display name on settings page'
				*/
			)			
		),
		'hooks_get_conditions'=>array(
			'type' => 'select2',			
			'mode'=>'multiple',
			'variants'=>array(
				/* This is example 
				'/app/addons/my_changes/file_name_same_as_function_name.php'=>'Display name on settings page'
				*/
			)			
		),
		'hooks_get_fields'=>array(
			'type' => 'select2',			
			'mode'=>'multiple',
			'variants'=>array(
				/* This is example 
				'/app/addons/my_changes/file_name_same_as_function_name.php'=>'Display name on settings page'
				*/
			)			
		),
		'hooks_get_categories'=>array(
			'type' => 'select2',			
			'mode'=>'multiple',
			'variants'=>array(
				/* This is example 
				'/app/addons/my_changes/file_name_same_as_function_name.php'=>'Display name on settings page'
				*/
			)			
		),
		'hooks_get_brands'=>array(
			'type' => 'select2',			
			'mode'=>'multiple',
			'variants'=>array(
				/* This is example 
				'/app/addons/my_changes/file_name_same_as_function_name.php'=>'Display name on settings page'
				*/
			)			
		),
		'hooks_get_pages'=>array(
			'type' => 'select2',			
			'mode'=>'multiple',
			'variants'=>array(
				/* This is example 
				'/app/addons/my_changes/file_name_same_as_function_name.php'=>'Display name on settings page'
				*/
			)			
		),
		'hooks_get_vendors'=>array(
			'type' => 'select2',			
			'mode'=>'multiple',
			'variants'=>array(
				/* This is example 
				'/app/addons/my_changes/file_name_same_as_function_name.php'=>'Display name on settings page'
				*/
			)			
		),
		'hooks_before_response'=>array(
			'type' => 'select2',			
			'mode'=>'multiple',
			'variants'=>array(
				/* This is example 
				'/app/addons/my_changes/file_name_same_as_function_name.php'=>'Display name on settings page'
				*/
			)			
		)
	) 	  	  		 	 	 	
);


return $schema;