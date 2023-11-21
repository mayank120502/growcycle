<?php
/*****************************************************************************
*                                                        © 2013 Cart-Power   *
*           __   ______           __        ____                             *
*          / /  / ____/___ ______/ /_      / __ \____ _      _____  _____    *
*      __ / /  / /   / __ `/ ___/ __/_____/ /_/ / __ \ | /| / / _ \/ ___/    *
*     / // /  / /___/ /_/ / /  / /_/_____/ ____/ /_/ / |/ |/ /  __/ /        *
*    /_//_/   \____/\__,_/_/   \__/     /_/    \____/|__/|__/\___/_/         *
*                                                                            *
*                                                                            *
* -------------------------------------------------------------------------- *
* This is commercial software, only users who have purchased a valid license *
* and  accept to the terms of the License Agreement can install and use this *
* program.                                                                   *
* -------------------------------------------------------------------------- *
* website: https://store.cart-power.com                                      *
* email:   sales@cart-power.com                                              *
******************************************************************************/

use Tygh\Registry;

function fn_cp_open_graph_homepage_markup_data($params = [], $only_auto = false)
{
    if (AREA == 'C' && Registry::get('addons.cp_open_graph.use_homepage_markup') != 'Y') {
        return [];
    }
    $is_store_id = false;
    if (fn_allowed_for('MULTIVENDOR')) {
        $storefront = Tygh::$app['storefront'];
        $company_id = $storefront->storefront_id;
        $is_store_id = true;
    } else {
        $company_id = !empty($params['company_id']) ? $params['company_id'] : fn_get_runtime_company_id();
    }
    $data = fn_cp_og_get_manual_data('homepage', $company_id, DESCR_SL);
    if (empty($data)) {
        $data = fn_cp_og_get_default_homepage_data($company_id, DESCR_SL);
    }
    if (!empty($is_store_id)) {
        $data['url'] = fn_url('?storefront_id=' . $company_id, 'C');
    } else {
        $data['url'] = fn_url('', 'C');
    }

    return $data;
}

function fn_cp_open_graph_category_markup_data($params = [], $only_auto = false)
{
    $addon_settings = Registry::get('addons.cp_open_graph');
    if (AREA == 'C' && $addon_settings['use_categories_markup'] != 'Y') {
        return [];
    }
    $data = [];
    $category = Tygh::$app['view']->getTemplateVars('category_data');
    if (empty($category)) {
        return [];
    }
    if (!$only_auto && isset($category['cp_og_data_type']) && $category['cp_og_data_type'] == CP_OG_DATA_MANUAL) {
        $data = fn_cp_og_get_manual_data('category', $category['category_id'], DESCR_SL);
    } else {
        $description = !empty($category['meta_description']) ? $category['meta_description'] : $category['description'];
        $data = [
            'object_type'   => 'category',
            'object_id'     => isset($category['category_id']) ? $category['category_id'] : '',
            'title'         => !empty($category['page_title']) ? $category['page_title'] : $category['category'],
            'description'   => fn_cp_og_data_strip_description($description),
            'image'         => isset($category['main_pair']['detailed']) ? $category['main_pair']['detailed'] : []
        ];
    }
    if (empty($data)) {
        return [];
    }
    $data['url'] = !empty($category['link']) ? $category['link'] : fn_url('categories.view?category_id=' . $category['category_id'], 'C');
    $data['title'] = str_replace('{{ storefront }}', '', $data['title']);
    $data['title'] = str_replace('{{ pagination }}', '', $data['title']);
    $data['description'] = str_replace('{{ storefront }}', '', $data['description']);
    $data['description'] = str_replace('{{ pagination }}', '', $data['description']);
    
    if ($addon_settings['use_product_image'] == 'Y' && empty($data['image'])) { // add image from product if no image on category
        $products = Tygh::$app['view']->getTemplateVars('products');
        if (!empty($products)) {
            foreach($products as $pr_data) {
                if (!empty($pr_data['main_pair'])) {
                    $data['image'] = !empty($pr_data['main_pair']['detailed']) ? $pr_data['main_pair']['detailed'] : $pr_data['main_pair']['icon'];
                    break;
                }
            }
        }
    }
    
    return $data;
}

function fn_cp_open_graph_product_markup_data($params = [], $only_auto = false)
{
    $settings = Registry::get('addons.cp_open_graph');
    if (AREA == 'C' 
        && (empty($settings['use_products_markup']) || $settings['use_products_markup'] != 'Y')
    ) {
        return [];
    }
    $data = [];
    $template_var = (AREA == 'C') ? 'product' : 'product_data';
    $product = Tygh::$app['view']->getTemplateVars($template_var);
    if (empty($product)) {
        return [];
    }
    if (!$only_auto && isset($product['cp_og_data_type']) && $product['cp_og_data_type'] == CP_OG_DATA_MANUAL) {
        if (!empty($product['product_id'])) {
            $data = fn_cp_og_get_manual_data('product', $product['product_id'], DESCR_SL);
        }
    } else {
        $description = '';
        if (!empty($product['meta_description'])) {
            $description = $product['meta_description'];
        } elseif (!empty($product['short_description'])) {
            $description = $product['short_description'];
        } elseif (!empty($product['full_description'])) {
            $description = $product['full_description'];
        }
        if (!empty($product['page_title'])) {
            $title = $product['page_title'];
        } elseif (!empty($product['product'])) {
            $title = $product['product'];
        } else {
            $title = '';
        }
        $data = [
            'object_type'   => 'product',
            'object_id'     => isset($product['product_id']) ? $product['product_id'] : '',
            'title'         => $title,
            'description'   => fn_cp_og_data_strip_description($description),
            'image'         => isset($product['main_pair']['detailed']) ? $product['main_pair']['detailed'] : []
        ];
    }
    if (empty($data)) {
        return [];
    }
    $data['title'] = str_replace('{{ storefront }}', '', $data['title']);
    $data['description'] = str_replace('{{ storefront }}', '', $data['description']);
    $data['type'] = 'og:product';
    if (!empty($product['product_id'])) {
        $data['url'] = fn_url('products.view?product_id=' . $product['product_id'], 'C');
    }

    if (AREA == 'C') {
        // Product extra fields
        $product_fields = [];
        if (!empty($product['price'])) {
            $product_fields['price']['amount'] = fn_format_price((float) $product['price']);
            $product_fields['price']['currency'] = CART_PRIMARY_CURRENCY;
        }
        if (!empty($settings['feature_brand'])) {
            $product_fields['brand'] = fn_cp_og_get_feature_value($settings['feature_brand'], $product);
        }
        if (!empty($settings['feature_availability'])) {
            if ($settings['feature_availability'] == 'auto') {
                $availability = 'out of stock';

                $amount = 0;
                if (isset($product['inventory_amount'])) {
                    $amount = $product['inventory_amount'];
                } elseif (isset($product['amount'])) {
                    $amount = $product['amount'];
                }
                if (!empty($product['min_qty']) && $amount < $product['min_qty']) {
                    $amount = 0;
                }
                if ($amount > 0 || Registry::get('settings.General.inventory_tracking') == 'N') {
                    $availability = 'in stock';
                }
                
                $product_fields['availability'] = $availability;
            } else {
                $availability = fn_cp_og_get_feature_value($settings['feature_availability'], $product);
                $product_fields['availability'] = strtolower(trim($availability));
            }
        }
        if (!empty($settings['feature_condition'])) {
            $condition = fn_cp_og_get_feature_value($settings['feature_condition'], $product, true);
            $product_fields['condition'] = strtolower(trim($condition));
        }
        if (!empty($settings['feature_retailer_item_id'])) {
            if ($settings['feature_retailer_item_id'] == 'use_product_code') {
                $product_fields['retailer_item_id'] = $product['product_code'];
            } elseif ($settings['feature_retailer_item_id'] == 'use_product_id') {
                $product_fields['retailer_item_id'] = $product['product_id'];
            } else {
                $product_fields['retailer_item_id'] = fn_cp_og_get_feature_value($settings['feature_retailer_item_id'], $product);
            }
        }
        if (!empty($settings['feature_item_group_id'])) {
            $product_fields['item_group_id'] = fn_cp_og_get_feature_value($settings['feature_item_group_id'], $product);
        }
        if (!empty($product_fields)) {
            $data['extra_fields']['product'] = $product_fields;
        }
    }

    return $data;
}

function fn_cp_open_graph_page_markup_data($params = [], $only_auto = false)
{
    if (AREA == 'C' && Registry::get('addons.cp_open_graph.use_pages_markup') != 'Y') {
        return [];
    }

    $data = [];
    $template_var = (AREA == 'C') ? 'page' : 'page_data';
    $page = Tygh::$app['view']->getTemplateVars($template_var);
    if (empty($page)) {
        return [];
    }
    
    if (!$only_auto && isset($page['cp_og_data_type']) && $page['cp_og_data_type'] == CP_OG_DATA_MANUAL) {
        $data = fn_cp_og_get_manual_data('page', $page['page_id'], DESCR_SL);
    } else {
        $description = !empty($page['meta_description']) ? $page['meta_description'] : $page['description'];
        $data = [
            'object_type'   => 'page',
            'object_id'     => isset($page['page_id']) ? $page['page_id'] : '',
            'title'         => !empty($page['page_title']) ? $page['page_title'] : $page['page'],
            'description'   => fn_cp_og_data_strip_description($description)
        ];
    }
    if (empty($data)) {
        return [];
    }
    $data['title'] = str_replace('{{ storefront }}', '', $data['title']);
    $data['description'] = str_replace('{{ storefront }}', '', $data['description']);
    
    $data['url'] = !empty($page['link']) ? $page['link'] : fn_url('pages.view?page_id=' . $page['page_id'], 'C');
    
    return $data;
}

function fn_cp_open_graph_blog_markup_data($params = [], $only_auto = false)
{
    $data = [];
    $template_var = (AREA == 'C') ? 'page' : 'page_data';
    $page = Tygh::$app['view']->getTemplateVars($template_var);
    if (empty($page)) {
        return [];
    }
    if (empty($page['page_type']) || $page['page_type'] != PAGE_TYPE_BLOG) {
        return [];
    }

    $use_markup = Registry::get('addons.cp_open_graph.use_markup_for');
    if (AREA == 'C' && (empty($use_markup['blog']) || $use_markup['blog'] != 'Y')) {
        return ['fake' => true]; // stop other object markup
    }
    
    if (!$only_auto && isset($page['cp_og_data_type']) && $page['cp_og_data_type'] == CP_OG_DATA_MANUAL) {
        $data = fn_cp_og_get_manual_data('page', $page['page_id'], DESCR_SL);
    } else {
        $description = !empty($page['meta_description']) ? $page['meta_description'] : $page['description'];
        $data = [
            'object_type'   => 'page',
            'object_id'     => isset($page['page_id']) ? $page['page_id'] : '',
            'title'         => !empty($page['page_title']) ? $page['page_title'] : $page['page'],
            'description'   => fn_cp_og_data_strip_description($description),
            'image'         => !empty($page['main_pair']['icon']) ? $page['main_pair']['icon'] : []
        ];
    }
    if (empty($data)) {
        return [];
    }
    $data['url'] = !empty($page['link']) ? $page['link'] : fn_url('pages.view?page_id=' . $page['page_id'], 'C');
    
    return $data;
}

function fn_cp_og_get_feature_value($feature_id, $product_data, $only_value = false)
{
    if (!is_numeric($feature_id)) {
        return '';
    }

    $value = '';
    if (isset($product_data['header_features']) 
        && isset($product_data['header_features'][$feature_id])
    ) {
        $feature = $product_data['header_features'][$feature_id];
        $value = !empty($feature['variant']) ? $feature['variant'] : $feature['value'];

    } elseif (
        isset($product_data['product_features']) 
        && isset($product_data['product_features'][$feature_id])
    ) {
        $feature = $product_data['product_features'][$feature_id];
        if (!empty($feature['value'])) {
            $value = $feature['value'];
        
        } elseif (
            !empty($feature['variant_id'])
            && !empty($feature['variants'][$feature['variant_id']]['variant'])
        ) {
            $value = $feature['variants'][$feature['variant_id']]['variant'];
        }
    }

    if (empty($value) || $only_value) {
        return $value;
    }

    $prefix = isset($feature_data['prefix']) ? $feature_data['prefix'] : '';
    $suffix = isset($feature_data['suffix']) ? $feature_data['suffix'] : '';

    return "{$prefix}{$value}{$suffix}";
}