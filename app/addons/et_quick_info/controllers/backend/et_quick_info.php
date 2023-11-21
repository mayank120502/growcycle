<?php

use Tygh\Registry;
if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
  fn_trusted_vars('block_data');

  if ($mode == 'update') {
    $block_id = fn_et_quick_info_update($_REQUEST['block_data'], $_REQUEST['block_id'], DESCR_SL);
    return array(CONTROLLER_STATUS_OK, 'et_quick_info.update?block_id='.$block_id);
  }

  if ($mode == 'm_update') {
    foreach ($_REQUEST['block_data'] as $key => $value) {
      fn_et_quick_info_update($value, $key, DESCR_SL);
    }
    $return_url='et_quick_info.manage';
  }

  if ($mode == 'delete') {
    if (!empty($_REQUEST['block_id'])) {
      fn_et_quick_info_delete_by_id($_REQUEST['block_id']);
    }
    if(!empty($_REQUEST['return_url'])) {
      $return_url = $_REQUEST['return_url'];
    }else{
      $return_url='et_quick_info.manage';
    }
  }

  if ($mode == 'update_status'){
    if (!empty($_REQUEST['id']) && !empty($_REQUEST['status'])) {
      fn_et_quick_info_update_status($_REQUEST['id'], $_REQUEST['status']);
    }
    $return_url='et_quick_info.manage';
  }
  return array(CONTROLLER_STATUS_OK, $return_url);   
}

if ($mode == 'add'){

}elseif ($mode == 'update') {
  $params['block_id']=$_REQUEST['block_id'];

  list($block, ) = fn_et_get_quick_info($params, DESCR_SL);

  if (empty($block)) {
    return array(CONTROLLER_STATUS_NO_PAGE);
  }

  Tygh::$app['view']->assign('block', $block);

} elseif ($mode == 'manage'|| $mode == 'picker') {
  
  list($blocks, ) = fn_et_get_quick_info(array('short'=>true), DESCR_SL);
  Tygh::$app['view']->assign('blocks', $blocks);

}elseif ($mode == 'dynamic') {
  

}
