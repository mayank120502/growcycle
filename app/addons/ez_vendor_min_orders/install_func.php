<?php

/*
 * Copyright 2021 1st Source4 IT, LLC, EZ Merchant Solutions
 * All rights reserved.
 * Resale prohibited.
 */
if( !defined('BOOTSTRAP') ) die('Access denied');
use Tygh\Registry;
use Tygh\Languages;
use Tygh\Languages\Po;

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
	// If an install or force, create the po file/language variables.
	$force_po = Registry::get('runtime.controller') == 'addons'
				|| (Registry::get('runtime.controller') == 'ez_vendor_min_orders' && Registry::get('runtime.mode') == 'check_install');
	if( $force_po || $force ) {
		foreach($langs as $lang) {
			ez_vendor_min_orders_create_po_file("var/langs/{$lang}/addons/ez_vendor_min_orders.po", $lang_vars);
		}
	}
	if( $cnt ) {
		$msg = sprintf("%s: Installed %d language variables into %d languages", Registry::get('runtime.controller'), $cnt, count($langs));
		fn_set_notification('N', __("notice"), $msg, 'K');
	}
}

function ez_vendor_min_orders_create_po_file($po_file, $lang_vars) {
	include(($d=dirname(__FILE__))."/lib/lang_vars.php");
	$dx = explode('/', $d);
	$addon = $dx[count($dx)-1];
	$cnt = 0;
	if( empty($lang_vars) ) 
		return;
		// Get existing po file addon entries
	$po_text = ez_vendor_min_orders_get_addon_po_entries($addon, 'en');

	foreach($lang_vars as $var => $val) {
			$po_text .= 
"msgctxt \"Languages::$var\"
msgid \"$val\"
msgstr \"$val\"

";
	}
		
	$res = file_put_contents($po_file, $po_text);
	if( $res === false )
		fn_set_notification("E", __("error"), "Failed to create po file '$po_file': <pre>".print_r(error_get_last(),true)."</pre>", 'K');
}

function ez_vendor_min_orders_get_addon_po_entries($addon_name, $lang_code='en') {
	$values = Po::getValues(sprintf("%slangs/%s/addons/%s.po", Registry::get('config.dir.var'), $lang_code, $addon_name));
	$saved_entries = array();
	foreach($values as $id => $data) {
		if( strpos($id, 'Languages::') === 0 )
			continue;	// Skip languages
		$saved_entries[$id] = $data;
	}
	if( empty($saved_entries)) {	// No existing PO file.  Create the primary entries
		$saved_entries[''] = array(
										'msgid' => '',
										'msgstr' => array(
                    										0 => 'Project-Id-Version: tygh',
                    										1 => 'Content-Type: text/plain; charset=UTF-8',
                    										2 => 'Language-Team: English',
                    										3 => 'Language: en_US'
                    									),
                    					'msgctxt' =>  '',
                    					'id' => '',
                    					'parent' => '',
                    					'section' => '',
                    			  );
		$saved_entries["Addons::name::$addon_name"] = array
        (
            'msgctxt' => "Addons::name::$addon_name",
            'msgid' => "$addon_name",
            'msgstr' => array(0 => "$addon_name"),
            'id' => "$addon_name",
            'parent' => 'name',
            'section' => ''
        );

		$saveed_entries["Addons::description::$addon_name"] = array
        (
            'msgctxt' => "Addons::description::$addon_name",
            'msgid' => "$addon_name description",
            'msgstr' => array(0 => "$addon_name description"),
            'id' => $addon_name,
            'parent' => 'description',
            'section' => ''
        );
	}
	
	$po_text = 
"msgid \"\"
msgstr \"Project-Id-Version: tygh\"
\"Content-Type: text/plain; charset=UTF-8\"
\"Language-Team: English\"
\"Language: en_US\"

";

	foreach($saved_entries as $id => $po_data) {
		if( empty($id) )	// Header
			continue;
		$po_text .=
"msgctxt \"{$po_data['msgctxt']}\"
msgid \"{$po_data['msgid']}\"
msgstr \"{$po_data['msgstr'][0]}\"

";
	}
	

	
	return $po_text;
}

function ez_vendor_min_orders_install($params=array()) {
	$d=dirname(__FILE__);
	$dx = explode('/', $d);
	$addon_name = $dx[count($dx)-1];
	$verbose = !empty($params['verbose']);
	$messages = array();

	$force = false;
	foreach($params as $k => $v) {
		switch($k) {
			case 'install_templates':
				if( $v ) {
					$repo_dir = "var/themes_repository/responsive/templates/addons/$addon_name";
					if( $verbose ) print( ez_vendor_min_orders_log("Installing templates from $repo_dir")."\n");
					foreach(glob("design/themes/*", GLOB_ONLYDIR) as $dir) {
						if($verbose) print( ez_vendor_min_orders_log("\t$dir/templates/addons/$addon_name")."\n");
						fn_copy($repo_dir, "$dir/templates/addons/$addon_name");
					}
				}
				break;
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
	if( $verbose ) die( $addon_name."_log"("Clear caches... Done"));
}


?>