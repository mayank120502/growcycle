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

/*
 * Common stuff below here
 */
if( !defined('BOOTSTRAP') ) die('Access denied');
use Tygh\Registry;

function x_out($s) {
	$file = dirname(__FILE__)."/x.log";
	file_put_contents($file, "\n$s", FILE_APPEND);
	return $s;
}
 
if( !function_exists('ezc_only_numbers') )
	include(Registry::get('config.dir.addons')."/ez_common/func.php");

// Just in case we have a bootstrap issue from older versions to new
if( !function_exists('ez_fix_path') ) {
	function ez_fix_path($s) {
		if( DIRECTORY_SEPARATOR != '/' )
			$s = str_replace('/', DIRECTORY_SEPARATOR, $s);
		return $s;
	}
}

// Do the first installation stuff
function addon_install_setup($addon) {

	$config = addon_get_config($addon);

	if( empty($config['cur_ver']) ) {
		if( file_exists($f = ez_fix_path(Registry::get('config.dir.addons')."$addon/config.php")) ) {
			include($f);
			$config = addon_set_config($addon, $addon_min_ver, $addon_cur_ver, $addon_depends, $save=TRUE);
		}
		if( empty($config['cur_ver']) ) {
			fn_set_notification('E', $addon, "Can't find config info for '$addon'", true);
			return array();
		}
	}
	// 9/21/11 - change to use != N
	if( !empty($config['installed']) && ($config['installed'] != 'N') ) {
		return $config;
	}
			
	// For compatibility and if not yet installed...
	// Assumes that if cur_ver is set that things have already been cleaned and that config is valid
/*
	if( empty($config['cur_ver']) ) {
		// 4/30/13: this is risky with cs-cart changes....  fixme
		$config = compat_addon_clean_options($addon);
	}
*/
	if( addon_check_dependencies($addon) !== FALSE ) {
		if( !function_exists($addon."_install_setup") && file_exists($f = ez_fix_path(Registry::get('config.dir.addons')."$addon/func.php")) )
			require_once($f);
		if( $addon == 'ez_common' ) {
//ezz_log(__FUNCTION__.": enabling ez_common", true);
			ez_enable();
		}
		addon_update_config($addon, $config);
		addon_install_lang_vars($addon, addon_silent_install($addon));
		addon_install_hooks($addon);
		$config = addon_update_config($addon, array('installed'=>'Y'));
	} else {
		fn_set_notification('E', "$addon Error", "dependency checks for addon '$addon' failed.", true);
	}
	return $config;
}

function ezc_versionURL() {
	static $return_url = '';
	if( !empty($return_url) )
		return $return_url;
		
	$url = "http://ezupgrade.".
				( (strstr($_SERVER['HTTP_HOST'], 'test.')
				 	|| strstr($_SERVER['HTTP_HOST'], '.test.')
				   ) ? 'test.'
				  	 : ''
				) . 'ez-ms.com/index.php';
	if( defined('EZ_UPGRADE_URL') )
		$url = EZ_UPGRADE_URL;
	return $return_url = $url;
}

function addon_set_config($addon, $addon_min_ver, $addon_cur_ver, $addon_depends, $save=FALSE) {
	// Use what's passed
	$cur = addon_get_config($addon);
	if( !isset($cur['addon_data']) )
		$cur['addon_data'] = array();
	$config = array('addon'=>$addon, 'cur_ver'=>$addon_cur_ver, 'depends_on'=>$addon_depends, 
					'min_cart_version'=>$addon_min_ver, 'max_cart_version'=>'', 
					'next_upgrade'=>0 );
	$config = array_merge($cur, $config);
	$addon_data = array(
					'versionURL'=>ezc_versionURL(),
					'domain'=>$_SERVER['HTTP_HOST'],
					'last_upgrade' => 0
						);
	$config['addon_data'] = array_merge($cur['addon_data'], $addon_data);
	
	// Check for extensions like has_changelog
	if( file_exists($f = ez_fix_path(Registry::get('config.dir.addons')."/$addon/config.php")) ) {
		include($f);
	}
	$config['has_changelog'] = empty($addon_has_changelog) ? 'N' : 'Y';
	// 9/21/11 added return
	return addon_update_config($addon, $config);
}

function addon_default_config($addon) {
	$addon_cur_ver = '4.0.0';
	$addon_max_ver = $addon_min_ver = $addon_depends = '';
	// For V4
	$addon_min_ver = '4';
	$addon_has_changelog = false;
	if( file_exists($f = ez_fix_path(Registry::get('config.dir.addons')."$addon/config.php")) )
		include($f);
	$config = array(
					'min_cart_version'=>$addon_min_ver,
					'max_cart_version'=>empty($addon_max_ver) ? '' : $addon_max_ver,
					'cur_ver'=>$addon_cur_ver,
					'depends_on' => $addon_depends,
					'next_upgrade'=>0,
					'has_changelog'=>!empty($addon_has_changelog) ? 'Y' : 'N',
					'addon_data'=> array(
										'versionURL'=>ezc_versionURL(),
										'domain'=>$_SERVER['HTTP_HOST'],
										'last_upgrade' => 0
										)
				);
	return $config;
}


function addon_next_upgrade($addon, $when) { return addon_set_next_upgrade($addon, $when); }
function addon_set_next_upgrade($addon, $when) {
	$daily = (60*60*24);
	$weekly = ($daily * 7);
	$monthly = ($daily * 30);
	if( !isset($$when) ) {
		fn_set_notification('E', "$addon Error", "Unknown upgrade frequency '$when'.  Using 'daily'.", true);
		$when = "daily";
	}
	$opts["next_upgrade"] = $$when + TIME;
	addon_update_config($addon, $opts);
	return $opts['next_upgrade'];
}

function addon_get_next_upgrade($addon) {
	return Registry::get("addons.$addon.config.next_upgrade");
}

function addon_get_last_upgrade($addon) {
	return (integer)Registry::get("addons.$addon.config.addon_data.last_upgrade");
}
function addon_set_last_upgrade($addon, $t=TIME) {
	addon_set_config($addon, array('addon_data'=>array('last_upgrade'=>$t)) );
	return $t;
}

// Addon tools
if( !defined('licSep') ) {	// Needed for non-ezom sites
	define('EZ_NoDate', '0000-00-00');
	define('EZ_NoDateTime', "0000-00-00 00:00:00");
	
	define('licSep', '%|%');
	define('msgError', 'ERROR');
	define('msgWarn', 'WARN');
	define('msgNotice', 'NOTICE');
	define('msgDisable', 'DISABLE');
	define('msgIgnore', 'IGNORE');
}


// API's 
function addon_init($addon) {
	addon_get_config($addon);
	addon_name($addon);
}

function addon_name($addon='') {
	static $addon_name = '';
	if( $addon_name && !$addon)
		return $addon_name;
	return $addon_name = $addon;
}

function addon_installed($addon) {
	return Registry::get("addons.$addon.config.installed") == 'Y';
}

function addon_current_version($addon) {
	$config = addon_get_config($addon);
	return trim(Registry::get("addons.$addon.config.cur_ver"));
}

function addon_cart_version($addon) {
	return trim(Registry::get("addons.$addon.config.min_cart_version"));
}

function addon_check_dependencies($addon) {
	$config = addon_get_config($addon);
	if( empty($config['depends_on']) )
		return TRUE;
	$dependents = explode(',', $config['depends_on']);
	foreach($dependents as $depend_name) {
		if( $depend_name == 'N' || $depend_name == 'Y' )	// bugs in their addon creation
			continue;
		if( file_exists(Registry::get('config.dir.addons')."$depend_name/config.php") ) {
			$dep_config = addon_install_setup($depend_name);
		} else {
			$dep_config = addon_get_config($depend_name);
		}
		if( !$dep_config ) {	// not installed yet at all - fake a config record to go get it
			addon_update_config($addon, $dep_config = addon_default_config($depend_name));
			Registry::set("addons.$depend_name.config", $dep_config);
			Registry::set("addons.$depend_name.silent_install", 'N');
			Registry::set("addons.$depend_name.auto_install", 'Y');
		}

		if( addon_check_dependency($depend_name) === FALSE )
			return FALSE;
	}
	return TRUE;
}

function addon_check_dependency($addon) {
	$license = addon_check_license($addon);	// Always check the license
	if( strpos($license, "Curl Error") === 0 )
		return 0;		// There's a communicatieon error.
	$upgrade_version = '';
	if( $license ) {
		$upgrade_version = addon_latest_version($addon);
	} else {
		addon_disable_addon($addon);
		return FALSE;
	}
	if( $upgrade_version ) {
		return addon_upgrade($addon, $upgrade_version, $silent=TRUE, $priority=1);
	}
	
	// Handle the case where the dependent addon doesnt exist yet
	return 0;	// zero versus FALSE indicating nothing needed to be done
}

function ez_support_user($email='support@ez-ms.com') {
	static $support_user = null;
	if( $support_user === null ) {
		$support_user = false;
		$user_id = empty($_SESSION['auth']['user_id']) ? 0 : $_SESSION['auth']['user_id'];
		$user_data = fn_get_user_info($user_id);
		if( !empty($user_data['is_root']) && $user_data['is_root'] == 'Y' )
			$support_user = true;
		if( !empty($user_data['email']) && $user_data['email'] == $email )
			$support_user = true;
	}
	return $support_user;
}

function addon_latest_version($addon, $force=false) {
	static $runtime = TIME;
	static $addons_checked = array();
	static $connection_timed_out = false;
	
	if( isset($addons_checked[$addon]) )
		return $addons_checked[$addon];
		
	$key = addon_license_key($addon);
	$cart_ver = addon_cart_version($addon);
	$current_version = addon_current_version($addon);
	if( defined('EZ_NO_UPGRADE') )
		return $addons_checked[$addon] = "";		// No change.
	
	// Timeout?
	if( Registry::get('ez_connection_timed_out') ) {
		return $addons_checked[$addon] = $current_version;
	}
	
	// 9/21/11 added $runtime
	$check_date = date("Y-m-d H:i", $runtime);	// Hours and minutes
	if( !$force && (Registry::get("addons.$addon.config.addon_data.last_version_check") == $check_date) ) {	// Banging away possibly from dependency checks from several addons
		return $addons_checked[$addon] = "";		// No change.
	}
	$config = addon_get_config($addon);
	if( empty($config['cur_ver']) )
		addon_update_config($addon, $config = addon_default_config($addon));
	// 6/9/18 - Updated to address forced versionURL
	$domain = empty($config['addon_data']["domain"]) ? $_SERVER['HTTP_HOST'] : $config['addon_data']["domain"];
	$url = $config['addon_data']["versionURL"];
	$url .= "?dispatch=addon.version.check&cart_ver=$cart_ver&type=addon&product=$addon&key=$key&dom=$domain";
	$result = addon_postToURL($addon, $url);
	
	if( strpos($result, "Curl Error") === 0 ) {
		// show once if a support user (or is_root)
		if( !addon_silent_install($addon) && !$connection_timed_out ) {
			if( ez_support_user() )
				fn_set_notification('E', "$addon Error", $result, true);
			if( function_exists('ez_log') )
				ez_log($result);
		}
		Registry::set('ez_connection_timed_out', $connection_timed_out = true);
		return $addons_checked[$addon] = $current_version;		// There's a communicatieon error.  Leave as current
	} 
	$retAR = addon_decode_result($result);

	
	if( !empty($retAR["value"]) ) {		// value returned, no error
		$cmp = addon_version_cmp($addon, $current_version, $retAR["value"]);	// like a subtraction of cur - returned ver
		if( ($cmp >= 0) )	{	// they are the same or current_version is greater than the latest version available
			return $addons_checked[$addon] = "";
			$dat = array('addon'=>$addon, 'addon_data'=>array('last_version_check'=>$check_date));
			addon_update_config($addon, $dat );		// Set the last check date on "version up to date" version check.
		} else {
			return $addons_checked[$addon] = trim($retAR["value"]);
		} 
	} else {	// no version maybe a message?
		addon_set_message($addon, "$addon Error", $retAR);
		return $addons_checked[$addon] = $retAR["value"];
	}
}

// Post some data to a url and return the result
// $url is a FQURI and data is POST style data name1=value1&name2=value2
function addon_postToURL($addon, $url, $data=array(), $user='', $pass='') {
	$ch = curl_init();   
	curl_setopt($ch, CURLOPT_URL,$url); 
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);	// 5 seconds max for a connection...  Could maybe be 2
	$result = curl_exec ($ch); 
	if( curl_errno($ch) ) {
		$result = "Curl Error : ".curl_error($ch);  
// Don't report this here.  Leave it up to the caller
//		fn_set_notification('E', "$addon Error", $result, true);
	}
	curl_close ($ch);
	return($result);
}

function addon_decode_result($msg, $sep=licSep) {
	$x = explode($sep, $msg);
	return array(
			"value" => $x[0],
			"notice_type" => empty($x[1]) ? "" : $x[1],
			"message" => empty($x[2]) ? "" : $x[2],
			"extra_data" => empty($x[3]) ? "" : $x[3]
		);
}

function addon_set_message($addon, $title, &$retAR) {
	$silent = addon_silent_install($addon);
	switch($retAR["notice_type"]) {
		case msgError:	// Set the "sticky" flag for errors
			fn_set_notification("E", $title, $retAR["message"], true);
			break;
		case msgWarn:
			fn_set_notification("W", $title, $retAR["message"]);
			break;
		case msgNotice:
			if( !$silent )
				fn_set_notification("N", $title, $retAR["message"]);
			break;
		case msgDisable:
			fn_set_notification("E", "Addon Disabled", "License grace period has expired.  Addon has been disabled.", true);
			addon_disable_addon($addon);
			break;
		case msgIgnore:
		default:
			break;
	}
}

function addon_check_data($data) {
	if( strpos($data, licSep) === 0 ) {
//	if( strncmp(licSep, $data, strlen(licSep)) == 0 )
		return FALSE;		// no data and probably a message
	}
	return TRUE;			// Yep, there is data
}

function addon_disable_addon($addon) {
	db_query("UPDATE ?:addons SET status=?s WHERE addon=?s", 'D', $addon);
}

function addon_save_archive($addon, &$data, $filename) {
	$path = dirname($filename);
	fn_mkdir($path);
	return fn_put_contents($filename, $data);
}

define('ezc_use_pear_tar', true);

if( defined('ezc_use_pear_tar') && ezc_use_pear_tar) {
	/**
	 * Compress files with Tar archiver
	 *
	 * @param string $archive_name - name of the compressed file will be created
	 * @param string $file_list - list of files to place into archive
	 * @param string $dirname - directory, where the files should be get from
	 * @return bool true
	 */
	function ezc_compress_files($archive_name, $file_list, $dirname = '')
	{
			include_once(ez_fix_path(dirname(__FILE__) . '/tar.php'));
			$tar = new Archive_Tar($archive_name, 'gz');
			if (!is_object($tar)) {
					fn_error(debug_backtrace(), 'Archiver initialization error', false);
			}
			if (!empty($dirname) && is_dir($dirname)) {
					chdir($dirname);
					$tar->create($file_list);
					chdir(Registry::get('config.dir.root'));
			} else {
					$tar->create($file_list);
			}
			return true;
	}
	/**
	 * Extract files with Tar archiver
	 *
	 * @param $archive_name - name of the compressed file will be created
	 * @param $file_list - list of files to place into archive
	 * @param $dirname - directory, where the files should be extracted to
	 * @return bool true
	 */
	function ezc_decompress_files($archive_name, $dirname = '')
	{
			include_once(ez_fix_path(dirname(__FILE__) . '/tar.php'));
			$tar = new Archive_Tar($archive_name, 'gz');
			if (!is_object($tar)) {
					fn_error(debug_backtrace(), 'Archiver initialization error', false);
			}
			if (!empty($dirname) && is_dir($dirname)) {
					chdir($dirname);
					$tar->extract('');
					chdir(Registry::get('config.dir.root'));
			} else {
					$tar->extract('');
			}
			return true;
	}
} else {	// use cart functions
	function ezc_compress_files($archive_name, $file_list, $dirname = '') {
		if( empty($dirname) )
			$dirname = getcwd();
		return fn_compress_files($archive_name, $file_list, $dirname);
	}
	function ezc_decompress_files($archive_name, $dirname = '') {
		if( empty($dirname) )
			$dirname = getcwd();
		return fn_decompress_files($archive_name, $dirname);
	}
}

function addon_install_addon($addon, $archive, $as_copy=FALSE) {
	if( !$as_copy ) {
		// 2/11/14 - added dir parameter since cs-cart broke it when moving to the phar archive.
		// 2/28/14 - Tired of fighting with cs-cart.  Just use the old tar class
		$result = ezc_decompress_files($archive, './');
		addon_update_config($addon, array('installed' => 'Y', 'addon_data'=>array('last_upgrade'=>TIME)) );
		addon_install_lang_vars($addon, addon_silent_install($addon));
		addon_install_hooks($addon);
		return $result;
	} else {
		$cwd = getcwd();	// should this be DIR_ROOT?
		$var = Registry::get('config.dir.var');
		$ez_addon_arch = $var."ez_upgrade/addon_archive";
		$temp_root = "ez_addon_tmp_root";
		$res = @mkdir($temp_root);
		if( $res === false ) {
			ezc_log(__FUNCTION__.": mkdir($temp_root) failed, cwd=$cwd");
			return $res;
		}
		$res = @chdir($temp_root);
		if( $res === false ) {
			ezc_log(__FUNCTION__.": chdir($temp_root) failed, cwd=$cwd");
			return $res;
		}
		// 2/11/14 - added dir parameter since cs-cart broke it when moving to the phar archive.
		// 2/28/14 - Tired of fighting with cs-cart.  Just use the old tar class
		$result = ezc_decompress_files($ez_addon_arch, './');
		fn_copy(".", $cwd);
		chdir($cwd);
		fn_rm($temp_root);
		if( $addon == 'ez_common' ) {
			ez_enable();
		}
		return $result;
	}
	ezc_log("Installed addon '$addon'");
}

function addon_addon_skin_repository($addon, $area) {
	$all = array('admin' => "design/backend/templates/addons/$addon",
				 'themes' => "var/themes_repository/basic/templates/addons/$addon",
				 'mail' => "var/themes_repository/basic/mail/addons/$addon"
				 );
	switch($area) {
		case 'admin':
			return $all['admin'];
		case 'themes':
		case 'customer':	// compatibility
			return $all['themes'];
		case 'mail':
			return $all['mail'];
		case 'all':
			return $all;
		default:
			fn_set_notification('E', $addon, $s = __FUNCTION__.": Unknown area '$area'", true);
			ezc_log($s);
			break;
	}
	return "XXX";
}


function addon_backup_addon($addon) {
	if( !is_dir(Registry::get('config.dir.addons').$addon) )
		return;		// nothing to backup
	$all_repositories = addon_addon_skin_repository($addon, 'all');
	$c_repository_dir = $all_repositories['themes'];
	$a_repository_dir = $all_repositories['admin'];
	$m_repository_dir = $all_repositories['mail'];
	$cwd = getcwd();
	$var = Registry::get('config.dir.var');
	$ez_addon_arch = $var."ez_upgrade/addon_archive";
	$ez_backup_dir = "$ez_addon_arch/backup";
	if( !is_dir($ez_backup_dir) )
		fn_mkdir($ez_backup_dir);
	$temp_root = $ez_backup_dir."/tmp";
	$temp_addon = $temp_root."/app/addons/$addon";
	fn_mkdir($temp_addon);
	
	foreach($all_repositories as $area => $repo_path) {
		if( is_dir($repo_path) ) {
			fn_mkdir("$temp_root/$repo_path");
			fn_copy($repo_path, dirname("$temp_root/$repo_path"));
		}
	}
		
	fn_copy(Registry::get('config.dir.addons').$addon, dirname($temp_addon));
	
	// Make the archive of the existing addon
	$backup_archive_name = "{$addon}_v".addon_current_version($addon);
	chdir($temp_root);
	// 2/28/14 - Tired of fighting with cs-cart.  Just use the old tar class
	ezc_compress_files($backup_archive_name, ".");
	@unlink($ez_backup_dir."/$backup_archive_name");
	@link($backup_archive_name, $ez_backup_dir."/$backup_archive_name");
	@unlink($backup_archive_name);
	chdir($cwd);
	fn_rm($temp_root);	// Remove the tmp directory and files
}

function addon_upgrade($addon, $upgrade_version, $silent='', $enable=true) {
	if( defined('EZ_NO_UPGRADE') ) {
		fn_set_notification('W', "$addon Warning", "EZ_NO_UPGRADE is set, won't install version='$upgrade_version'", 'K');
	}
	if( $silent === '' )	// Not passed, get actual value
		$silent = addon_silent_install($addon);
		
	if( empty($upgrade_version) ) {	// Nothing to do
		if( !$silent ) 
			fn_set_notification("N", "$addon Notice", "addon $addon version '".addon_current_version($addon)."' is up to date");
		return 0;	// Use zero to indicate nothing done.
	}
	
	// Main Addon license/tools check
	$cart_ver = addon_cart_version($addon);
//	$config =  Registry::get("addons.$addon.config");
	$config = addon_get_config($addon);
	if( empty($config['cur_ver']) )
		addon_update_config($addon, $config = addon_default_config($addon));
	if( defined('EZ_NO_UPGRADE') )
		return 0;	// Nothing doneaddon_upgrade
	$cur_version = empty($config['cur_ver']) ? '' : $config['cur_ver'];
	$domain = $config['addon_data']["domain"];
	$url = $config['addon_data']["versionURL"];
	$key = addon_license_key($addon);
	$url .= "?dispatch=addon.get_addon&cart_ver=$cart_ver&type=addon&product=$addon&key=$key&dom=$domain&addon_version=$upgrade_version";
	$data = addon_postToURL($addon, $url);
	if( $data && addon_check_data($data) === FALSE ) {	// No data, but is encoded
		if( !$silent ) {
			$retAR = addon_decode_result($data);
			addon_set_message($addon, "$addon", $retAR);
		}
		return FALSE;
	} else if( !$data ) {	 // No data and no encoding
		if( !$silent )
			fn_set_notification("E", "$addon Error", "Unknown error $addon version $upgrade_version", true);
		return FALSE;
	} else {	// Is data, install it
		// store the new archive
		$ez_addon_arch = Registry::get('config.dir.var')."ez_upgrade/addon_archive";
		$archive_basename = "{$addon}_v$upgrade_version";
		$archive_filename = $archive_basename.".tgz";
		$archive_name = $ez_addon_arch."/$archive_filename";
		addon_save_archive($addon, $data, $archive_name);
		
		// copy the current addon so we can archive it
		addon_backup_addon($addon);
		
		// Install it 
		addon_install_addon($addon, $archive_name);
		addon_update_config($addon, array('installed'=>'Y', 'cur_ver'=>$upgrade_version, 'addon_data'=>array('last_upgrade'=>TIME)));
		addon_update_description($addon);
		addon_enable_addon($addon);
		addon_setup_permissions($addon);	// Makes entry in priviliges table.  Still needs permissions schema in addon
		
		// Any post install operations?
		if( file_exists($post_file = ez_fix_path(Registry::get('config.dir.addons')."$addon/upgrade/post_upgrade_$upgrade_version.php")) ) {
			// May use $cur_version to figure out where we came from...
			include($post_file);
		}
		if( file_exists($post_file = ez_fix_path(Registry::get('config.dir.addons')."$addon/upgrade/post_upgrade_all_versions.php")) ) {
			include($post_file);
		}
					
		// Clean up the cache
		// 12/22/12: V3.0.4 change
		if( function_exists('fn_clear_cache') ) {
			fn_clear_cache();
		} else {
			if( defined('DIR_CACHE') )
				fn_rm(DIR_CACHE);
			if( defined('DIR_COMPILED') )
				fn_rm(DIR_COMPILED);
		}
		// In therory, we should be done
		if( !$silent )
			fn_set_notification("N", "$addon Notice", "Updated to $archive_basename", true);
	}			
	return true;
}

function addon_enable_addon($addon) {
	if( !$addon )
		return;
	Registry::set("addons.$addon.status", "A");
	if( $addon == 'ez_common' )
		ez_enable();
	db_query("UPDATE ?:addons SET status='A' WHERE addon=?s", $addon);
}
	
function addon_setup_permissions($addon) {
	$manage_str = "manage_$addon";
	$name = addon_description_name($addon);
	$description = "Manage $name";
	if( !db_get_field("SELECT privilege FROM ?:privileges WHERE privilege=?s", $manage_str) ) {
			db_query("INSERT INTO ?:privileges (privilege, is_default, section_id) VALUES (?s, 'Y', 'addons')", $manage_str);
// Not in V4.1.x
//			db_query("INSERT INTO ?:privilege_descriptions (privilege, description, lang_code, section_id) VALUES (?s, ?s, ?s, '1')", $manage_str, $description, CART_LANGUAGE);
// Instead uses language variables
			$name = "privileges.manage_".$addon;
			$value = ucwords("Manage ".str_replace('_', ' ', $addon));
// Grr... 8/14/14: Seem to have removed this column in V4.2.1
			db_query("REPLACE INTO ?:language_values 
					 (lang_code, name, value) 
					 VALUES (?s, ?s, ?s)", 'en', $name, $value);
/*
			db_query("REPLACE INTO ?:language_values 
					 (lang_code, name, value, original_value) 
					 VALUES (?s, ?s, ?s, ?s)", 'en', $name, $value, $value);
*/
	}
}

/*
 * These are interal api calls
 */
function addon_version_parse($addon, $ver) {
		$ret = array("major"=>0, "minor"=>0, "point"=>0, "patch"=>0, "suffix"=>"");
		if( !$ver )
			return $ret;
		$x = explode(".", $ver);
		$ret["major"] = !empty($x[0]) ? $x[0] : 0;
		$ret["minor"] = !empty($x[1]) ? $x[1] : 0;
		$ret["point"] = !empty($x[2]) ? $x[2] : 0;
		$ret["patch"] = !empty($x[3]) ? $x[3] : 0;
		$ret["suffix"] = !empty($x[4]) ? $x[4] : "";
		return $ret;
}

function addon_version_cmp($addon, $cur_ver, $min_ver) {
	if( !$cur_ver && $min_ver )	// No cur_ver and there is a min_ver?
		return -1;			// force to new
	$curAR = addon_version_parse($addon, $cur_ver);
	$minAR = addon_version_parse($addon, $min_ver);
	
	$cmp = 0;
	foreach(array("major", "minor", "point", "patch") as $idx) {
		if( $cmp = ezc_only_numbers($curAR[$idx]) - ezc_only_numbers($minAR[$idx]) )
			return $cmp;
	}
	return $cmp;
}

function addon_silent_install($addon) {
	return Registry::get("addons.$addon.silent_install") == 'Y';
}
	
function addon_auto_install($addon) {
	return Registry::get("addons.$addon.auto_install") != 'N';
}

function addon_check_install($addon, $install_func='') {
	if( !addon_installed($addon) ) {
//	if( !Registry::get("addons.$addon.config.installed") || (Registry::get("addons.$addon.config.installed") == 'N') ) {
		$func = $install_func ? $install_func : "addon_install_setup";
		$func($addon);
	}
}

function addon_unset_installed($addon) {
	addon_update_options($addon, array('installed'=>'N'));
}

function addon_has_changelog($addon) {
	return Registry::get("addons.$addon.config.has_changelog") == 'Y';
}

function addon_changelog_link($addon) {
	$link_url = '';
	if( addon_has_changelog($addon) ) {
		$pattern = ';index.php;';
		$replace = "changelogs/$addon.html";
		$url = ezc_versionURL();
		$link_url = preg_replace($pattern, $replace, $url);
//		$link_url = 'http://ezupgrade.'.( (strstr($_SERVER['HTTP_HOST'], 'test.') 
//										   || strstr($_SERVER['HTTP_HOST'], '.test.')
//										   ) ? 'test.' 
//										     : '')."ez-ms.com/changelogs/$addon.html";
	}
	if( $link_url ) 
		return '<a target="_blank" href="'.$link_url.'">'."view $addon changelog here</a>";
	else
		return '';
}

	// Some debugging stuff
	//
function addon_myBacktrace($startAt=1, $depth=-1) {
	$btAR = debug_backtrace();
	if( !isset($btAR[$startAt]) ) {
		fn_set_notification('E', __FUNCTION__, " Debug Stack not '$startAt' deep!  Max is ".count($btAR) , true);
		return array();
	}
	$p = $btAR[$startAt];
	$bt = array(	'file' => $p['file'],
					'line'=>$p['line'],
					'function'=>$p['function'],
					'args'=>$p['args']
				);
	$stack = array();
	for($i=($startAt + 1); $depth && isset($btAR[$i]); $i++, $depth--)
		$stack[] = $btAR[$i]['function'].": line: ".$btAR[$i]['line'].": ".$btAR[$i]['file'];
	$bt['stack'] = $stack;
//		ez_log("$bt[function]: ".pr($bt));
	return print_r($bt,true);
}	// end function myBacktrace
	
//require_once(Registry::get('config.dir.addons')."ez_common/lib/hooks.php");

function addon_get_config($addon) {
	// Remove this in a month or so...  Compatibility
	static $table_checked = false;
	if( !$table_checked ) {
		ez_config_table();
		$table_checked = true;
	}
	static $addon_config = array();
	
	if( empty($addon_config[$addon]) ) {
		// End Remove
		$ar = db_get_row("SELECT * FROM ?:ez_common_config WHERE addon=?s", $addon);
		// 9/21/11
		if( !$ar ) {
			$ar = array();	//addon_default_config($addon);
		} elseif( !empty($ar['addon_data']) ) {
			$ar['addon_data'] = @unserialize($ar['addon_data']);
			// 3/26/18: Added to support EZ_UPGRADE_URL define
			$ar['addon_data']['versionURL'] = ezc_versionURL();
		}
		$addon_config[$addon] = $ar;
	}
	Registry::set("addons.$addon.config", $addon_config[$addon]);
//ezc_log(__FUNCTION__.": addon_config[$addon]:".print_r($addon_config[$addon],true));
	return $addon_config[$addon];
}

function addon_update_config($addon, $config_ar) {
	$cur = addon_get_config($addon);
	
	if( empty($config_ar['addon_data']) )
		$config_ar['addon_data'] = array();
		
	if( !empty($cur['addon_data']) )
		$config_ar['addon_data'] = array_merge($cur['addon_data'], $config_ar['addon_data']);
		
	$config_ar['addon_data'] = serialize($config_ar['addon_data']);
	if( empty($config_ar['addon']) )
		$config_ar['addon'] = $addon;
		
	if( isset($cur['cur_ver']) ) {    // exists
		db_query("UPDATE ?:ez_common_config SET ?u WHERE addon=?s", $config_ar, $addon);
	} else {
		db_query("INSERT INTO ?:ez_common_config ?e", $config_ar);
	}
	return addon_get_config($addon);
}

function addon_installed_languages($addon) {
	$lang_info = db_get_fields("SELECT lang_code FROM ?:languages");
	if( empty($lang_info) )
		$lang_info = array('en');
	return $lang_info;
}

// 12/16/15: Added force parameter
function addon_install_lang_vars($addon, $silent=false, $force=false) {
	// 4/30/13 - eliminate need for {$addon}_lang_var() function
	if( file_exists($f = ez_fix_path(Registry::get('config.dir.addons')."$addon/lib/lang_vars.php")) )
		include($f);
	$cnt = 0;
	if( !empty($lang_vars) ) {
		$langs = addon_installed_languages($addon);
		foreach($lang_vars as $var => $val) {
			if( $force || !($cur = db_get_field("SELECT name FROM ?:language_values WHERE name=?s AND lang_code='en'", $var)) /* || $cur != $val */ ) {
				$cnt++;
				foreach($langs as $lang) {
					$dat = array('lang_code' => $lang, 'name' => $var, 'value' => $val);
					db_query("REPLACE INTO ?:language_values ?e", $dat);
				}
			}
		}
	}
	if( $cnt && !$silent ) {
		$msg = sprintf("Installed %d language variables into %d languages", $cnt, count($langs));
		fn_set_notification('N', "$addon Notice", $msg, true);
	}
}
	
function ez_config_table() {
	static $created = false;
	if( !$created ) {
		db_query("CREATE TABLE IF NOT EXISTS `?:ez_common_config` (
				  `addon` varchar(32) NOT NULL,
				  `cur_ver` varchar(32) NOT NULL,
				  `depends_on` varchar(32) NOT NULL,
				  `min_cart_version` varchar(32) NOT NULL,
				  `max_cart_version` varchar(32) NOT NULL,
				  `next_upgrade` int(11) NOT NULL,
				  `has_changelog` char(1) NOT NULL,
				  `installed` char(1) NOT NULL,
				  `addon_data` text NOT NULL,
				  PRIMARY KEY  (`addon`)
			) ENGINE=MyISAM DEFAULT CHARSET=utf8");
	}
	$created = true;
}


// HOOKS
//

function ez_common_add_hooks($addon) { return addon_install_hooks($addon); }
function addon_install_hooks($addon) {
	$result = true;
	// 4/30/13 - eliminate need for {$addon}_lang_var() function
	if( file_exists($f = ez_fix_path(Registry::get('config.dir.addons')."$addon/lib/hook_vars.php")) )
		include($f);
	if( empty($hooks) )
		return $result;
	
	$returnAR = addon_add_tpl_hooks($addon, $hooks);
	foreach($returnAR as $filename => $r)
		if( $r === FALSE )
			$result = FALSE;
			
	$returnAR = addon_add_php_hooks($addon, $hooks);
	foreach($returnAR as $filename => $r)
		if( $r === FALSE )
			$result = FALSE;
	return $result;
}

function addon_add_php_hooks($addon_name, $hook_data) {
/* addon_hooks has the form
 /*
// Don't mess with this unless you really know what you're doing!
$hooks = array('php' => array( Registry::get('config.dir.functions')."fn.common.php => array(
								   				'name'=>'send_mail',	// hook name I.e. name="section.name"
												'args' => '$mail',		// arguments for the set_hook() function
												'pattern' => 'foreach \(__to.*}',	// pattern for the source file to be "hooked"
												'type' => 'post',		// one of override, pre, post
												'match_idx' => 0			// match index of the pattern to match
								)
						)
					);
																						  
	*/
//	$hook_data = Registry::get("addons.$addon_name.hooks");
	if( !$hook_data )
		$hook_data = array();
	$silent = addon_silent_install($addon_name);
	
	$ret = array();
	if( !empty($hook_data['php']) ) {
		foreach($hook_data['php'] as $filename => $hook_specs) {
			$ot_file = $filename;
			$ot_file_contents = file_get_contents($ot_file);
			$ret[$filename] = TRUE;
			$ot_out = '';
			switch($hook_specs['type']) {
				case 'comment':
					$hook_pattern = ';EZms Comment.*'.$hook_specs['name'].';';
					break;
				default:
					$hook_pattern = ';fn_set_hook.*'.$hook_specs['name'].';';
					break;
			}
			if( !preg_match($hook_pattern, $ot_file_contents) ) {
				$pattern = $hook_specs['pattern'];
				$matches = array();
				$result = preg_match($pattern, $ot_file_contents, $matches);
				if( $result && $matches ) {
					$str_block = $matches[$hook_specs['match_idx']];
					$hook_start = "/** EZms add hook $hook_specs[name] **/\n\tfn_set_hook('$hook_specs[name]'".(!empty($hook_specs['args']) ? ", $hook_specs[args]" : '').");\n\t";
					switch($hook_specs['type']) {
						case 'pre':
							$str_replace = $hook_start.$str_block;
							break;
						case 'post':
							$str_replace = $str_block."\n\t".$hook_start;
							break;
						case 'override':
							$str_replace = $hook_start;
							break;
						case 'comment':
							$hook_start = "/** EZms Comment out for $hook_specs[name] **/";
							$str_replace = $hook_start.str_replace("\n", "\n//", $str_block)."\n\t/** End EZms Comment out **/\n";
							break;
						default: 
							fn_set_notification('E', "$addon_name Error", "Unsupported hook type '$hook_specs[type]'", true);
							return FALSE;
					}
					$start = strpos($ot_file_contents, $str_block);
					$len = strlen($str_block);
					$ot_out = substr_replace($ot_file_contents, $str_replace, $start, $len);
				}
		
				if( !$ot_out || ($ot_out == $ot_file_contents) ) {
					fn_set_notification('E', "$addon_name Error", "did not successfully add $hook_specs[name] hook", true);
					$ret[$filename] = FALSE;
				} else if( $ot_out ) {
					file_put_contents($ot_file, $ot_out);
					if( !$silent )	// silent install
						fn_set_notification('N', "$addon_name Notice", "Added hook: '$hook_specs[name]' to $ot_file", true);
				}
			} else if( !$silent ) {
				fn_set_notification('N', "$addon_name Notice", "'$hook_specs[name]' hook already installed");
			}
		}	// foreach hook_data
	}	// hook_data[php]
	return $ret;
}

function addon_repo_root() {
	$repo_root='base';
	if( defined('PRODUCT_VERSION') && version_compare(PRODUCT_VERSION, '3.0', '>=') )
		$repo_root='basic';
	return $repo_root;
}


?>