<?php

$schema['addons/et_vivashop_mv_functionality/blocks/et_featured_vendors.tpl'] =array (
  'settings' => array(
    'number_of_columns' => array (
      'type' => 'input',
      'default_value' => 6
    ),
    'show_location' => array (
      'type' => 'checkbox',
      'default_value' => 'Y'
    ),
    'show_products_count' => array (
      'type' => 'checkbox',
      'default_value' => 'Y'
    )
  ),
  'fillings' => array ('all', 'manually'),
  'params' => array (
    'status' => 'A',
  ),
);

$schema['addons/et_vivashop_mv_functionality/blocks/et_featured_vendors_sidebar.tpl'] =array (
  'fillings' => array ('all', 'manually'),
  'params' => array (
    'status' => 'A',
    'limit'=>'50'
  ),
);


if (isset($schema['blocks/vendor_list_templates/featured_vendors.tpl']['settings']['show_rating'])){
    $schema['addons/et_vivashop_mv_functionality/blocks/et_featured_vendors.tpl']['settings']['show_rating'] = array(
        'type' => 'checkbox',
        'default_value' => 'Y'
    );
}

if (isset($schema['blocks/vendor_list_templates/featured_vendors.tpl']['settings']['show_vendor_rating'])){
    $schema['addons/et_vivashop_mv_functionality/blocks/et_featured_vendors.tpl']['settings']['show_vendor_rating'] = array(
        'type' => 'checkbox',
        'default_value' => 'Y'
    );
}

return $schema;