<?php

$schema['addons/et_vivashop_settings/blocks/products/et_home_grid.tpl'] = array (
  'settings' => array(
    'number_of_columns' => array (
        'type' => 'input',
        'default_value' => 5
    )
  ),
  'bulk_modifier' => array (
    'fn_gather_additional_products_data' => array (
      'products' => '#this',
      'params' => array (
        'get_icon' => true,
        'get_detailed' => true,
        'get_options' => true,
        'get_additional' => true,
        'et_query' => true,
      ),
    ),
  ),
);
$schema['addons/et_vivashop_settings/blocks/et_subcategories.tpl'] = array (
  'settings' => array (
    'et_type' => array (
      'type' => 'selectbox',
      'values' => array (
        'I' => 'et_subcateg_opt_img_title',
        'T' => 'title',
        'S' => 'tmpl_scroller'
      ),
      'default_value' => 'I'
    ),
  ),
);

$schema['addons/et_vivashop_settings/addons/blog/blocks/et_featured_recent_posts_scroller.tpl'] = array (
    'fillings' => array('blog.recent_posts_scroller'),
    'params' => array (
        'plain' => true,
        'request' => array (
            'blog_page_id' => '%PAGE_ID%',
        ),
    ),
    'settings' => array (
        'limit' => array (
            'type' => 'input',
            'default_value' => 3
        ),
        'not_scroll_automatically' => array (
            'type' => 'checkbox',
            'default_value' => 'Y'
        ),
        'speed' =>  array (
            'type' => 'input',
            'default_value' => 400
        ),
        'pause_delay' =>  array (
            'type' => 'input',
            'default_value' => 3
        ),
        'item_quantity' =>  array (
            'type' => 'input',
            'default_value' => 3
        ),
        'outside_navigation' => array (
            'type' => 'checkbox',
            'default_value' => 'Y'
        ),
    ),
);

$schema['addons/et_vivashop_settings/addons/blog/blocks/et_sidebar_latest_posts_scroller.tpl'] = array (
    'fillings' => array('blog.recent_posts_scroller'),
    'params' => array (
        'plain' => true,
        'request' => array (
            'blog_page_id' => '%PAGE_ID%',
        ),
    ),
    'settings' => array (
        'limit' => array (
            'type' => 'input',
            'default_value' => 3
        ),
        'not_scroll_automatically' => array (
            'type' => 'checkbox',
            'default_value' => 'Y'
        ),
        'speed' =>  array (
            'type' => 'input',
            'default_value' => 400
        ),
        'pause_delay' =>  array (
            'type' => 'input',
            'default_value' => 3
        ),
        'item_quantity' =>  array (
            'type' => 'input',
            'default_value' => 3
        ),
        'outside_navigation' => array (
            'type' => 'checkbox',
            'default_value' => 'Y'
        ),
    ),
);


return $schema;