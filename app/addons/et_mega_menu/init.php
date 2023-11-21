<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
  'update_category_post',
  'delete_category_pre',
  'get_categories_after_sql',
  'update_static_data',
  'delete_static_data_pre',
	'update_language_post',
	'delete_languages_post'
);
