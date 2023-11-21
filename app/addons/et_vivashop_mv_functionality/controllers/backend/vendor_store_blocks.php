<?php
$debug=false;
use Tygh\Registry;
if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
  fn_trusted_vars('block_data');
  $return_url = 'vendor_store_blocks.manage';
  if ($debug) {
    fn_set_notification('E','request vars',print_r($_REQUEST,true));
  }
  if ($mode == 'update') {
    $vsb_id = fn_et_mv_vsb_update($_REQUEST['block_data'], $_REQUEST['vsb_id'], DESCR_SL);
    return array(CONTROLLER_STATUS_OK, 'vendor_store_blocks.update?vsb_id=' . $vsb_id);
  }
  if ($mode == 'm_update') {
    foreach ($_REQUEST['block_data'] as $key => $value) {
      fn_et_mv_vsb_update_status($value, $key, DESCR_SL);
    }
  }
  if ($mode == 'delete') {
    if (!empty($_REQUEST['vsb_id'])) {
      fn_et_mv_vsb_delete_by_id($_REQUEST['vsb_id']);
    }
    if(!empty($_REQUEST['return_url'])) {
      $return_url = $_REQUEST['return_url'];
    }
  }
  if ($mode == 'update_status'){
    if (!empty($_REQUEST['id']) && !empty($_REQUEST['status'])) {
      fn_et_mv_vsb_update_status($_REQUEST['id'], $_REQUEST['status']);
    }
  }
  return array(CONTROLLER_STATUS_OK, $return_url);   
}

if ($mode == 'update') {
  $params['item_ids']=$_REQUEST['vsb_id'];
  list($vsb, ) = fn_et_mv_get_vsb($params, DESCR_SL);
  if (empty($vsb)) {
    return array(CONTROLLER_STATUS_NO_PAGE);
  }
  Tygh::$app['view']->assign('vsb', $vsb[$_REQUEST['vsb_id']]);

  $fillings=fn_et_vivashop_settings_get_product_fillings();
  Tygh::$app['view']->assign('fillings', $fillings);

} elseif ($mode == 'add') {
  $fillings=fn_et_vivashop_settings_get_product_fillings();
  Tygh::$app['view']->assign('fillings', $fillings);
} elseif ($mode == 'manage') {
  $params=array(
    'short'=>true
  );

  $runtime_company_id=Registry::get('runtime.company_id');
  $session_et_company_id=intval(fn_get_session_data('et_company_id'));
  $runtime_et_company_id=Registry::get('runtime.et_company_id');
  if ($runtime_company_id!==0){
    $company_id=$runtime_company_id;
  }else{
    $company_id=$session_et_company_id;
  }

  if ($company_id>0){
    $params['company_id']=$company_id;
  }
  
  list($vsb, ) = fn_et_mv_get_vsb($params, DESCR_SL);
  Tygh::$app['view']->assign('vsb', $vsb);
  
}elseif ($mode == 'dynamic') {
  Tygh::$app['view']->assign('id', $_REQUEST['new_id']);
  if (isset($_REQUEST['type'])){
  Tygh::$app['view']->assign('type', $_REQUEST['type']);
  }

}elseif ($mode == 'fillings') {

  $fillings=fn_et_vivashop_settings_get_product_fillings();
  Tygh::$app['view']->assign('fillings', $fillings);
  Tygh::$app['view']->assign('filling', $_REQUEST['value']);
  Tygh::$app['view']->assign('id', $_REQUEST['id']);
}
