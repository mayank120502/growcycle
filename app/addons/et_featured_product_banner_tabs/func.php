<?php
use Tygh\Registry;
use Tygh\BlockManager\Block;
use Tygh\Languages\Languages;
use Tygh\BlockManager\SchemesManager;

if (!defined('BOOTSTRAP')) { die('Access denied'); }


/* INSERT/UPDATE DB VALUES */
function fn_et_featured_product_banner_tabs_update($data, $block_id, $lang_code=DESCR_SL){

  if ($data['tab']){
    foreach ($data['tab'] as $key => $value) {
      if (isset($value['content']['items']['item_ids']) && is_array($value['content']['items']['item_ids'])){
        $item_ids=$value['content']['items']['item_ids'];
        if (is_array($item_ids)) {
            @asort($item_ids);
            $item_ids = implode(',', array_keys($item_ids));
      }
        $data['tab'][$key]['content']['items']['item_ids']=$item_ids;
      }

    }
  }

  if (isset($block_id) && !empty($block_id)){
    /* EXISTING BLOCK */

    /* Block */
    $block_sql          = array();
    $block_sql['data']  = serialize($data['settings']);

    db_query("UPDATE ?:et_featured_product_banner_tabs SET ?u WHERE block_id = ?i", $block_sql, $block_id);

    /* Block data */
    $block_data           = array();
    $block_data['title']  = $data['title'];

    $block_data_sql             = array();
    $block_data_sql['block_id'] = $block_id;
    $block_data_sql['data']     = serialize($block_data);

    db_query("UPDATE ?:et_featured_product_banner_tabs_data SET ?u WHERE block_id = ?i AND lang_code = ?s", $block_data_sql, $block_id, $lang_code);

    if ($data['update_all_langs']=="Y"){
      db_query("UPDATE ?:et_featured_product_banner_tabs_data SET ?u WHERE block_id = ?i", $block_data_sql, $block_id);
    }

    /* Tabs */
    $existing_tabs  = fn_get_et_tabs($block_id);
    $updated_tabs   = array();

    foreach ($data['tab'] as $key => $value) {
      /* Tab */
      $tab_data                     = array();
      $tab_data['custom_settings']  = $value['custom_settings'];
      if (isset($value['product_ids'])){
        $tab_data['content']['items']['item_ids'] = $value['product_ids'];
        $tab_data['content']['items']['filling'] = 'manually';
      }else{
        $tab_data['content'] = $value['content'];
      }
      $tab_data['banner_ids']['banner_1'] = (isset($value['banner_1']['banner_ids'])&&is_array($value['banner_1']['banner_ids'])) ?  implode(',',array_keys($value['banner_1']['banner_ids'])) : "";
      $tab_data['banner_ids']['banner_2'] = (isset($value['banner_2']['banner_ids'])&&is_array($value['banner_2']['banner_ids'])) ?  implode(',',array_keys($value['banner_2']['banner_ids'])) : "";

      $tab_sql              = array();
      $tab_sql['block_id']  = $block_id;
      $tab_sql['position']  = isset($value['position']) ? $value['position'] : "";
      $tab_sql['data']      = serialize($tab_data);


      $tab_lang_data                  = array();
      $tab_lang_data['title']         = isset($value['title']) ? $value['title'] : "";

      $tab_data_sql         = array();
      $tab_data_sql['data'] = serialize($tab_lang_data);

      if (!empty($value['tab_id'])){
        /* EXISTING TAB */

        /* Update Tab values */
        $tab_id       = $value['tab_id'];
        $tab_data_id  = $value['data_id'];

        db_query("UPDATE ?:et_featured_product_banner_tabs_tabs SET ?u WHERE tab_id = ?i", $tab_sql, $tab_id);

        /* Update Tab data values */
        db_query("UPDATE ?:et_featured_product_banner_tabs_tabs_data SET ?u WHERE data_id = ?s", $tab_data_sql, $tab_data_id);

        if ($data['update_all_langs']=="Y"){
          db_query("UPDATE ?:et_featured_product_banner_tabs_tabs_data SET ?u WHERE tab_id = ?s", $tab_data_sql, $tab_id);
        }

        /* Update banners */
        $banner_1_img = fn_et_update_tab_banner('et_fpbt_1', $tab_data_id, $key."1", $lang_code);
        $banner_2_img = fn_et_update_tab_banner('et_fpbt_2', $tab_data_id, $key."2", $lang_code);


        if ($data['update_all_langs']=="Y"){

          $banner_1_img_id = reset($banner_1_img);
          $banner_2_img_id = reset($banner_2_img);
          
          $lang_codes = Languages::getAll();
          unset($lang_codes[$lang_code]);
          
          foreach ($lang_codes as $new_lang_code => $v) {
            $tab_new_data_id = db_get_field("SELECT data_id FROM ?:et_featured_product_banner_tabs_tabs_data WHERE tab_id = ?i AND lang_code = ?s", $tab_id, $new_lang_code);

            $img_1=fn_get_image_pairs($tab_new_data_id, 'et_fpbt_1', 'M', true, false, $new_lang_code);
            if (!empty($img_1)){
              fn_delete_image_pairs($tab_new_data_id, 'et_fpbt_1');
            }
            fn_add_image_link($tab_new_data_id, $banner_1_img_id);

            $img_2=fn_get_image_pairs($tab_new_data_id, 'et_fpbt_2', 'M', true, false, $new_lang_code);
            if (!empty($img_1)){
              fn_delete_image_pairs($tab_new_data_id, 'et_fpbt_2');
            }
            fn_add_image_link($tab_new_data_id, $banner_2_img_id);
          }
        }


      }elseif (isset($value['tab_id'])) {
        /* NEW TAB */
        $tab_id = db_query("INSERT INTO ?:et_featured_product_banner_tabs_tabs SET ?u", $tab_sql);

        /* Tab data (language specific) */
        $tab_data_sql['tab_id']     = $tab_id;
        $tab_data_sql['lang_code']  = $lang_code;

        $tab_data_id = db_query("INSERT INTO ?:et_featured_product_banner_tabs_tabs_data SET ?u", $tab_data_sql);

        /* Update banners */
        $banner_1_img = fn_et_update_tab_banner('et_fpbt_1', $tab_data_id, $key."1", $lang_code);
        $banner_2_img = fn_et_update_tab_banner('et_fpbt_2', $tab_data_id, $key."2", $lang_code);

        $banner_1_img_id = reset($banner_1_img);
        $banner_2_img_id = reset($banner_2_img);

        /* Block data and banners (other languages) */
        $lang_codes = Languages::getAll();
        unset($lang_codes[$lang_code]);

        foreach ($lang_codes as $tab_data_sql['lang_code'] => $v) {
          $tab_data_id  = db_query("INSERT INTO ?:et_featured_product_banner_tabs_tabs_data ?e", $tab_data_sql);
          
          /* INSERT BANNERS */
          fn_add_image_link($tab_data_id, $banner_1_img_id);
          fn_add_image_link($tab_data_id, $banner_2_img_id);
        }
      }

      $updated_tabs[]=$tab_id;
    }
    /* Delete deactivated tabs */
    $deleted_tabs = array_diff($existing_tabs, $updated_tabs);
    fn_et_delete_tabs($deleted_tabs);

  }else{
    /* NEW BLOCK */
    
    /* INSERT DB VALUES */

    /* Block */
    $block_sql            = array();
    $block_sql['status']  = 'A';
    $block_sql['data']    = serialize($data['settings']);

    $block_id=db_query("INSERT INTO ?:et_featured_product_banner_tabs ?e", $block_sql);

    /* Block data (current language) */
    $block_data           = array();
    $block_data['title']  = $data['title'];

    $block_data_sql               = array();
    $block_data_sql['block_id']   = $block_id;
    $block_data_sql['data']       = serialize($block_data);
    $block_data_sql['lang_code']  = $lang_code;

    db_query("INSERT INTO ?:et_featured_product_banner_tabs_data ?e", $block_data_sql);

    /* Block data (other languages) */
    $lang_codes = Languages::getAll();
    unset($lang_codes[$lang_code]);
    foreach ($lang_codes as $block_data_sql['lang_code'] => $v) {
      db_query("INSERT INTO ?:et_featured_product_banner_tabs_data ?e", $block_data_sql);
    }

    /* Tabs */
    foreach ($data['tab'] as $key => $value) {
      /* Tab */
      $tab_data                     = array();
      $tab_data['custom_settings']  = $value['custom_settings'];
      if (isset($value['product_ids'])){
        $tab_data['content']['items']['item_ids'] = $value['product_ids'];
        $tab_data['content']['items']['filling'] = 'manually';
      }else{
        $tab_data['content'] = $value['content'];
      }
      $tab_data['banner_ids']['banner_1'] = (isset($value['banner_1']['banner_ids'])&&is_array($value['banner_1']['banner_ids'])) ?  implode(',',array_keys($value['banner_1']['banner_ids'])) : "";
      $tab_data['banner_ids']['banner_2'] = (isset($value['banner_2']['banner_ids'])&&is_array($value['banner_2']['banner_ids'])) ?  implode(',',array_keys($value['banner_2']['banner_ids'])) : "";

      
      $tab_sql              = array();
      $tab_sql['block_id']  = $block_id;
      $tab_sql['position']  = $value['position'];
      $tab_sql['data']      = serialize($tab_data);
      $tab_id = db_query("INSERT INTO ?:et_featured_product_banner_tabs_tabs SET ?u", $tab_sql);

      /* Tab data (language specific) */
      $tab_lang_data                  = array();
      $tab_lang_data['title']         = $value['title'];

      $tab_data_sql               = array();
      $tab_data_sql['tab_id']     = $tab_id;
      $tab_data_sql['data']       = serialize($tab_lang_data);
      $tab_data_sql['lang_code']  = $lang_code;

      $tab_data_id = db_query("INSERT INTO ?:et_featured_product_banner_tabs_tabs_data SET ?u", $tab_data_sql);

      /* INSERT BANNERS */
      $banner_1_img = fn_et_update_tab_banner('et_fpbt_1', $tab_data_id, $key."1", $lang_code);
      $banner_2_img = fn_et_update_tab_banner('et_fpbt_2', $tab_data_id, $key."2", $lang_code);

      $banner_1_img_id = reset($banner_1_img);
      $banner_2_img_id = reset($banner_2_img);

      /* Block data and banners (other languages) */
      $lang_codes = Languages::getAll();
      unset($lang_codes[$lang_code]);

      foreach ($lang_codes as $tab_data_sql['lang_code'] => $v) {
        $tab_data_id  = db_query("INSERT INTO ?:et_featured_product_banner_tabs_tabs_data ?e", $tab_data_sql);
        
        /* INSERT BANNERS */
        fn_add_image_link($tab_data_id, $banner_1_img_id);
        fn_add_image_link($tab_data_id, $banner_2_img_id);
      }
    }
  }

  return $block_id;
}

function fn_et_featured_product_banner_tabs_update_status($block_id,$status){
  if (!empty($block_id)) {
    db_query("UPDATE ?:et_featured_product_banner_tabs SET status = ?s WHERE block_id = ?i", $status, $block_id);

    fn_set_notification('N', __('notice'), __('status_changed'));
  }
}

function fn_get_et_tabs($block_id){
  $tab_ids = db_get_hash_array("SELECT tab_id FROM ?:et_featured_product_banner_tabs_tabs WHERE block_id = ?i", 'tab_id', $block_id);
  $tab_ids = array_keys($tab_ids);
  return $tab_ids;
}

/* UPDATE IMAGE HELPER FUNCTION */
function fn_et_attach_image_pairs($name, $object_type, $key = 0, $lang_code = CART_LANGUAGE, $object_id)
{
    $icons = fn_filter_uploaded_data($name . '_image_icon', array('png', 'gif', 'jpg', 'jpeg', 'ico'));
    $detailed = fn_filter_uploaded_data($name . '_image_detailed', array('png', 'gif', 'jpg', 'jpeg', 'ico'));
    $pairs_data[$key] = !empty($_REQUEST[$name . '_image_data'][$key]) ? $_REQUEST[$name . '_image_data'][$key]: array();
    $object_ids = array();

    return fn_update_image_pairs($icons, $detailed, $pairs_data, $object_id, $object_type, $object_ids, true, $lang_code);
}

function fn_et_update_tab_banner($name,$id,$key,$lang_code){
  $file="file_".$name."_image_icon";
  $update_image=true;
  if (!empty($_REQUEST[$file][$key]) && array($_REQUEST[$file][$key]))
  {
    $image = $_REQUEST[$file][$key];

    if ($image == $name) {
        $update_image=false;
    }
  }else{
    $update_image=false;
  }

  if ($update_image){
    fn_delete_image_pairs($id, $name);
  }
  $result=fn_et_attach_image_pairs($name, $name, $key, $lang_code, $id);
  return $result;
}

/* READ DATABASE VALUES */
function fn_et_get_featured_product_banner_tabs($params=array(), $lang_code=CART_LANGUAGE){
  $block = $joins = array();
  $condition_block = $limit = '';
  $get_product_data = false;
  static $cache = array();

  if (!empty($params['limit'])) {
    $limit = db_quote(' LIMIT 0, ?i', $params['limit']);
  }
  if (isset($params['item_ids']) && !empty($params['item_ids'])) {
    $params['block_id']=$params['item_ids'];
  }
  if (isset($params['get_product_data']) && $params['get_product_data']) {
    $get_product_data=true;
    $condition_block.=db_quote(" AND ?:et_featured_product_banner_tabs.status = 'A'");
  }

  if (!empty($params['block_id'])) {
    $condition_block.=db_quote(" AND ?:et_featured_product_banner_tabs.block_id = ?s",$params['block_id']);
  }

  if (!empty($params['active'])) {
    $condition_block.=db_quote(" AND ?:et_featured_product_banner_tabs.status = 'A'");
  }

  $fields = array (
    '?:et_featured_product_banner_tabs.block_id',
    '?:et_featured_product_banner_tabs.status',
    '?:et_featured_product_banner_tabs_data.data as q_blocks',
  );

  if (isset($params['short']) && $params['short']==true) {
    /* SHORT INFO */

    $condition_block.=db_quote(" AND ?:et_featured_product_banner_tabs_data.lang_code = ?s",$lang_code);
    $block_data = db_get_hash_array(
      "SELECT ?p FROM ?:et_featured_product_banner_tabs " .
      "LEFT JOIN ?:et_featured_product_banner_tabs_data 
        ON ?:et_featured_product_banner_tabs_data.block_id = ?:et_featured_product_banner_tabs.block_id ".
      "WHERE 1 ?p ?p",
      'block_id', implode(", ", $fields), $condition_block, $limit
    );
    foreach ($block_data as $key => $value) {
      $block_data[$key]['q_blocks']=unserialize($value['q_blocks']);
      $block_data[$key]['title']=$block_data[$key]['q_blocks']['title'];
      $tab_count=db_get_field("SELECT COUNT(*) FROM ?:et_featured_product_banner_tabs_tabs WHERE block_id = ?i", $value['block_id']);
      $block_data[$key]['tab_count']=$tab_count;
    }
    return array($block_data, $params);

  }else{
    if (!isset($cache[$params['block_id']])) {

      /* BLOCK */
      $condition_tab="";
      $addittional_fields = array(
        '?:et_featured_product_banner_tabs.data as q_blocks_data'
      );
      $block_fields=array_merge($fields,$addittional_fields);

      $block_data = db_get_row(
        "SELECT ?p FROM ?:et_featured_product_banner_tabs " .
        "LEFT JOIN ?:et_featured_product_banner_tabs_data 
          ON ?:et_featured_product_banner_tabs_data.block_id = ?:et_featured_product_banner_tabs.block_id
          AND ?:et_featured_product_banner_tabs_data.lang_code = ?s ".
        "WHERE 1 ?p ?p",
        implode(", ", $block_fields), $lang_code, $condition_block, $limit
      );

      if (!empty($block_data)){
        $block_data['q_blocks']=unserialize($block_data['q_blocks']);
        $block_data['q_blocks_data']=unserialize($block_data['q_blocks_data']);
      }

      if (!empty($block_data)){
        /* TABS */
        $tab_fields=array(
          '?:et_featured_product_banner_tabs_tabs.tab_id',
          '?:et_featured_product_banner_tabs_tabs.position',
          '?:et_featured_product_banner_tabs_tabs.data as q_tabs',

          '?:et_featured_product_banner_tabs_tabs_data.data_id',
          '?:et_featured_product_banner_tabs_tabs_data.data as q_tabs_data',
        );
        $condition_tab.=db_quote(" AND ?:et_featured_product_banner_tabs_tabs.block_id = ?s",$params['block_id']);

        $sort_tab = db_quote("ORDER BY position asc");

        $tabs_data = db_get_array(
          "SELECT ?p FROM ?:et_featured_product_banner_tabs_tabs " .
          "LEFT JOIN 
            ?:et_featured_product_banner_tabs_tabs_data ON
            ?:et_featured_product_banner_tabs_tabs_data.tab_id = ?:et_featured_product_banner_tabs_tabs.tab_id
          AND 
            ?:et_featured_product_banner_tabs_tabs_data.lang_code = ?s ".
          "WHERE 1 ?p ?p ",
          implode(", ", $tab_fields), $lang_code, $condition_tab, $sort_tab
        );
        foreach ($tabs_data as $key => $value) {
          $tabs_data[$key]['q_tabs']=unserialize($tabs_data[$key]['q_tabs']);
          $tabs_data[$key]['q_tabs_data']=unserialize($tabs_data[$key]['q_tabs_data']);

          $tabs_data[$key]['banner_image_1']=fn_get_image_pairs($value['data_id'], 'et_fpbt_1', 'M', true, false, $lang_code);
          $tabs_data[$key]['banner_image_2']=fn_get_image_pairs($value['data_id'], 'et_fpbt_2', 'M', true, false, $lang_code);

          if (!empty($tabs_data[$key]['q_tabs']['product_ids'])){
            $tabs_data[$key]['q_tabs']['content']['items']['filling']='manually';
            $tabs_data[$key]['q_tabs']['content']['items']['item_ids']=$tabs_data[$key]['q_tabs']['product_ids'];
            unset($tabs_data[$key]['q_tabs']['product_ids']);
          }

          /* GET PRODUCT DATA */
          if ($get_product_data){
            $block_scheme = SchemesManager::getBlockScheme('products', array(), true);

            $filling=$tabs_data[$key]['q_tabs']['content']['items']['filling'];
            $block_scheme['content']['items']['fillings'][$filling]['params']['subcats']=true;
            $product_data = Block::instance()->getItems('items', $tabs_data[$key]['q_tabs'], $block_scheme, $key);

            $et_params=array(
              'get_icon'=>true,
              'get_detailed'=>true,
            );
            fn_gather_additional_products_data($product_data,$et_params);


            $tabs_data[$key]['product_data']=$product_data;
          }

          if ($get_product_data){
            foreach ($tabs_data[$key]['q_tabs']['banner_ids'] as $k => $v) {
              if (!empty($v)){
                $banner_data = fn_get_banners(array('item_ids'=>$v));
                $tabs_data[$key]['banner_data'][$k] = $banner_data[0];
              }
            }
          }
        }
      }

      if (!empty($block_data)){
        /* Format return data */
        $cache[$params['block_id']]         = $block_data;
        $cache[$params['block_id']]['tabs'] = $tabs_data;
      }else{
        $cache[$params['block_id']]         = array();
      }
    }
    
    $return_data= $cache[$params['block_id']];

    return array($return_data, $params);
  }

}

function fn_et_get_featured_product_banner_tabs_title($block_id,$lang_code=CART_LANGUAGE){
  if (!empty($block_id)){
    $data = db_get_field("SELECT data FROM ?:et_featured_product_banner_tabs_data WHERE block_id = ?i AND lang_code = ?s", $block_id, $lang_code);
    $data = unserialize($data);
    $title= $data['title'];

    return $title;
  }
}

/* DELETE DATABASE VALUES */

function fn_et_featured_product_banner_tabs_delete_by_id($block_id){
  if (!empty($block_id)) {

    $tab_ids=fn_get_et_tabs($block_id);
    fn_et_delete_tabs($tab_ids);

    db_query("DELETE FROM ?:et_featured_product_banner_tabs_data WHERE block_id = ?i", $block_id);
    db_query("DELETE FROM ?:et_featured_product_banner_tabs WHERE block_id = ?i", $block_id);
  }
}

function fn_et_delete_tabs($tab_ids=array()){
  foreach ($tab_ids as $key => $tab_id) {
    $tab_data_id = db_get_array("SELECT data_id FROM ?:et_featured_product_banner_tabs_tabs_data WHERE tab_id = ?i", $tab_id);
    foreach ($tab_data_id as $k => $data_id) {
      fn_delete_image_pairs($data_id, 'et_fpbt_1');
      fn_delete_image_pairs($data_id, 'et_fpbt_2');
    }
    db_query("DELETE FROM ?:et_featured_product_banner_tabs_tabs WHERE tab_id = ?i", $tab_id);
    db_query("DELETE FROM ?:et_featured_product_banner_tabs_tabs_data WHERE tab_id = ?i", $tab_id);
  }
}

function fn_et_get_featured_product_banner_tab($params,$get_product_data=true,$lang_code=DESCR_SL){

  if (!empty($params['tab_id'])){
    $tab_id=$params['tab_id'];
    /* TABS */
    $tab_fields=array(
      '?:et_featured_product_banner_tabs_tabs.tab_id',
      '?:et_featured_product_banner_tabs_tabs.position',
      '?:et_featured_product_banner_tabs_tabs.data as q_tabs',

      '?:et_featured_product_banner_tabs_tabs_data.data_id',
      '?:et_featured_product_banner_tabs_tabs_data.data as q_tabs_data',
    );
    $condition_tab=db_quote(" AND ?:et_featured_product_banner_tabs_tabs.tab_id = ?s",$tab_id);

    $sort_tab = db_quote("ORDER BY position asc");

    $tabs_data = db_get_array(
      "SELECT ?p FROM ?:et_featured_product_banner_tabs_tabs " .
      "LEFT JOIN 
        ?:et_featured_product_banner_tabs_tabs_data ON
        ?:et_featured_product_banner_tabs_tabs_data.tab_id = ?:et_featured_product_banner_tabs_tabs.tab_id
      AND 
        ?:et_featured_product_banner_tabs_tabs_data.lang_code = ?s ".
      "WHERE 1 ?p ?p ",
      implode(", ", $tab_fields), $lang_code, $condition_tab, $sort_tab
    );

    foreach ($tabs_data as $key => $value) {
      $tabs_data[$key]['q_tabs']=unserialize($tabs_data[$key]['q_tabs']);
      $tabs_data[$key]['q_tabs_data']=unserialize($tabs_data[$key]['q_tabs_data']);

      $tabs_data[$key]['banner_image_1']=fn_get_image_pairs($value['data_id'], 'et_fpbt_1', 'M', true, false, $lang_code);
      $tabs_data[$key]['banner_image_2']=fn_get_image_pairs($value['data_id'], 'et_fpbt_2', 'M', true, false, $lang_code);

      if (!empty($tabs_data[$key]['q_tabs']['product_ids'])){
        $tabs_data[$key]['q_tabs']['content']['items']['filling']='manually';
        $tabs_data[$key]['q_tabs']['content']['items']['item_ids']=$tabs_data[$key]['q_tabs']['product_ids'];
        unset($tabs_data[$key]['q_tabs']['product_ids']);
      }

      /* GET PRODUCT DATA */
      if ($get_product_data){
        $block_scheme = SchemesManager::getBlockScheme('products', array(), true);

        $filling=$tabs_data[$key]['q_tabs']['content']['items']['filling'];
        $block_scheme['content']['items']['fillings'][$filling]['params']['subcats']=true;
        $product_data = Block::instance()->getItems('items', $tabs_data[$key]['q_tabs'], $block_scheme, $key);

        $et_params=array(
          'get_icon'=>true,
          'get_detailed'=>true,
        );
        fn_gather_additional_products_data($product_data,$et_params);


        $tabs_data[$key]['product_data']=$product_data;
      }

      if ($get_product_data){
        foreach ($tabs_data[$key]['q_tabs']['banner_ids'] as $k => $v) {
          if (!empty($v)){
            $banner_data = fn_get_banners(array('item_ids'=>$v));
            $tabs_data[$key]['banner_data'][$k] = $banner_data[0];
          }
        }
      }
    }

    return $tabs_data;
  }
}

function fn_et_featured_product_banner_tabs_update_language_post($language_data, $lang_id, $action)
{

  if ($action == 'add') {
    $data = db_get_array("SELECT * FROM ?:et_featured_product_banner_tabs_data WHERE lang_code = ?s", DEFAULT_LANGUAGE);
    foreach ($data as $_data) {

      // unset($_data['block_id']);
      $_data['lang_code']=$language_data['lang_code'];

      db_query("REPLACE INTO ?:et_featured_product_banner_tabs_data ?e", $_data);
    }

    $data = db_get_array("SELECT * FROM ?:et_featured_product_banner_tabs_tabs_data WHERE lang_code = ?s", DEFAULT_LANGUAGE);

    foreach ($data as $_data) {
      unset($_data['data_id']);
      $_data['lang_code']=$language_data['lang_code'];

      $new_id=db_query("REPLACE INTO ?:et_featured_product_banner_tabs_tabs_data ?e", $_data);
    }
  }
}

function fn_et_featured_product_banner_tabs_delete_languages_post($lang_ids, $lang_codes, $deleted_lang_codes)
{
  foreach ($deleted_lang_codes as $lang_code) {
    db_query("DELETE FROM ?:et_featured_product_banner_tabs_data WHERE lang_code = ?s", $lang_code);
    db_query("DELETE FROM ?:et_featured_product_banner_tabs_tabs_data WHERE lang_code = ?s", $lang_code);
  }
}