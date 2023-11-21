<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			http://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_print_r(){
	$args = func_get_args();
	echo('<ol style="font-family: Courier; font-size: 12px; border: 1px solid #dedede; background-color: #efefef; float: left; padding-right: 20px;">');
	foreach ($args as $v) {
		echo('<li><pre>' . htmlspecialchars(print_r($v, true)) . "\n" . '</pre></li>');
	}
	echo('</ol><div style="clear:left;"></div>');
}

function fn_get_schema($folder, $file_name){
	$schema = include('app/addons/csc_live_search/schemas/'.$folder.'/'.$file_name.'.php');	
	return $schema;	
}

function fn_get_config_data(){
	static $config;
	if (!$config){
		$config  = require_once(DIR_ROOT . '/config.php');
	}
	return $config;
}

function fn_cls_validate_request($params, $ls_settings){	
	if (empty($ls_settings['anti_csrf']) || $ls_settings['anti_csrf']!='Y'){
		return true;	
	}		
	$cookie = 'cls'.$params['runtime_storefront_id'].$params['runtime_company_id'];	
	if (!empty($params['cls_hash']) && !empty($_COOKIE[$cookie]) && $params['cls_hash']==md5($_COOKIE[$cookie] . $_SERVER['HTTP_HOST'] . (SESSION_ALIVE_TIME* 2))){
		return true;
	}	
	
	return false;	
}