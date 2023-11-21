<?php
/*****************************
* Copyright 2021, 1st Source IT, LLC
* All rights reserved.
* Permission granted for use as
* long as this copyright notice, associated text and
* links remain in tact.
* Licensed for a single domain and a single instance of EZ-cart.
* Additional licenses can be purchased for additonal sites.
*
* http://www.ez-ms.com
* http://www.ez-om.com
* http://www.1sit.com*
*
* End copyright notification
*/

use Tygh\Registry;

if ( !defined('BOOTSTRAP') ) { die('Access denied'); }
/*
fn_register_hooks(
	'pre_place_order'
);
*/
$addon_name = basename(dirname( __FILE__));
if( class_exists('ez_log') && function_exists('ez_log_prefs')
	&& ($log_prefs = ez_log_prefs())
	&& !empty($log_prefs['enabled']) ) {
	ez_log::init($addon_name, empty($log_prefs['log_level']) ? logLog : $log_prefs['log_level'], 
							empty($log_prefs['area']) ? "" : $log_prefs['area'], 
							$dispaly_errors=false);
} elseif( class_exists('ez_log') ) {
	ez_log::init($addon_name, logLog, '', false);
} elseif( file_exists($f = __DIR__."/class.log.php") ) {
	require_once($f);
}
?>