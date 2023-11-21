<?php

use Tygh\Registry;
use Tygh\Settings;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
  if ($mode == 'update' && $_REQUEST['addon'] == 'et_vivashop_mv_functionality') {
      $et_mv_settings = isset($_REQUEST['et_mv_settings']) ? $_REQUEST['et_mv_settings'] : array();
      fn_update_et_vivashop_mv_functionality_settings($et_mv_settings);
  }
}

if ($mode == 'update') {
  if ($_REQUEST['addon'] == 'et_vivashop_mv_functionality') {
    Tygh::$app['view']->assign('et_mv_settings', fn_get_et_vivashop_mv_functionality_settings());
  }
}
