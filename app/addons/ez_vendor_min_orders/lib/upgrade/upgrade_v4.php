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

// Version 4 version
function ez_enable() {
	$data = array('addon' => 'ez_common',
			  'status' => 'A',
			  'version' => '',
			  'priority' => 0,
			  'dependencies' => '',
			  'separate' => 0
			  );
	db_query("REPLACE INTO ?:addons ?e", $data);

	$data = array('addon' => 'ez_common',
			  'name' => "EZ Common Addon Tools",
			  'description' => "Common functions/tools used by EZ Merchant Solutions addon products",
			  'lang_code' => 'en'
			  );
	db_query("REPLACE INTO ?:addon_descriptions ?e", $data);
	
	$addon_section_id = Settings::instance()->updateSection(array(
		'parent_id'    => 0,
		'edition_type' => 'ROOT',
		'name'         => 'ez_common',
		 'type'        => Settings::ADDON_SECTION,
	));
	
}

function addon_description($addon) {
	static $desc = array();
	if( isset($desc[$addon]) )
		return $desc[$addon];
	return $desc[$addon] = db_get_field("SELECT description FROM ?:addon_descriptions WHERE addon=?s AND lang_code=?s", $addon, CART_LANGUAGE);
}

function addon_description_name($addon) {
	static $names = array();
	if( isset($names[$addon]) )
		return $names[$addon];
	return $names[$addon] = db_get_field("SELECT name FROM ?:addon_descriptions WHERE addon=?s AND lang_code=?s", $addon, CART_LANGUAGE);
}

function addon_update_description($addon) {
	if (file_exists(Registry::get('config.dir.addons') . $addon . '/addon.xml')) {
		$xml = simplexml_load_file(Registry::get('config.dir.addons') . $addon . '/addon.xml');
		$name = (string)$xml->name;
		$description = (string)$xml->description;
		if( empty($addon) && ($name || $description)) {
			fn_set_notification('E', 'EZ Common Tools Error', "addon not set in ".__FUNCTION__.", options not updated.", true);
		} else if($name || $description) {
			db_query("REPLACE INTO ?:addon_descriptions SET addon=?s, name=?s, description=?s, lang_code=?s", $addon, (string)$name, (string)$description, CART_LANGUAGE);
		}
	}
}
	
function addon_license_key($addon) {
	addon_init($addon);
	$key = Registry::get("addons.$addon.license_key");
	if( !$key ) {
		$uc_settings = Settings::instance()->getValues("Upgrade_center");
		$key = $uc_settings['license_number'];
	}
	return trim($key);
}

function addon_get_short_companies() {
	$params = array('status'=>'A');
	return fn_get_short_companies($params);
}
function addon_get_store_count() {
	return count(addon_get_short_companies());
}

function addon_add_tpl_hooks($addon_name, $addon_hooks, $areas=array()) {
/* addon_hooks has the form
 /*
// Don't mess with this unless you really know what you're doing!
$hooks = array('themes' => array( 'views/checkout/summary.tpl' => array(
								   				'name'=>'custom_summary',	// hook name I.e. name="section.name"
												'section' => 'checkout',	// section for the hook name I.e. name="section:name"
												'pattern' => '<p>\{\$lang.text_customer_notes\}:</p>\).*</textarea>',	// pattern for the source file to be "hooked"
												'type' => 'override',		// one of override, pre, post
												'match_idx' => 0			// match index of the pattern to match
																		)
			   					)
					);
																						  
	*/
//	$addon_hooks = Registry::get("addons.$addon_name.hooks");
	if( !$addon_hooks )
		$addon_hooks = array();
	$silent = addon_silent_install($addon_name);
	
	if( !$areas )
		$tmpl_areas = array('customer', 'admin', 'mail');
	else
		$tmpl_areas = $areas;
	$ret = array();
	foreach($addon_hooks as $area_name => $hook_data) {
		if( !in_array($area_name, $tmpl_areas) )
			continue;
		// Running in Admin area A
		if( $area_name == 'customer' || $area_name == 'mail' && fn_allowed_for('ULTIMATE') ) {
			foreach( fn_get_all_companies_ids() as $company ) {
				$installed_themes = fn_get_installed_themes($company);
				$design_dir = fn_get_theme_path('[themes]/', 'C', $company);
				foreach($installed_themes as $theme_name) {
					if( $area_name == 'customer' )
						$area_name = 'templates';
					$path = "$design_dir$theme_name/$area_name/";
//ezc_log(sprintf("%s: ULTIMATE: area_name=%s, path=%s, company=%d", __FUNCTION__, $area_name, $path, $company), false, logDetail);
					foreach($hook_data as $filename => $hook_specs) {
						$ot_file = "$path/$filename";
						$ot_file_contents = file_get_contents($ot_file);
						$ret[$company][$filename] = TRUE;
						$ot_out = '';
						if( strpos($ot_file_contents, $hook_specs['name']) === FALSE ) {
							$pattern = $hook_specs['pattern'];
							$matches = array();
							$result = preg_match($pattern, $ot_file_contents, $matches);
							if( $result && $matches ) {
								$str_block = $matches[$hook_specs['match_idx']];
								$hook_start = "{** EZms add hook $hook_specs[name] **}\n\t{hook name=\"$hook_specs[section]:$hook_specs[name]\"}\n\t";
								$hook_end = "\n\t{/hook}\t{** EZms end hook $hook_specs[name] **}\n";
								switch($hook_specs['type']) {
									case 'comment':
										$str_replace = "{** EZms add comment_out for $hook_specs[name]\n\t".$str_block."\n\tEnd EZms comment_out **}";
										break;
									case 'pre':
										$str_replace = $hook_start.$hook_end.$str_block;
										break;
									case 'post':
										$str_replace = $str_block."\n\t".$hook_start.$hook_end;
										break;
									case 'override':
										$str_replace = $hook_start.$str_block.$hook_end;
										break;
									default:
										fn_set_notification('E', "$addon_name Error", "Unknown hook type '$hook_specs[type]' for company=$company", true);
										return FALSE;
										break;
								}
								$start = strpos($ot_file_contents, $str_block);
								$len = strlen($str_block);
								$ot_out = substr_replace($ot_file_contents, $str_replace, $start, $len);
							}	// if result && matches
				
							if( !$ot_out || ($ot_out == $ot_file_contents) ) {
								fn_set_notification('E', "$addon_name Error", "did not add '$path/$hook_specs[name]' hook for company=$company", true);
								$ret[$company][$filename] = FALSE;
							} else if( $ot_out ) {
								file_put_contents($ot_file, $ot_out);
								if( !$silent )	// silent install
									fn_set_notification('N', "$addon_name Notice", "Added hook: '$hook_specs[name]' to '$ot_file' for company=$company", true);
							}
						} else if( !$silent ) {
							fn_set_notification('N', "$addon_name Notice", "'$hook_specs[name]' hook already installed for company=$company");
						}
					}	// foreach hook_data
				}	// foreach installed_themes
			} // foreach skin_paths
		} elseif( $area_name == 'customer' || $area_name == 'mail' ) {	// MVE - no companies
			$installed_themes = fn_get_installed_themes($company);
			$design_dir = fn_get_theme_path('[themes]/', 'C', $company);
			foreach($installed_themes as $theme_name) {
				if( $area_name == 'customer' )
					$area_name = 'templates';
				$path = "$design_dir$theme_name/$area_name/";
//ezc_log(sprintf("%s: MVE: area_name=%s, path=%s, company=%d", __FUNCTION__, $area_name, $path, $company), false, logDetail);
				foreach($hook_data as $filename => $hook_specs) {
					$ot_file = "$path/$filename";
					$ot_file_contents = file_get_contents($ot_file);
					$ret[$company][$filename] = TRUE;
					$ot_out = '';
					if( strpos($ot_file_contents, $hook_specs['name']) === FALSE ) {
						$pattern = $hook_specs['pattern'];
						$matches = array();
						$result = preg_match($pattern, $ot_file_contents, $matches);
						if( $result && $matches ) {
							$str_block = $matches[$hook_specs['match_idx']];
							$hook_start = "{** EZms add hook $hook_specs[name] **}\n\t{hook name=\"$hook_specs[section]:$hook_specs[name]\"}\n\t";
							$hook_end = "\n\t{/hook}\t{** EZms end hook $hook_specs[name] **}\n";
							switch($hook_specs['type']) {
								case 'comment':
									$str_replace = "{** EZms add comment_out for $hook_specs[name]\n\t".$str_block."\n\tEnd EZms comment_out **}";
									break;
								case 'pre':
									$str_replace = $hook_start.$hook_end.$str_block;
									break;
								case 'post':
									$str_replace = $str_block."\n\t".$hook_start.$hook_end;
									break;
								case 'override':
									$str_replace = $hook_start.$str_block.$hook_end;
									break;
								default:
									fn_set_notification('E', "$addon_name Error", "Unknown hook type '$hook_specs[type]", true);
									return FALSE;
									break;
							}
							$start = strpos($ot_file_contents, $str_block);
							$len = strlen($str_block);
							$ot_out = substr_replace($ot_file_contents, $str_replace, $start, $len);
						}	// if result && matches
			
						if( !$ot_out || ($ot_out == $ot_file_contents) ) {
							fn_set_notification('E', "$addon_name Error", "did not add '$path/$hook_specs[name]' hook for company=$company", true);
							$ret[$company][$filename] = FALSE;
						} else if( $ot_out ) {
							file_put_contents($ot_file, $ot_out);
							if( !$silent )	// silent install
								fn_set_notification('N', "$addon_name Notice", "Added hook: '$hook_specs[name]' to '$ot_file' for company=$company", true);
						}
					} else if( !$silent ) {
						fn_set_notification('N', "$addon_name Notice", "'$hook_specs[name]' hook already installed for company=$company");
					}
				}	// foreach hook_data
			}	// foreach installed_themes		
		} else {	// Admin	// if customer or mail
			$path = "design/backend/templates";
			$company = 0;
//ezc_log(sprintf("%s: Admin: area_name=%s, path=%s, company=%d", __FUNCTION__, $area_name, $path, $company), false, logDetail);
			foreach($hook_data as $filename => $hook_specs) {
				$ot_file = "$path/$filename";
				$ot_file_contents = file_get_contents($ot_file);
				$ret[$company][$filename] = TRUE;
				$ot_out = '';
				if( strpos($ot_file_contents, $hook_specs['name']) === FALSE ) {
					$pattern = $hook_specs['pattern'];
					$matches = array();
					$result = preg_match($pattern, $ot_file_contents, $matches);
					if( $result && $matches ) {
						$str_block = $matches[$hook_specs['match_idx']];
						$hook_start = "{** EZms add hook $hook_specs[name] **}\n\t{hook name=\"$hook_specs[section]:$hook_specs[name]\"}\n\t";
						$hook_end = "\n\t{/hook}\t{** EZms end hook $hook_specs[name] **}\n";
						switch($hook_specs['type']) {
							case 'comment':
								$str_replace = "{** EZms add comment_out for $hook_specs[name]\n\t".$str_block."\n\tEnd EZms comment_out **}";
								break;
							case 'pre':
								$str_replace = $hook_start.$hook_end.$str_block;
								break;
							case 'post':
								$str_replace = $str_block."\n\t".$hook_start.$hook_end;
								break;
							case 'override':
								$str_replace = $hook_start.$str_block.$hook_end;
								break;
							default:
								fn_set_notification('E', "$addon_name Error", "Unknown hook type '$hook_specs[type]", true);
								return FALSE;
								break;
						}
						$start = strpos($ot_file_contents, $str_block);
						$len = strlen($str_block);
						$ot_out = substr_replace($ot_file_contents, $str_replace, $start, $len);
					}	// if result && matches
		
					if( !$ot_out || ($ot_out == $ot_file_contents) ) {
						fn_set_notification('E', "$addon_name Error", "did not add '$path/$hook_specs[name]' hook for company=$company", true);
						$ret[$company][$filename] = FALSE;
					} else if( $ot_out ) {
						file_put_contents($ot_file, $ot_out);
						if( !$silent )	// silent install
							fn_set_notification('N', "$addon_name Notice", "Added hook: '$hook_specs[name]' to '$ot_file' for company=$company", true);
					}
				} else if( !$silent ) {
					fn_set_notification('N', "$addon_name Notice", "'$hook_specs[name]' hook already installed for company=$company");
				}
			}	// foreach hook_data
		}
	}	// foreach hook
	return $ret;
}

// Note: area names no longer supported for V4
function addon_install_skins($addon, $area_names=array()) {
	return fn_install_addon_templates($addon);
}

function addon_check_license($addon) {
	static $checked_licenses = array();
	static $connection_timed_out = false;
	
	if( isset($checked_licenses[$addon]) )
		return $checked_licenses[$addon];
		
	$key = addon_license_key($addon);
	if($connection_timed_out || Registry::get('ez_connection_timed_out') )
		return $key;
	
	$config =  Registry::get("addons.$addon.config");
	if( empty($config['cur_ver']) )
		addon_update_config($addon, $config = addon_default_config($addon));
	// 6/8/18 - added protection
	$domain = empty($config['addon_data']["domain"]) ? $_SERVER['HTTP_HOST'] : $config['addon_data']["domain"];
	$url = $config['addon_data']["versionURL"];
	$stores = addon_get_store_count();
	$url .= "?dispatch=addon.license.check&type=addon&product=$addon&key=$key&dom=$domain&stores=$stores";
	$result = addon_postToURL($addon, $url);
	if( strpos($result, "Curl Error") === 0 ) {
		// Display once
		if( !$connection_timed_out ) {
			// Don't show, but log instead
//			fn_set_notification('E', "$addon Error", $result, true);
			ez_log(__FUNCTION__.": $result", false, logLog);
		}
		Registry::set('ez_connection_timed_out', $connection_timed_out = true);
		return $checked_licenses[$addon] = $key;	// Curl error always return okay...
	}
	$retAR = addon_decode_result($result);
	if( !$retAR["value"] ) {	// bad license show message - silent otherwise
		addon_set_message($addon, "$addon Error", $retAR);
	}
	return $checked_licenses[$addon] = $retAR["value"];
}
	
function addon_product_edition() {
	return defined('PRODUCT_EDITION') ? PRODUCT_EDITION : 'ULTIMATE';
}

function addon_install_templates($addon, $message_type='return') {
	$repo_dir = "var/themes_repository/responsive/templates/addons/$addon";
	$msg[] = "Installing templates from $repo_dir";
	foreach(glob("design/themes/*", GLOB_ONLYDIR) as $dir) {
		$msg[] = "\t$dir/templates/addons/$addon";
		fn_copy($repo_dir, "$dir/templates/addons/$addon");
	}
	switch($message_type) {
		case 'screen':
			echo implode("\n", $msg);
			break;
		case 'notice':
			fn_set_notification('N', __('notice'), "<pre>".implode("\n", $msg)."</pre>", 'K');
			break;
		case 'return':
			return implode("\n", $msg);
		default:
			if( $message_type ) // function name
				$message_type(implode("\n", $msg) );
			break;
	}
}

?>