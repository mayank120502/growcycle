<?php

use Tygh\Enum\NotificationSeverity;
use Tygh\Registry;
use Tygh\Navigation\LastView;
use Tygh\Languages\Languages;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

  if ($mode == 'm_update') {
    if (!empty($_REQUEST['seo_data'])) {
      $errors = [];
      $new_names = [];
      foreach ($_REQUEST['seo_data'] as $k => $v) {
        if (!empty($v['name'])) {
          $created_seo_name = fn_et_create_seo_name_rules($v['name'], $v['rule_params'], fn_get_corrected_seo_lang_code(DESCR_SL));
        }
      }
    }
  }

  return array(CONTROLLER_STATUS_OK, "et_seo_rules.manage");
}

if ($mode == 'manage') {
  $fields=fn_get_table_fields('seo_names');

  if (!in_array('et_vendor_id',$fields)){
   db_query("ALTER TABLE `?:seo_names` ADD COLUMN `et_vendor_id` int(11) unsigned NOT NULL DEFAULT '0';");
  }

  list($seo_data, $search) = fn_et_get_seo_rules($_REQUEST);

  Tygh::$app['view']->assign('seo_data', $seo_data);
  Tygh::$app['view']->assign('search', $search);
}

function fn_et_get_seo_rules($params = array(), $lang_code = DESCR_SL)
{
  $condition = fn_get_seo_company_condition('?:seo_names.company_id');

  $lang_code = fn_get_corrected_seo_lang_code($lang_code);

  $global_total = db_get_fields("SELECT dispatch FROM ?:et_seo_names WHERE 1 ?p GROUP BY dispatch", $condition);
  $local_total = db_get_fields("SELECT dispatch FROM ?:et_seo_names WHERE lang_code = ?s ?p", $lang_code, $condition);
  if ($diff = array_diff($global_total, $local_total)) {
    foreach ($diff as $disp) {
      fn_et_create_seo_name_rules(str_replace('.', '-', $disp), $disp, DESCR_SL);
    }
  }

  // Init filter
  $params = LastView::instance()->update('seo_rules', $params);

  // Set default values to input params
  $default_params = array (
    'page' => 1,
  );

  $params = array_merge($default_params, $params);

  if (isset($params['name']) && fn_string_not_empty($params['name'])) {
    $condition .= db_quote(" AND name LIKE ?l", "%".trim($params['name'])."%");
  }

  if (isset($params['rule_params']) && fn_string_not_empty($params['rule_params'])) {
    $condition .= db_quote(" AND dispatch LIKE ?l", "%".trim($params['rule_params'])."%");
  }

  $limit = '';
  $seo_data = db_get_array("SELECT name, dispatch FROM ?:et_seo_names WHERE lang_code = ?s ?p ORDER BY dispatch $limit", $lang_code, $condition);

  return array($seo_data, $params);
}

function fn_et_create_seo_name_rules($name, $dispatch, $lang_code = DESCR_SL){
  

  $seo_settings = fn_get_seo_settings(0);
  $non_latin_symbols = $seo_settings['non_latin_symbols'];

  $_object_name = preg_replace(
      '/(page)(-)([0-9]+|full_list)/',
      '$1$3',
      fn_generate_name($name, '', 0, ($non_latin_symbols == 'Y'))
  );

  $data=[
    'name' => $_object_name,
    'dispatch' => $dispatch,
    'lang_code' => $lang_code
  ];

  $affected_rows = db_query("INSERT INTO ?:et_seo_names ?e ON DUPLICATE KEY UPDATE ?u", $data, $data);
}
