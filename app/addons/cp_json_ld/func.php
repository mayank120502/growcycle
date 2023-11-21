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
use Tygh\Enum\ObjectStatuses;
use Tygh\Addons\ProductReviews\ServiceProvider as ProductReviewsProvider;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_cp_get_global_id_values($settings, $product)
{
    $global_ids = [];
    $product_code = isset($product['product_code']) ? $product['product_code'] : '';
    
    // setting => field of value
    $base_global_values = [
        'feature_gtin8' => 'gtin8',
        'feature_gtin12'=> 'gtin12',
        'feature_gtin13'=> 'gtin13',
        'feature_gtin14'=> 'gtin14',
        'feature_mpn'   => 'mpn'
    ];

    foreach ($base_global_values as $setting => $field) {
        if (empty($settings[$setting])) {
            continue;
        }
        $feature_id = $settings[$setting];

        if ($feature_id == 'use_product_code') {
            $global_ids[$field] = $product_code;
        } else {
            $global_ids[$field] = fn_cp_jld_get_feature_value($feature_id, $product);
        }
    }

    return $global_ids;
}

function fn_cp_jld_get_more_features($settings, $product)
{
    $material = $color = $pattern = '';
    if (!empty($settings['feature_material'])) {
        $material = fn_cp_jld_get_feature_value($settings['feature_material'], $product);
    }
    if (!empty($settings['feature_color'])) {
        $color = fn_cp_jld_get_feature_value($settings['feature_color'], $product);
    }
    if (!empty($settings['feature_pattern'])) {
        $pattern = fn_cp_jld_get_feature_value($settings['feature_pattern'], $product);
    }
    return [$material, $color, $pattern];
}

function fn_cp_jld_get_product_condition($settings, $product)
{
    if (empty($settings['feature_condition'])) {
        return '';
    }
    
    $prefix = 'https://schema.org/';
    
    $condition = '';
    if (!empty($settings['avail_conditions_string'])) {
        $cond_f_id = $settings['feature_condition'];
        $vars_map_c = json_decode($settings['avail_conditions_string'], true);
        if (!empty($product['header_features'][$cond_f_id]['variant_id'])) {
            if (!empty($vars_map_c[$product['header_features'][$cond_f_id]['variant_id']])) {
                $condition = $vars_map_c[$product['header_features'][$cond_f_id]['variant_id']];
            }

        } elseif (!empty($product['product_features'][$cond_f_id]['variant_id'])) {
            if (!empty($vars_map_c[$product['product_features'][$cond_f_id]['variant_id']])) {
                $condition = $vars_map_c[$product['product_features'][$cond_f_id]['variant_id']];
            }
        }
    }
    if (!empty($condition)) {
        return $prefix . $condition;
    } else {
        $condition = fn_cp_jld_get_feature_value($settings['feature_condition'], $product);
    }
    if (empty($condition)) {
        return false;
    }

    $condition == strtolower(trim($condition));
    $condition_value = '';
    switch ($condition) {
        case 'new':
            $condition_value = 'NewCondition';
            break;

        case 'refurbished':
            $condition_value = 'RefurbishedCondition';
            break;

        case 'used':
            $condition_value = 'UsedCondition';
            break;

        case 'damaged':
            $condition_value = 'DamagedCondition';
            break;
    }

    return "{$prefix}{$condition_value}";
}

function fn_cp_jld_get_product_retailer_item_id($settings, $product)
{
    $value = '';
    if (!empty($settings['feature_retailer_item_id'])) {
        if ($settings['feature_retailer_item_id'] == 'use_product_code') {
            $value = $product['product_code'];
        } elseif ($settings['feature_retailer_item_id'] == 'use_product_id') {
            $value = $product['product_id'];
        } else {
            $value = fn_cp_jld_get_feature_value($settings['feature_retailer_item_id'], $product);
        }
    }
    return $value;
}

function fn_cp_jld_get_feature_value($feature_id, $product, $only_value = false)
{
    if (!is_numeric($feature_id)) {
        return '';
    }

    $value = '';
    if (isset($product['header_features']) 
        && isset($product['header_features'][$feature_id])
    ) {
        $feature = $product['header_features'][$feature_id];
        $value = !empty($feature['variant']) ? $feature['variant'] : $feature['value'];

    } elseif (
        isset($product['product_features']) 
        && isset($product['product_features'][$feature_id])
    ) {
        $feature = $product['product_features'][$feature_id];
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

function fn_cp_structured_data_get_product_availability($settings, $product)
{
    $prefix = 'https://schema.org/';
    $availability = '';
    if ($settings['feature_availability'] == 'auto') {
        $availability = 'OutOfStock';
        
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
            $availability = 'InStock';
        }
        if (empty($amount) && !empty($product['out_of_stock_actions']) && $product['out_of_stock_actions'] == 'B') {
            $availability = 'PreOrder';
        }
        
    } else {
        $availability = '';
        if (!empty($settings['avail_vars_string'])) {
            $av_f_id = $settings['feature_availability'];
            $vars_map = json_decode($settings['avail_vars_string'], true);
            if (!empty($product['header_features'][$av_f_id]['variant_id'])) {
                if (!empty($vars_map[$product['header_features'][$av_f_id]['variant_id']])) {
                    $availability = $vars_map[$product['header_features'][$av_f_id]['variant_id']];
                }

            } elseif (!empty($product['product_features'][$av_f_id]['variant_id'])) {
                if (!empty($vars_map[$product['product_features'][$av_f_id]['variant_id']])) {
                    $availability = $vars_map[$product['product_features'][$av_f_id]['variant_id']];
                }
            }
        }
        if (!empty($availability)) {
            return $prefix . $availability;
        } else {
            $availability = fn_cp_jld_get_feature_value($settings['feature_availability'], $product);
        }
        $availability = ucwords(strtolower($availability));
        $availability = str_replace(' ', '', $availability);
    }
    return !empty($availability) ? $prefix . $availability : '';
}

function fn_cp_structured_data_get_product_img($main_pair)
{
    $img_url = !empty($main_pair['detailed']['image_path']) ? $main_pair['detailed']['image_path'] : '';

    return $img_url;
}

function fn_cp_structured_data_get_product_brand($product, $brand_feature_id)
{
    $brand = $brand_icon = '';

    if (!empty($brand_feature_id)) {
        if (isset($product['product_features'][$brand_feature_id])) {
            $brand_data = $product['product_features'][$brand_feature_id];

        } elseif (isset($product['header_features'][$brand_feature_id])) {
            $brand_data = $product['header_features'][$brand_feature_id];
        }

        if (!empty($brand_data)) {
            $selected_variant = isset($brand_data['variant_id']) ? $brand_data['variant_id'] : 0;

            if (isset($brand_data['variants'][$selected_variant])) {
                $variant_data = $brand_data['variants'][$selected_variant];
                $brand = isset($variant_data['variant']) ? $variant_data['variant'] : '';

                if (isset($variant_data['image_pair'])) {
                    $icon_data = isset($variant_data['image_pair']['icon']) ? $variant_data['image_pair']['icon'] : '';
                } elseif (isset($variant_data['image_pairs'])) {
                    $icon_data = isset($variant_data['image_pairs']['icon']) ? $variant_data['image_pairs']['icon'] : '';
                }

                $brand_icon = isset($icon_data['image_path']) ? $icon_data['image_path'] : '';
            }
        }
    }

    return [$brand, $brand_icon];
}

function fn_cp_json_ld_remove_empty_values($data)
{
    return array_filter($data, function($value) { return trim($value) !== ''; });
}

function fn_cp_json_ld_add_page_markup($controller, $mode, $company_id = 0, $params = [])
{
    $json_markups = [];
    $settings = Registry::get('addons.cp_json_ld');

    $allow_markups = fn_get_schema('cp_json_ld', 'markups');

    $current_objects = !empty($allow_markups['all']) ? $allow_markups['all'] : [];
    if (!empty($allow_markups[$controller][$mode])) {
        $current_objects = array_merge($current_objects, $allow_markups[$controller][$mode]);
        $current_objects = array_unique($current_objects);
    }
    if (empty($current_objects)) {
        return;
    }

    $markup_objects = fn_get_schema('cp_json_ld', 'markup_objects');
    foreach ($current_objects as $current_object) {
        if (empty($markup_objects[$current_object])) {
            continue;
        }

        $object = $markup_objects[$current_object];

        $obj_data = [];
        if (!empty($object['get_function']) && function_exists($object['get_function'])) {
            $obj_data = call_user_func($object['get_function'], $params);
        }
        if (!empty($obj_data) || !empty($object['allow_empty'])) {
            $json_markups[$current_object]['content'] = fn_cp_json_ld_get_data($object['type'], $obj_data, $settings, $company_id);
            $json_markups[$current_object]['extra'] = !empty($object['extra']) ? $object['extra'] : [];
        } elseif (!empty($object['add_if_empty'])) {
            $emp_content = !empty($object['add_if_empty']['content']) ? $object['add_if_empty']['content'] : '';
            if (!empty($emp_content)) {
                $to_field = !empty($object['add_if_empty']['no_format']) ? 'alt_content' : 'content';
                $json_markups[$current_object][$to_field] = $emp_content;
            }
        }
    }
    
    Tygh::$app['view']->assign('cp_json_ld_markups', $json_markups);
}

function fn_cp_json_ld_get_data($obj, $obj_data = [], $settings = [], $company_id = 0)
{
    $data = [];
    $settings = !empty($settings) ? $settings : Registry::get('addons.cp_json_ld');

    fn_set_hook('cp_json_ld_get_data_pre', $obj, $obj_data, $settings, $company_id);

    switch ($obj) {
        case 'company':
            if (function_exists('___cp')) {
                $cpv2 = ___cp('Y29tcGFueV9uYW1l');
                if (!empty($settings['store_type'])) {
                    $data = [
                        '@context'  => 'https://schema.org',
                        '@type'     => $settings['store_type'],
                        'url'       => fn_url('', 'C'),
                        'name'      => !empty($settings[$cpv2]) ? $settings[$cpv2] : $obj_data[$cpv2],
                        'image'     => isset($obj_data['logo']) ? $obj_data['logo'] : '',
                    ];
                    if (!empty($settings['currencies_accepted'])) {
                        $data['currenciesAccepted'] = $settings['currencies_accepted'];
                    }
                    if (!empty($settings['opening_hours'])) {
                        $data['openingHours'] = $settings['opening_hours'];
                    }
                    if (!empty($settings['payment_accepted'])) {
                        $data['paymentAccepted'] = $settings['payment_accepted'];
                    }
                } else {
                    $data = [
                        '@context'  => 'https://schema.org',
                        '@type'     => 'Organization',
                        'url'       => fn_url('', 'C'),
                        'name'      => !empty($settings[$cpv2]) ? $settings[$cpv2] : $obj_data[$cpv2],
                        'logo'      => isset($obj_data['logo']) ? $obj_data['logo'] : ''
                    ];
                }
            }
            if (empty($data)) {
                return false;
            }
            if (Registry::get('addons.discussion.status') == 'A' && !empty($settings['use_rating']) && $settings['use_rating'] == 'Y') {
                $testimonials = fn_get_discussion(0, 'E', true, ['avail_only' => true]);
                if (!empty($testimonials['average_rating']) && !empty($testimonials['search']['cp_json_ld_total_items'])) {
                    
                    $data['aggregateRating'] = [
                        '@type'         => 'AggregateRating',
                        'ratingValue'   => $testimonials['average_rating'],
                        'reviewCount'   => $testimonials['search']['cp_json_ld_total_items'],
                        'bestRating'    => 5,
                        'worstRating'   => 1
                    ];
                }
            }
            if (isset($settings['use_phone']) && $settings['use_phone'] == 'Y') {
                $contacts = [];
                if (!empty($obj_data['company_phone'])) {
                    $contacts[] = [
                        '@type'         => 'ContactPoint',
                        'telephone'     => $obj_data['company_phone'],
                        'contactType'   => 'customer service'
                    ];
                }
                if (!empty($obj_data['company_phone_2'])) {
                    $contacts[] = [
                        '@type'         => 'ContactPoint',
                        'telephone'     => $obj_data['company_phone_2'],
                        'contactType'   => 'customer service'
                    ];
                }
                if (!empty($contacts)) {
                    $data['contactPoint'] = $contacts;
                }
            }

            if ((isset($settings['use_address']) && $settings['use_address'] == 'Y') || !empty($settings['store_type'])) {
                $address_data = [
                    '@type'             => 'PostalAddress',
                    'streetAddress'     => $obj_data['company_address'],
                    'addressLocality'   => $obj_data['company_city'],
                    'addressRegion'     => $obj_data['company_state'],
                    'postalCode'        => $obj_data['company_zipcode'],
                    'addressCountry'    => $obj_data['company_country']
                ];

                $address_data = fn_cp_json_ld_remove_empty_values($address_data);

                $data['address'] = $address_data;
            }

            $company_description_data = fn_cp_json_ld_get_company_descr($company_id, CART_LANGUAGE);

            if (!empty($company_description_data['cp_description'])) {
                $data['description'] = $company_description_data['cp_description'];
            }

            if (!empty($company_description_data['cp_socials'])) {
                $social_list = explode(',', $company_description_data['cp_socials']);
                $social_list = fn_cp_json_ld_remove_empty_values($social_list);

                if (!empty($social_list)){
                    $data['sameAs'] = array_values($social_list);
                }
            }

            break;

        case 'blog':
            
            if (empty($obj_data['type']) || empty($obj_data['name']) || empty($obj_data['url'])) {
                break;
            }
            $description = '';
            if (!empty($obj_data['description'])) {
                $description = $obj_data['description'];
            }
            $description = trim(preg_replace('/\s\s+/', ' ', $description)); //remove newline(there was problem with yandex webmaster)

            if ($obj_data['type'] == 'blog') {
                $data = [
                    '@context'      => 'https://schema.org',
                    '@type'         => 'Blog',
                    'name'          => $obj_data['name'],
                    'description'   => strip_tags($description),
                    'url'           => $obj_data['url']
                ];
            } elseif ($obj_data['type'] == 'article') {
                $data = [
                    '@context'  => 'https://schema.org',
                    '@type'     => 'Article',
                    'mainEntityOfPage' => [
                        '@type' => 'WebPage',
                        '@id'   => $obj_data['url']
                    ],
                    'headline'  => $obj_data['name'],
                    'description' => strip_tags($description),
                    'image' => !empty($obj_data['image']) ? $obj_data['image'] : '',
                    'datePublished' => !empty($obj_data['date_published']) ? $obj_data['date_published'] : '',
                    'dateModified' => !empty($obj_data['date_modified']) ? $obj_data['date_modified'] : '',
                    'author' => [
                        '@type' => 'Person',
                        'name'  => isset($obj_data['author']) ? $obj_data['author'] : ''
                    ]
                ];
            } else {
                break;
            }

            $data['publisher'] = [
                '@type' => 'Organization',
                'name'  => !empty($obj_data['publisher_data']['name']) ? $obj_data['publisher_data']['name'] : '',
                'logo'  => [
                    '@type' => 'ImageObject',
                    'url'   => isset($obj_data['publisher_data']['logo']) ? $obj_data['publisher_data']['logo'] : ''
                ]
            ];
            break;
        case 'product':

            // Prepare data for schema.org product markup
            
            $availability = fn_cp_structured_data_get_product_availability($settings, $obj_data);

            $price = 0;
            if (!empty($obj_data['price'])) {
                $price = fn_format_price((float)$obj_data['price']);
            }

            $description = '';
            if (!empty($obj_data['full_description'])) {
                $description = $obj_data['full_description'];
            } elseif (!empty($obj_data['short_description'])) {
                $description = $obj_data['short_description'];
            }

            $description = trim(preg_replace('/\s\s+/', ' ', $description)); //remove newline(there was problem with yandex webmaster)

            $brand_feature_id = isset($settings['feature_brand']) ? $settings['feature_brand'] : false;
            list($brand, $brand_icon) = fn_cp_structured_data_get_product_brand($obj_data, $brand_feature_id);

            $global_ids = fn_cp_get_global_id_values($settings, $obj_data);
            $condition = fn_cp_jld_get_product_condition($settings, $obj_data);
            
            list($material, $color, $pattern) = fn_cp_jld_get_more_features($settings, $obj_data);
            
            $valid_price_period = $settings['price_valid_period'];
            $price_valid_until = '';

            if (trim($valid_price_period) !== '') {
                $price_valid_until = date("c", time() + intval($valid_price_period) * SECONDS_IN_DAY);
            }

            $data = [];
            if (function_exists('___cp')) {
                $cpv3 = ___cp('UHJvZHVjdA');
                $cpv4 = ___cp('bWFpbl9wYWly');
                $data = [
                    '@context'      => 'https://schema.org/',
                    '@type'         => $cpv3,
                    'name'          => isset($obj_data['product']) ? strip_tags($obj_data['product']) : '',
                    'image'         => isset($obj_data[$cpv4]) ? call_user_func(___cp('Zm5fY3Bfc3RydWX0dPJlZF9kYPRhP2dldF9wcm9kdWX0P2ltZw'), $obj_data[$cpv4]) : '',
                    'description'   => strip_tags($description),
                    'sku'           => !empty($obj_data['product_code']) ? $obj_data['product_code'] : ''
                ];
                if ($material) {
                    $data['material']  = $material;
                }
                if ($color) {
                    $data['color']  = $color;
                }
                if ($pattern) {
                    $data['pattern']  = $pattern;
                }
            } else {
                break;
            }

            $retailer_item_id = fn_cp_jld_get_product_retailer_item_id($settings, $obj_data);
            if (!empty($retailer_item_id)) {
                $data['productID'] = $retailer_item_id;
            }

            if (!empty($brand)) {
                $data['brand'] = [
                    '@type'=> 'Brand',
                    'name' => $brand,
                    'logo' => $brand_icon
                ];
            }

            if (!empty($global_ids)) {
                foreach ($global_ids as $g_id => $g_data) {
                    $data[$g_id] = $g_data;
                }
            }

            $auth = Tygh::$app['session']['auth'];
            $show_price = !empty($auth['user_id']) || Registry::get('settings.General.allow_anonymous_shopping') != 'hide_price_and_add_to_cart';

            if ($show_price) {
                $offers = [
                    '@type'             => 'Offer',
                    'url'               => fn_url('products.view&product_id=' . $obj_data['product_id'], 'C'),
                    'priceCurrency'     => CART_PRIMARY_CURRENCY,
                    'price'             => $price,
                    'priceValidUntil'   => $price_valid_until,
                    'availability'      => $availability,
                    'seller'            => [
                        '@type' => 'Organization',
                        'name'  => isset($obj_data['company_name']) ? $obj_data['company_name'] : ''
                    ]
                ];
                
                $agregate_prices = $agregate_offers = [];
                if (!empty($obj_data['prices'])) { // qty discounts
                    $agregate_prices[] = $price;
                    foreach ($obj_data['prices'] as $p_price) {
                        $agregate_prices[] = !empty($p_price['percentage_discount'])
                            ? fn_format_price((1 - $p_price['percentage_discount'] / 100) * $price)
                            : $p_price['price'];
                    }
                }

                if (Registry::get('addons.product_variations.status') == 'A' // variations
                    && !empty($obj_data['variation_features'])
                    && !empty($obj_data['variation_features_variants'])
                ) {
                    foreach ($obj_data['variation_features'] as $v_feature_id => $v_feature) {
                        if ($v_feature['purpose'] != 'group_variation_catalog_item'
                            || empty($obj_data['variation_features_variants'][$v_feature_id]['variants'])
                        ) {
                            continue;
                        }
                        foreach ($obj_data['variation_features_variants'][$v_feature_id]['variants'] as $v_variant) {
                            if (empty($v_variant['product']['product_id'])) {
                                continue;
                            }
                            
                            $agregate_prices[] = fn_get_product_price($v_variant['product']['product_id'], 1, $auth);
                            $agregate_offers[] = fn_url('products.view?product_id=' . $v_variant['product']['product_id'], 'C');
                        }
                    }
                }
                
                if (!empty($agregate_prices)) {
                    $offers['@type'] = 'AggregateOffer';
                    $offers['highPrice'] = max($agregate_prices);
                    $offers['lowPrice'] = min($agregate_prices);
                    $offers['offerCount'] = count($agregate_prices);

                    if (!empty($agregate_offers)) {
                        foreach ($agregate_offers as $offer_url) {
                            $offers['offers'][] = [
                                '@type' => 'Offer',
                                'url'   => $offer_url
                            ];
                        }
                    }
                }

                if ($condition) {
                    $offers['itemCondition'] = $condition;
                }
                $data['offers'] = $offers;
            }
            $prod_rev_def = Registry::get('addons.product_reviews');
            if (empty($obj_data['product_reviews']) && !empty($obj_data['product_reviews_count']) && !empty($prod_rev_def['status']) && $prod_rev_def['status'] == 'A') {
                $search_params = [
                    'product_id'     => (int) $obj_data['product_id'],
                    'status'         => ObjectStatuses::ACTIVE,
                    'storefront_id'  => fn_product_reviews_get_storefront_id_by_setting(),
                    'items_per_page' => (int) $prod_rev_def['reviews_per_page']
                ];

                $product_reviews_repository = ProductReviewsProvider::getProductReviewRepository();
                $service = ProductReviewsProvider::getService();

                list($product_reviews, ) = $product_reviews_repository->find($search_params);
                if (!empty($product_reviews)) {
                    $obj_data['product_reviews'] = $product_reviews;
                    $obj_data['product_reviews_rating_stats'] = $service->getProductRatingStats(
                        $obj_data['product_id'],
                        $search_params['storefront_id']
                    );
                }
            }
            if (isset($obj_data['product_reviews']) && !empty($obj_data['product_reviews_rating_stats']['total'])) {
                $aggregate_rating = [
                    '@type'         => 'AggregateRating',
                    'ratingValue'   => $obj_data['average_rating'],
                    'reviewCount'   => $obj_data['product_reviews_rating_stats']['total'],
                    'bestRating'    => 5,
                    'worstRating'   => 1
                ];

                $data['aggregateRating'] = $aggregate_rating;
                $reviews_data = [];
                $posts = array_slice($obj_data['product_reviews'], 0, $settings['review_qty']);

                foreach ($obj_data['product_reviews'] as $post) {
                    if (!$post['rating_value'] || empty($post['user_data']['name'])) {
                        continue;
                    }
                    $cur_review = [
                        '@type'         => 'Review',
                        'reviewRating'  => [
                            '@type'         => 'Rating',
                            'ratingValue'   => isset($post['rating_value']) ? $post['rating_value'] : '',
                            'bestRating'    => 5,
                        ],
                        'datePublished' => date("c", $post['product_review_timestamp']),
                        'reviewBody'    => trim(preg_replace('/\s\s+/', ' ', $post['message']['comment'])),
                        'author'        => [
                            '@type' => 'Person',
                            'name'  => $post['user_data']['name']
                        ]
                    ];
                    if (!empty($post['message']['advantages'])) {
                        $cur_review['positiveNotes'] = [
                            '@type'             => 'ItemList',
                            'itemListElement'   => [
                                '@type'     => 'ListItem',
                                'position'  => 1,
                                'name'      => $post['message']['advantages']
                            ]
                        ];
                    }
                    if (!empty($post['message']['disadvantages'])) {
                        $cur_review['negativeNotes'] = [
                            '@type'             => 'ItemList',
                            'itemListElement'   => [
                                '@type'     => 'ListItem',
                                'position'  => 1,
                                'name'      => $post['message']['disadvantages']
                            ]
                        ];
                    }
                    $reviews_data[] = $cur_review;
                }

                $data['review'] = $reviews_data;
                
            } elseif (isset($obj_data['discussion']) && !empty($obj_data['discussion']['search']['cp_json_ld_total_items']) && !empty($obj_data['discussion']['average_rating'])) {
                $discussion = $obj_data['discussion'];
                $review_qty = $discussion['search']['cp_json_ld_total_items'];

                $aggregate_rating = [
                    '@type'         => 'AggregateRating',
                    'ratingValue'   => $discussion['average_rating'],
                    'reviewCount'   => $review_qty,
                    'bestRating'    => 5,
                    'worstRating'   => 1
                ];

                $data['aggregateRating'] = $aggregate_rating;
                if (!empty($discussion['posts']) && !empty($settings['review_qty'])) {
                    $reviews_data = [];
                    $posts = array_slice($discussion['posts'], 0, $settings['review_qty']);

                    foreach ($posts as $post) {
                        if (!$post['rating_value']) {
                            continue;
                        }
                        $cur_review = [
                            '@type'         => 'Review',
                            'reviewRating'  => [
                                '@type'         => 'Rating',
                                'ratingValue'   => isset($post['rating_value']) ? $post['rating_value'] : '',
                                'bestRating'    => 5,
                            ],
                            'datePublished' => date("c", $post['timestamp']),
                            'reviewBody'    => trim(preg_replace('/\s\s+/', ' ', $post['message'])),
                            'author'        => [
                                '@type' => 'Person',
                                'name'  => $post['name']
                            ]
                        ];
                        if (!empty($post['cp_pr_advantages'])) {
                            $cur_review['positiveNotes'] = [
                                '@type'             => 'ItemList',
                                'itemListElement'   => [
                                    '@type'     => 'ListItem',
                                    'position'  => 1,
                                    'name'      => $post['cp_pr_advantages']
                                ]
                            ];
                        }
                        if (!empty($post['cp_pr_disadvantages'])) {
                            $cur_review['negativeNotes'] = [
                                '@type'             => 'ItemList',
                                'itemListElement'   => [
                                    '@type'     => 'ListItem',
                                    'position'  => 1,
                                    'name'      => $post['cp_pr_disadvantages']
                                ]
                            ];
                        }
                        $reviews_data[] = $cur_review;
                    }

                    $data['review'] = $reviews_data;
                }
            }
            break;

        case 'search':

            if (empty($obj_data['url'])) {
                break;
            }

            $data = [
                '@context'  => 'https://schema.org',
                '@type'     => 'WebSite',
                'url'       => $obj_data['url'],
                'potentialAction' => [
                    [
                        '@type'         => 'SearchAction',
                        'target'        => fn_url('products.search?search_performed=Y') . '&q={search_term_string}',
                        'query-input'   => 'required name=search_term_string',
                    ]
                ]
            ];
            break;

        case 'breadcrumbs':

            if (empty($obj_data['breadcrumbs'])) {
                break;
            }

            $data = array(
                '@context' => 'https://schema.org',
                '@type' => 'BreadcrumbList'
            );

            foreach ($obj_data['breadcrumbs'] as $key => $bc) {
                $data['itemListElement'][] = array(
                    '@type' => 'ListItem',
                    'position' => !empty($bc['position']) ? $bc['position'] : $key + 1,
                    'name' => !empty($bc['name']) ? $bc['name'] : '',
                    'item' => !empty($bc['url']) ? $bc['url'] : ''
                );
            }
            break;

        case 'faq':

            if (empty($obj_data['questions'])) {
                break;
            }

            $data = [
                '@context'  => 'https://schema.org/',
                '@type'     => 'FAQPage'
            ];

            foreach ($obj_data['questions'] as $question) {
                if (empty($question['question']) || empty($question['answer'])) {
                    continue;
                }
                $data['mainEntity'][] = [
                    '@type' => 'Question',
                    'name'  => $question['question'],
                    'acceptedAnswer' => [
                        '@type' => 'Answer',
                        'text'  => $question['answer']
                    ]
                ];
            }
            break;

        case 'video':

            if (empty($obj_data['name'])) {
                break;
            }

            $data = [
                '@context'      => 'https://schema.org/',
                '@type'         => 'VideoObject',
                'name'          => $obj_data['name'],
                'description'   => !empty($obj_data['description']) ? $obj_data['description'] : '',
                'thumbnailUrl'  => !empty($obj_data['thumbnailUrl']) ? $obj_data['thumbnailUrl'] : [],
                'uploadDate'    => !empty($obj_data['uploadDate']) ? $obj_data['uploadDate'] : ''
            ];

            $optional_props = ['duration', 'contentUrl', 'embedUrl', 'expires', 'hasPart', 'interactionStatistic'];
            foreach ($optional_props as $property) {
                if (empty($obj_data[$property])) {
                    continue;
                }
                $data[$property] = $obj_data[$property];
            }
            
            break;

        default:
            break;
    }
    
    fn_set_hook('cp_json_ld_get_data_post', $data, $obj, $obj_data, $settings, $company_id);

    return !empty($data) ? json_encode($data) : '';
}

function fn_cp_jld_update_company_description($company_data, $company_id, $lang_code = DESCR_SL)
{
    $company_data['company_id'] = $company_id;
    $company_data['lang_code'] = $lang_code;

    db_query("REPLACE INTO ?:cp_json_ld_company_descriptions ?e", $company_data);
    return true;
}

function fn_cp_json_ld_get_company_descr($company_id, $lang_code = DESCR_SL)
{
    static $init_cache = false;

    $cache_name = 'cp_json_ld_list_cache_static';
    $condition = array('cp_json_ld_company_descriptions');

    if (!$init_cache) {
        Registry::registerCache($cache_name, $condition, Registry::cacheLevel('static'), true);
        $init_cache = true;
    }

    $company_data = Registry::get($cache_name . '.' . $company_id . CART_LANGUAGE);

    if (empty($company_data)) {
        $company_data = fn_cp_json_ld_get_company_data($company_id, $lang_code);

        Registry::set($cache_name . '.' . $company_id . CART_LANGUAGE, $company_data);
    }

    return $company_data;
}

function fn_cp_json_ld_get_company_data($company_id, $lang_code = DESCR_SL)
{
    $company_data = db_get_row(
        "SELECT cp_description, cp_socials FROM ?:cp_json_ld_company_descriptions WHERE company_id = ?i AND lang_code = ?s",
        $company_id, $lang_code
    );

    return $company_data;
}

//
// Hooks
//

function fn_cp_json_ld_dispatch_before_display()
{
    if (AREA != 'C') {
        return;
    }

    $controller = Registry::get('runtime.controller');
    $mode = Registry::get('runtime.mode');
    $company_id = Registry::get('runtime.company_id');
    $params = $_REQUEST;

    fn_cp_json_ld_add_page_markup($controller, $mode, $company_id, $params);

    // Disable seo add-on markup
    $seo_markup = Tygh::$app['view']->getTemplateVars('schema_org_markup_items');
    if (!empty($seo_markup)) {
        Tygh::$app['view']->assign('schema_org_markup_items', []);
    }
}

function fn_cp_json_ld_get_discussion_posts(&$params, $items_per_page, $fields, $join, $condition, $order_by, $limit)
{
    if (empty($params['total_items'])){
        $params['cp_json_ld_total_items'] = db_get_field("SELECT COUNT(*) FROM ?:discussion_posts $join WHERE $condition");
    } else {
        $params['cp_json_ld_total_items'] = $params['total_items'];
    }
}

function fn_cp_json_ld_get_discussion_post($object_id, $object_type, $get_posts, $params, &$discussion)
{
    if (!$get_posts && isset($params['from_prod_tab'])) {
        $discussion['search']['cp_json_ld_total_items'] = empty($discussion['search']['cp_json_ld_total_items']) ? $discussion['search']['total_items'] : $discussion['search']['cp_json_ld_total_items'];
    }
}

//
// addon.xml funcs
//

function fn_update_cp_json_ld_priviliges()
{
    if (version_compare(PRODUCT_VERSION, '4.10', '>=')) {
        $privileges = array('manage_cp_extended_catalog', 'view_cp_json_ld_company');
        db_query('UPDATE ?:privileges SET group_id = ?s WHERE privilege IN (?a)', 'cp_json_ld', $privileges);
        db_query('UPDATE ?:privileges SET is_view = ?s WHERE privilege = ?s', 'Y', 'view_cp_json_ld_company');
    }

    return true;
}

function fn_cp_json_ld_business_info()
{
    $hint = __('cp_json_ld.local_business_info');
    return $hint;
}

function fn_cp_json_ld_get_conditions_variants()
{
    $hint = '';
    $addon_settings = Registry::get('addons.cp_json_ld');
    $parced_vars = [];
    if (!empty($addon_settings['avail_conditions_string'])) {
        $parced_vars = json_decode($addon_settings['avail_conditions_string'], true);
    }
    if (!empty($addon_settings['feature_condition'])) {
        $f_vars = db_get_hash_array("SELECT pfv.variant_id, pfvd.variant FROM ?:product_feature_variants as pfv
            LEFT JOIN ?:product_feature_variant_descriptions as pfvd ON pfvd.variant_id = pfv.variant_id AND pfvd.lang_code = ?s
            WHERE pfv.feature_id = ?i", 'variant_id', CART_LANGUAGE, $addon_settings['feature_condition']
        );
        if (!empty($f_vars)) {
            $avail_opt = ['DamagedCondition','NewCondition','RefurbishedCondition','UsedCondition'];
            
            $hint .= '<div id="container_addon_option_cp_json_ld_feature_condition_vars" class="control-group setting-wide  cp_json_ld">
                        <label for="container_addon_option_cp_json_ld_feature_condition_vars" class="control-label ">' . __('cp_json_condition_mapping') . ':
                        <div class="muted description">' . __('cp_json_condition_mapping_descr') . '</div></label><div class="controls">';
        
            foreach($f_vars as $v_data) {
                $sel_options = '';
                foreach($avail_opt as $s_opt) {
                    $selected= '';
                    if (!empty($parced_vars[$v_data['variant_id']]) && $parced_vars[$v_data['variant_id']] == $s_opt) {
                        $selected .= 'selected="selected"';
                    }
                    $sel_options .= '<option value="' . $s_opt . '" ' . $selected . ' >' . $s_opt . '</option>';
                }
                $hint .= '<div><div>' . $v_data['variant']  .':</div>
                <select name="addon_data[cond_vars][' . $v_data['variant_id'] . ']">' . $sel_options . '</select>
                </div>';
            }
            $hint .= '</div></div>';
        }
    }
    return $hint;
}

function fn_cp_json_ld_get_availability_vars()
{
    $hint = '';
    $addon_settings = Registry::get('addons.cp_json_ld');
    $parced_vars = [];
    if (!empty($addon_settings['avail_vars_string'])) {
        $parced_vars = json_decode($addon_settings['avail_vars_string'], true);
    }
    if (!empty($addon_settings['feature_availability']) && $addon_settings['feature_availability'] != 'auto') {
        $f_vars = db_get_hash_array("SELECT pfv.variant_id, pfvd.variant FROM ?:product_feature_variants as pfv
            LEFT JOIN ?:product_feature_variant_descriptions as pfvd ON pfvd.variant_id = pfv.variant_id AND pfvd.lang_code = ?s
            WHERE pfv.feature_id = ?i", 'variant_id', CART_LANGUAGE, $addon_settings['feature_availability']
        );
        if (!empty($f_vars)) {
            $avail_opt = ['BackOrder','Discontinued','InStock','InStoreOnly','LimitedAvailability','OnlineOnly','OutOfStock','PreOrder','PreSale','SoldOut'];
            
            $hint .= '<div id="container_addon_option_cp_json_ld_feature_availability_vars" class="control-group setting-wide  cp_json_ld">
                        <label for="container_addon_option_cp_json_ld_feature_availability_vars" class="control-label ">' . __('cp_json_avalability_mapping') . ':
                        <div class="muted description">' . __('cp_json_avalability_mapping_descr') . '</div></label><div class="controls">';
        
            foreach($f_vars as $v_data) {
                $sel_options = '';
                foreach($avail_opt as $s_opt) {
                    $selected= '';
                    if (!empty($parced_vars[$v_data['variant_id']]) && $parced_vars[$v_data['variant_id']] == $s_opt) {
                        $selected .= 'selected="selected"';
                    }
                    $sel_options .= '<option value="' . $s_opt . '" ' . $selected . ' >' . $s_opt . '</option>';
                }
                $hint .= '<div><div>' . $v_data['variant']  .':</div>
                <select name="addon_data[avail_vars][' . $v_data['variant_id'] . ']">' . $sel_options . '</select>
                </div>';
            }
            $hint .= '</div></div>';
        }
    }
    return $hint;
}
