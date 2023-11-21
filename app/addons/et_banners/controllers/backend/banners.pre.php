<?php

use Tygh\Registry;
use Tygh\Settings;

if (!defined('BOOTSTRAP')) { die('Access denied'); }
if ($_SERVER['REQUEST_METHOD']	== 'POST') {
	if ($mode == 'update') {
		fn_et_banners_save_pre($_POST);
	}
}