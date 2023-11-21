<?php

$schema['et_featured_product_banner_tabs'] = array(
  'templates' => 'addons/et_featured_product_banner_tabs/blocks',
  'wrappers' => 'blocks/wrappers',
  'content' => array(
    'items' => array(
      'type' => 'enum',
      'object' => 'et_block_id',
      'items_function'=>'fn_et_get_featured_product_banner_tabs',
      'remove_indent' => true,
      'fillings' => array(
        'manually' => array(
          'picker' => 'addons/et_featured_product_banner_tabs/pickers/picker.tpl',
          'picker_params' => array (
            'multiple' => false,
            'use_keys' => 'N',
            'default_name' => __('none'),
            'type'=>'links',
            'sort_order' => 'asc',
          ), 
          'params' => array (
            'simple' => true,
            'sort_by' => 'position',
            'sort_order' => 'asc',
            'status' => 'A',
            'get_product_data' => true,
          ),
        ),
      ),
    ),
  ),
  'cache' => array(
      'update_handlers' => array(
          'product_features',
          'product_features_descriptions',
          'product_features_values',
          'product_feature_variants',
          'product_feature_variant_descriptions',
          'images_links',
          'products',
          'product_descriptions',
          'product_prices',
          'products_categories',
          'product_options',
          'product_options_descriptions',
          'product_option_variants',
          'product_option_variants_descriptions',
          'product_global_option_links',
          'storefronts_companies',
      ),
      'callable_handlers' => array(
          'currency' => array('fn_get_secondary_currency'),
      ),
  ),
);


return $schema;