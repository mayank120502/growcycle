<?php

$schema['et_search']= array (
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
  'templates' => 'addons/et_search/blocks/et_search.tpl',
);


return $schema;