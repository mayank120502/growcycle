<?php
use Tygh\Registry;
use Tygh\BlockManager\Block;
use Tygh\Languages\Languages;
use Tygh\Menu;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_et_mega_menu_install(){
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
function fn_et_mega_menu_uninstall(){
  if (fn_allowed_for('ULTIMATE')){
  }
}

/************************************/
/* CATEGORY MENU SETTINGS FUNCTIONS */
/************************************/

/* INSERT/UPDATE DB VALUES */
function fn_et_mega_menu_update_category_post(&$category_data, &$category_id,&$lang_code)
{
  if (isset($category_data['et_menu'])){
    $et_menu          = $category_data['et_menu'];
    
    $et_menu_id       = isset($et_menu['et_menu_id']) ? $et_menu['et_menu_id'] : '';
    $data['categ_id'] = $category_id;
    $data['lang_code']= $lang_code;

    if (isset($et_menu['size'])){
      $data['size']       = serialize($et_menu['size']);
    }
    if (isset($et_menu['thumbnails'])){
      $data['thumbnails'] = serialize($et_menu['thumbnails']);
    }

    if (isset($et_menu['icon'])){
      $data['icon']       = serialize($et_menu['icon']);
    }
    if (isset($et_menu['text'])){
      $data['text']       = serialize($et_menu['text']);
    }
    if (isset($et_menu['banner'])){
      $data['banner']     = serialize($et_menu['banner']);
    }

    if (fn_allowed_for('ULTIMATE') && Registry::get('runtime.company_id')) 
    {
      $data['company_id'] = Registry::get('runtime.company_id');
    }

    fn_set_hook('et_update_category_pre', $category_data, $data);


    if (isset($et_menu_id) && !empty($et_menu_id)){
      /* EXISTING MENU */

      /* UPDATE DB VALUES */
      db_query("UPDATE ?:et_category_menu SET ?u WHERE et_menu_id = ?i", $data, $et_menu_id);

      if (isset($et_menu['update_all_langs']) && $et_menu['update_all_langs']=="Y"){
        $lang_codes = Languages::getAll();
        unset($lang_codes[$lang_code]);
        
        foreach ($lang_codes as $data['lang_code'] => $v) {
          db_query("UPDATE ?:et_category_menu SET ?u WHERE categ_id = ?i AND lang_code = ?s ", $data, $category_id, $data['lang_code']);
        }
      }

      /* UPDATE IMAGES */
      $et_menu_icon=fn_energothemes_update_image('et_menu_icon', $et_menu_id, $lang_code);
      $et_menu_icon_hover=fn_energothemes_update_image('et_menu_icon_hover', $et_menu_id, $lang_code);
      $et_menu_image=fn_energothemes_update_image('et_menu_image', $et_menu_id, $lang_code);

      if (isset($et_menu['update_all_langs']) &&$et_menu['update_all_langs']=="Y"){
        
        $et_menu_icon_id=reset($et_menu_icon);
        $et_menu_icon_hover_id=reset($et_menu_icon_hover);
        $et_menu_image_id=reset($et_menu_image);

        $lang_codes = Languages::getAll();
        unset($lang_codes[$lang_code]);
        
        foreach ($lang_codes as $data['lang_code'] => $v) {
          $id=db_get_field("SELECT et_menu_id FROM ?:et_category_menu WHERE categ_id = ?i AND lang_code = ?s ", $category_id, $data['lang_code']);

          $has_et_menu_icon=fn_get_image_pairs($id, 'et_menu_icon', 'M', true, false, $lang_code);
          if (!empty($has_et_menu_icon)){
            fn_delete_image_pairs($id, 'et_menu_icon');
          }
          fn_add_image_link($id, $et_menu_icon_id);

          $has_et_menu_icon_hover=fn_get_image_pairs($id, 'et_menu_icon_hover', 'M', true, false, $lang_code);
          if (!empty($has_et_menu_icon_hover)){
            fn_delete_image_pairs($id, 'et_menu_icon_hover');
          }
          fn_add_image_link($id, $et_menu_icon_hover_id);

          $has_et_menu_image=fn_get_image_pairs($id, 'et_menu_image', 'M', true, false, $lang_code);
          if (!empty($has_et_menu_image)){
            fn_delete_image_pairs($id, 'et_menu_image');
          }
          fn_add_image_link($id, $et_menu_image_id);

        }
      }

    }else{
      /* NEW MENU */

      /* INSERT DB VALUES */
      $et_menu_id=db_query("INSERT INTO ?:et_category_menu ?e", $data);

      /* INSERT IMAGES */
      $icon_img = fn_attach_image_pairs('et_menu_icon', 'et_menu_icon', $et_menu_id, $lang_code);
      $icon_img_hover = fn_attach_image_pairs('et_menu_icon_hover', 'et_menu_icon_hover', $et_menu_id, $lang_code);
      $banner_img = fn_attach_image_pairs('et_menu_image', 'et_menu_image', $et_menu_id, $lang_code);

      $icon_img_id = reset($icon_img);
      $icon_img_id_hover = reset($icon_img_hover);
      $banner_img_id = reset($banner_img);

      /* ADD INITIAL VALUES FOR ALL LANGUAGES*/
      $lang_codes = Languages::getAll();
      unset($lang_codes[$lang_code]);

      foreach ($lang_codes as $data['lang_code'] => $v) {
        /* INSERT DB VALUES */
        $et_menu_icon_id=db_query("INSERT INTO ?:et_category_menu ?e", $data);
        
        /* INSERT IMAGES */
        fn_add_image_link($et_menu_icon_id, $icon_img_id);
        fn_add_image_link($et_menu_icon_id, $icon_img_id_hover);
        fn_add_image_link($et_menu_icon_id, $banner_img_id);
      }
    }
  }
}


/* UPDATE IMAGE HELPER FUNCTION */
function fn_energothemes_update_image($name,$id,$lang_code){
  $file="file_".$name."_image_icon";

  $update_image=true;
  if (!empty($_REQUEST[$file][0]) && array($_REQUEST[$file][0]))
  {
    $image = $_REQUEST[$file][0];

    if ($image == $name) {
        $update_image=false;
    }
  }else{
    $update_image=false;
  }

  if ($update_image){
    fn_delete_image_pairs($id, $name);
  }

  $result=fn_attach_image_pairs($name, $name, $id, $lang_code);
  return $result;
}

/* READ DATABASE VALUES */
function fn_get_et_category_menu_settings_multi($category_ids,$block_id=0,$get_product_data=false,$lang_code=CART_LANGUAGE,$company_id=0){

  static $cache = array();

  if (!isset($cache[$block_id]) || $block_id==0) {

    /* Get ET settings */
    $condition = '';
    $condition.= db_quote(" AND ?:et_category_menu.lang_code = ?s",$lang_code);
    $condition.= db_quote(" AND ?:et_category_menu.categ_id IN (?n)", $category_ids);

    $fields = array (
      'et_menu_id',
      'categ_id',
      'size',
      'thumbnails',
      'icon',
      'text',
      'banner'
    );

    fn_set_hook('et_get_category_multi_pre', $fields);

    $et_menu = db_get_hash_array(
      "SELECT ?p FROM ?:et_category_menu " .
      "WHERE 1 ?p", 
      'categ_id', implode(", ", $fields), $condition
    );

    if (!empty($et_menu)){
      foreach ($et_menu as $categ_id => $data) {
        /* UNSERIALIZE DATA */
        $et_menu[$categ_id]['size']=unserialize($et_menu[$categ_id]['size']);
        $et_menu[$categ_id]['thumbnails']=unserialize($et_menu[$categ_id]['thumbnails']);
        $et_menu[$categ_id]['icon']=unserialize($et_menu[$categ_id]['icon']);
        $et_menu[$categ_id]['text']=unserialize($et_menu[$categ_id]['text']);
        $et_menu[$categ_id]['banner']=unserialize($et_menu[$categ_id]['banner']);


        /* GET IMAGES */
        $et_menu[$categ_id]['icon']['img'] = fn_get_image_pairs($et_menu[$categ_id]['et_menu_id'], 'et_menu_icon', 'M', true, false, $lang_code);
        $et_menu[$categ_id]['icon']['img_hover'] = fn_get_image_pairs($et_menu[$categ_id]['et_menu_id'], 'et_menu_icon_hover', 'M', true, false, $lang_code);
        $et_menu[$categ_id]['banner']['img'] = fn_get_image_pairs($et_menu[$categ_id]['et_menu_id'], 'et_menu_image', 'M', true, false, $lang_code);

        fn_set_hook('et_get_category_multi_post', $et_menu,$categ_id,$get_product_data);
      }
    }

    /* Add default CS-Cart images */
    foreach ($category_ids as $key => $categ_id) {
      $et_menu[$categ_id]['category_img']=fn_get_image_pairs($categ_id,'category','M',true,true);
    }
    
    $cache[$block_id]=$et_menu;
  }

  return $cache[$block_id];
}


function fn_get_et_category_menu_settings($category_id,$lang_code=CART_LANGUAGE,$company_id=0,$get_product_data=false)
{
  static $cache = array();

  if (!isset($cache[$category_id])) {
    $condition = '';
    $condition.=db_quote(" AND ?:et_category_menu.categ_id = ?s",$category_id);
    $condition.=db_quote(" AND ?:et_category_menu.lang_code = ?s",$lang_code);

    if (fn_allowed_for('ULTIMATE') && Registry::get('runtime.company_id')) 
    {
      $condition.=db_quote(" AND ?:et_category_menu.company_id = ?s",$company_id);
    }

    $fields = array (
      'et_menu_id',
      'size',
      'thumbnails',
      'icon',
      'text',
      'banner'
    );

    fn_set_hook('et_get_category_pre', $fields);

    $et_menu = db_get_row(
      "SELECT ?p FROM ?:et_category_menu " .
      "WHERE 1 ?p",
      implode(", ", $fields), $condition
    );

    /* UNSERIALIZE DATA */
    if (isset($et_menu['et_menu_id'])){
      $et_menu['size']=unserialize($et_menu['size']);
      $et_menu['thumbnails']=unserialize($et_menu['thumbnails']);
      $et_menu['icon']=unserialize($et_menu['icon']);
      $et_menu['text']=unserialize($et_menu['text']);
      $et_menu['banner']=unserialize($et_menu['banner']);
      fn_set_hook('et_get_category_post', $et_menu,$get_product_data);
    }

    /* GET IMAGES */
    if (isset($et_menu['et_menu_id'])){
      $et_menu['icon']['img'] = fn_get_image_pairs($et_menu['et_menu_id'], 'et_menu_icon', 'M', true, false, $lang_code);
      $et_menu['icon']['img_hover'] = fn_get_image_pairs($et_menu['et_menu_id'], 'et_menu_icon_hover', 'M', true, false, $lang_code);
      $et_menu['banner']['img'] = fn_get_image_pairs($et_menu['et_menu_id'], 'et_menu_image', 'M', true, false, $lang_code);
    };

    $cache[$category_id] = $et_menu;
  }

  $et_menu = !empty($cache[$category_id]) ? $cache[$category_id] : array();

  return $et_menu;
}

/* DELETE DATABASE VALUES */
function fn_et_mega_menu_delete_category_pre($category_id, $recurse){
  /* Delete images */
  $et_menu_ids=db_get_array("SELECT et_menu_id FROM ?:et_category_menu WHERE ?:et_category_menu.categ_id = ?i", $category_id);

  foreach ($et_menu_ids as $key => $value) {
    $et_menu_id=$value['et_menu_id'];
    fn_delete_image_pairs($et_menu_id, 'et_menu_icon');
    fn_delete_image_pairs($et_menu_id, 'et_menu_icon_hover');
    fn_delete_image_pairs($et_menu_id, 'et_menu_image');
  }

  /* Delete values */
  db_query("DELETE FROM ?:et_category_menu WHERE ?:et_category_menu.categ_id = ?i", $category_id);
}

/* ADD THE SETTING VALUES TO THE FRONTEND MENU */
function fn_et_mega_menu_get_categories_after_sql(&$categories, $params, $join, $condition, $fields, $group_by, $sortings, $sorting, $limit, $lang_code){
  if (isset($params['get_et_category_menu_info']) && $params['get_et_category_menu_info']){

    $category_ids = array_keys($categories);
    $et_menu=fn_get_et_category_menu_settings_multi($category_ids,$params['block_data']['block_id'],false);
    foreach ($et_menu as $categ_id => $value) {
      $categories[$categ_id]['et_menu']=$value;
    }

  }
}

/********************************************/
/* STANDARD MENU WITH FONTAWESOME FUNCTIONS */
/********************************************/

/* INSERT/UPDATE DB VALUES */
function fn_et_mega_menu_update_static_data($data, &$param_id, $condition, $section, $lang_code){

  if (isset($data['et_menu']) && $data['et_menu']){
    $et_menu_id=$data['et_menu_id'];
    $et_menu=$data['et_menu'];

    if (empty($param_id)){
      $data['section'] = $section;

      $param_id = $data['param_id'] = db_query("INSERT INTO ?:static_data ?e", $data);
      foreach (fn_get_translation_languages() as $data['lang_code'] => $_v) {
          db_query('REPLACE INTO ?:static_data_descriptions ?e', $data);
      }
    }

    $et_data=serialize($et_menu);

    $et_menu_data=array();
    $et_menu_data=array(
      'param_id'  => $param_id,
      'data'      => $et_data,
      'lang_code' => $lang_code
    );

    if (isset($et_menu_id) && !empty($et_menu_id)){
      db_query("UPDATE ?:et_menu SET ?u WHERE et_menu_id = ?i", $et_menu_data, $et_menu_id);
    } else {
      db_query("INSERT INTO ?:et_menu ?e", $et_menu_data);
    }
  }
}


/* READ DATABASE VALUES */
function fn_et_mega_menu_get_et_menu_multi($param_ids,$block_id=0, $lang_code=DESCR_SL){
  static $cache = array();
  if (!isset($cache[$block_id]) || $block_id==0) {
    $et_menu = array();
    $et_menu = db_get_hash_array(
      "SELECT * FROM ?:et_menu 
      WHERE 1 AND ?:et_menu.param_id IN (?n) AND ?:et_menu.lang_code = ?s", 'param_id', $param_ids, $lang_code
    );
    if (!empty($et_menu)){
      foreach ($et_menu as $param_id => $data) {
        $et_menu[$param_id]=unserialize($et_menu[$param_id]['data']);
        $et_menu[$param_id]['et_menu_id']=$data['et_menu_id'];
      }
    }
    $cache[$block_id]=$et_menu;
  }
  return $cache[$block_id];
}
function fn_et_mega_menu_get_et_menu($param_id, $lang_code=DESCR_SL){
  $data=array();
  $data = db_get_array(
    "SELECT * FROM ?:et_menu 
    WHERE ?:et_menu.param_id = ?s AND ?:et_menu.lang_code = ?s", $param_id, $lang_code
  );

  if (!empty($data)){
    return array(
      'et_menu_id'  => $data[0]['et_menu_id'],
      'data'        => unserialize($data[0]['data'])
    );
  }else{
    return false;
  }
}

/* DELETE DATABASE VALUES */
function fn_et_mega_menu_delete_static_data_pre($param_id){
  db_query("DELETE FROM ?:et_menu WHERE ?:et_menu.param_id = ?i", $param_id);
}

function fn_et_get_menu_items($value, $block, $block_scheme)
{
  $menu_items = array();

  if (!empty($block['content']['menu'])
    && Menu::getStatus($block['content']['menu']) == 'A'
    && fn_check_menu_owner($block['content']['menu'])
  ) {
    $params = array(
      'section' => 'A',
      'get_params' => true,
      'icon_name' => '',
      'use_localization' => true,
      'status' => 'A',
      'generate_levels' => true,
      'request' => array(
        'menu_id' => $block['content']['menu'],
      ),
    );
    $data=fn_get_static_data($params);

    $param_ids=array_keys($data);
    $et_menu=fn_et_mega_menu_get_et_menu_multi($param_ids,$block['block_id']);
    
    foreach ($et_menu as $param_id => $value) {
      $data[$param_id]['et_menu']=$value;
    }

    $data=fn_make_tree($data, 0, 'param_id', 'subitems');;

    $menu_items = fn_top_menu_form($data);
    fn_dropdown_appearance_cut_second_third_levels($menu_items, 'subitems', $block['properties']);
  }

  return $menu_items;
}

function fn_et_mega_menu_update_language_post($language_data, $lang_id, $action)
{

  if ($action == 'add') {
    $data = db_get_array("SELECT * FROM ?:et_menu WHERE lang_code = ?s", DEFAULT_LANGUAGE);
    foreach ($data as $_data) {

      unset($_data['et_menu_id']);
      $_data['lang_code']=$language_data['lang_code'];

      db_query("REPLACE INTO ?:et_menu ?e", $_data);
    }

    $data = db_get_array("SELECT * FROM ?:et_category_menu WHERE lang_code = ?s", DEFAULT_LANGUAGE);

    foreach ($data as $_data) {
      $id=$_data['categ_id'];

      $has_et_menu_image=fn_get_image_pairs($_data['et_menu_id'], 'et_menu_image', 'M', true, false, DEFAULT_LANGUAGE);
      $has_et_menu_icon=fn_get_image_pairs($_data['et_menu_id'], 'et_menu_icon', 'M', true, false, DEFAULT_LANGUAGE);
      $has_et_menu_icon_hover=fn_get_image_pairs($_data['et_menu_id'], 'et_menu_icon_hover', 'M', true, false, DEFAULT_LANGUAGE);

      unset($_data['et_menu_id']);
      $_data['lang_code']=$language_data['lang_code'];

      $new_id=db_query("REPLACE INTO ?:et_category_menu ?e", $_data);

      if (!empty($has_et_menu_image)){
        fn_add_image_link($new_id, $has_et_menu_image['pair_id']);
      }
      if (!empty($has_et_menu_icon)){
        fn_add_image_link($new_id, $has_et_menu_icon['pair_id']);
      }
      if (!empty($has_et_menu_icon_hover)){
        fn_add_image_link($new_id, $has_et_menu_icon_hover['pair_id']);
      }
    }
  }
}

function fn_et_mega_menu_delete_languages_post($lang_ids, $lang_codes, $deleted_lang_codes)
{
  foreach ($deleted_lang_codes as $lang_code) {
    db_query("DELETE FROM ?:et_menu WHERE lang_code = ?s", $lang_code);
    db_query("DELETE FROM ?:et_category_menu WHERE lang_code = ?s", $lang_code);
  }
}