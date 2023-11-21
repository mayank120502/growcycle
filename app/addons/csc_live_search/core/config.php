<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }
ini_set('display_errors', 0);
define('AREA', 'CLS'); //live search mode
define('CLS_DIR_ROOT', DIR_ROOT.'/app/addons/csc_live_search/');
define('TIME', time());

foreach (glob(CLS_DIR_ROOT."core/autoload/*.php") as $filename){
    require_once($filename);
}
foreach (glob(CLS_DIR_ROOT."core/common/*.php") as $filename){
    require_once($filename);
}

if (!empty($_REQUEST['lang_code'])){
	$lang =  $_REQUEST['lang_code'];	
}else{
	$lang =  db_get_field("SELECT value FROM ?:settings_objects WHERE name=?s", 'frontend_default_language');		
}
define('DESCR_SL', $lang);
define('CART_LANGUAGE', DESCR_SL);
$_REQUEST['lang_code'] = CART_LANGUAGE;

require_once(CLS_DIR_ROOT."config.php");
require_once(CLS_DIR_ROOT."Tygh/CscLiveSearch.php");