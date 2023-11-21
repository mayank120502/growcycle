<?php

use Tygh\Registry;

defined('BOOTSTRAP') or die('Access denied');

Registry::set('config.tweaks.validate_menu',false);

$schema['central']['et_my_content'] = [
  'title' => __('et_my_content'),
  'position' => 300,
  'items' => [
    'et_vendor_panel_menu.my_home_blocks' => [
      'title' => __('et_vendor_panel_menu.my_home_blocks'),
      'root_title' => __('et_my_content'),
      'attrs' => [
        'class'=>'is-addon'
      ],
      'href' => 'vendor_store_blocks.manage',
      'position' => 100
    ],
    'et_vendor_panel_menu.my_banners' => [
      'title' => __('et_vendor_panel_menu.my_banners'),
      'root_title' => __('et_my_content'),
      'attrs' => [
        'class'=>'is-addon'
      ],    
      'href' => 'vendor_banners.manage',
      'position' => 200
    ],

    'et_vendor_panel_menu.my_pages' => [
      'title' => __('et_vendor_panel_menu.my_pages'),
      'root_title' => __('et_my_content'),
      'attrs' => [
        'class'=>'is-addon'
      ],    
      'href' => 'pages.manage?get_tree=multi_level&page_type=' . PAGE_TYPE_VENDOR,
      'alt' => 'pages.update?come_from=' . PAGE_TYPE_VENDOR,
      'position' => 300
    ]

  ]
];

return $schema;