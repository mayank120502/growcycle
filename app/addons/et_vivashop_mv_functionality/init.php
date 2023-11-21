<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
	'update_company',
  'get_company_data_post',
  'page_object_by_type',
  'post_get_pages',
  'get_pages_pre',
  'get_pages',
  'init_product_tabs_post',
  'create_seo_name_pre',
  'add_breadcrumb',
  'dropdown_object_link_post',
  'get_banners',
  'get_products_post',
  'update_language_post'
);