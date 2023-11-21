<?php

$schema['central']['website']['items']['et_my_content'] = array(
    'type' => 'title',
    'title' => __('et_my_content'),
    'attrs' => array(
        'class' => 'is-addon'
    ),
    'href' => 'vendor_store_blocks.manage',
    'position' => 300,
);

/*
$schema['central']['website']['items']['et_my_content']['subitems']['default_vendor_store'] = array(
  'title' => __('et_vendor_panel_menu.default_vendor_store'),
  'attrs' => array(
    'class'=>'is-addon'
  ),
  'href' => 'default_vendor_store.manage',
  'position' => 10
);
*/

$schema['central']['website']['items']['et_my_content']['subitems']['et_vivashop_mv_functionality.home_blocks'] = array(
  'attrs' => array(
    'class'=>'is-addon'
  ),
  'href' => 'vendor_store_blocks.manage',
  'position' => 10
);

$schema['central']['website']['items']['et_my_content']['subitems']['et_vivashop_mv_functionality.vendor_pages'] = array(
  'attrs' => array(
    'class'=>'is-addon'
  ),    
  'href' => 'pages.manage?get_tree=multi_level&page_type=' . PAGE_TYPE_VENDOR,
  'alt' => 'pages.update?come_from=' . PAGE_TYPE_VENDOR,
  'position' => 20
);

$schema['central']['website']['items']['et_my_content']['subitems']['banners'] = array(
    'attrs' => array(
        'class'=>'is-addon'
    ),
    'href' => 'vendor_banners.manage',
    'position' => 100
);


return $schema;
