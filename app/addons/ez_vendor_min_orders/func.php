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

if ( !defined('BOOTSTRAP') ) { die('Access denied'); }
use Tygh\Registry;

// Do the first installation stuff
function ez_vendor_min_orders_install_setup() {
	addon_install_setup('ez_vendor_min_orders');
}

if( !function_exists('ez_fix_path') ) {
	function ez_fix_path($s) {
		if( DIRECTORY_SEPARATOR != '/' )
			$s = str_replace('/', DIRECTORY_SEPARATOR, $s);
		return $s;
	}
}

if( file_exists($f = __DIR__."/install_func.php") ) {
	include($f);
} else {
	function ez_vendor_min_orders_install_lang_vars($force=false) {
		include(dirname(__FILE__)."/lib/lang_vars.php");
		$cnt = 0;
		if( !empty($lang_vars) ) {
			$langs = db_get_fields("SELECT lang_code FROM ?:languages");
			if( empty($langs) )
				$langs = array('en');
	
			foreach($lang_vars as $var => $val) {
				if( $force || (!($cur = db_get_field("SELECT name FROM ?:language_values WHERE name=?s AND lang_code='en'", $var))) ) {
					$cnt++;
					foreach($langs as $lang) {
						$dat = array('lang_code' => $lang, 'name' => $var, 'value' => $val);
						db_query("REPLACE INTO ?:language_values ?e", $dat);
					}
				}
			}
		}
		
		if( $force ) {
			foreach($langs as $lang) {
				ez_vendor_min_orders_create_po_file("var/langs/{$lang}/addons/ez_vendor_min_orders.po", $lang_vars);
			}
		}
		$messages = array();
		if( $cnt ) {
			$messages[] = sprintf("%s: Installed %d language variables into %d languages", Registry::get('runtime.controller'), $cnt, count($langs));
		}
		return $messages;
	}
	
	function ez_vendor_min_orders_create_po_file($po_file, $lang_vars) {
		include(($d=dirname(__FILE__))."/lib/lang_vars.php");
		$dx = explode('/', $d);
		$addon = $dx[count($dx)-1];
		$cnt = 0;
		if( !empty($lang_vars) ) {
			$po_str = 'msgid ""
	msgstr "Project-Id-Version: tygh"
	"Content-Type: text/plain; charset=UTF-8\n"
	"Language-Team: English\n"
	"Language: en_US"
	
	';
			foreach($lang_vars as $var => $val) {
				$po_str .= '
	msgctxt "Languages::'.$var.'"
	msgid "'.$val.'"
	msgstr "'.$val.'"
	';
			}
			$res = file_put_contents($po_file, $po_str);
			if( $res === false )
				fn_set_notification("E", __("error"), "Failed to create po file '$po_file': <pre>".print_r(error_get_last(),true)."</pre>", 'K');
		}
	}
	
	function ez_vendor_min_orders_install($params=array()) {
		$d=dirname(__FILE__);
		$dx = explode('/', $d);
		$addon_name = $dx[count($dx)-1];
		$verbose = !empty($params['verbose']);
		$messages = array();
		
		if( !class_exists('ez_vendor_min_orders_log') && file_exists($f = __DIR__."/class.log.php"))
			include($f);
	
		$force = false;
		foreach($params as $k => $v) {
			switch($k) {
	/*
				case 'install_templates':
					if( $v ) {
						$repo_dir = "var/themes_repository/responsive/templates/addons/$addon_name";
						if( $verbose ) print( vmo_log("Installing templates from $repo_dir")."\n");
						foreach(glob("design/themes/*", GLOB_ONLYDIR) as $dir) {
							if($verbose) print( vmo_log("\t$dir/templates/addons/$addon_name")."\n");
							fn_copy($repo_dir, "$dir/templates/addons/$addon_name");
						}
					}
					break;
	*/
				case 'force':
					$force = $v;
					break;
			}
		}
		$func = $addon_name."_install_lang_vars";
		$result = $func($force);
		if( $result )
			$messages += $result;
		
		// Do any DB adjustments
		$result = ez_vendor_min_orders_db_setup($params);
		if($result)
			$messages += $result;
			
		// Clear all the caches
		fn_clear_cache();
		fn_clear_template_cache();
		
		if( $messages ) fn_set_notification('N', __("notice"), implode("<br/>", $messages), 'K');
		if( $verbose ) die( ezm_log("Clear caches... Done"));
	}
}	// else file_esists

function ez_vendor_min_orders_db_setup($params=array()) {
	$verbose = $force = false;
	
	$d=dirname(__FILE__);
	$dx = explode('/', $d);
	$addon_name = $dx[count($dx)-1];
	$messages = array();

	$alter_tables = array(
			'?:companies' => array('vendor_min_order_amount' => "ALTER TABLE ?:companies ADD COLUMN vendor_min_order_amount decimal(12,2) default 0.00")
	);

	foreach($params as $k => $v) {
		switch($k) {
			case 'verbose':
				$verbose = true;
				break;
			case 'force':
				$force = $v;
				break;
		}
	}
	
	// DB Adjustments
	foreach($alter_tables as $tbl => $tbl_data) {
		$fields = fn_get_table_fields($tbl_base = str_replace('?:', '', $tbl));
		foreach($tbl_data as $fld => $verb) {
			$msg = "";
			if( strpos($verb, 'ADD COLUMN') !== false) {	// Adds will fail if exists
				if( !in_array($fld, $fields)) {
					db_query($verb);
					$msg = vmo_log("Altered table '$tbl' '$verb'");
					$messages[] = $msg;
				}
			} else {
				db_query($verb);
				$msg = vmo_log("Altered table '$tbl' '$verb'");
				$messages[] = $msg;
			}
			if( $verbose && $msg) print($msg."\n");
		}	// foreach
	}	// foreach
	return $messages;
}


// Addon specific Hooks and functions go here

function vmo_log($s, $level=0) { return vmo_dbg($s, false, $level);}
function vmo_dbg($s, $pre=false, $level=0) {
	if( $pre ) printf("<pre>%s</pre>", htmlspecialchars($s));
	elseif( class_exists('ez_log') ) ez_log::add_msg('ez_vendor_min_orders', $s, $level);
	elseif( class_exists('ez_vendor_min_orders_log') ) ez_vendor_min_orders_log::add_msg($s, $level);
	return $s;
}



function vendor_min_order_get_companies() {
	return db_get_hash_array("SELECT company, company_id, vendor_min_order_amount FROM ?:companies WHERE vendor_min_order_amount > 0", 'company_id');
}
?>