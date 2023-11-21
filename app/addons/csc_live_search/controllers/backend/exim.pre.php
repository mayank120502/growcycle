<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			https://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
use Tygh\Registry;
use Tygh\CscLiveSearch;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {    
    if ($mode == 'import') {
		$addon= CscLiveSearch::_get_option_values();
		if ($addon['speedup_exclude_import']=="Y"){
			define('CSS_SKIP_INDEXATION', true);
		}
	}
}
