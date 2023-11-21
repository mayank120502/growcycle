<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
	'et_get_category_pre',
	'et_get_category_post',
  'et_update_category_pre',
  'et_get_category_multi_pre',
  'et_get_category_multi_post'
);
