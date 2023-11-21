<?php
$debug=false;
use Tygh\Registry;
if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'manage') {
  $params=array(
    'short'=>true
  );
  $params['company_id']=0;
  list($vsb, ) = fn_et_mv_get_vsb($params, DESCR_SL);

  // fn_set_notification('E','vsb',print_r($vsb,true));
  Tygh::$app['view']->assign('vsb', $vsb);
}