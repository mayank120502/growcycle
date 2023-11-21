<?php
use Tygh\Registry;

$schema['et_subcaegories'] = array(
  'templates' => array(
    'addons/et_vivashop_settings/blocks/et_subcategories.tpl' => array(),
  ),
  'wrappers' => 'blocks/wrappers',
  'cache' => array(
    'update_handlers' => array('categories', 'category_descriptions'),
    'request_handlers' => array('current_category_id' =>'%CATEGORY_ID%', 'current_company_id' => '%COMPANY_ID%')
  ),
);

$schema['et_sidebar_subcategories'] = array(
  'templates' => array(
    'addons/et_vivashop_settings/blocks/et_sidebar_subcategories.tpl' => array(),
  ),
  'wrappers' => 'blocks/wrappers',
  'cache' => array(
      'update_handlers' => array(
          'products',
          'products_categories',
          'product_variation_group_products',
          'categories',
          'category_descriptions',
          'storefronts_companies',
      ),
      'request_handlers' => array('current_category_id' =>'%CATEGORY_ID%', 'current_company_id' => '%COMPANY_ID%'),
  ),
);

$schema['et_home_grid'] =array(
  'content' => array(
    'description' => array(
      'type' => 'simple_text',
      'required' => false,
    ),
    'items' => array(
      'type' => 'enum',
      'object' => 'products',
      'items_function' => 'fn_get_products',
      'remove_indent' => true,
      'hide_label' => true,
      'fillings' => array(
        'manually' => array(
          'picker' => 'pickers/products/picker.tpl',
          'picker_params' => array(
            'type' => 'links',
            'positions' => true,
          ),
        ),
        'newest' => array(
          'params' => array(
            'sort_by' => 'timestamp',
            'sort_order' => 'desc',
            'request' => array(
              'cid' => '%CATEGORY_ID%'
            )
          )
        ),
        'recent_products' => array(
          'params' => array(
            'apply_limit' => true,
            'session' => array(
              'pid' => '%RECENTLY_VIEWED_PRODUCTS%'
            ),
            'request' => array(
              'exclude_pid' => '%PRODUCT_ID%'
            ),
            'force_get_by_ids' => true,
          ),
        ),
        'most_popular' => array(
          'params' => array(
            'popularity_from' => 1,
            'sort_by' => 'popularity',
            'sort_order' => 'desc',
            'request' => array(
              'cid' => '%CATEGORY_ID'
            )
          ),
        ),
      ),
    ),
  ),
  'cache' => array(
      'update_handlers' => array(
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
      'request_handlers' => array('current_category_id' => '%CATEGORY_ID%'),
      'cookie_handlers' => array('%ALL%'),
      'callable_handlers' => array(
          'currency' => array('fn_get_secondary_currency'),
          'storefront' => ['fn_blocks_get_current_storefront_id'],
      ),
      'disable_cache_when' => array(
          'callable_handlers' => array(
              array('fn_block_products_disable_cache', array('$block_data'))
          ),
      )
  ),
  'templates' => 'addons/et_vivashop_settings/blocks/products/et_home_grid.tpl',
  'wrappers' => 'addons/et_vivashop_settings/blocks/wrappers',
);

$schema['et_cta'] = array(
  'templates' => 'addons/et_vivashop_settings/blocks/cta.tpl',
  'wrappers' => 'blocks/wrappers',
  'content' => array(
    'et_cta_title_text' => array(
      'type' => 'simple_text',
      'required' => true,
    ),
    'et_cta_step_1_title' => array(
      'type' => 'input_long',
      'required' => true,
    ),
    'et_cta_step_1_text' => array(
      'type' => 'simple_text',
      'required' => true,
    ),
    'et_cta_step_2_title' => array(
      'type' => 'input_long',
      'required' => true,
    ),
    'et_cta_step_2_text' => array(
      'type' => 'simple_text',
      'required' => true,
    ),
    'et_cta_step_3_title' => array(
      'type' => 'input_long',
      'required' => true,
    ),
    'et_cta_step_3_text' => array(
      'type' => 'simple_text',
      'required' => true,
    ),
    'et_cta_button_text' => array(
      'type' => 'input_long',
      'required' => true,
    ),
    'et_cta_button_url' => array(
      'type' => 'input_long',
      'required' => true,
    ),

  ),
  'settings' => array(
      'settings' => array(
        'remove_indent'=>true,
        'type' => 'template',
        'template'=>'addons/et_vivashop_settings/settings/cta.tpl',
      )
  ),
  'cache' => array(
      'update_handlers' => array(
          'bm_blocks_content',
      ),
  ),
  'multilanguage' => true,
);

$schema['et_eib'] = array(
  'templates' => 'addons/et_vivashop_settings/blocks/eib.tpl',
  'wrappers' => 'addons/et_vivashop_settings/blocks/eib_wrappers',
  'content' => array(
    'et_eib_block_1_title' => array(
      'type' => 'input_long',
      'required' => true,
    ),
    'et_eib_block_1_text' => array(
      'type' => 'simple_text',
      'required' => true,
    ),
    'et_eib_block_2_title' => array(
      'type' => 'input_long',
      'required' => true,
    ),
    'et_eib_block_2_text' => array(
      'type' => 'simple_text',
      'required' => true,
    ),
    'et_eib_block_3_title' => array(
      'type' => 'input_long',
      'required' => true,
    ),
    'et_eib_block_3_text' => array(
      'type' => 'simple_text',
      'required' => true,
    ),
    'et_eib_block_4_title' => array(
      'type' => 'input_long',
      'required' => true,
    ),
    'et_eib_block_4_text' => array(
      'type' => 'simple_text',
      'required' => true,
    ),
  ),
  'settings' => array(
      // 'et_icon_position' => array (
      //   'type' => 'selectbox',
      //   'values' => array (
      //     'T' => 'et_top',
      //     'L' => 'left',
      //   ),
      //   'default_value' => 'T'
      // ),
      'settings' => array(
        'remove_indent'=>true,
        'type' => 'template',
        'template'=>'addons/et_vivashop_settings/settings/eib.tpl',
      )
  ),
  'cache' => array(
      'update_handlers' => array(
          'bm_blocks_content',
      ),
  ),
  'multilanguage' => true,
);

if (Registry::get('addons.discussion.status')=="A"){
  $schema['testimonials']['settings']['et_settings']= array(
    'remove_indent'=>true,
    'type' => 'template',
    'template'=>'addons/et_vivashop_settings/settings/testimonials.tpl',
  );
}

$schema['et_home_banners'] = array (
  'content' => array (
    'description' => array(
      'type' => 'simple_text',
      'required' => false,
    ),
    'items' => array (
      'remove_indent' => true,
      'hide_label' => true,
      'type' => 'enum',
      'object' => 'banners',
      'items_function' => 'fn_get_banners',
      'fillings' => array (
        'manually' => array (
          'picker' => 'addons/banners/pickers/banners/picker.tpl',
          'picker_params' => array (
            'type' => 'links',
            'positions' => true,
          ),
          'params' => array (
            'sort_by' => 'position',
            'sort_order' => 'asc'
          )
        ),
      ),
    ),
  ),
  'templates' => array (
    'addons/et_vivashop_settings/addons/banners/blocks/et_banners.tpl' => array(),
  ),
  'wrappers' => 'addons/et_vivashop_settings/blocks/wrappers',
  'cache' => array(
    'update_handlers' => array(
      'banners', 'banner_descriptions', 'banner_images'
    )
  )
);

$schema['vendors']['settings']['description']=array(
  'type' => 'simple_text',
  'required' => false,
);

$schema['et_profile_info'] = array(
  'templates' => 'addons/et_vivashop_settings/blocks/et_profile_info.tpl',
  'wrappers' => 'blocks/wrappers',
  'content' => array(
    'et_register_text' => array(
      'type' => 'text',
      'required' => false,
    ),
    'et_profile_text' => array(
      'type' => 'text',
      'required' => false,
    ),
  ),
  'cache' => false,
  'multilanguage' => true,
);

if (isset($schema['blog']['content'])) {
  $schema['blog']['content'] = array_reverse($schema['blog']['content'], true);
  $schema['blog']['content']['description'] = array(
    'type' => 'simple_text',
    'required' => false,
  );
  $schema['blog']['content'] = array_reverse($schema['blog']['content'], true);
}
return $schema;