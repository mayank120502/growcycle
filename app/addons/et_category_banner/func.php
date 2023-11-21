<?php
use Tygh\Registry;
use Tygh\BlockManager\Block;
use Tygh\Languages\Languages;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_et_category_banner_install(){
  if (fn_allowed_for('ULTIMATE')){
    $fields = fn_get_table_fields('et_menu');
    if (!in_array('company_id', $fields)) {
        db_query("ALTER TABLE ?:et_menu ADD COLUMN `company_id` int(11) unsigned NOT NULL DEFAULT '0'");
    }

    $fields = fn_get_table_fields('et_category_menu');
    if (!in_array('company_id', $fields)) {
        db_query("ALTER TABLE ?:et_category_menu ADD COLUMN `company_id` int(11) unsigned NOT NULL DEFAULT '0'");
    }
  }
}
function fn_et_category_banner_uninstall(){
  if (fn_allowed_for('ULTIMATE')){
  }
}

function fn_et_category_banner_update_category_post(&$category_data, &$category_id,&$lang_code)
{
  $go=true;

  $data['category_id']  = $category_id;
  $data['data']  = (isset($category_data['et_category_banner']['item_ids']) && is_array($category_data['et_category_banner']['item_ids'])) ? implode(',',array_keys($category_data['et_category_banner']['item_ids'])) : '';

  if (fn_allowed_for('ULTIMATE')){
    if (Registry::get('runtime.company_id')) {
      $data['company_id'] = $category_data['company_id'];
      $go=true;
    }else{
      $go=false;
    }
  }

  if ($go===true){
    fn_update_et_category_banner($data);
  }
  return true;
}


function fn_get_et_category_banner_current(){
  $category_id = isset($_REQUEST['category_id']) ? $_REQUEST['category_id'] : false;

  if ($category_id){
    $data = fn_get_et_category_banner($category_id);
    if (!empty($data['item_ids'])){
      $data['banner_data'] = fn_get_banners(array('item_ids'=>$data['item_ids']));
      $data['banner_data'] = $data['banner_data'][0];
    }
    return $data;
  }
  return;
}


function fn_get_et_category_banner($category_id,$lang_code=CART_LANGUAGE)
{
  $condition = '';
  $condition.=db_quote(" AND ?:et_category_banner.category_id = ?s",$category_id);

  $fields = array (
    'data',
  );
  $et_category_banner = db_get_row(
    "SELECT ?p FROM ?:et_category_banner " .
    "WHERE 1 ?p",
    implode(", ", $fields), $condition);
  
  $et_category_banner['item_ids']=isset($et_category_banner['data']) ? $et_category_banner['data'] : '';

  return $et_category_banner;
}

function fn_update_et_category_banner($data, $lang_code=CART_LANGUAGE)
{

  if ($data['category_id']){
    db_query("REPLACE INTO ?:et_category_banner ?e", $data);
  }

  return true;
}