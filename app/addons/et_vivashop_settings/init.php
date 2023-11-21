<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
	'dispatch_assign_template',
	'update_grid',
	'get_filters_products_count_pre',
	'get_filters_products_count_post',
	'gather_additional_products_data_post',
	'update_block_pre',
	'update_block_post',
	'get_block_post',
	'get_blocks_post',
	'dispatch_before_send_response',
	'render_blocks',
	'render_block_content_after',
	'render_block_pre'
);