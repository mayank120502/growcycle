<?php
use Tygh\Registry;
use Tygh\Settings;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'update' && $_SERVER['REQUEST_METHOD'] == 'POST') {
  fn_et_vivashop_mv_functionality_serialize($_POST['company_data']);
}