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
use Tygh\Registry;

if( !class_exists('ez_vendor_min_orders_log') ) {
$dir_ar = explode('/', dirname(__FILE__));
$addon_name = array_pop($dir_ar);

define('ez_vendor_min_orders_log_logfilename', "/${addon_name}.log");
define('ez_vendor_min_orders_log_logdir', dirname(__FILE__));
define('ez_vendor_min_orders_log_logfile', ez_vendor_min_orders_log_logdir.ez_vendor_min_orders_log_logfilename);
define('ez_vendor_min_orders_log_end_record', "\r\n");

if( !defined('logAll') ) {
	define('logAll', 0);
	define('logInfo', 1);
	define('logLog', logInfo);
	define('logTrace', 2);
	define('logDetail', 3);
}

class ez_vendor_min_orders_log {
	static $buf = array();
	static $output = false;
	static $log_level = 0;
	static $log_area = 'A';
	static $testing = false;
	
	static function init($log_level=0, $output=false, $area = 'A', $display_errors=false) {
		// Too many issues from other addons and core cs-cart to have this be live on other than 
		// test environments....
		if( $display_errors ) {
			error_reporting(E_ALL);
			if( $output )
				ini_set('display_errors', true);
		}

		$err = true;
		if( !is_dir(ez_vendor_min_orders_log_logdir) )
			$err = @mkdir(ez_vendor_min_orders_log_logdir);
		if( $err )
			register_shutdown_function('ez_vendor_min_orders_log_dump_log');
		self::$output = $output;
		self::$log_level = $log_level;
		self::$log_area = $area;
	}
	
	static function add_msg($s, $level=0) {
		if( self::$log_level >= $level )
			self::$buf[] = $s;
	}
	
	static function show_log($entries=10) {
		$raw_log_entries = array_reverse(explode(ez_vendor_min_orders_log_end_record, @file_get_contents(ez_vendor_min_orders_log_logfile)));
		array_shift($raw_log_entries);		// Last (first) record will always be empty due to entries ending in ez_vendor_min_orders_log_end_record
		if( !current($raw_log_entries) )
			$raw_log_entries = array();
		$tot_entries = count($raw_log_entries);
		$entries = ($tot_entries > $entries) ? $entries : $tot_entries;
		echo "<pre>";
//		echo "Logfile: ".ez_vendor_min_orders_log_logfile."\n";
		if( $entries ) {
			echo "Total log entries: ".count($raw_log_entries)."\n";
			echo "Showing $entries entries\n";
			for($i=0; $i < $entries && isset($raw_log_entries[$i]); $i++)
				echo $raw_log_entries[$i];
		} else {
			echo date('r').": No log entries to show.\n";
		}
		echo "</pre>";
	}
	static function clear_log() {
		$ts = "[".date("r")."]\n";
		// Overwrite log file leaving permissions alone.
		@file_put_contents($ts."Log cleared".ez_vendor_min_orders_logend_record, ez_vendor_min_orders_log_logfile);	
	}
	static function truncate_log($entries=100) {
		$raw_log_entries = array_reverse(explode(ez_vendor_min_orders_log_end_record, @file_get_contents(ez_vendor_min_orders_log_logfile)));
		if( !current($raw_log_entries) )
			$raw_log_entries = array();
		$cur_log_entries = count($raw_log_entries);
		if( $cur_log_entries < $entries )
			return $cur_log_entries;
		$newlog = array();
		for($i=0; $i < $entries && isset($raw_log_entries[$i]); $i++) 
			$newlog = $raw_log_entries[$i];
		$newlog = array_reverse($newlog);
		if( $newlog )
			file_put_contents(ez_vendor_min_orders_log_logfile, implode(ez_vendor_min_orders_log_end_record, $newlog));
		return count($newlog);
	}
}

function ez_vendor_min_orders_log_dump_log() {
	if( !empty(ez_vendor_min_orders_log::$buf) ) {
		$ts = "[".date("r")."]\n";
		@file_put_contents(ez_vendor_min_orders_log_logfile, $ts.implode("\n", ez_vendor_min_orders_log::$buf)."\r\n", FILE_APPEND);
		if( !defined('AJAX_REQUEST') && ez_vendor_min_orders_log::$output && ez_vendor_min_orders_log::$log_area && (strpos(ez_vendor_min_orders_log::$log_area, AREA) !== false) )
			echo "<pre>$ts".implode("\n", ez_vendor_min_orders_log::$buf)."</pre>";
	}
}

$level = Registry::get('addons.ez_vendor_min_orders.debug');
if( empty($level) )
	$level = logAll;
ez_vendor_min_orders_log::init($level );

}	// class exists log
?>