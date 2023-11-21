<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
	'update_company',
	'get_product_data_post',
	'update_language_post'
);