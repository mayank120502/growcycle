<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    return;
}

if ($mode == 'et_menu_product_fillings') {

  $fillings=fn_et_vivashop_settings_get_product_fillings();
  Tygh::$app['view']->assign('fillings', $fillings);
  Tygh::$app['view']->assign('filling', $_REQUEST['value']);
  Tygh::$app['view']->assign('id', $_REQUEST['id']);
}
