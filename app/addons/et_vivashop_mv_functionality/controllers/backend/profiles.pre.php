<?php
use Tygh\Registry;


defined('BOOTSTRAP') or die('Access denied');

$auth = & Tygh::$app['session']['auth'];

if ($mode == 'view_product_as_user') {
	$redirect_url = !empty($_REQUEST['redirect_url'])
    ? $_REQUEST['redirect_url']
    : '';

  if (strstr($redirect_url, 'pages.view')!==false){
		$url=$_REQUEST['redirect_url'];
		$purl=parse_url($url);
		parse_str($purl['query'],$pquery);
		
		$page_id=$pquery['page_id'];
		$page_data = fn_get_page_data($page_id, CART_LANGUAGE);
		if ($page_data['page_type'] == PAGE_TYPE_VENDOR) {
			$_REQUEST['redirect_url']='companies.page_view&page_id='.$page_data['page_id'].'&company_id='.$page_data['company_id'].'&action=preview';
		}
  }
}