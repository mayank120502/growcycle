<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
  'url_post',
  'get_route',
  'seo_update_objects_pre',
  'dispatch_before_display',
  ['update_page_post',1799],
  'seo_get_name_pre'
);