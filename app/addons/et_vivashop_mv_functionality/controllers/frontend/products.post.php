<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'view' || $mode == 'quick_view') {


  $product=Tygh::$app['view']->getTemplateVars('product');
  $company_id=$product['company_id'];
  $vendor=fn_get_company_data($company_id);
  if (is_array($vendor)){
    $vendor=fn_filter_company_data_by_profile_fields($vendor);
  }
  
  Tygh::$app['view']->assign('company_id', $company_id);
  Tygh::$app['view']->assign('vendor', $vendor);

  if (Registry::get('addons.discussion.status') == 'A'){
    $company=fn_get_discussion($company_id, 'M', true);
    Tygh::$app['view']->assign('company', $company);
  }

  if ($product['company_id']){
      $product['company_has_store']=fn_et_vivashop_mv_functionality_has_microstore($product['company_id']);
      Tygh::$app['view']->assign('product', $product);
  }
}
