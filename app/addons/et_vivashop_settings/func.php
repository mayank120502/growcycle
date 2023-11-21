<?php
use Tygh\Registry;
use Tygh\Settings;

use Tygh\Menu;
use Tygh\DataKeeper;
use Tygh\Enum\YesNo;
use Tygh\Enum\ProductTracking;

function fn_et_vivashop_settings_install(){

  $fields = fn_get_table_fields('bm_grids');
  if (!in_array('company_id', $fields)) {
      db_query("ALTER TABLE `?:bm_grids` ADD COLUMN `et_grid` VARCHAR( 255 ) NOT NULL, ADD COLUMN `et_grid_bkg` mediumtext;");
  }

}
function fn_et_vivashop_settings_uninstall(){
  db_query("ALTER TABLE `?:bm_grids` DROP `et_grid`, DROP `et_grid_bkg`;");
}

function fn_et_format_price($price, $currency, $span_id = '', $class = '', $is_secondary = false, $live_editor_name = '', $live_editor_phrase = '')
{

  $value = fn_format_rate_value(
    $price,
    $number_type,
    $currency['decimals'],
    $currency['decimals_separator'],
    $currency['thousands_separator'],
    $currency['coefficient']
  );

  if (isset($currency['decimals_separator']) && !empty($currency['decimals_separator'])){
    $dec=strpos($value,$currency['decimals_separator']);
  }else{
    $dec=0;
    $et_decimals='';
  }
  
  if ($dec>0){
   $et_decimals=substr($value,$dec+1);
   $et_decimals="<sup>".$et_decimals."</sup>";
   $value=substr($value,0,$dec);
  }


  if (!empty($span_id) && $is_secondary) {
    $span_id = 'sec_' . $span_id;
  }

  $span_id = !empty($span_id) ? ' id="' . $span_id . '"' : '';
  $class = !empty($class) ? ' class="' . $class . '"' : '';

  $live_editor_attrs = '';
  if (Registry::get('runtime.customization_mode.live_editor') && !empty($live_editor_name)) {
    $live_editor_attrs = ' data-ca-live-editor-obj="' . $live_editor_name . '"';
    if (!empty($live_editor_phrase)) {
      $live_editor_attrs .= ' data-ca-live-editor-phrase="' . $live_editor_phrase . '"';
    }
  }

  if ($class) {
    $currency['symbol'] = '<span' . $class . '>' . $currency['symbol'] . '</span>';
  }

  $data = array (
    '<span' . $span_id . $class . $live_editor_attrs . '>',
    $value.$et_decimals,
    '</span>',
  );

  if ($currency['after'] == 'Y') {
    array_push($data, '&nbsp;' . $currency['symbol']);
  } else {
    array_unshift($data, $currency['symbol']);
  }

  return implode('', $data);

}

function fn_et_get_product_counts_by_category($params, $lang_code = CART_LANGUAGE)
{
  static $cache = array();
  $cache_id=$params['company_id'];

  if (!isset($cache[$cache_id])) {
    $default_params = array(
        'company_id' => 0,
        'sort_by' => 'position',
        'sort_order' => 'asc',
    );

    $params = array_merge($default_params, $params);

    $sort_fields = array(
        'position' => '?:categories.position',
        'category' => '?:category_descriptions.category',
        'count' => 'count',
    );

    $sort = db_sort($params, $sort_fields, $default_params['sort_by'], $default_params['sort_order']);

    $condition = $join = '';
    if (!empty($params['company_id'])) {
        if (is_array($params['company_id'])) {
            $condition .= db_quote(" AND ?:products.company_id IN (?n) ", $params['company_id']);
        } else {
            $condition .= db_quote(" AND ?:products.company_id = ?i ", $params['company_id']);
        }
    }
    $condition .= db_quote(" AND ?:category_descriptions.lang_code = ?s ", $lang_code);

    $condition .= db_quote(" AND ?:products.status = 'A' ");

    $join .= 'JOIN ?:products ON ?:products_categories.product_id = ?:products.product_id ';
    $join .= 'JOIN ?:categories ON ?:products_categories.category_id = ?:categories.category_id ';
    $join .= 'JOIN ?:category_descriptions ON ?:products_categories.category_id = ?:category_descriptions.category_id ';

    if (Registry::get('addons.product_variations.status')=="A"){
      $join .= 'LEFT JOIN ?:product_variation_group_products ON ?:products_categories.product_id = ?:product_variation_group_products.product_id ';
      $condition .= db_quote(" AND (?:product_variation_group_products.parent_product_id = 0 OR ?:products_categories.product_id not in (SELECT  ?:product_variation_group_products.product_id FROM  ?:product_variation_group_products WHERE 1))");
    }

    $hide_out_of_stock_products = Registry::get('settings.General.show_out_of_stock_products') === YesNo::NO;

    if ($hide_out_of_stock_products) {
        if (Registry::get('settings.General.global_tracking') === ProductTracking::TRACK) {
            $condition .= db_quote(' AND ?:products.amount > 0');
        } elseif (Registry::get('settings.General.default_tracking') === ProductTracking::TRACK) {
            $condition .= db_quote(' AND (?:products.amount > 0 OR ?:products.tracking = ?s)', ProductTracking::DO_NOT_TRACK);
        } else {
            $condition .= db_quote(' AND (?:products.amount > 0 OR ?:products.tracking = ?s OR ?:products.tracking IS NULL)', ProductTracking::DO_NOT_TRACK);
        }
    }
    
    $result = db_get_hash_array("SELECT COUNT(*) as count, ?:category_descriptions.category, ?:category_descriptions.category_id FROM ?:products_categories ?p WHERE 1 ?p GROUP BY ?:products_categories.category_id ?p", 'category_id', $join, $condition, $sort);
    
    $cache[$cache_id]=$result;
  }else{
    $result=$cache[$cache_id];
  }
  return $result;
}

function fn_et_adjust_categs($data,&$pc,$company_pc=array(),$all_categs=array()){

  $temp=array();
  foreach ($data['subcategories'] as $k => $v) {
    $categ_id=$v['category_id'];
    $parent_id=$v['parent_id'];
  
    if (isset($v['subcategories'])){
      $pc[$categ_id]=0;
      
      $ret=fn_et_adjust_categs($v,$pc,$company_pc,$all_categs);

      $temp[$categ_id]=$v;

      $temp[$categ_id]['subcategories']=$ret;
      if (!empty($company_pc) && isset($company_pc[$categ_id])){

         // $temp[$categ_id]['product_count']=$pc[$categ_id];
         $temp[$categ_id]['product_count']+=$pc[$categ_id];
         $pc[$parent_id]+=$temp[$categ_id]['product_count'];
      }elseif (empty($company_pc)){
         $temp[$categ_id]['product_count']+=$pc[$categ_id];
         $pc[$parent_id]+=$temp[$categ_id]['product_count'];
      }else{

        $temp[$categ_id]['product_count']=$pc[$categ_id];
        $pc[$parent_id]+=$pc[$categ_id];
      }
  
     
    }else{
      $temp[$categ_id]=$v;

      if (!empty($company_pc) && isset($company_pc[$categ_id])){
        $temp[$categ_id]['product_count']=$company_pc[$categ_id]['count'];
        $pc[$parent_id]+=$company_pc[$categ_id]['count'];
      }elseif (empty($company_pc)){
        $pc[$parent_id]+=$all_categs[$categ_id]['count'];
      }
      
    }

  }

  return $temp;
}

function fn_et_vendor_adjust_categs($data,&$pc,$company_pc=array()){

  $temp=array();
  foreach ($data['subcategories'] as $k => $v) {
    $categ_id=$v['category_id'];
    $parent_id=$v['parent_id'];
 
    if (isset($v['subcategories'])){
      $pc[$categ_id]=0;
      
      $ret=fn_et_vendor_adjust_categs($v,$pc,$company_pc);

      $temp[$categ_id]=$v;

      $temp[$categ_id]['subcategories']=$ret;
      if (!empty($company_pc) && isset($company_pc[$categ_id])){

         $temp[$categ_id]['product_count']=$pc[$categ_id];
         $pc[$parent_id]+=$temp[$categ_id]['product_count'];
      }elseif (empty($company_pc)){
         $temp[$categ_id]['product_count']+=$pc[$categ_id];
         $pc[$parent_id]+=$temp[$categ_id]['product_count'];
      }else{

        $temp[$categ_id]['product_count']=$pc[$categ_id];
        $pc[$parent_id]+=$pc[$categ_id];
      }
 
     
    }else{
      $temp[$categ_id]=$v;

      if (!empty($company_pc) && isset($company_pc[$categ_id])){
        $temp[$categ_id]['product_count']=$company_pc[$categ_id]['count'];
        $pc[$parent_id]+=$company_pc[$categ_id]['count'];
      }elseif (empty($company_pc)){
        $pc[$parent_id]+=$v['product_count'];
      }
      
    }

  }

  return $temp;
}

function fn_et_get_categories($category_id = '0',$company_ids = '0', $lang_code = CART_LANGUAGE)
{
  $params = array (
    'category_id' => $category_id,
    'simple' => false,
    'company_ids' => $company_ids
  );
  
  list($categories,) = fn_get_categories($params, $lang_code);

  if (Registry::get('addons.et_vivashop_settings.et_viva_sidebar_pc')==="Y"){

    $pc=array();

    if ($company_ids>0){
      $company_pc=fn_et_get_product_counts_by_category(array('company_id'=>$company_ids));
    }else{
      $company_pc=fn_et_get_product_counts_by_category(array('company_id'=>0));
    }

    foreach ($categories as $key => $value) {
     $categ_id=$value['category_id'];

     if (isset($value['subcategories'])){
      if ($company_ids>0){
        $ret=fn_et_vendor_adjust_categs($value,$pc,$company_pc);
        $categories[$categ_id]['product_count']=$pc[$categ_id];
      }else{
        $all_categs=fn_et_get_product_counts_by_category(array('company_id'=>0));
        $ret=fn_et_adjust_categs($value,$pc,$all_categs);
        $categories[$categ_id]['product_count']+=$pc[$categ_id];
      }

      $categories[$categ_id]['subcategories']=$ret;

     }elseif (!empty($company_pc) && isset($company_pc[$categ_id])){
       $categories[$categ_id]['product_count']=$company_pc[$categ_id]['count'];
     }

    }
  }else{
    if (!empty($categories)){
      $categories['hide_product_count']=true;
    }
  }
  return $categories;
}

function fn_et_vivashop_settings_update_grid(&$grid_data)
{
  if (isset($grid_data['et_grid'])) {
    $grid_data['et_grid'] = empty($grid_data['et_grid']) ? 'N' : (is_array($grid_data['et_grid']) ? implode(',', $grid_data['et_grid']) : $grid_data['et_grid']);
  }
}

function fn_et_get_wishlist_get_count(){
  if (function_exists('fn_wishlist_get_count')){
    return fn_wishlist_get_count();
  }else{
    return 0;
  }
}

function et_sort_by_pos_name($a, $b) {
  if ($a['position'] < $b['position']){
    $retval=-1;
  }
  if ($a['position'] == $b['position']){
    $retval=0;
  }
  if ($a['position'] > $b['position']){
    $retval=1;
  }
  if ($retval == 0) {
    if ($a['variant'] < $b['variant']){
      $retval=-1;
    }
    if ($a['variant'] == $b['variant']){
      $retval=0;
    }
    if ($a['variant'] > $b['variant']){
      $retval=1;
    }
  }
  return $retval;
}



function fn_et_vivashop_settings_get_filters_products_count_pre(&$params,$cache_params,$cache_tables){
  if (isset($params['block_data'])){
    if ($params['block_data']['properties']['template']=='blocks/product_filters/for_category/horizontal_filters.tpl'){

      if (fn_allowed_for('MULTIVENDOR') && $params['dispatch']=="companies.products"){

        $et_vs=fn_et_mv_get_vs($params['company_id']);

        if(isset($et_vs['data']['filters'])){
          if ($et_vs['data']['filters']!="horizontal"){
            unset($params['dispatch']);
          }
        }elseif (Registry::get('addons.et_vivashop_mv_functionality.et_vendor_filters'!="horizontal")){
          unset($params['dispatch']);
        }

      }

    }else if ($params['block_data']['properties']['template']=='blocks/product_filters/for_category/original.tpl'){
      if (fn_allowed_for('MULTIVENDOR') && $params['dispatch']=="companies.products"){

        $et_vs=fn_et_mv_get_vs($params['company_id']);
        
        if(isset($et_vs['data']['filters'])){
          if ($et_vs['data']['filters']!="vertical"){
            unset($params['dispatch']);
          }
        }elseif (Registry::get('addons.et_vivashop_mv_functionality.et_vendor_filters'!="vertical")){
          unset($params['dispatch']);
        }

      }else{
        $default_filters=Registry::get('addons.et_vivashop_settings.et_viva_filters');

        if ($default_filters!="vertical"){
          unset($params['dispatch']);
        }
      }

    }
  }

}

function fn_et_vivashop_settings_get_filters_products_count_post($params,$lang_code,&$filters,$selected_filters){
  $category_id=0;
  $features_hash='';
  $q=isset($params['q'])?$params['q']:'';
  $pcode_from_q=isset($params['pcode_from_q'])?$params['pcode_from_q']:'';
  $pshort=isset($params['pshort'])?$params['pshort']:'';
  $pfull=isset($params['pfull'])?$params['pfull']:'';
  $pname=isset($params['pname'])?$params['pname']:'';
  $pkeywords=isset($params['pkeywords'])?$params['pkeywords']:'';

  if (isset($params['category_id'])){
    $category_id=$params['category_id'];
  }
  if (isset($params['features_hash'])){
    $features_hash=$params['features_hash'];
  }
  $count_params=array(
    'cid'           =>  $category_id,
    'subcats'       =>  'Y',
    'custom_extend' =>  array(),
    'features_hash' =>  '',
    'q'             =>  $q,
    'pcode_from_q'  =>  $pcode_from_q,
    'pshort'        =>  $pshort,
    'pfull'         =>  $pfull,
    'pname'         =>  $pname,
    'pkeywords'     =>  $pkeywords,
    'status'        =>  'A',
    'group_child_variations' => 1,
    'load_products_extra_data'=>0

  );

  if (isset($params['company_id'])){
    $count_params['company_id']=$params['company_id'];
  }

  foreach ($filters as $filter_id => $filter_value) {

    /* Slider filter */
    if (isset($filter_value['slider']) && $filter_value['selected_range']){

      $total_items=0;
      if (!empty($features_hash)){
        $count_params['features_hash']=fn_add_filter_to_hash($features_hash,$filter_id,$variant_id);
      }
      if (Registry::get('addons.et_vivashop_settings.et_viva_filter_pc')==="Y"){
        $count=fn_get_products($count_params);
        $total_items=$count[1]['total_items'];

        $filters[$filter_id]['et_item_count']=$total_items;
      }

    }elseif (isset($filter_value['variants']) || isset($filter_value['selected_variants'])  ){

      /* Set selected */
      if (isset($filter_value['selected_variants'])){
        foreach ($filter_value['selected_variants'] as $key => $value) {
          $filter_value['selected_variants'][$key]['et_selected']=true;
        }
      }
      
      /* Merge all variants */
      $all_variants=array();
      if (isset($filter_value['variants']) && isset($filter_value['selected_variants'])){
        $all_variants=fn_array_merge($filter_value['variants'],$filter_value['selected_variants']);
      }else if (!isset($filter_value['selected_variants'])){
        $all_variants=$filter_value['variants'];
      }else {
        $all_variants=$filter_value['selected_variants'];
      }

      /* Sort the variants */
      usort($all_variants, 'et_sort_by_pos_name');

      /* Add product count */
      foreach ($all_variants as $key => $variant_value) {
        $variant_id=$variant_value['variant_id'];
        $total_items=0;


        /* Get product count*/
        if (Registry::get('addons.et_vivashop_settings.et_viva_filter_pc')==="Y"){
          $et_filter_hash=array($filter_id=>$variant_id);
          $count_params['features_hash']=fn_generate_filter_hash($et_filter_hash);
          if (!isset($variant_value['disabled'])){
            $count=fn_get_products($count_params);
            $total_items=$count[1]['total_items'];
          }

          /* Set count for selected variants */
          if ( isset($filter_value['selected_variants']) && in_array($variant_id, array_keys($filter_value['selected_variants']))) {
            $filters[$filter_id]['selected_variants'][$variant_id]['et_item_count']=$total_items;
          }
        }
        /* Create et_all_variants */
        $filters[$filter_id]['et_all_variants'][$variant_id]=$variant_value;
        if (Registry::get('addons.et_vivashop_settings.et_viva_filter_pc')==="Y"){
          $filters[$filter_id]['et_all_variants'][$variant_id]['et_item_count']=$count[1]['total_items'];
        }
      }
    }
  }

}

function fn_et_vivashop_settings_gather_additional_products_data_post($product_ids, $params, &$products, $auth, $lang_code){
  static $cache = array();
  if (isset($params['get_variation_features_variants']) && $params['get_variation_features_variants']){

    foreach ($products as $key => $product) {
      if (isset($product['variation_features_variants'])){
        foreach ($product['variation_features_variants'] as $feature_id => $variation_features_variants) {
          $color_hex_found=false;
          $feature_data=fn_get_product_feature_data($feature_id);

          if ($feature_data['filter_style']=="color"){

            foreach ($variation_features_variants as $k => $value) {
              foreach ($variation_features_variants['variants'] as $variant_id => $value) {
              
                if (!isset($cache[$variant_id])) {

                  $color_hex=db_get_field("SELECT ?:product_feature_variants.color FROM ?:product_feature_variants WHERE 0721843 and variant_id=?i ", $variant_id);

                  $cache[$variant_id]=$color_hex;
                }else{
                  $color_hex=$cache[$variant_id];
                }
                
                if (!empty($color_hex)){
                  $color_hex_found=true;
                }
                $products[$key]['variation_features_variants'][$feature_id]['variants'][$variant_id]['color_hex']=$color_hex;
              }
            }
            if ($color_hex_found) {
              $products[$key]['variation_features_variants'][$feature_id]['color_hex_found']=$color_hex_found;
            }
          }
        }
      }
    }
  }
}


function fn_et_vivashop_settings_update_block_pre(&$block_data){
  if (isset($block_data['type']) && strpos($block_data['type'],'et_')===0){

    $type=substr($block_data['type'], 3);
  
    if ($type=="cta"){
      if (!Registry::get('runtime.simple_ultimate')) {
        $company_id = Registry::get('runtime.company_id');
      } else {
        $company_id = 1;
      }
      fn_attach_image_pairs('et_block_bkg', 'et_block_bkg', $company_id);
    }

    $colors=isset($block_data[$type][$type."_colors"]) ? $block_data[$type][$type."_colors"]:"";

    if (!empty($colors)) {
      $properties=isset($block_data['properties']) ? unserialize($block_data['properties']):array();
      $properties['et_settings']=$colors;

      $block_data['properties']=serialize($properties);
    }

  }else if (isset($block_data['type']) && $block_data['type']=='testimonials'){

    $colors=isset($block_data['testimonials']["et_colors"]) ? $block_data['testimonials']["et_colors"]:"";

    if (!empty($colors)) {
      $properties=unserialize($block_data['properties']);
      $properties['et_settings']=$colors;

      $block_data['properties']=serialize($properties);
    }

    if (!Registry::get('runtime.simple_ultimate')) {
      $company_id = Registry::get('runtime.company_id');
    } else {
      $company_id = 1;
    }
    fn_attach_image_pairs('et_testimonials_bkg', 'et_testimonials_bkg', $company_id);
  }
}
function fn_et_vivashop_settings_update_block_post($block_data){
  if (isset($block_data['type']) && strpos($block_data['type'],'et_')===0){

    $type=substr($block_data['type'], 3);

    $colors=isset($block_data[$type][$type."_colors"]) ? $block_data[$type][$type."_colors"]:"";

    if (isset($colors)) { 
      $setting_name=$type.'_colors';
      $setting_value=serialize($colors);
    }
  }
}

function fn_et_vivashop_settings_get_block_post(&$block){
  if (isset($block['type'])){
    if (strpos($block['type'],'et_')===0){
      $type=substr($block['type'], 3);
      $et_settings=fn_get_et_vivashop_block_settings($type);

      if (isset($et_settings)&&!empty($et_settings)){
        $block['et_additional_settings']=$et_settings;
      }
    }else if ($block['type']=='testimonials'){
      $block['et_image']=fn_get_image_pairs(fn_et_vivashop_settings_get_bkg_id(), 'et_testimonials_bkg', 'M', false, true);
    }
  }
}

function fn_et_vivashop_settings_get_blocks_post(&$data){
  foreach ($data as $s_key => $s_value) {
    foreach ($s_value as $b_key => $b_value) {
      if (strpos($b_value['type'],'et_')===0){
        $type=substr($b_value['type'], 3);
        $et_settings=fn_get_et_vivashop_block_settings($type);
        if (isset($et_settings)&&!empty($et_settings)){
          $data[$s_key][$b_key]['et_image_data']=$et_settings;
        }
      }else if ($b_value['type']=='testimonials'){
        $type=$b_value['type'];
        $et_settings=fn_get_et_vivashop_block_settings($type);
        if (isset($et_settings)&&!empty($et_settings)){
          $data[$s_key][$b_key]['et_image_data']=$et_settings;
        }
      }
    }
  }
  return true;
}

function fn_get_et_vivashop_block_settings($type)
{
  if (isset($type)&&!empty($type)){
    if ($type=="cta"){
      $return['main_pair'] = fn_get_image_pairs(fn_et_vivashop_settings_get_bkg_id(), 'et_block_bkg', 'M', false, true, DESCR_SL);
    }else if ($type=="testimonials"){
      $return['main_pair'] = fn_get_image_pairs(fn_et_vivashop_settings_get_bkg_id(), 'et_testimonials_bkg', 'M', false, true, DESCR_SL);
    }
    if (isset($return)){
      return $return;
    }
  }
}


function fn_et_vivashop_settings_get_bkg_id()
{
  if (Registry::get('runtime.simple_ultimate')) {
    $id = 1;
  } elseif (Registry::get('runtime.company_id')) {
    $id = Registry::get('runtime.company_id');
  } else {
    $id = 0;
  }

  return $id;
}


/* Add rating counts */
function fn_et_vivashop_settings_get_discussion_post($object_id, $object_type, $get_posts, $params, &$discussion){
  if (AREA=='C' && $discussion['type']!="C"){
    $count=array(
      '5'=>0,
      '4'=>0,
      '3'=>0,
      '2'=>0,
      '1'=>0,
    );
    $thread_id=$discussion['thread_id'];
    $condition = db_quote(" AND ?:discussion_rating.thread_id = ?i AND ?:discussion_posts.status = 'A'", $thread_id);

    $et_posts = db_get_array(
        "SELECT ?:discussion_rating.* FROM ?:discussion_rating LEFT JOIN ?:discussion_posts ON ?:discussion_posts.post_id = ?:discussion_rating.post_id WHERE 1 ?p ORDER BY ?:discussion_rating.rating_value DESC", $condition
    );
    
    if (!empty($et_posts)){
      foreach ($et_posts as $k => $post) {
        if (isset($post['rating_value'])) {
          $val=$post['rating_value'];
          $count[$val]++;
        }
      }
    }
    if (!empty($discussion)){
      $discussion['et_count']=$count;
      $discussion['et_count_total']=count($et_posts);
    }
  }
}


function et_get_device(){
  if (Registry::get('addons.et_vivashop_settings.et_viva_responsive')=='traditional'){
    return false;
  }
  
  if (AREA == 'C') {
    if (!defined('ET_DEVICE')){
      if (!class_exists('Mobile_Detect')) {
        require(Registry::get('config.dir.addons') . 'et_vivashop_settings/lib/mobile_detect.php');
      }
      $et_device = new Mobile_Detect;
      
      if ($et_device->isTablet() || $et_device->isiPad() || (stristr($_SERVER['HTTP_USER_AGENT'], 'Intel Mac')!==false && isset($_COOKIE['et_is_real_ipad']) && $_COOKIE['et_is_real_ipad']==1)) {
        fn_define('ET_DEVICE', 'T');

        if (isset($_COOKIE['et_ft_width']) && $_COOKIE['et_ft_width']>1024){
          fn_define('ET_FT_WIDTH',1);
        }else{
          fn_define('ET_FT_WIDTH',0);
        }

      } elseif ($et_device->isMobile()) {
        fn_define('ET_DEVICE', 'M');
      } else {
        fn_define('ET_DEVICE', 'D');
      }
    }
    $x=fn_constant('ET_DEVICE');

    return $x;
  }
}

function fn_et_vivashop_settings_dispatch_before_send_response($status, $area, $controller, $mode, $action){
  if ($status=="404" && AREA == 'C'){
    et_get_device();
  }
}

function fn_et_vivashop_settings_dispatch_assign_template(){
  if ( AREA == 'C'){
  }
}

function fn_et_vivashop_settings_render_block_pre(&$block, &$block_schema, $params, &$block_content){
  if ($block['wrapper']=='addons/et_vivashop_settings/components/et_ajax_tab.tpl'){
    $block_schema['wrappers']['addons/et_vivashop_settings/components/et_ajax_tab.tpl']=array('name'=>'et_ajax_tab');
  }
}


use Tygh\BlockManager\RenderManager;
function fn_et_vivashop_settings_render_blocks(&$grid, &$block, $that, &$content){
  if ($grid['wrapper']=="blocks/grid_wrappers/et_multi_scroller.tpl" && $block['status'] == 'A'){
    $block['et_first'] = empty($content);
    $block['is_multi_scroller'] = true;

    Registry::set('navigation.et_content.' . $grid['grid_id'] . '.' . $block['block_id'], $block['name']);

    $block_content=RenderManager::renderBlockContent($block);
    $n='data-et-content="';
    $has_content=substr($block_content, strpos($block_content, $n)+strlen($n),1);

    if ($has_content){
      Registry::set('navigation.et_content.has_content.'. $block['block_id'], true);
    }else{
      Registry::set('navigation.et_content.has_content.'. $block['block_id'], false);
    }
  }
}


function fn_et_vivashop_settings_render_block_content_after($block_schema, $block, &$block_content, $params){
  if (!empty($block['is_multi_scroller']) && !defined('AJAX_REQUEST')){

    if (empty($block_content)){
      $has_content=0;
    }else{
      $has_content=1;
    }

    if (!empty($block['et_first'])){
    }else{
      $block_content='<div class="et-multi-scroller et-simple-scroller  content-tab-'.$block['grid_id'].'_'.$block['block_id'].'" id="content_tab_'.$block['grid_id'].'_'.$block['block_id'].'" data-et-content="'.$has_content.'"></div>';
    }
  }
}


/* Demo data */
function fn_et_vivashop_settings_demo_data(){

  return __('et_vivashop_settings.demo_banners', array(
      '[demo_banners_url]' =>  fn_url('vivashop_demo_banners.install'),
      '[demo_data_url]' =>  fn_url('vivashop_demo_data.install')
  ));

}


function fn_et_vivashop_settings_get_default_vendors(){
  $default_companies = array('Simtech','ACME Corp');
  $result_companies = array();
  foreach ($default_companies as $key => $name) {
    $query=db_get_hash_array("SELECT company_id, company FROM ?:companies WHERE company LIKE ?s",'company_id', $name);
    if (!empty($query)){
      $result_companies[] =$query;
    }
  }
  return $result_companies;
}


function fn_et_vivashop_settings_add_banner($name, $banner,$image_dir, $company_id){


  $banner_data = array(
    'banner' => $name,
    'status' => 'A',
    'type' => 'G',
    'localization' => '',
    'timestamp' => TIME,
    'target' => 'T',
    'url' => '#',
    'description' => '',
    'company_id' => $company_id,
  );
  $banner_data = array_merge($banner_data, $banner);

  $demo_directory = Registry::get('config.dir.files').$image_dir;

  /* Image for graphic banner and/or background for desktop extended banner */

  /* Unset any images */
  $img_key=array('banners_main','et_banners_desktop_extra', 'et_banners_phone', 'et_banners_phone_extra', 'et_banners_tablet', 'et_banners_tablet_extra');

  foreach ($img_key as $_k => $_img_name) {
    unset($_REQUEST[$_img_name.'_image_data']);
    unset($_REQUEST['file_'.$_img_name.'_image_icon']);
    unset($_REQUEST['type_'.$_img_name.'_image_icon']);
  }

  /* Set images*/ 
  if (isset($banner_data['image'])){
    $banner_image= array( (!empty($banner['image']) ? $demo_directory.$banner['image'] : ""));
    if (fn_allowed_for('ULTIMATE') && isset($banner['ult_image'])) {
      $banner_image= array((!empty($banner['ult_image']) ? $demo_directory.$banner['ult_image'] : ""));
    }

    $images = array(
      'banner_id' => 0,
      'banners_main_image_data' => array(
        array(
          'pair_id' => '',
          'type' => 'M',
          'object_id' => 0,
          'image_alt' => '',
        )
      ),
      'file_banners_main_image_icon' => $banner_image,
      'type_banners_main_image_icon' => array(
        'server'
      ),
    );
    $_REQUEST = array_merge($_REQUEST, $images);
  }


  if ($banner_data['type'] == 'E' && isset($banner_data['extra_images'])){
    foreach ($banner['extra_images'] as $key => $value) {
      // $images = array();
      $images = array(
        'banner_id' => 0,
        $key.'_image_data' => array(
          array(
            'pair_id' => '',
            'type' => 'M',
            'object_id' => 0,
            'image_alt' => '',
          )
        ),
        'file_'.$key.'_image_icon' => array(
          (!empty($value) ? $demo_directory.$value : "")
        ),
        'type_'.$key.'_image_icon' => array(
          'server'
        ),
      );
      $_REQUEST = array_merge($_REQUEST, $images);
    }
  }
  $result = $banner_id = fn_banners_update_banner($banner_data, 0, CART_LANGUAGE);

  if ($banner_data['type'] == 'E'){
    $banner_data['banner_data']['update_all_langs']="Y";
    fn_et_banners_save_post($banner_data,$banner_id,CART_LANGUAGE);
  }
  

  if (fn_allowed_for('ULTIMATE') && $banner_id) {
    fn_share_object_to_all('banners', $banner_id);
  }
  
  return $result;

}

use Tygh\BlockManager\Block;
use Tygh\BlockManager\SchemesManager;

function fn_et_vivashop_settings_demo_banners_install(){
  
  /* Generate backup */
  list($database_size, $all_tables) = fn_get_stats_tables();

  $bkp_params = array(
    'db_filename'     => 'before_viva_demo_data_'. PRODUCT_VERSION . '_' . date('dMY_His', TIME).'.sql',
    'db_tables'       => $all_tables,
    'db_schema'       => 1,
    'db_data'         => 1,
    'db_compress'     => 'zip',
    'move_progress'   => false
  );

  $dump_file_path = DataKeeper::backupDatabase($bkp_params);

  if (!empty($dump_file_path)) {
      fn_set_notification('W', __('notice'),'Backup created: <strong>'.$bkp_params['db_filename'].'</strong');
  }



  /* Block background images */
  $blocks = fn_get_schema('vivashop_demo_data', 'blocks');

  if (isset($blocks) && is_array($blocks)){
    foreach ($blocks as $name => $block) {
      $type = $block['block_type'];

      if (fn_allowed_for('ULTIMATE')) {
        $company_id=fn_get_runtime_company_id();
        if ($company_id==0){
          $company_id=fn_get_default_company_id();
        }
        $result=db_get_array("SELECT a.name,a.block_id,a.lang_code FROM ?:bm_blocks_descriptions as a LEFT JOIN ?:bm_blocks ON a.block_id = ?:bm_blocks.block_id WHERE name LIKE ?s AND ?:bm_blocks.company_id = ?i","%$name%",$company_id);
        $demo_directory = $company_id.'/vivashop_demo/blocks/';
      }else{
        $result=db_get_array("SELECT name,block_id, lang_code FROM ?:bm_blocks_descriptions WHERE name LIKE ?s","%$name%");
        $demo_directory = '1/vivashop_demo/blocks/';
      }
      

      
      
      if (isset($result[0]['block_id'])){

        $block_id = $result[0]['block_id'];
        $block_data = Block::instance()->getById($block_id, 0, array(), DESCR_SL);
        
        $block_data['apply_to_all_langs']='Y';
        $block_data['description']= array(
          'name' => $block_data['name'],
          'lang_code' => DESCR_SL
        );

        $block_data[$type]=array($type."_colors" => 
            (isset($block_data['properties']['et_settings']) ? $block_data['properties']['et_settings'] : ""));
        unset($block_data['properties']['et_settings']);

        $block_data['content_data']=array(
          'snapping_id'=>'',
          'lang_code' => DESCR_SL,
          'content'=> $block_data['content']
        );

        unset($block_data['name']);
        unset($block_data['lang_code']);
        unset($block_data['snapping_id']);
        unset($block_data['object_id']);
        unset($block_data['object_type']);
        unset($block_data['availability']);
        unset($block_data['et_additional_settings']);

        $image_name= $block['image_name'];

        unset($_REQUEST[$image_name.'_image_data']);
        unset($_REQUEST['file_'.$image_name.'_image_icon']);
        unset($_REQUEST['type_'.$image_name.'_image_icon']);

        $demo_directory = Registry::get('config.dir.files').$demo_directory;
        $image_file=$block['image_file'];
        if (fn_allowed_for('ULTIMATE')) {
          $image_file=$block['image_file_ult'];
        }

        $images = array(
          $image_name.'_image_data' => array(
            array(
              'pair_id' => '',
              'type' => 'M',
              'object_id' => 0,
              'image_alt' => '',
              'detailed_alt'=>''
            )
          ),
          'file_'.$image_name.'_image_detailed' => array(
            (!empty($image_file) ? $demo_directory.$image_file : "")
          ),
          'type_'.$image_name.'_image_detailed' => array(
            'server'
          ),
        );
        $_REQUEST = array_merge($_REQUEST, $images);


        if (!empty($block_data['description'])) {
            $block_data['description']['lang_code'] = DESCR_SL;
            $description = $block_data['description'];
        }

        $block_schema = SchemesManager::getBlockScheme($block_data['type'], []);

        if (SchemesManager::isTemplateAvailable($block_data, $block_schema)) {
            $block_id = Block::instance()->update($block_data, $description);
        }
      }
    }
  }  

  /* Banners import*/
  $banners = fn_get_schema('vivashop_demo_data', 'banners');
  if (isset($banners) && is_array($banners)){

    $skip=false;
    foreach ($banners as $name => $banner) {
      $result=db_get_array("SELECT banner_id FROM ?:banner_descriptions WHERE banner LIKE ?s","$name");

      if ($result){
        fn_set_notification('W',__('notice'),"Banner named <strong>$name</strong> already exists. <strong>Banner</strong> demo data import skipped.");
        $skip=true;
        break;
      }
    }

    if (!$skip){
      $old = array();
      foreach ($banners as $name => $banner) {

        $company_id=0;
        $final_name=$name;

        if (fn_allowed_for('ULTIMATE')) {
          $company_id=fn_get_runtime_company_id();
          if ($company_id==0){
            $company_id=fn_get_default_company_id();
          }

          if ($company_id!=1){

            $image_dir = '/'.$company_id.'/vivashop_demo/banners/';

          }else{
            $image_dir = '/1/vivashop_demo/banners/';
          }

          if (isset($banner['name_ult'])){

            $final_name = $banner['name_ult'];

          }else if (stristr($name, 'marketplace')){
            $final_name = str_replace('Marketplace', 'Shop', $name);
          }
        }else{

          $image_dir = '/1/vivashop_demo/banners/';
        }


        
        $banner_id = fn_et_vivashop_settings_add_banner($final_name, $banner,$image_dir,$company_id);

        if (!empty($banner['block_name'])){
          $block_name=$banner['block_name'];

          if (fn_allowed_for('ULTIMATE')) {
            if (isset($banner['block_name_ult'])) {
              $block_name = $banner['block_name_ult'];
            }else if (stristr($block_name, 'marketplace')){
              $block_name = str_replace('Marketplace', 'Shop', $block_name);
            }
          }
          $result=db_get_array("SELECT name, block_id, lang_code FROM ?:bm_blocks_descriptions WHERE name LIKE ?s","%$block_name%");
          
          foreach ($result as $key => $value) {
            $name=$value['name'];
            $id=$value['block_id'];
            $lang_code=$value['lang_code'];
            $multiple=false;
            $is_new = !(in_array($id, $old));

            if (strrpos($name, 's',-1) || (isset($banner['multiple_same_block']) && $banner['multiple_same_block']==true)){
              $multiple=true;
            }

            $content=db_get_field("SELECT content FROM ?:bm_blocks_content WHERE block_id = ?i AND lang_code = ?s", $id, $lang_code);
            $content=unserialize($content);
            $content['items']['filling']='manually';
            if ($content['items']['filling']=='manually'){

              if ($multiple){
                if ($is_new){
                  $old[]=$id;
                  $content['items']['item_ids'] = $banner_id; 
                }else{
                  $content['items']['item_ids'] = empty($content['items']['item_ids']) ? $banner_id : $content['items']['item_ids'].",".$banner_id;
                }
              }else{
                $content['items']['item_ids'] = $banner_id; 
              }
            }
            $content=serialize($content);
            db_query("UPDATE ?:bm_blocks_content SET content = ?s WHERE block_id = ?i AND lang_code = ?s",$content,$id,$lang_code);

            if (isset($banner['block_properties'])){
              db_query("UPDATE ?:bm_blocks SET properties = ?s WHERE block_id = ?i",$banner['block_properties'],$id);
            }
          }
        }
      }
      fn_set_notification('N', __('successful'),'Banners demo data imported.');
    }
  }
}

function fn_et_vivashop_settings_demo_data_install(){

  if (fn_allowed_for('ULTIMATE')) {
    $company_id=fn_get_runtime_company_id();
    if ($company_id==0){
      $company_id=fn_get_default_company_id();
    }

    if ($company_id!=1){
      $demo_directory = Registry::get('config.dir.files')."/1";
      $company_directory=Registry::get('config.dir.files')."/".$company_id;
      if (!file_exists($company_directory)){
        fn_copy($demo_directory, $company_directory,true);
      }
    }
  }
  
  fn_et_vivashop_settings_demo_banners_install();
  /* Pages and Blog import */
  $pages = fn_get_schema('vivashop_demo_data', 'pages');

  if (isset($pages) and is_array($pages)){

    $skip=false;
    foreach ($pages as $name => $page) {
      $result=db_get_array("SELECT page_id FROM ?:page_descriptions WHERE page LIKE ?s","$name");

      if ($result){
        fn_set_notification('W',__('notice'),"Page named <strong>$name</strong> already exists. <strong>Page and blog</strong> demo data import skipped.");
        $skip=true;
        break;
      }
    }

    if (!$skip){

      // Copy page inline images
      $demo_directory = Registry::get('config.dir.files')."/1/vivashop_demo/pages";
      $image_directory=Registry::get('config.dir.root').'/images/vivashop_demo_pages';
      fn_copy($demo_directory, $image_directory,true);

      // Insert page data
      foreach ($pages as $name => $page) {
        $company_id=0;

        if (fn_allowed_for('ULTIMATE')) {
          $company_id=fn_get_runtime_company_id();
          if ($company_id==0){
            $company_id=fn_get_default_company_id();
          }
          $demo_blog_directory = $company_id.'/vivashop_demo/blog/';
        }else{
          $demo_blog_directory = '1/vivashop_demo/blog/';
        }

        $page_data = array(
          'company_id' => $company_id,
          'page_type' => $page['page_type'],
          'page' => $name,
          'description' => $page['description'],
          'status' => 'A',
          'parent_id' => '0'
        );
        $page_data = array_merge($page_data, $page);
        

        switch ($page['page_type']) {
          case PAGE_TYPE_TEXT:
            /* Page */
            $page_id=fn_update_page($page_data);

          break;
          
          case PAGE_TYPE_BLOG:
            /* Blog */

            /* Blog image */
            $demo_blog_directory = Registry::get('config.dir.files').$demo_blog_directory;
            $images = array(
              'blog_image_image_data' => array(
                array(
                  'pair_id' => '',
                  'type' => 'M',
                  'object_id' => 0,
                  'image_alt' => '',
                )
              ),
              'file_blog_image_image_icon' => array(
                (!empty($page['image']) ? $demo_blog_directory.$page['image'] : "")
              ),
              'type_blog_image_image_icon' => array(
                'server'
              ),
            );
            $_REQUEST = array_merge($_REQUEST, $images);

            /* Blog parent id */
            if ($page_data['is_blog_root']!==true && isset($blog_root_id)){
              $page_data['parent_id'] = $blog_root_id;

              $page_id = fn_update_page($page_data);

            }else if ($page_data['is_blog_root']===true) {

              if (fn_allowed_for('ULTIMATE')) {
                $page_data['page']='Our Blog';
              }

              $blog_root_id=$page_id = fn_update_page($page_data);

              /* Assign to block */
              if ($page_data['block_name'] ){
                $block_names=explode(',', $page_data['block_name']);

                foreach ($block_names as $key => $block_name) {

                  $result=db_get_array("SELECT name,block_id, lang_code FROM ?:bm_blocks_descriptions WHERE name LIKE ?s", $block_name);

                  foreach ($result as $key => $value) {
                    $name = $value['name'];
                    $id   = $value['block_id'];
                    $lang_code=$value['lang_code'];

                    $content=db_get_field("SELECT content FROM ?:bm_blocks_content WHERE block_id = ?i AND lang_code = ?s", $id, $lang_code);

                    $content=unserialize($content);

                    if (isset($content['items']['parent_page_id'])){
                      $content['items']['parent_page_id']=$blog_root_id;
                    }

                    $content=serialize($content);

                    db_query("UPDATE ?:bm_blocks_content SET content = ?s WHERE block_id = ?i AND lang_code = ?s", $content, $id, $lang_code);
                  }
                }
              }
            }

          break;

          case PAGE_TYPE_FORM:
            /* Form */
            $auth=Tygh::$app['session']['auth'];
            $current_user=fn_get_user_short_info($auth['user_id']);

            $page_data['form']['general'][FORM_RECIPIENT]=$current_user['email'];

            $page_id=fn_update_page($page_data);

          break;
          default:
          break;
        }

      }
      fn_set_notification('N', __('successful'),'Pages and blog demo data imported.');

    }
  } 

  /* Menu import */

  $menus = fn_get_schema('vivashop_demo_data', 'menus');

  if (isset($menus) && is_array($menus)){
    $skip=false;

    foreach ($menus as $name => $menu) {
      $result=db_get_array("SELECT menu_id FROM ?:menus_descriptions WHERE name LIKE ?s", $name);

      if ($result){
        fn_set_notification('W',__('notice'),"Menu named <strong>$name</strong> already exists. <strong>Menu</strong> demo data import skipped.");
        $skip=true;
        break;
      }
    }

    if (!$skip){
      fn_et_vivashop_settings_insert_menu($menus);
      fn_set_notification('N', __('successful'),'Menu demo data imported.');

    }
  }

  /* Category demo data*/
  $categs = fn_get_schema('vivashop_demo_data', 'categs');

  if (isset($categs) && is_array($categs)){
    $company_id=0;
    if (fn_allowed_for('ULTIMATE')) {
      $company_id=fn_get_runtime_company_id();
      if ($company_id==0){
        $company_id=fn_get_default_company_id();
      }
    }

    $mv_condition = '';
    if (fn_allowed_for('MULTIVENDOR') && (Registry::get('addons.vendor_debt_payout.status') == 'A')) {
      $mv_condition = "AND category_type = 'C'";
    }
    /* Get first 9 top level categories */
    $result=db_get_array("SELECT category_id FROM ?:categories WHERE parent_id = 0 AND status = 'A'  AND company_id = ?i ?p LIMIT 9 ",$company_id,$mv_condition);

    /* Get store first 10 active products */
    $store_products = db_get_hash_array("SELECT product_id FROM ?:products WHERE status = 'A' LIMIT 10",'product_id');

    if (fn_allowed_for('ULTIMATE')) {
      $store_products = db_get_hash_array("SELECT product_id FROM ?:products WHERE status = 'A' AND company_id = ?i LIMIT ?i ", 'product_id', $company_id, 10);
          }

    $store_product_ids = implode(',', array_keys($store_products));

    foreach ($result as $key => $value) {
      $index = $key+1;
      $categ = $categs[$index];
      $category_id = $value['category_id'];

      /* Add first 10 active products if enabled */
      $products = unserialize($categ['products']);
      if ($products['enabled']=='Y'){
        $products['ids'] = $store_product_ids;
        $categ['products'] = serialize($products);
      }

      /* Build final values */
      $et_categ_data=array(
        'company_id'=>  $company_id,
        'categ_id'  =>  $category_id,
        'lang_code' =>  DESCR_SL,
      );

      $et_categ_data = array_merge($et_categ_data, $categ);

      $param_id = db_query("REPLACE INTO ?:et_category_menu ?e", $et_categ_data);

      foreach (fn_get_translation_languages() as $et_categ_data['lang_code'] => $_v) {
        db_query("REPLACE INTO ?:et_category_menu ?e", $et_categ_data);
      }

      /* Banners */
      $result_banners=array();

      if (isset($categ['banners'])){
        foreach ($categ['banners'] as $name => $banner) {
          
          if (fn_allowed_for('ULTIMATE')) {
            $image_dir = $company_id.'/vivashop_demo/category/';
          }else{
            $image_dir = '1/vivashop_demo/category/';
          }

          $result_banners[] = fn_et_vivashop_settings_add_banner($name, $banner, $image_dir, $company_id);
        }

        $et_categ_banner_sql = array(
          'category_id' =>  $category_id,
          'data'        =>  implode(',',$result_banners),
        );

        db_query("REPLACE INTO ?:et_category_banner ?e", $et_categ_banner_sql);
      }

      /* Demo description */
      $db_description = db_get_array("SELECT description, category, lang_code FROM ?:category_descriptions WHERE category_id = ?i ",$category_id);
      
      
      $demo_descr=$categs['demo_categ_description'];

      foreach ($db_description as $_k => $_v) {
        $description=$_v['description'];
        $category=$_v['category'];

        if (empty($description)){
          $new_descr=str_replace('%categ%', $category, $demo_descr);

          db_query("UPDATE ?:category_descriptions SET description = ?s WHERE category_id = ?i", $new_descr, $category_id);
        }
      }



    }
    fn_set_notification('N', __('successful'),'Category demo settings imported.');

  }

  /* Featured products and banners */
  $fpabs = fn_get_schema('vivashop_demo_data', 'featured_products_and_banners');
  if (isset($fpabs) && is_array($fpabs)){

    $skip=false;

    foreach ($fpabs as $index => $fpab) {
      $result=db_get_array("SELECT data FROM ?:et_featured_product_banner_tabs_data WHERE data LIKE ?s AND lang_code = ?s", $fpab['title'], DESCR_SL);

      if ($result){

        $result = unserialize($result[0]['data']);
        $name = $result['title'];
        fn_set_notification('W',__('notice'),"Block named <strong>$name</strong> already exists. <strong>Featured products and banners</strong> demo data import skipped.");
        $skip=true;
        break;
      }
    }

    if (!$skip){
      foreach ($fpabs as $index => $fpab) {

        /* Settings */
        $sql_settings = array(
          'data'  =>  $fpab['settings']
        );
        $block_id = db_query("REPLACE INTO ?:et_featured_product_banner_tabs ?e", $sql_settings);

        /* Title */
        $sql_title=array(
          'block_id'  =>  $block_id,
          'data'      =>  $fpab['title'],
          'lang_code' =>  DESCR_SL,
        );

        db_query("REPLACE INTO ?:et_featured_product_banner_tabs_data ?e", $sql_title);

        foreach (fn_get_translation_languages() as $sql_title['lang_code'] => $_v) {
          db_query("REPLACE INTO ?:et_featured_product_banner_tabs_data ?e", $sql_title);
        }

        /* Tabs */
        foreach ($fpab['tabs'] as $tab_index => $tab) {
          /* Banners */
          $result_banners=array();

          if (isset($tab['banners'])){
            foreach ($tab['banners'] as $name => $banner) {
              
              $company_id=0;
              if (fn_allowed_for('ULTIMATE')) {
                $company_id=fn_get_runtime_company_id();
                if ($company_id==0){
                  $company_id=fn_get_default_company_id();
                }
                $image_dir = $company_id.'/vivashop_demo/fpab/';
              }else{
                $image_dir = '1/vivashop_demo/fpab/';
              }


              $result_banners[] = fn_et_vivashop_settings_add_banner($name, $banner, $image_dir, $company_id);
            }
          }

          /* Settings */
          $tab_data = unserialize($tab['data']);
          
          /* Products */
          $prod_count=count(explode(',',$tab_data['product_ids']));

          $store_products = db_get_hash_array("SELECT product_id FROM ?:products WHERE status = 'A' LIMIT ?i ", 'product_id', $prod_count);

          if (fn_allowed_for('ULTIMATE')) {
            $company_id=fn_get_runtime_company_id();
            if ($company_id==0){
              $company_id=fn_get_default_company_id();
            }
            $store_products = db_get_hash_array("SELECT product_id FROM ?:products WHERE status = 'A' AND company_id = ?i LIMIT ?i ", 'product_id', $company_id, $prod_count);
          }

          $store_product_ids = implode(',', array_keys($store_products));

          $tab_data['product_ids'] = $store_product_ids;

          /* Banners */

          $tab_data['banner_ids']['banner_1']= isset($result_banners[0]) ? $result_banners[0] : "";
          $tab_data['banner_ids']['banner_2']= isset($result_banners[1]) ? $result_banners[1] : "";

          /* Final data */

          $tab_data = serialize($tab_data);

          $sql_tab_settings = array(
            'block_id'  => $block_id,
            'position'  => $tab['position'],
            'data'      => $tab_data,
          );

          
          $tab_id = db_query("INSERT INTO ?:et_featured_product_banner_tabs_tabs ?e", $sql_tab_settings);

          /* Title */
          $sql_tab_title = array(
            'tab_id'  => $tab_id,
            'block_id'  => $block_id,
            'data'  =>  $tab['tabs_data'],
            'lang_code' => DESCR_SL
          );
          db_query("REPLACE INTO ?:et_featured_product_banner_tabs_tabs_data ?e", $sql_tab_title);

          foreach (fn_get_translation_languages() as $sql_tab_title['lang_code'] => $_v) {
            db_query("REPLACE INTO ?:et_featured_product_banner_tabs_tabs_data ?e", $sql_tab_title);
          }

        }
      }
      fn_set_notification('N', __('successful'),'Featured products and banners demo data imported.');
    }
  }

  $quick_infos =  fn_get_schema('vivashop_demo_data', 'quick_infos');
  if (isset($quick_infos) && is_array($quick_infos)){
    $skip=false;

    foreach ($quick_infos as $index => $quick_info) {
      $result=db_get_field("SELECT data FROM ?:et_quick_info_title WHERE data LIKE ?s AND lang_code = ?s", $quick_info['title'], DESCR_SL);

      if ($result){

        $result = unserialize($result);
        $name = $result['title'];
        fn_set_notification('W',__('notice'),"Block named <strong>$name</strong> already exists. <strong>Product page quick info</strong> demo data import skipped.");
        $skip=true;
        break;
      }
    }

    if (!$skip){
      foreach ($quick_infos as $index => $quick_info) {
        /* ?:et_quick_info */
        $qi_sql = array(
          'data'      =>  $quick_info['settings'],
          'status'    => 'A',
          'position'  =>  $quick_info['position']
        );
        $block_id = db_query("INSERT INTO ?:et_quick_info ?e", $qi_sql);

        /* ?:et_quick_info_title */
        $qi_title_sql = array(
          'block_id'  =>  $block_id,
          'data'      =>  $quick_info['title'],
          'lang_code' =>  DESCR_SL
        );

        db_query("REPLACE INTO ?:et_quick_info_title ?e", $qi_title_sql);

        foreach (fn_get_translation_languages() as $qi_title_sql['lang_code'] => $_v) {
          db_query("REPLACE INTO ?:et_quick_info_title ?e", $qi_title_sql);
        }

        /* ?:et_quick_info_descr */

        $company_id=fn_get_default_company_id();
        $result_companies=array('0'=>array($company_id=>$company_id));
        if (fn_allowed_for('ULTIMATE')) {
          $company_id=fn_get_runtime_company_id();
          if ($company_id==0){
            $company_id=fn_get_default_company_id();
          }
          $result_companies=db_get_hash_array("SELECT company_id, company FROM ?:companies WHERE 1 ",'company_id');
          // $result_companies=array('0'=>array($company_id=>$company_id));
        }

        if (fn_allowed_for('MULTIVENDOR')) {
          $result_companies = fn_et_vivashop_settings_get_default_vendors();
        }


        /* ?:et_quick_info_data */
                if (!empty($result_companies)){
          foreach ($result_companies as $key => $value) {

            $qi_descr_sql = array(
              'data'      =>  $quick_info['content'],
              'lang_code' =>  DESCR_SL
            );

            $content_id = db_query("INSERT INTO ?:et_quick_info_descr ?e", $qi_descr_sql);

            foreach (fn_get_translation_languages() as $qi_descr_sql['lang_code'] => $_v) {
              $qi_descr_sql['content_id']=$content_id;
              db_query("REPLACE INTO ?:et_quick_info_descr ?e", $qi_descr_sql);
            }

            $company_id=key($value);
            if (fn_allowed_for('ULTIMATE')) {
               $company_id=$value['company_id'];
            }

            $qi_data_sql = array(
              'content_id'  =>  $content_id,
              'block_id'    =>  $block_id,
              'company_id'  =>  $company_id
            );
            db_query("INSERT INTO ?:et_quick_info_data ?e", $qi_data_sql);
          }
        }

      }
      fn_set_notification('N', __('successful'),'Product page quick info demo data imported.');
    }
  }
  
  /* Set variation product tab not in popup */
  $variation_tab_id=db_get_field("SELECT tab_id FROM ?:product_tabs WHERE addon LIKE ?s AND show_in_popup = ?s", 'product_variations','Y');
  if ($variation_tab_id){
    db_query("UPDATE ?:product_tabs SET `show_in_popup` = ?s WHERE tab_id = ?i ",'N',$variation_tab_id);
  }

  /* Multivendor only */
  if (fn_allowed_for('MULTIVENDOR')) {

      $result_companies = fn_et_vivashop_settings_get_default_vendors();
      $mv_data =  fn_get_schema('vivashop_demo_data', 'mv');

      if (!empty($result_companies) && isset($mv_data) && is_array($mv_data)){
        $index=0;

        // fn_et_vivashop_settings_add_default_vendor_blocks($mv_data);

        foreach ($result_companies as $key => $value) {
          $company_id=key($value);
          $index++;

          foreach ($mv_data as $type => $data) {
            switch ($type) {

              case 'contact_page':
              case 'social':
                /* contact_page and social */
                foreach ($data as $_type => $_value) {
                  $sql = array(
                    'company_id'  =>  $company_id,
                    'type'        =>  $_type,
                    'description' =>  $_value
                  );
                  db_query("REPLACE INTO ?:et_mv_ved ?e", $sql);
                }
                
              break;

              case 'description':

                /* copy inline images */
                $demo_directory = Registry::get('config.dir.files')."/1/vivashop_demo/mv/content";
                $image_directory=Registry::get('config.dir.root').'/images/vivashop_demo_mv';
                fn_copy($demo_directory, $image_directory, true);

                /* generate company specific description */
                $new_descr=str_replace('%company%', $value[$company_id]['company'], $data['content']);

                $lang_code=DESCR_SL;
                db_query("UPDATE ?:company_descriptions SET company_description = ?s WHERE company_id = ?i AND lang_code = ?s", $new_descr, $company_id, $lang_code);

                foreach (fn_get_translation_languages() as $lang_code => $_v) {
                  db_query("UPDATE ?:company_descriptions SET company_description = ?s WHERE company_id = ?i AND lang_code = ?s", $new_descr, $company_id, $lang_code);
                }
              break;
              
              case 'store_settings':
                /* et_mv_vendor_settings */
                if (isset($data[$index])){
                  $settings=$data[$index];
                }else{
                  $settings=$data[1];
                }

                $sql_settings=array(
                  'company_id'  => $company_id,
                  'data'  => $settings
                );

                db_query("REPLACE INTO ?:et_mv_vendor_settings ?e",$sql_settings);

              break;

              case 'store_pages':
                /*store pages*/
                fn_et_vivashop_settings_insert_page($data, $company_id);
              break;

              case 'vsb':
                /* Vendor store blocks */

                if (isset($data[$index])){
                  $vsbs=$data[$index];
                }else{
                  $vsbs=$data[1];
                }
                foreach ($vsbs as $name => $vsb) {
                  switch ($vsb['type']) {
                    case 'banners':
                      /* Banners */
                      $result_banners=array();

                      if (isset($vsb['banners'])){
                        foreach ($vsb['banners'] as $name => $banner) {
                          
                          $image_dir = '/1/vivashop_demo/mv/banners/';

                          $banner_id = fn_et_vivashop_settings_add_banner($name, $banner, $image_dir, $company_id);

                          $result_banners[$banner_id]=count($result_banners)+1;
                        }
                      }

                      /* Settings */
                      $vsb_settings = unserialize($vsb['vsb_settings']);


                      $vsb_settings['banner_ids']=$result_banners;

                      $vsb_settings = serialize($vsb_settings);

                      /* Final settings */
                      $vsb_sql=array(
                        'company_id'  =>  $company_id,
                        'status'      =>  'A',
                        'position'    =>  '0',
                        'data'        =>  $vsb_settings
                      );

                      $vsb_id=db_query("INSERT INTO ?:et_mv_vsb ?e", $vsb_sql);

                      /* Data */
                      $vsb_data_sql=array(
                        'vsb_id'    =>  $vsb_id,
                        'text'      =>  '',
                        'data'      =>  $vsb['vsb_data'],
                        'lang_code' =>  DESCR_SL
                      );
                      db_query("INSERT INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);

                      foreach (fn_get_translation_languages() as $vsb_data_sql['lang_code'] => $_v) {
                        db_query("REPLACE INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);
                      }

                    break;

                    case 'products':

                      /* Settings */
                      $vsb_settings = unserialize($vsb['vsb_settings']);

                      /* Products */
                      $prod_count=count(explode(',',$vsb_settings['product_ids']));

                      $store_products = db_get_hash_array("SELECT product_id FROM ?:products WHERE status = 'A' AND company_id = ?i LIMIT ?i", 'product_id', $company_id, $prod_count);
                      $store_product_ids = implode(',', array_keys($store_products));


                      $vsb_settings['product_ids'] = $store_product_ids;

                      /* Final settings */

                      $vsb_settings = serialize($vsb_settings);

                      $vsb_sql=array(
                        'company_id'  =>  $company_id,
                        'status'      =>  'A',
                        'position'    =>  '0',
                        'data'        =>  $vsb_settings
                      );

                      $vsb_id = db_query("INSERT INTO ?:et_mv_vsb ?e", $vsb_sql);

                      /* Data */
                      $vsb_data_sql=array(
                        'vsb_id'    =>  $vsb_id,
                        'text'      =>  '',
                        'data'      =>  $vsb['vsb_data'],
                        'lang_code' =>  DESCR_SL
                      );
                      db_query("INSERT INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);

                      foreach (fn_get_translation_languages() as $vsb_data_sql['lang_code'] => $_v) {
                        db_query("REPLACE INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);
                      }

                    break;

                    case 'textarea':

                      /* Final settings */

                      $vsb_sql=array(
                        'company_id'  =>  $company_id,
                        'status'      =>  'A',
                        'position'    =>  '0',
                        'data'        =>  $vsb['vsb_settings']
                      );

                      $vsb_id=db_query("INSERT INTO ?:et_mv_vsb ?e", $vsb_sql);

                      /* Data */
                      $vsb_data = unserialize($vsb['vsb_data']);

                      /* Generate company specific title */
                      $new_title=str_replace('%company%', $value[$company_id]['company'], $vsb_data['title']);


                      $vsb_data['title'] = $new_title;
                      $vsb_data = serialize($vsb_data);

                      $vsb_data_sql=array(
                        'vsb_id'    =>  $vsb_id,
                        'text'      =>  $vsb['vsb_text'],
                        'data'      =>  $vsb_data,
                        'lang_code' =>  DESCR_SL
                      );
                      db_query("INSERT INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);

                      foreach (fn_get_translation_languages() as $vsb_data_sql['lang_code'] => $_v) {
                        db_query("REPLACE INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);
                      }
                    break;

                  }

                }

              break;
          }

        }// result companies
        /* Vendor home blocks */


        fn_set_notification('N', __('successful'),'Demo vendors store settings imported.');
      }
    }
  }
}

function fn_et_vivashop_settings_add_default_vendor_blocks($mv_data){
  $company_id=0;

  foreach ($mv_data as $type => $data) {
    switch ($type) {
      case 'vsb':
        /* Vendor store blocks */
        if (isset($data[0])){
          $vsbs=$data[0];
        }

        foreach ($vsbs as $name => $vsb) {
          switch ($vsb['type']) {
            case 'banners':
              /* Banners */
              $result_banners=array();

              if (isset($vsb['banners'])){
                foreach ($vsb['banners'] as $name => $banner) {
                  
                  $image_dir = '/1/vivashop_demo/mv/banners/';

                  $banner_id = fn_et_vivashop_settings_add_banner($name, $banner, $image_dir, $company_id);

                  $result_banners[$banner_id]=count($result_banners)+1;
                }
              }

              /* Settings */
              $vsb_settings = unserialize($vsb['vsb_settings']);

              $vsb_settings['banner_ids']=$result_banners;

              $vsb_settings = serialize($vsb_settings);

              /* Final settings */
              $vsb_sql=array(
                'company_id'  =>  $company_id,
                'status'      =>  'A',
                'position'    =>  '0',
                'data'        =>  $vsb_settings
              );

              $vsb_id=db_query("INSERT INTO ?:et_mv_vsb ?e", $vsb_sql);

              /* Data */
              $vsb_data_sql=array(
                'vsb_id'    =>  $vsb_id,
                'text'      =>  '',
                'data'      =>  $vsb['vsb_data'],
                'lang_code' =>  DESCR_SL
              );
              db_query("INSERT INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);

              foreach (fn_get_translation_languages() as $vsb_data_sql['lang_code'] => $_v) {
                db_query("REPLACE INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);
              }

            break;

            case 'products':

              /* Settings */
              $vsb_settings = $vsb['vsb_settings'];

              $vsb_sql=array(
                'company_id'  =>  $company_id,
                'status'      =>  'A',
                'position'    =>  '0',
                'data'        =>  $vsb_settings
              );

              $vsb_id = db_query("INSERT INTO ?:et_mv_vsb ?e", $vsb_sql);

              /* Data */
              $vsb_data_sql=array(
                'vsb_id'    =>  $vsb_id,
                'text'      =>  '',
                'data'      =>  $vsb['vsb_data'],
                'lang_code' =>  DESCR_SL
              );
              db_query("INSERT INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);

              foreach (fn_get_translation_languages() as $vsb_data_sql['lang_code'] => $_v) {
                db_query("REPLACE INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);
              }

            break;

            case 'textarea':

              /* Final settings */

              $vsb_sql=array(
                'company_id'  =>  $company_id,
                'status'      =>  'A',
                'position'    =>  '0',
                'data'        =>  $vsb['vsb_settings']
              );

              $vsb_id=db_query("INSERT INTO ?:et_mv_vsb ?e", $vsb_sql);

              /* Data */
              $vsb_data = $vsb['vsb_data'];

              $vsb_data_sql=array(
                'vsb_id'    =>  $vsb_id,
                'text'      =>  $vsb['vsb_text'],
                'data'      =>  $vsb_data,
                'lang_code' =>  DESCR_SL
              );
              db_query("INSERT INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);

              foreach (fn_get_translation_languages() as $vsb_data_sql['lang_code'] => $_v) {
                db_query("REPLACE INTO ?:et_mv_vsb_data ?e", $vsb_data_sql);
              }
            break;

          }

        }

      break;
    }
  }

}

function fn_et_vivashop_settings_insert_page($data, $company_id, $parent_id='0'){
  foreach ($data as $name => $page) {
    $page_data = array(
      'company_id'  => $company_id,
      'page_type'   => $page['page_type'],
      'position'    => $page['position'],
      'page'        => $name,
      'description' => $page['description'],
      'status'      => 'A',
      'parent_id'   => $parent_id
    );

    $page_id=fn_update_page($page_data);

    if (isset($page['subpage'])){
      fn_et_vivashop_settings_insert_page($page['subpage'], $company_id, $page_id);
    }
  }
}

function fn_et_vivashop_settings_insert_menu($data, $parent_id='0',$menu_id='0'){
  $company_id=0;
  if (fn_allowed_for('ULTIMATE')) {
    $company_id=fn_get_runtime_company_id();
    if ($company_id==0){
      $company_id=fn_get_default_company_id();
    }
  }

  foreach ($data as $menu_name => $menu) {

    if ($parent_id == 0){
      /* Create menu */
      $menu_data=array(
        'menu_id'   =>  0,
        'name'      =>  $menu_name,
        'status'    =>  'A',
        'lang_code' => DESCR_SL,
        'company_id'=>  $company_id
      );

      $menu_id=Menu::update($menu_data);

      /* Assign to block */
      if (isset($menu['block_name'])){
        $block_name=$menu['block_name'];
        $result=db_get_array("SELECT name,block_id, lang_code FROM ?:bm_blocks_descriptions WHERE name LIKE ?s", $block_name);
        
        foreach ($result as $key => $value) {
          $name = $value['name'];
          $id   = $value['block_id'];
          $lang_code=$value['lang_code'];

          $content=db_get_field("SELECT content FROM ?:bm_blocks_content WHERE block_id = ?i AND lang_code = ?s", $id, $lang_code);
          $content=unserialize($content);
          if (isset($content['menu'])){
            $content['menu']=$menu_id;
          }
          $content=serialize($content);

          db_query("UPDATE ?:bm_blocks_content SET content = ?s WHERE block_id = ?i AND lang_code = ?s", $content, $id, $lang_code);
        }
      }
    }

    /* Menu items */
    
    foreach ($menu['menu_items'] as $name => $menu_item) {

      $skip=false;
      if (
          (fn_allowed_for('ULTIMATE') && isset($menu_item['mv_only']))
        || (fn_allowed_for('MULTIVENDOR') && isset($menu_item['ultimate_only']))
        ) {
        $skip=true;
    }

      if (!$skip){

      /* Build URL */

      $url='#';
      if (!empty($menu_item['url'])){
        $url=$menu_item['url'];
      }
      if (isset($menu_item['type'])){

        switch ($menu_item['type']) {
          
          case PAGE_TYPE_BLOG:
          case PAGE_TYPE_TEXT:
            if (fn_allowed_for('ULTIMATE') && isset($menu_item['type_title_ult'])){
              $id=db_get_field("SELECT page_id FROM ?:page_descriptions WHERE page LIKE ?s", $menu_item['type_title_ult']);
            }else{
              $id=db_get_field("SELECT page_id FROM ?:page_descriptions WHERE page LIKE ?s", $menu_item['type_title']);
            }
            if ($id){
              $url="pages.view&page_id=".$id;
            }
            break;

          case 'brand':

            $feature_id=db_get_field("SELECT feature_id FROM ?:product_features WHERE purpose LIKE ?s",'organize_catalog');

            if ($feature_id){
              $filter_id=db_get_field("SELECT filter_id FROM ?:product_filters WHERE feature_id = ?i",$feature_id);

              if ($filter_id){
                $url='product_features.view_all&filter_id='.$filter_id;
              }
            }
          break;
          
          case 'testimonial':
            $thread_id=db_get_field("SELECT thread_id FROM ?:discussion WHERE object_type LIKE ?s",$menu_item['type_title']);
            if ($thread_id){
              $url='discussion.view&thread_id='.$thread_id;
            }
          break;

          default:
            $url='#';
          break;
        }
        
      }

      /* Insert menu items */
      $menu_item_data=array(
        'param'     =>  $url, //$menu_item['url']
        'param_2'   =>  '', //active menu item dispatch
        'param_3'   =>  '', // generate submenu C - categ, A - pages
        'param_4'   =>  '',
        'param_5'   =>  $menu_id,
        'class'     =>  '',
        'section'   =>  'A',
        'status'    =>  'A',
        'position'  =>  $menu_item['position'],
        'parent_id' =>  $parent_id,

        'company_id' => $company_id
      );
      $param_id = db_query("INSERT INTO ?:static_data ?e", $menu_item_data);

      if (isset($menu_item_data['parent_id'])) {
          if (!empty($menu_item_data['parent_id'])) {
              $new_id_path = db_get_field("SELECT id_path FROM ?:static_data WHERE param_id = ?i", $menu_item_data['parent_id']);
              $new_id_path .= '/' . $param_id;
          } else {
              $new_id_path = $param_id;
          }
          db_query("UPDATE ?:static_data SET id_path = ?s WHERE param_id = ?i", $new_id_path, $param_id);
      }

      if (fn_allowed_for('ULTIMATE') && isset($menu_item['title_ult'])){
        $et_name=$menu_item['title_ult'];
      }else{
        $et_name=$name;
      }
      $menu_item_descr=array(
        'param_id'  =>  $param_id,
        'descr'     =>  $et_name,
      );
      
      if (isset($menu_item['et_menu_settings'])){
        $et_menu_data=array(
          'param_id'  => $param_id,
          'data'      => $menu_item['et_menu_settings']
        );
      }

      foreach (fn_get_translation_languages() as $menu_item_descr['lang_code'] => $_v) {

        db_query("REPLACE INTO ?:static_data_descriptions ?e", $menu_item_descr);

        if (isset($et_menu_data)){
          $et_menu_data['lang_code']=$menu_item_descr['lang_code'];
          db_query("REPLACE INTO ?:et_menu ?e", $et_menu_data);
        }

      }


      if (isset($menu_item['submenu'])){
        fn_et_vivashop_settings_insert_menu($menu_item['submenu'], $param_id, $menu_id);
      }
      }
    }
  }
}


function fn_et_vivashop_settings_get_product_fillings(){
  $block_scheme = SchemesManager::getBlockScheme('products', array(), true);
  $allowed_fillings=array('manually','newest','most_popular','bestsellers','on_sale','rating');
  $fillings=array();
  foreach ($block_scheme['content']['items']['fillings'] as $key => $value) {
    if (in_array($key,$allowed_fillings)){
      $fillings[$key]=$value;
    }
  }
  return $fillings;
}