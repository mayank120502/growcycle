<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if (isset($_REQUEST['et_switch_company_id']) && $_REQUEST['et_switch_company_id']!==false){
	fn_set_session_data('et_company_id', $_REQUEST['et_switch_company_id'], COOKIE_ALIVE_TIME);
	Registry::set('runtime.et_company_id', $_REQUEST['et_switch_company_id']);
}

$et_company_id=intval(fn_get_session_data('et_company_id'));
if ($et_company_id){
	$name=fn_get_company_name($et_company_id);
}
if (!isset($name)){
	$name=__("all_vendors");
}
Registry::set('runtime.et_company_name',$name);