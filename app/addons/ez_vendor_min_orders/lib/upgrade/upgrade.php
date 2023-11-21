<?php
/*****************************
* Copyright 2021 1st Source IT, LLC
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
if( !defined('BOOTSTRAP') ) die('Access denied');
use Tygh\Registry;

/*
 * EZ_common specific functions
 */
if( !class_exists('ez_log') && is_file($f = ez_fix_path(Registry::get('config.dir.addons')."ez_common/class.ez_log.php")) ) {
	include($f);
	ez_log::init('ez_common', logDetail, '', false);
	ez_log::add_msg('ez_common', "ez_common not initialized");
}
 
if( !function_exists('addon_version_compare') ) {
	function addon_version_compare($v, $operator=">=", $cv='') {
		if( empty($cv) )
			$cv = PRODUCT_VERSION;
		return version_compare($cv, $v, $operator);
	}
}

$major_version = preg_replace(';([0-9]+)\..*;', '$1', PRODUCT_VERSION);
$f = dirname(__FILE__)."/upgrade_v$major_version.php";
if( file_exists($f) )
	include($f);
define('addon_major_version', $major_version);
include(ez_fix_path(dirname(__FILE__)."/upgrade_common.php"));
?>