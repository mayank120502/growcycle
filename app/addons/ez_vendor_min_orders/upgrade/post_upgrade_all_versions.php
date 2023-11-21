<?php
if( !defined('BOOTSTRAP') ) die('Access denied');
use Tygh\Registry;

// addons/<addon_name>/upgrade/FILE
$v = explode(DIRECTORY_SEPARATOR, __FILE__);
$addon_name = $v[count($v)-3];
$func = $addon_name."_install";
if( function_exists($func) ) {
	$func(array('force'=>true) );
}

?>