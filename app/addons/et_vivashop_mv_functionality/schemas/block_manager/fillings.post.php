<?php

$schema['et_same_vendor'] = array (
  'limit' => array (
    'type' => 'input',
    'default_value' => 3,
  ),
  'percent_range' => array (
    'type' => 'input',
    'unset_empty' => true,
  ),
  'similar_category' => array (
    'type' => 'checkbox',
    'default_value' => 'Y'
  ),
  'similar_subcats' => array (
    'type' => 'checkbox',
    'default_value' => 'Y'
  ),
  'similar_in_stock' => array (
    'type' => 'checkbox',
    'default_value' => 'Y'
  ),
);

$schema['vendor_rating'] = array (
  'limit' => array (
    'type' => 'input',
    'default_value' => 3,
  ),
  'cid' => array (
    'type' => 'picker',
    'option_name' => 'filter_by_categories',
    'picker' => 'pickers/categories/picker.tpl',
    'picker_params' => array(
        'multiple' => true,
        'use_keys' => 'N',
        'view_mode' => 'table',
        'no_item_text' => __('default_filter_by_location'),
    ),
    'unset_empty' => true, // remove this parameter from params list if the value is empty
  ),
);

return $schema;
