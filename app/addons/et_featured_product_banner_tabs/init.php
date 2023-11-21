<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
	'update_language_post',
	'delete_languages_post'
);
