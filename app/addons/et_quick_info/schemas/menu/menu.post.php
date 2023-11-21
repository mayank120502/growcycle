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

$schema['top']['addons']['items']['et_addons']['subitems']['et_quick_info'] = array(
  'attrs' => array(
    'class'=>'is-addon'
  ),
  'href' => 'et_quick_info.manage',
  'position' => 100
);

return $schema;