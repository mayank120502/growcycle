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
use Tygh\Settings;


// Compatibility
$dir_addons = Registry::get('config.dir.addons');
$index_script = Registry::get('config.customer_index');

// addons/<addon_name>/controllers/admin/FILE
$v = explode(DIRECTORY_SEPARATOR, __FILE__);
$addon_name = $v[count($v)-4];
if( $_SERVER['REQUEST_METHOD'] == 'POST' && !empty($_REQUEST['addon']) && $addon_name == $_REQUEST['addon'] ) {
	if( file_exists($f = ez_fix_path($dir_addons."ez_common/lib/addon_processing.php")) ) {
		include($f);
	} else if( !empty($_REQUEST['addon']) && ($_REQUEST['addon'] == $addon_name ) ) {
		$v = ini_get('display_errors');
		if( $v ) ini_set('display_errors', '0');
		// Modifying this addon?  Verify the install completed 
		// Wish they had an "install" routine for processing outside of options....
		switch($mode) {
			case 'update':
				require_once(ez_fix_path($dir_addons."$addon_name/lib/upgrade/upgrade.php"));		
				// copy of common version of tools - used to bootstrap the ez_common addon
				addon_check_install($addon_name);
				addon_check_dependencies($addon_name);
				break;
		}
		if( $v ) ini_set('display_errors', $v);
	}
}
return array(CONTROLLER_STATUS_OK);
?>