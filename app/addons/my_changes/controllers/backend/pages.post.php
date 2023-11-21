<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }
/*Artur Mnatsakanyan*/

// We need to clear cache of the pages when create new blog 
if ($mode == 'update' || $mode == 'delete') {

	if($mode == 'delete')
	{
		fn_csc_full_page_cache_cleare_cache_by_controller('pages');
	}
	elseif (isset($_REQUEST['page_data']) && isset($_REQUEST['page_data']['page_type']) && $_REQUEST['page_data']['page_type'] == 'B')
	{
		if(function_exists('fn_csc_full_page_cache_cleare_cache_by_controller'))  
			fn_csc_full_page_cache_cleare_cache_by_controller('pages');
	}

}
