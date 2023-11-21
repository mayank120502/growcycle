<?php
$schema['et_main_menu']= array (
  'content' => array(
    'items' => array(
      'type' => 'enum',
      'object' => 'categories',
      'items_function' => 'fn_get_categories',
      'remove_indent' => true,
      'hide_label' => true,
      'fillings' => array (
        'full_tree_cat' =>  array (
          'params' => array (
            'plain' => false,
            'group_by_level' => true,
            'max_nesting_level' => 3,
            'request' => array (
              'active_category_id' => '%CATEGORY_ID%',
            ),
          ),
        ),
      ),
    ),
  ),
  'templates' => 'addons/et_mega_menu/blocks/et_main_menu.tpl',
  'wrappers' => 'addons/et_mega_menu/blocks/wrappers',
  'cache' => array(
    'update_handlers' => array('categories','et_category_menu'),
  )
);

$schema['et_menu_horizontal']= array (
  'content' => array(
    'items' => array(
      'type' => 'function',
      'function' => array('fn_et_get_menu_items')
    ),
    'menu' => array(
      'type' => 'template',
      'template' => 'views/menus/components/block_settings.tpl',
      'hide_label' => true,
      'data_function' => array('fn_get_menus'),
    ),
  ),
  'templates' => 'addons/et_mega_menu/blocks/et_menu_horizontal.tpl',
  'wrappers' => 'blocks/wrappers',
  'cache' => array(
    'update_handlers' => array('menus', 'menus_descriptions', 'static_data','et_menu'),
    'request_handlers' => array('*')
  )
);

$schema['et_top_menu']= array (
  'content' => array(
    'items' => array(
      'type' => 'function',
      'function' => array('fn_et_get_menu_items')
    ),
    'menu' => array(
      'type' => 'template',
      'template' => 'views/menus/components/block_settings.tpl',
      'hide_label' => true,
      'data_function' => array('fn_get_menus'),
    ),
  ),
  'templates' => 'addons/et_mega_menu/blocks/et_top_menu.tpl',
  'wrappers' => 'blocks/wrappers',
  'cache' => array(
    'update_handlers' => array('menus', 'menus_descriptions', 'static_data','et_menu'),
    'request_handlers' => array('*')
  )
);

return $schema;