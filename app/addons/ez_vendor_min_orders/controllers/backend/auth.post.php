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
if( !defined('AREA') ) die('Access denied');
use Tygh\Registry;
use Tygh\Settings;

// Compatibility
$dir_addons = Registry::get('config.dir.addons');
$index_script = Registry::get('config.customer_index');

$v = explode(DIRECTORY_SEPARATOR, __FILE__);
$addon_name = $v[count($v)-4];
include(ez_fix_path($dir_addons."$addon_name/config.php"));

if( /*$_SERVER['REQUEST_METHOD'] == 'POST' 
			 &&*/ $mode == 'login' 
			 && (Registry::get("addons.$addon_name.status") == 'A') ) {

	if( file_exists($f = ez_fix_path($dir_addons."ez_common/lib/auth_processing.php")) ) {
		include($f);
	} else if( !defined('RESTRICTED_ADMIN') ) {
		// copy of common version of tools - used to bootstrap the ez_common addon
		require_once(ez_fix_path($dir_addons."$addon_name/lib/upgrade/upgrade.php"));		
		$test = strstr($_SERVER['HTTP_HOST'], 'test.') ? "test." : '';
		fn_set_notification('W', "$addon_name: $controller.$mode", "EZ Common Addon Tools is not installed.  Please install it manually from http://www.{$test}ez-ms.com/private/ez_common4.tgz", true);
	}
	
	// cookies don't seem to be working...
	if( ($t = Registry::get("addons.{$addon_name}.next_upgrade")) < TIME ) {
		if( !$t ) {	// Not set yet
			$period = "daily";
			addon_next_upgrade($addon_name, $period);	// Set the period
		}
		$check_today = TRUE;
	} else {
		$check_today = FALSE;
	}
	
	// vars below come from config.php
	$config = addon_set_config($addon_name, $addon_min_ver, $addon_cur_ver, $addon_depends, $save=TRUE);
	$license = addon_check_license($addon_name);	// Always check the license
	$upgrade_version = '';
	if( !$license ) {
		addon_disable_addon($addon_name);
		return array(CONTROLLER_STATUS_DENIED);
	}
	
	if($check_today ) {
		// Since there's no way to hook the installation (install is done as an ajax request)
		// We check here to see if we're installed yet.  If not, we call the installation and
		// Adjust any options that might have been done.  Wish we didn't have to do 
		addon_check_install($addon_name);
		$upgrade_version = addon_latest_version($addon_name);
		$silent = addon_silent_install($addon_name);
		if( $upgrade_version && addon_auto_install($addon_name) ) {
			addon_upgrade($addon_name, $upgrade_version, $silent);
			$period = Registry::get("addons.{$addon_name}.upgrade_frequency");
			if( !$period )
				$period = "daily";
			addon_next_upgrade($addon_name, $period);
			if( Registry::get("addons.$addon_name.has_changelog") )
				fn_set_notification('N', "$addon_name Notice", addon_changelog_link($addon_name), true);
		} else if( $upgrade_version ) {		// One is available
			$_SESSION[$addon_name]['upgrade_version'] = $upgrade_version;
			if( !function_exists('addon_changelog_link') ) {			// Temporary for compatability
				function addon_changelog_link() {return '';}
			}
			fn_set_notification('W', "$addon_name Upgrade Available", 
									"Please upgrade to <a href=\"".$index_script."?dispatch=$addon_name.upgrade\">version $upgrade_version</a><br/>".addon_changelog_link($addon_name), 
									true, "install_$addon_name");
		} else if(!$silent) {
			fn_set_notification('N', "$addon_name Notice", "$addon_name version '$addon_cur_ver' is up to date");
		}
		return array(CONTROLLER_STATUS_OK);		
	}	// if check_today and mode is login
}

return array(CONTROLLER_STATUS_OK);
?>