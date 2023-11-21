<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD']  == 'POST') {

  fn_trusted_vars('banners', 'banner_data');
  $suffix = '';

  //
  // Delete banners
  //
  if ($mode == 'm_delete') {
    foreach ($_REQUEST['banner_ids'] as $v) {
      fn_delete_banner_by_id($v);
    }

    $suffix = '.manage';
  }

  //
  // Add/edit banners
  //
  if ($mode == 'update') {
    $banner_id = fn_banners_update_banner($_REQUEST['banner_data'], $_REQUEST['banner_id'], DESCR_SL);

    $suffix = ".update?banner_id=$banner_id";
  }

  if ($mode == 'delete') {
    if (!empty($_REQUEST['banner_id'])) {
      fn_delete_banner_by_id($_REQUEST['banner_id']);
    }

    $suffix = '.manage';
  }

  return array(CONTROLLER_STATUS_OK, 'vendor_banners' . $suffix);
}

if ($mode == 'update') {
  $banner = fn_get_banner_data($_REQUEST['banner_id'], DESCR_SL);

  if (empty($banner)) {
    return array(CONTROLLER_STATUS_NO_PAGE);
  }

  Registry::set('navigation.tabs', array (
    'general' => array (
      'title' => __('general'),
      'js' => true
    ),
  ));

  Tygh::$app['view']->assign('banner', $banner);

} elseif ($mode == 'manage' || $mode == 'picker') {
  $runtime_company_id=Registry::get('runtime.company_id');
  $session_et_company_id=intval(fn_get_session_data('et_company_id'));
  $runtime_et_company_id=Registry::get('runtime.et_company_id');
  if ($runtime_company_id!==0){
    $company_id=$runtime_company_id;
  }else{
    $company_id=$session_et_company_id;
  }

  list($banners, ) = fn_get_banners(array('company_id'=>$company_id,'dispatch'=>'vendor_banners.manage'), DESCR_SL);

  Tygh::$app['view']->assign('banners', $banners);
}



/* Banners picker */

if ($mode == 'picker') {
  Tygh::$app['view']->display('addons/et_vivashop_mv_functionality/pickers/banners/picker_contents.tpl');
  exit;
}
