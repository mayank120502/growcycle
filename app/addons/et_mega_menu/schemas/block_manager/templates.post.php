<?php

$schema['addons/et_mega_menu/blocks/et_main_menu.tpl'] = array (
	'settings' => array (
    'dropdown_second_level_elements' => array (
      'type' => 'input',
      'default_value' => '12'
    ),
    'dropdown_third_level_elements' => array (
      'type' => 'input',
      'default_value' => '6'
    ),
	),
	'params' => array (
    'plain' => false,
    'get_et_category_menu_info' => true,
    'group_by_level' => true,
    'max_nesting_level' => 3,
    'request' => array (
      'active_category_id' => '%CATEGORY_ID%',
    ),
	)
);

$schema['addons/et_mega_menu/blocks/et_menu_horizontal.tpl'] = array (
  'settings' => array (
    'dropdown_second_level_elements' => array (
      'type' => 'input',
      'default_value' => '12'
    ),
    'dropdown_third_level_elements' => array (
      'type' => 'input',
      'default_value' => '6'
    ),
  ),
);


/* NYI: Mult-Level Options */
/*
$schema['addons/et_mega_menu/blocks/et_top_menu.tpl'] = array (
  'settings' => array (
    'dropdown_second_level_elements' => array (
      'type' => 'input',
      'default_value' => '12'
    ),
    'dropdown_third_level_elements' => array (
      'type' => 'input',
      'default_value' => '6'
    ),
  ),
);
*/


return $schema;