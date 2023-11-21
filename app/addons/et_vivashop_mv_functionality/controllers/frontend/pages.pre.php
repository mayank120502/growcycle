<?php
use Tygh\Registry;


if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'view') {
	$_REQUEST['page_id'] = empty($_REQUEST['page_id']) ? 0 : $_REQUEST['page_id'];
  $preview = fn_is_preview_action($auth, $_REQUEST);
  $page_data = fn_get_page_data($_REQUEST['page_id'], CART_LANGUAGE, $preview);

	if ($page_data['page_type'] == PAGE_TYPE_VENDOR) {
		return array(CONTROLLER_STATUS_REDIRECT, 'companies.page_view&page_id='.$page_data['page_id'].'&company_id='.$page_data['company_id']);
	}
}
