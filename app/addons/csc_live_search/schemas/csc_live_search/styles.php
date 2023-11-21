<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			https://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
if (!defined('BOOTSTRAP')) { die('Access denied'); }
$schema = array(   
	'styles' => array(
		'base_styles_settings'=>array(
			'type'=>'title'
		),
		'theme'=>array(
			'type' => 'selectbox',
			'default'=>'csc_live_search/themes/modern.less',
			'class'=>'clsInput',
			'variants'=>[
				'csc_live_search/themes/modern.less'=>__('cls.modern'),
				'csc_live_search/themes/classic.less'=>__('cls.classic')
			]
		),
		'base_text_color'=>array(
			'type' => 'color',
			'default'=>'#2a2c47',
			'class'=>'clsInput'
		),
		'active_elements_background'=>array(
			'type' => 'color',
			'default'=>'#eaeaed',
			'class'=>'clsInput'
		),
		'active_elements_color'=>array(
			'type' => 'color',
			'default'=>'#029d52',
			'class'=>'clsInput'
		),
		'link_color'=>array(
			'type' => 'color',
			'default'=>'#1155bb',
			'class'=>'clsInput'
		),
		'border_radius'=>array(
			'type' => 'input',
			'min' => 0,
			'default'=> 5,
			'class'=>'clsInput'
		),
		'desktop_max_width'=>array(
			'type' => 'input',
			'min' => 0,
			'default'=> 700,
			'tooltip'=>true		
		),
		'category_label'=>array(
			'type'=>'title'
		),
		
		'show_category'=>array(
			'type' => 'checkbox',
			'default'=>'Y',
			'class'=>'clsInput',						
		),
		'color_type'=>array(
			'type' => 'selectbox',
			'default'=>'M',
			'class'=>'clsInput',
			'tooltip'=>true,
			'variants'=>array(
				'M'=>__('cls.one_of_ten'),
				'A'=>__('cls.rand_every_category'),
				'E'=>__('cls.fixed_color'),
			),
			'show_when'=>['show_category'=>['Y']]		
							
		),		
		'category_e'=>array(
			'type' => 'color',
			'default'=>'#50AFD6',
			'class'=>'clsInput',
			'show_when'=>[
				'color_type'=>['E']
			],
			'hide_when'=>[
				'show_category'=>['undefined']
			]					
		),
		'show_category_gradient'=>array(
			'type' => 'checkbox',
			'default'=>'N',
			'class'=>'clsInput',
			'show_when'=>['show_category'=>['Y']]					
		),
		
		'elements'=>array(
			'type'=>'title'
		),
		'show_price'=>array(
			'type' => 'selectbox',
			'default'=>'Y',
			'variants'=>[
				'Y'=>__('cls.display'),
				'D'=>__('cls.not_display'),
				'A'=>__('cls.display_authed')
			],
			'class'=>'clsInput'					
		),	
		'show_cart'=>array(
			'type' => 'selectbox',
			'default'=>'Y',
			'variants'=>[
				'Y'=>__('cls.display'),
				'D'=>__('cls.not_display'),
				'A'=>__('cls.display_authed')
			],
			'class'=>'clsInput'					
		),	
		'show_product_code'=>array(
			'type' => 'checkbox',
			'default'=>'Y',
			'class'=>'clsInput'			
		),
		'show_wish'=>array(
			'type' => 'checkbox',
			'default'=>'Y',
			'class'=>'clsInput'				
		),
		'show_compare'=>array(
			'type' => 'checkbox',
			'default'=>'Y',
			'class'=>'clsInput'				
		),
		'show_quick_view'=>array(
			'type' => 'checkbox',
			'default'=>'Y',
			'class'=>'clsInput'				
		),
		
	),			  	  		 	 	 	
);


return $schema;