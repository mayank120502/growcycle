<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }
use Tygh\Registry;
require_once(dirname(__FILE__).'/lic.php');


define('CS_FPC_MAX_FILES_IN_DIR', 1000);
define('CS_FPC_CACHE_DIR', Registry::get('config.dir.var').'cache/fpc');

if (class_exists('Tygh\CscFullPageCache') && Registry::get('runtime.controller')!="addons"){	
	$fpc_settings = Tygh\CscFullPageCache::_get_option_values(true);
	$fpc_settings['status']='A';	
	Registry::set('addons.csc_full_page_cache', $fpc_settings);		
}
if (AREA=="C" && function_exists('fn_csc_full_page_cache_run_turbo_mode')){	
	fn_csc_full_page_cache_run_turbo_mode();
}