<?php

if ( !isset($schema['top']['addons']['items']['et_addons'])){
	$schema['top']['addons']['items']['et_addons'] = array(
		'type' => 'title',
		'title' => __('et_addons_menu'),
	  'attrs' => array(
	    'class'=>'is-addon'
	  ),
	  'href' => 'et_quick_info.manage',
	  'position' => 100
	);
	$schema['top']['addons']['items']['locations_divider'] = array(
		'type' => 'divider',
		'position' => 101,
	);
}

$schema['top']['addons']['items']['et_addons']['subitems']['et_featured_product_banner_tabs'] = array(
  'attrs' => array(
    'class'=>'is-addon'
  ),
  'href' => 'et_featured_product_banner_tabs.manage',
  'position' => 100
);


return $schema;