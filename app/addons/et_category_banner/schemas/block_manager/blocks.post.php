<?php

$schema['et_category_banner'] = array(
  'templates' => array(
    'addons/et_category_banner/blocks/et_category_banner.tpl' => array(
    'settings' => array (
      'navigation' => array (
        'type' => 'selectbox',
        'values' => array (
          'N' => 'none',
          'D' => 'dots',
          'P' => 'pages',
          'A' => 'arrows'
        ),
        'default_value' => 'D'
      ),
      'delay' => array (
        'type' => 'input',
        'default_value' => '3'
      ),
    ),),
  ),

  'wrappers' => 'blocks/wrappers',
  'content' => array(
    'et_category_banner' => array(
      'type' => 'function',
      'function' => array('fn_get_et_category_banner_current'),
    )
  ),
  'cache' => array(
      'update_handlers' => array(
          'banners', 'banner_descriptions', 'banner_images'
      ),
      'request_handlers' => array('category_id'),
  ),
);

return $schema;