<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
	'get_banner_data',
	'get_banner_data_post',
	'get_banners',
	'get_banners_post',
	'delete_banners',
	'update_language_post'
);