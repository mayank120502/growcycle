<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
	'get_discussion_post',
	'get_discussion_posts'
);