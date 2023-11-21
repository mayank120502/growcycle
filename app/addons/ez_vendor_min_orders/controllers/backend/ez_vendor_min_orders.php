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
if ( !defined('BOOTSTRAP') ) { die('Access denied'); }
use Tygh\Registry;
use Tygh\Settings;

// Compatibility
$dir_addons = Registry::get('config.dir.addons');
$index_script = Registry::get('config.admin_index');

$v = explode(DIRECTORY_SEPARATOR, __FILE__);
$addon_name = $v[count($v)-4];

/* Every addon must have this to bootstrap the ez_common addon
 */
/* no license
if( file_exists($f=ez_fix_path($dir_addons."ez_common/lib/upgrade.php")) ) {
	require_once($f);
} else {	// Need to force update of the tools
	require_once(ez_fix_path($dir_addons."$controller/lib/upgrade/upgrade.php"));		// copy of common version of tools - used to bootstrap the ez_common addon
}
*/

switch($mode) {
	case 'log':
		// 7/21/17 - fixed class name
		$log_class=$addon_name . "_log";
		if( class_exists($log_class) ) {
			$log_lines = 10;
			$l_buf = array();
			switch($action) {
				case 'clear': 
					$log_class::clear_log(); 
					fn_set_notification('N', $controller, "Cleared log file");
					break;
				case 'truncate':
					$lines = (empty($_REQUEST['truncate_lines']) && $dispatch_extra) 
								? $dispatch_extra 
								: (empty($_REQUEST['truncate_lines']) ? 100 : $_REQUEST['truncate_lines']);
					$entries = $log_class::truncate_log($lines);
					fn_set_notification('N', $controller, "Truncated log to $entries lines");
					break;
				case 'show':
					$lines = min($log_lines, (empty($_REQUEST['show_lines']) && $dispatch_extra) 
								? $dispatch_extra 
								: (empty($_REQUEST['show_lines']) ? 100 : $_REQUEST['show_lines']));
					$log_class::show_log($lines);
					exit;
			}	// switch
		}	// class exists
		break;
	
	case 'install_lang_vars':
		$params = array();;
		switch($action) {
			case '1':
			case 'force':
				$params['force'] = true;
				break;
		}
		$messages = vendor_min_orders_install_lang_vars($params);
		if( !$messages )
			fn_set_notification('N', __("notice"), "No new lang vars to install");
		else
			fn_set_notification('N', __("notice"), implode("<br/>", $messages), 'K');
		break;
	case 'create_po_file':
		$lang = empty($action) ? (empty($_REQUEST['lang'])?'en':$_REQUEST['lang']) : $action;
		if( function_exists($func = $addon_name.'_create_po_file') )
			$func($f="var/langs/{$lang}/addons/{$addon_name}.po");
		fn_set_notification("N", __("notice"), "Created po file '$f'", 'K');
		fn_redirect("addons.manage");
	case 'check_install':
		$force_lang = $action ? true : (empty($_REQUEST['force']) ? false : true);
		$force_templates = $force_lang ? $force_lang : (empty($_REQUEST['force_templates']) ? false : true);
		if( function_exists($f = sprintf("%s_install_setup", $addon_name)) )
			$f(array('force'=>$force_lang, 'verbose'=>false, 'install_templates'=>$force_templates));
		if( file_exists($f = Registry::get('config.dir.addons')."$addon_name/upgrade/post_upgrade_all_versions.php") )
			include($f);
		if( function_exists('addon_install_setup') ) {
			$result = addon_install_setup($controller);
			if( $result === false )
				$result = "Failed";
			else $result = sprintf("Okay: Current version=%s, next upgrade=%s", 
								   (empty($result['cur_ver'])?"not set":$result['cur_ver']),
								   (empty($result['next_upgrade'])?"next login":("after ".date("m/d/Y H:i:s",$result['next_upgrade'])))
								   );
			fn_set_notification($result == "Failed" ? 'E' : 'N', "$controller.$mode", $result, 'K');
		} else {	// function exists
			fn_set_notification('E', __("error"), "$mode not supported or ez_common not installed.", 'K');
		}
		fn_redirect("addons.manage");	
		break;
		
	case 'test':
		switch($action) {
			case 'data':
				die("<pre>".print_r(vendor_min_order_get_companies(),true) );
			default:
				die("No such $mode '$action'");
		}
		break;		
	
	default:
		if( file_exists($f = ez_fix_path($dir_addons."ez_common/lib/std_addon_controller.php")) ) {
			include($f);
		}
		break;
}

$return_url = !empty($return_url)
				? $return_url 
				: (!empty($_REQUEST['redirect_url'])
					? $_REQUEST['redirect_url']
					: (!empty($_REQUEST['return_url'])
						? $_REQUEST['return_url']
						: $index_script
						)
				);

return array(CONTROLLER_STATUS_OK, $return_url);
?>