<?php

$schema['banners']['templates']['addons/et_banners/blocks/et_main_slider.tpl'] = array(
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
  ),
);

return $schema;