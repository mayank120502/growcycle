<?php

$schema['pages']['check_params'] = function($request) use ($schema) {

  $dispatch = $schema['pages']['customer_dispatch'];
  $page_type = '';
  if (!empty($request['page_id'])) {
    $page_type = db_get_field("SELECT page_type FROM ?:pages WHERE page_id = ?i", $request['page_id']);
  } elseif (!empty($request['page_type'])) {
    $page_type = $request['page_type'];
  }
  $suffix = ($page_type == PAGE_TYPE_VENDOR||$page_type == PAGE_TYPE_BLOG) ? '?page_type=' . $page_type : '';

  return $dispatch . $suffix;
};

return $schema;
