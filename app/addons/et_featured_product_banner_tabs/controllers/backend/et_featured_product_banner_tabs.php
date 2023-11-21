<?php

use Tygh\Registry;
if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
  if ($mode == 'update') {
    $block_id = fn_et_featured_product_banner_tabs_update($_REQUEST['block_data'], $_REQUEST['block_id'], DESCR_SL);
    return array(CONTROLLER_STATUS_OK, 'et_featured_product_banner_tabs.update?block_id='.$block_id);
  }

  $return_url = 'et_featured_product_banner_tabs.manage';

  if ($mode == 'delete') {
    if (!empty($_REQUEST['block_id'])) {
      fn_et_featured_product_banner_tabs_delete_by_id($_REQUEST['block_id']);
    }
  }

  if ($mode == 'update_status'){
    if (!empty($_REQUEST['id']) && !empty($_REQUEST['status'])) {
      fn_et_featured_product_banner_tabs_update_status($_REQUEST['id'], $_REQUEST['status']);
    }
  }

  return array(CONTROLLER_STATUS_OK, $return_url);   
}

if ($mode == 'add'){
  Registry::set('navigation.tabs', array (
    'general' => array (
      'title' => __('general'),
      'js' => true
    ),
    'tabs' => array (
      'title' => __('tabs'),
      'js' => true
    ),
  ));
  $fillings=fn_et_vivashop_settings_get_product_fillings();
  Tygh::$app['view']->assign('et_product_fillings', $fillings);

}elseif ($mode == 'update') {
  $params['block_id']=$_REQUEST['block_id'];

  Registry::set('navigation.tabs', array (
    'general' => array (
      'title' => __('general'),
      'js' => true
    ),
    'tabs' => array (
      'title' => __('tabs'),
      'js' => true
    ),
  ));

  list($block, ) = fn_et_get_featured_product_banner_tabs($params, DESCR_SL);

  if (empty($block)) {
    return array(CONTROLLER_STATUS_NO_PAGE);
  }

  Tygh::$app['view']->assign('block', $block);

  $fillings=fn_et_vivashop_settings_get_product_fillings();
  Tygh::$app['view']->assign('et_product_fillings', $fillings);

} elseif ($mode == 'manage'|| $mode == 'picker') {
  
  list($blocks, ) = fn_et_get_featured_product_banner_tabs(array('short'=>true), DESCR_SL);
  Tygh::$app['view']->assign('blocks', $blocks);

}elseif ($mode == 'dynamic') {
  
  Tygh::$app['view']->assign('id', $_REQUEST['new_id']);
  Tygh::$app['view']->assign('block_id', $_REQUEST['block_id']);
  Tygh::$app['view']->assign('type', $_REQUEST['type']);
  if (fn_allowed_for('ULTIMATE') && !Registry::get('runtime.company_id')) {
    Tygh::$app['view']->assign('picker_selected_companies', fn_ult_get_controller_shared_companies($_REQUEST['promotion_id'], 'promotions', 'update'));
  }
  $fillings=fn_et_vivashop_settings_get_product_fillings();
  Tygh::$app['view']->assign('et_product_fillings', $fillings);

}elseif ($mode == 'fillings') {

  $fillings=fn_et_vivashop_settings_get_product_fillings();
  Tygh::$app['view']->assign('fillings', $fillings);
  Tygh::$app['view']->assign('filling', $_REQUEST['value']);
  Tygh::$app['view']->assign('id', $_REQUEST['id']);
}

if ($mode == 'picker') {
  if (isset($_REQUEST['et_selected_id'])){
    Tygh::$app['view']->assign('et_selected_id', $_REQUEST['et_selected_id']);
  }
  Tygh::$app['view']->display('addons/et_featured_product_banner_tabs/pickers/picker_contents.tpl');
  exit;
}
