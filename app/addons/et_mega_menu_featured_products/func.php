<?php
use Tygh\Registry;
use Tygh\BlockManager\Block;
use Tygh\Languages\Languages;
use Tygh\Menu;
use Tygh\BlockManager\SchemesManager;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_et_mega_menu_featured_products_install(){
  $fields = fn_get_table_fields('et_category_menu');
  if (!in_array('products', $fields)) {
      db_query("ALTER TABLE ?:et_category_menu ADD COLUMN `products` text");
  }
}

function fn_et_mega_menu_featured_products_uninstall(){
  db_query("ALTER TABLE ?:et_category_menu DROP `products`");
}


/************************************/
/* CATEGORY MENU SETTINGS FUNCTIONS */
/************************************/

/* INSERT/UPDATE DB VALUES */
function fn_et_mega_menu_featured_products_et_update_category_pre(&$category_data, &$data)
{
  $et_menu          = $category_data['et_menu'];
  
  if (isset($et_menu['products'])){
    if (!empty($et_menu['products']['ids'])){
      $et_menu['products']['count']=count($et_menu['products']['ids']);
      @asort($et_menu['products']['ids']);
      $et_menu['products']['ids']=implode(',', array_keys($et_menu['products']['ids']));
    }
    if (isset($et_menu['products']['content']['items']['item_ids']) && is_array($et_menu['products']['content']['items']['item_ids'])){

      $item_ids=$et_menu['products']['content']['items']['item_ids'];
      $et_menu['products']['count']=count($item_ids);
      if (is_array($item_ids)) {
          @asort($item_ids);
          $item_ids = implode(',', array_keys($item_ids));
      }
      $et_menu['products']['content']['items']['item_ids']=$item_ids;
    }elseif (isset($et_menu['products']['content']['items']['limit']) && !empty($et_menu['products']['content']['items']['limit'])) {
      $et_menu['products']['count']=$et_menu['products']['content']['items']['limit'];
    }
    
    $data['products'] = serialize($et_menu['products']);
  }

}

/* READ DATABASE VALUES */
function fn_et_mega_menu_featured_products_et_get_category_multi_pre(&$fields){
  $fields[]='products';
}

function fn_et_mega_menu_featured_products_et_get_category_multi_post(&$et_menu,$categ_id,$get_product_data){
  $et_menu[$categ_id]['products']=unserialize($et_menu[$categ_id]['products']);

  /* GET PRODUCT DATA */
  if (!empty($et_menu[$categ_id]['products']['ids'])){
    $et_menu[$categ_id]['products']['content']['items']['filling']='manually';
    $et_menu[$categ_id]['products']['content']['items']['item_ids']=$et_menu[$categ_id]['products']['ids'];
    unset($et_menu[$categ_id]['products']['ids']);
  }
  if ($get_product_data){
    $block_scheme = SchemesManager::getBlockScheme('products', array(), true);

    $filling=$et_menu[$categ_id]['products']['content']['items']['filling'];
    $block_scheme['content']['items']['fillings'][$filling]['params']['subcats']=true;
    $product_data = Block::instance()->getItems('items', $et_menu[$categ_id]['products'], $block_scheme, $categ_id);

    $et_params=array(
      'get_icon'=>true,
      'get_detailed'=>true,
      'get_additional'=>true
    );
    fn_gather_additional_products_data($product_data,$et_params);
    $et_menu[$categ_id]['products']['detailed']=$product_data;
  }
}
function fn_et_mega_menu_featured_products_et_get_category_pre(&$fields){
  $fields[]='products';
}

function fn_et_mega_menu_featured_products_et_get_category_post(&$et_menu,$get_product_data){

  $et_menu['products']=unserialize($et_menu['products']);
  $et_menu_id=$et_menu['et_menu_id'];
  
  /* GET PRODUCT DATA */
  if (!empty($et_menu['products']['ids'])){
    $et_menu['products']['content']['items']['filling']='manually';
    $et_menu['products']['content']['items']['item_ids']=$et_menu['products']['ids'];
    unset($et_menu['products']['ids']);
  }

  if ($get_product_data){
    $block_scheme = SchemesManager::getBlockScheme('products', array(), true);

    $filling=$et_menu['products']['content']['items']['filling'];
    $block_scheme['content']['items']['fillings'][$filling]['params']['subcats']=true;
    $product_data = Block::instance()->getItems('items', $et_menu['products'], $block_scheme, $et_menu_id);

    $et_params=array(
      'get_icon'=>true,
      'get_detailed'=>true,
      'get_additional'=>true
    );
    fn_gather_additional_products_data($product_data,$et_params);
    $et_menu['products']['detailed']=$product_data;
  }


}

