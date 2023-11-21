<?php

use Tygh\Registry;

$schema['et_featured_vendors'] = array (
  'content' => array(
    'description' => array(
      'type' => 'simple_text',
      'required' => false,
    ),
    'items' => array(
      'type' => 'enum',
      'object' => 'vendors',
      'remove_indent' => true,
      'hide_label' => true,
      'items_function' => 'fn_et_blocks_get_vendors',
      'fillings' => array(
        'all' => array(),
        'manually' => array(
          'picker' => 'pickers/companies/picker.tpl',
          'picker_params' => array(
            'multiple' => true,
            'positions' => true,
          ),
          'params' => array (
              'sort_by' => 'position',
              'sort_order' => 'asc'
          )
        )
      ),
    ),
  ),
  'settings' => array(
    'displayed_vendors' => array(
      'type' => 'input',
      'default_value' => '12'
    )
  ),
  'templates' => 'addons/et_vivashop_mv_functionality/blocks/et_featured_vendors.tpl',
  'wrappers' => 'addons/et_vivashop_mv_functionality/blocks/wrappers',
  'multilanguage' => true,
  'cache' => [
    'update_handlers'   => [
      'images',
      'companies', 
      'company_descriptions', 
      'products', 
      'storefronts_companies',
      'profile_fields'],
    'callable_handlers' => [
      'storefront' => ['fn_blocks_get_current_storefront_id'],
    ],
  ],
);

$schema['et_featured_vendors_sidebar'] = array (
  'content' => array(
    'items' => array(
      'type' => 'enum',
      'object' => 'vendors',
      'remove_indent' => true,
      'hide_label' => true,
      'items_function' => 'fn_energothemes_get_short_companies',
      'fillings' => array(
        'all' => array(),
        'manually' => array(
          'picker' => 'pickers/companies/picker.tpl',
          'picker_params' => array(
            'multiple' => true,
            'positions' => true,
          ),
        )
      ),
    ),
  ),
  'templates' => 'addons/et_vivashop_mv_functionality/blocks/et_featured_vendors_sidebar.tpl',
  'wrappers' => 'blocks/wrappers',
  'cache' => array(
    'update_handlers' => array('companies', 'company_descriptions', 'logos'),
  ),
);

$schema['et_vendor_store_header'] = array(
  'templates' => array(
    'addons/et_vivashop_mv_functionality/blocks/et_vendor_store_header.tpl' => array(),
  ),
  'wrappers' => 'blocks/wrappers',
  'content' => array(
    'vendor_info' => array(
      'type' => 'function',
      'function' => array('fn_et_mv_get_header_data'),
    ),
  ),
  'cache' => array(
    'update_handlers' => array('companies', 'company_descriptions', 'logos', 'images_links', 'images','discussion','discussion_posts','discussion_rating','et_mv_ved','et_mv_vendor_settings','profile_fields','vendor_plans'),
    'request_handlers' => array('company_id'),
    'disable_cache_when' => array(
      'request_handlers' => array('thread_id'),
    ),
  ),
);

$schema['et_vendor_store_header_mobile'] = array(
  'templates' => array(
    'addons/et_vivashop_mv_functionality/blocks/et_vendor_store_header_mobile.tpl' => array(),
  ),
  'wrappers' => 'blocks/wrappers',
  'content' => array(
    'vendor_info' => array(
      'type' => 'function',
      'function' => array('fn_et_mv_get_header_data'),
    ),
  ),
  'cache' => array(
    'update_handlers' => array('companies', 'company_descriptions', 'logos', 'images_links', 'images','profile_fields','vendor_plans'),
    'request_handlers' => array('company_id')
  )
);

$schema['et_vendor_store_menu'] = array(
  'templates' => array(
    'addons/et_vivashop_mv_functionality/blocks/et_vendor_store_menu.tpl' => array(),
  ),
  'wrappers' => 'addons/et_vivashop_mv_functionality/blocks/wrappers',
  'content' => array(
    'vendor_info' => array(
      'type' => 'function',
      'function' => array('fn_et_mv_get_header_data'),
    ),
    'menu_items' => array(
      'type' => 'enum',
      'object' => 'categories',
      'items_function' => 'fn_et_mv_get_categories',
      'remove_indent' => true,
      'hide_label' => true,
      'fillings' => array (
        'full_tree_cat' =>  array (
          'params' => array (
            'plain' => false,
            'get_et_category_info' => true,
            'group_by_level' => true,
            'max_nesting_level' => 3,
            'request' => array (
              'category_id' => 0,
              'company_ids' => '%COMPANY_ID%',
            ),
          ),
        ),
      ),
    ),
  ),
  'cache' => array(
    'update_handlers' => array('et_mv_vsb','companies', 'company_descriptions', 'logos', 'images_links', 'images','et_mv_vendor_settings','pages','page_descriptions','vendor_plans'),
    'request_handlers' => array('company_id'),
    'disable_cache_when' => array(
      'request_handlers' => array('thread_id'),
    ),
  )
);

$schema['et_vendor_store_menu_mobile'] = array(
  'templates' => array(
    'addons/et_vivashop_mv_functionality/blocks/et_vendor_store_menu_mobile.tpl' => array(),
  ),
  'wrappers' => 'addons/et_vivashop_mv_functionality/blocks/wrappers',
  'content' => array(
    'vendor_info' => array(
      'type' => 'function',
      'function' => array('fn_et_mv_get_header_data'),
    ),
    'menu_items' => array(
      'type' => 'enum',
      'object' => 'categories',
      'items_function' => 'fn_et_mv_get_categories',
      'remove_indent' => true,
      'hide_label' => true,
      'fillings' => array (
        'full_tree_cat' =>  array (
          'params' => array (
            'plain' => false,
            'get_et_category_info' => true,
            'group_by_level' => true,
            'max_nesting_level' => 3,
            'request' => array (
              'category_id' => 0,
              'company_ids' => '%COMPANY_ID%',
            ),
          ),
        ),
      ),
    ),
  ),
  'cache' => array(
    'update_handlers' => array('et_mv_vsb','companies', 'company_descriptions', 'logos', 'images_links', 'images','et_mv_vendor_settings','pages','page_descriptions','vendor_plans'),
    'request_handlers' => array('company_id')
  )
);

$schema['et_vendor_store_description'] = array(
  'templates' => array(
    'addons/et_vivashop_mv_functionality/blocks/et_vendor_store_description.tpl' => array(),
  ),
  'wrappers' => 'blocks/wrappers',
  'content' => array(
    'vendor_info' => array(
      'type' => 'function',
      'function' => array('fn_blocks_get_vendor_info'),
    )
  ),
  'cache' => array(
    'update_handlers' => array('companies', 'company_descriptions', 'logos', 'images_links', 'images'),
    'request_handlers' => array('company_id')
  )
);

$schema['et_vendor_categories'] = array (
  'templates' => 'addons/et_vivashop_mv_functionality/blocks/et_vendor_categories.tpl',
  'wrappers' => 'blocks/wrappers',
  'cache' => array(
    'update_handlers' => array('categories', 'et_mv_vendor_settings'),
    'request_handlers' => array('company_id')
  ),
);
$schema['product_filters']['cache_overrides_by_dispatch']['companies.products']['update_handlers'][]='et_mv_vendor_settings';
$schema['product_filters']['cache_overrides_by_dispatch']['companies.products']['update_handlers'][]='settings_objects';

$schema['et_vendor_contact_button'] = array (
  'templates' => 'addons/et_vivashop_mv_functionality/blocks/et_vendor_contact_button.tpl',
  'wrappers' => 'blocks/wrappers'
);

$schema['products']['content']['items']['fillings']['et_same_vendor'] = array (
    'params' => array (
        'similar' => true,
        'request' => array (
            'main_product_id' => '%PRODUCT_ID%',
            'company_id' => '%COMPANY_ID%'
        )
    )
);

$schema['products']['content']['items']['fillings']['vendor_rating'] = array (
  'params' => array (
    'rating' => true,
    'sort_by' => 'rating',
    'request' => array (
      'company_id' => '%COMPANY_ID%'
    )
  ),
);

if (Registry::get('addons.discussion.status')=="A"){
  $schema['call_request']['cache']['update_handlers'] = ['companies', 'company_descriptions','profile_fields'];
}

$schema['main']['cache_overrides_by_dispatch']['companies.discussion']['update_handlers'][]='discussion';
$schema['main']['cache_overrides_by_dispatch']['companies.discussion']['update_handlers'][]='discussion_messages';
$schema['main']['cache_overrides_by_dispatch']['companies.discussion']['update_handlers'][]='discussion_posts';
$schema['main']['cache_overrides_by_dispatch']['companies.discussion']['update_handlers'][]='discussion_rating';
$schema['main']['cache_overrides_by_dispatch']['companies.discussion']['request_handlers'][]='thread_id';

$schema['products']['cache']['request_handlers'][] = 'company_id';

return $schema;