<?php
use Tygh\Registry;
use Tygh\BlockManager\ProductTabs;
use Tygh\Models\Company;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'contact') {
  
  if (Registry::get('addons.et_vivashop_mv_functionality.et_mv_menu_setting_contact')!="Y"){
    return array(CONTROLLER_STATUS_NO_PAGE);
  }


  Tygh::$app['view']->assign('use_vendor_url', true);
  $company_data = !empty($_REQUEST['company_id']) ? fn_get_company_data($_REQUEST['company_id']) : array();
  if (!empty($company_data)){
    fn_et_vivashop_mv_functionality_unserialize($company_data);
  }

  if (empty($company_data) || empty($company_data['status']) || !empty($company_data['status']) && $company_data['status'] != 'A') {
    return array(CONTROLLER_STATUS_NO_PAGE);
  }

  $company_data['total_products'] = count(db_get_fields(fn_get_products(array(
    'get_query' => true,
    'company_id' => $_REQUEST['company_id']
  ))));

  $company_data['logos'] = fn_get_logos($company_data['company_id']);

  Registry::set('navigation.tabs', array(
    'description' => array(
      'title' => __('description'),
      'js' => true
    )
  ));

  $params = array(
    'company_id' => $_REQUEST['company_id'],
    'active' => true
  );

  $vendor_extra_details=fn_et_vivashop_mv_functionality_get_ved($_REQUEST['company_id']);
  $vendor_store_blocks=fn_et_mv_get_vsb($params);


  $company_data = fn_filter_company_data_by_profile_fields($company_data);


  Tygh::$app['view']->assign('company_data', $company_data);
  Tygh::$app['view']->assign('vendor_extra_details', $vendor_extra_details);
  Tygh::$app['view']->assign('vsb', $vendor_store_blocks);

  fn_add_breadcrumb(__('store_home'),fn_url('companies.view?company_id='.$_REQUEST['company_id']));
  fn_add_breadcrumb(__('contact'));

  $bc = Tygh::$app['view']->getTemplateVars('breadcrumbs');
  unset($bc[0]);
  $bc=array_values($bc);
  Tygh::$app['view']->assign('breadcrumbs', $bc);
  
}elseif ($mode == 'on_sale' || $mode == 'bestsellers' || $mode == 'newest') {
  $company_id = (int) $_REQUEST['company_id'];
  $company_data = !empty($company_id) ? fn_get_company_data($company_id) : [];

  if (!empty($company_data['status']) && $company_data['status'] != 'A') {
      return array(CONTROLLER_STATUS_NO_PAGE);
  }

  Tygh::$app['view']->assign('use_vendor_url', true);
  $params = $_REQUEST;

  $params['extend'] = array('description');

  if ($mode == 'on_sale') {
      $title = __("on_sale");
      $params['on_sale'] = true;

      if (Registry::get('addons.et_vivashop_mv_functionality.et_mv_menu_setting_sale')!="Y"){
        return array(CONTROLLER_STATUS_NO_PAGE);
      }

  } elseif ($mode == 'bestsellers') {

    if (Registry::get('addons.et_vivashop_mv_functionality.et_mv_menu_setting_best')!="Y"){
      return array(CONTROLLER_STATUS_NO_PAGE);
    }

      $title = __("bestsellers");
      
      $params['bestsellers'] = true;
      $params['sales_amount_from'] = Registry::get('addons.bestsellers.sales_amount_from');

  } elseif ($mode == 'newest') {
    if (Registry::get('addons.et_vivashop_mv_functionality.et_mv_menu_setting_new')!="Y"){
      return array(CONTROLLER_STATUS_NO_PAGE);
    }

      $title = __("newest");

      $params['sort_by'] = empty($params['sort_by']) ? 'timestamp' : $params['sort_by'];
      $params['plain'] = true;
      $params['visible'] = true;

      $period = Registry::get('addons.bestsellers.period');
      $params['period'] = 'A';
      if ($period == 'today') {
          $params['period'] = 'D';

      } elseif ($period == 'last_days') {
          $params['period'] = 'HC';
          $params['last_days'] = Registry::get('addons.bestsellers.last_days');
      }

  } else {
      $title = __('products');
  }
  
  //Unset old base

  fn_add_breadcrumb(__('store_home'),fn_url('companies.view?company_id='.$_REQUEST['company_id']));
  fn_add_breadcrumb($title);

  $bc = Tygh::$app['view']->getTemplateVars('breadcrumbs');
  unset($bc[0]);
  $bc=array_values($bc);
  Tygh::$app['view']->assign('breadcrumbs', $bc);

  Registry::set('runtime.company_id',$params['company_id']);
  // unset($params['company_id']);
  list($products, $search) = fn_get_products($params, 20);

  fn_gather_additional_products_data($products, array('get_icon' => true, 'get_detailed' => true, 'get_additional' => true, 'get_options'=> true));

  $selected_layout = fn_get_products_layout($params);

  Tygh::$app['view']->assign('products', $products);

  Tygh::$app['view']->assign('search', $search);

  Tygh::$app['view']->assign('title', $title);

  Tygh::$app['view']->assign('selected_layout', $selected_layout);



}elseif ($mode == 'view'){
  Tygh::$app['view']->assign('use_vendor_url', true);
  $params_vsb = array(
    'company_id' => $_REQUEST['company_id'],
    'active'=>true,
    'get_product_data' => true,
'items_per_page' => 15
  );



  @list($vendor_store_blocks,)=fn_et_mv_get_vsb($params_vsb);

  if (empty($vendor_store_blocks)){
    // assign default vendor store blocks
    $params_vsb['company_id']=0;
    @list($vendor_store_blocks,)=fn_et_mv_get_vsb($params_vsb);
  }

  if (empty($vendor_store_blocks)){
    if (Registry::get('addons.vendor_plans.status') == 'A') {
      $company = Company::model()->find($_REQUEST['company_id']);
      if (!$company->vendor_store) {
        return array(CONTROLLER_STATUS_REDIRECT, 'companies.description?company_id=' . $_REQUEST['company_id']);
      }else{
        $return_url="companies.products&company_id=".$_REQUEST['company_id'];
        return array(CONTROLLER_STATUS_OK, $return_url);
      }
    }else{
      $return_url="companies.products&company_id=".$_REQUEST['company_id'];
      return array(CONTROLLER_STATUS_OK, $return_url);
    }
  }else{
    Tygh::$app['view']->assign('vsb', $vendor_store_blocks);
  }


}elseif ($mode == 'product_view'){
  $controller="products";
  $mode="view";

  $et_prod_exists=fn_product_exists($_REQUEST['product_id']);

  $company_id = (int) $_REQUEST['company_id'];
  $company_data = !empty($company_id) ? fn_get_company_data($company_id) : [];

  if (!($et_prod_exists) || (!empty($company_data['status']) && $company_data['status'] != 'A')) {
      return array(CONTROLLER_STATUS_NO_PAGE);
  }
  Registry::set('runtime.vendor_id', $company_id);

  $product = fn_get_product_data(
      $_REQUEST['product_id'],
      $auth,
      CART_LANGUAGE,
      '',
      true,
      true,
      true,
      true,
      fn_is_preview_action($auth, $_REQUEST),
      true,
      false,
      true
  );

  if (empty($product)) {
      return array(CONTROLLER_STATUS_NO_PAGE);
  }

  Tygh::$app['view']->assign('use_vendor_url', true);
  $orig_mode=$mode;
  $mode='view';
  include_once(Registry::get('config.dir.root') . '/app/controllers/frontend/products.php');
  $mode=$orig_mode;

  // Breadcrumbs
  $parent_ids = fn_get_category_ids_with_parent(Tygh::$app['session']['current_category_id']);
  //Current breadcrumbs
  $bc = Tygh::$app['view']->getTemplateVars('breadcrumbs');
  
  //Custom base
  $base=array();
  $bc_company_id=$_REQUEST['company_id'];
  $company_name = !empty($_REQUEST['company_id']) ? fn_get_company_name($_REQUEST['company_id']) : '';
  $base[0]=array(
    'title'=>__('store_home'),
    'link'=> fn_url('companies.view?company_id='.$bc_company_id),
  );
  
  //Unset old base
  unset($bc[0]);
  foreach ($bc as $key => $value) {
    if (stristr($value['link'], 'categories.view') ){
      $bc[$key]['link']=str_replace("categories.view", "companies.products&company_id=".$bc_company_id, $value['link']);
    }
  }

  //New breadcrumbs
  $new_bc=array_merge($base,$bc);
  
  Tygh::$app['view']->assign('breadcrumbs', $new_bc);

  // Discussion addon (rating)
  if (Registry::get('addons.discussion.status') == 'A'){
    $orig_mode=$mode;
    $mode='view';
    include_once(Registry::get('config.dir.addons') . 'discussion/controllers/frontend/products.post.php');
    $mode=$orig_mode;
  }

  // Product reviews addon
  if (Registry::get('addons.product_reviews.status') == 'A'){
    $orig_mode=$mode;
    $mode='view';
    include_once(Registry::get('config.dir.addons') . 'et_vivashop_settings/controllers/frontend/products.post.php');
    $mode=$orig_mode;
  }

  // Social buttons addon
  if (Registry::get('addons.social_buttons.status') == 'A'){
    $orig_mode=$mode;
    $mode='view';
    include_once(Registry::get('config.dir.addons') . 'social_buttons/controllers/frontend/products.post.php');
    $mode=$orig_mode;
  }

  //reward points addon
  if (Registry::get('addons.reward_points.status') == 'A'){
    $product['points_info']['price']=fn_get_price_in_points($product['product_id'],$auth);
    Tygh::$app['view']->assign('product', $product);
  }
  
  //geo maps addon
  if (Registry::get('addons.geo_maps.status') == 'A'){
    Tygh::$app['view']->assign([
        'shipping_estimation_product_id' => $_REQUEST['product_id'],
        'location'                       => fn_geo_maps_get_customer_stored_geolocation(),
    ]);
  }

  // Age verification addon
  if (Registry::get('addons.age_verification.status') == 'A'){
    $orig_mode=$mode;
    $mode='view';
    include_once(Registry::get('config.dir.addons') . 'age_verification/controllers/frontend/products.post.php');
    if (isset($type) && $type !== false && isset($url)) {
      return array (CONTROLLER_STATUS_REDIRECT, $url);
    }
    $mode=$orig_mode;
  }

  // Tags addon 
  if (Registry::get('addons.tags.status') == 'A'){
    $orig_mode=$mode;
    $mode='view';
    include_once(Registry::get('config.dir.addons') . 'tags/controllers/frontend/products.post.php');
    $mode=$orig_mode;
  }
  // Product variations addon
  if (Registry::get('addons.product_variations.status') == 'A'){
    $orig_mode=$mode;
    $mode='view';
    include_once(Registry::get('config.dir.addons') . 'product_variations/controllers/frontend/products.post.php');
    $mode=$orig_mode;
  }

}elseif ($mode == 'products'){
  $company_id = (int) $_REQUEST['company_id'];
  $company_data = !empty($company_id) ? fn_get_company_data($company_id) : [];
  if (isset($_REQUEST['search_performed']) && $_REQUEST['search_performed']=='Y'){
    Tygh::$app['view']->assign('et_is_vendor_search', true);
  }
//fn_print_die($company_id);
  if (!empty($company_data['status']) && $company_data['status'] != 'A') {
      return array(CONTROLLER_STATUS_NO_PAGE);
  }

  Tygh::$app['view']->assign('use_vendor_url', true);
  
  $company_name = !empty($_REQUEST['company_id']) ? fn_get_company_name($_REQUEST['company_id']) : '';

  $bc = Tygh::$app['view']->getTemplateVars('breadcrumbs');

  $index=false;
  foreach ($bc as $key => $value) {
    if (stristr($value['link'], 'companies.products') && ($value['title']==$company_name)){
      $index=$key;
    }
  }

  if ($index>0){
    unset($bc[$index]);
    $bc = array_values($bc);
  }

  array_shift($bc);
  Tygh::$app['view']->assign('breadcrumbs', $bc);
  
  $et_vs=fn_et_mv_get_vs($_REQUEST['company_id']);
  Tygh::$app['view']->assign('et_vs', $et_vs);

  $et_params = $_REQUEST;
  $company_data = !empty($_REQUEST['company_id']) ? fn_get_company_data($_REQUEST['company_id']) : array();
  
  if (!empty($company_data)){
    fn_et_vivashop_mv_functionality_unserialize($company_data);
  }

  $company_id = $company_data['company_id'];
  $et_params['company_id'] = $company_id;
  $et_params['extend'] = array('description');
  if (!empty($category_data)) {
    $et_params['cid'] = $category_id;
    if (Registry::get('settings.General.show_products_from_subcategories') == 'Y') {
      $et_params['subcats'] = 'Y';
    }
  }
  if ($items_per_page = fn_change_session_param(Tygh::$app['session']['companies_params'], $_REQUEST, 'items_per_page')) {
      $et_params['items_per_page'] = $items_per_page;
  }

//fn_print_die($items_per_page);
  if ($sort_by = fn_change_session_param(Tygh::$app['session']['companies_params'], $_REQUEST, 'sort_by')) {
      $et_params['sort_by'] = $sort_by;
  }
  if ($sort_order = fn_change_session_param(Tygh::$app['session']['companies_params'], $_REQUEST, 'sort_order')) {
      $et_params['sort_order'] = $sort_order;
  }

  if (!empty($products)) {
      Tygh::$app['session']['continue_url'] = Registry::get('config.current_url');
  }

  if (!empty($_REQUEST['category_id'])) {
  }else{
    $s=fn_get_subcategories(
        0, array('company_ids' => $company_data['company_id']));
    Tygh::$app['view']->assign('subcategories', $s);
  }

}elseif ($mode == 'discussion'){
  Tygh::$app['view']->assign('use_vendor_url', true);
  // Discussion addon (rating)
  if (Registry::get('addons.discussion.status') == 'A'){
    $orig_mode=$mode;
    $mode='view';
    include_once(Registry::get('config.dir.addons') . 'discussion/controllers/common/discussion.php');
    
    //Breadcrumbs
    if (!empty($discussion_object_data['url']) && stristr($discussion_object_data['url'], 'companies.view')){

      $bc = Tygh::$app['view']->getTemplateVars('breadcrumbs');

      $bc[1]=array(
        'title'=>__('store_home'),
        'link'=> $discussion_object_data['url'],
      );

      unset($bc[0]);
      $bc=array_values($bc);
      Tygh::$app['view']->assign('breadcrumbs', $bc);
      
      Tygh::$app['view']->assign('breadcrumbs', $bc);
    }
    $mode=$orig_mode;
  }


}elseif ($mode == 'description'){
  if (Registry::get('addons.et_vivashop_mv_functionality.et_mv_menu_setting_about')!="Y"){
    return array(CONTROLLER_STATUS_NO_PAGE);
  }

  fn_add_breadcrumb(__('store_home'),fn_url('companies.view?company_id='.$_REQUEST['company_id']));
  fn_add_breadcrumb(__('about_us'));

  Tygh::$app['view']->assign('use_vendor_url', true);

  $bc = Tygh::$app['view']->getTemplateVars('breadcrumbs');
  unset($bc[0]);
  $bc=array_values($bc);
  Tygh::$app['view']->assign('breadcrumbs', $bc);
  
  $company_data = !empty($_REQUEST['company_id']) ? fn_get_company_data($_REQUEST['company_id']) : array();
  if (!empty($company_data)){
    fn_et_vivashop_mv_functionality_unserialize($company_data);
  }

  if (empty($company_data) || empty($company_data['status']) || !empty($company_data['status']) && $company_data['status'] != 'A') {
      return array(CONTROLLER_STATUS_NO_PAGE);
  }

  Tygh::$app['view']->assign('company_data', $company_data);
  
}elseif ($mode == 'catalog'){
  $companies = Tygh::$app['view']->getTemplateVars('companies');

  foreach ($companies as $key => $value) {
    $company_id=$value['company_id'];
    
    $et_vendor_info=fn_get_company_data($company_id);
    $et_vendor_info = fn_filter_company_data_by_profile_fields($et_vendor_info);
    if (!empty($company_data)){
      fn_et_vivashop_mv_functionality_unserialize($company_data);
    }
    $companies[$key]=fn_array_merge($companies[$key], $et_vendor_info);
    

    $companies[$key]['vendor_extra_details']=fn_et_vivashop_mv_functionality_get_ved($company_id);

    $companies[$key]['product_count']= fn_et_get_company_product_count($company_id);
    if (Registry::get('addons.discussion.status') == 'A'){
      $et_vendor_review=fn_get_discussion($company_id, 'M', true);
      $companies[$key]['discussion']=fn_array_merge($companies[$key]['discussion'],$et_vendor_review);
    }


  }

  Tygh::$app['view']->assign('companies', $companies);

}elseif ($mode == 'page_view'){
  $controller="pages";
  $mode="view";
  $company_id = (int) $_REQUEST['company_id'];
  Tygh::$app['view']->assign('use_vendor_url', true);

  include_once(Registry::get('config.dir.root') . '/app/controllers/frontend/pages.php');

  // Social buttons addon
  if (Registry::get('addons.social_buttons.status') == 'A'){
    include_once(Registry::get('config.dir.addons') . 'social_buttons/controllers/frontend/pages.post.php');
  }

  $page_data = Tygh::$app['view']->getTemplateVars('page');

  //Current breadcrumbs
  $bc = Tygh::$app['view']->getTemplateVars('breadcrumbs');
  
  //Custom base
  $base=array();
  $base[0]=array(
    'title'=>__('store_home'),
    'link'=> fn_url('companies.view?company_id='.$company_id),
  );

  //Unset old base
  if (isset($bc[0])){
    unset($bc[0]);
  }

  foreach ($bc as $key => $value) {
    $link=$value['link'];
    if (!empty($link)){
      $bc[$key]['link']=str_replace('pages.view', 'companies.page_view', $link);
    }
  }

  //New breadcrumbs
  $new_bc=array_merge($base,$bc);

  Tygh::$app['view']->assign('breadcrumbs', $new_bc);

}elseif ($mode =='vendor_plans'){
  Tygh::$app['view']->assign('et_mv_settings', fn_get_et_vivashop_mv_functionality_settings());

}
