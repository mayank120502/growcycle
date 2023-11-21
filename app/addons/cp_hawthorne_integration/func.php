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

use Tygh\Enum\YesNo;
use Tygh\Registry;
use Tygh\Http;
use Tygh\Enum\ObjectStatuses;
use Tygh\Addons\MasterProducts\ServiceProvider;
use Tygh\Settings;

/**
 * Get information about data imported from Hawthorne
 *
 * @return array
 */
function fn_cp_hawthorne_imported() {
    $hawthorne['total'] = db_get_field("SELECT COUNT(*) FROM ?:cp_hawthorne_import");
    if ($hawthorne['total']) {
        $hawthorne['processed'] = db_get_field("SELECT COUNT(*) FROM ?:cp_hawthorne_import WHERE detailed = ?s", YesNo::YES);
    }
    return $hawthorne;
}

/**
 * Get Hawthorne token
 *
 * @return array
 */
function fn_cp_hawthorne_get_token() {
    
    if (isset(Tygh::$app['session']['hawthorne_token'])) {
        if (Tygh::$app['session']['hawthorne_token']['valid_till'] > TIME) {
            $token = Tygh::$app['session']['hawthorne_token']['token'];
        } else {
            unset(Tygh::$app['session']['hawthorne_token']);
            $token = fn_cp_hawthorne_authorization();
        }
    } else {
        $token = fn_cp_hawthorne_authorization();
    }

    return $token;
}

/**
 * Authorization at Hawthorne
 *
 * @return array
 */
function fn_cp_hawthorne_authorization() {
    $token = false;
    $hawthorne_settings = Registry::get('addons.cp_hawthorne_integration');
    $auth_request = [
        'client_id' => $hawthorne_settings['client_id'],
        'client_secret' => $hawthorne_settings['client_secret'],
        'grant_type' => 'client_credentials'
    ];
    $request_url = HAWTHORNE_API_URL . HAWTHORNE_AUTH_PATH;

    $request_result = Http::post($request_url, $auth_request, []);
    $request_result = json_decode($request_result, true);
    if (isset($request_result['access_token'])) {
        $token = $request_result['access_token'];
        $valid_till = isset($request_result['expires_in']) ? TIME + $request_result['expires_in'] : TIME + HAWTHORNE_EXPIRATION_TIME;
        Tygh::$app['session']['hawthorne_token'] = [
            'token' => $token,
            'valid_till' => $valid_till
        ];
    } else {
        $message = isset($request_result['Message']) ? $request_result['Message'] : __("cp_hawthorne_authorization_failed");
        fn_set_notification('E', __('error'), $message);
    }

    return $token;
}

/**
 * Get the list of products from Hawthorne
 *
 * @return boolean
 */
function fn_cp_hawthorne_import_products()
{
    $return = false;
    $token = fn_cp_hawthorne_get_token();
    
    if ($token) {
        $request_url = HAWTHORNE_API_URL . HAWTHORNE_IMPORT_PATH . "?PartType=All&DealerPricing=true";
        $extra['headers'] = [
            'Authorization: Bearer ' . $token
        ];
        $request_result = Http::get($request_url, [], $extra);
        $request_result = json_decode($request_result, true);
        db_query('TRUNCATE ?:cp_hawthorne_import');
        $show_progress = Registry::get('runtime.mode') == 'update_by_cron' ? false : true;
        if (isset($request_result['Success']) && $request_result['Success'] && !empty($request_result['Data'])) {
            $import_data = [];
            if ($show_progress) {
                fn_set_progress('import', __("importing_data"), $show_progress);
            }
            foreach ($request_result['Data'] as $hawthorne_product) {
                if (isset($hawthorne_product['Id'])) {
                    if ($show_progress) {
                        fn_set_progress('echo', $hawthorne_product['Id'], $show_progress);
                    }
                    $import_data[] = [
                        'part_id' => $hawthorne_product['Id'],
                        'main' => json_encode($hawthorne_product),
                        'detailed' => YesNo::NO
                    ];
                }
            }

            for ($i=0; $i<=count($import_data); $i+=HAWTHORNE_IMPORT_LIMIT) {
                $reduced_data = array_slice($import_data, $i, HAWTHORNE_IMPORT_LIMIT, true);
                db_replace_into('cp_hawthorne_import', $reduced_data, true);
            }
            $return = true;
        } else {
            $message = isset($request_result['Message']) ? $request_result['Message'] : __("cp_hawthorne_import_failed");
            fn_set_notification('E', __('error'), $message);
        }
    }
    return $return;
}

/**
 * Parse data saved in cp_hawthorne_import table to create/update products
 * If "master_products" is active - created products must be common, selected vendor gets usage of common products
 * 
 * @return array
 */
function fn_cp_hawthorne_process_products()
{
    $return = [];
    $hawthorne_data = db_get_array('SELECT * FROM ?:cp_hawthorne_import WHERE detailed = ?s', YesNo::NO);
    $hawthorne_schema = fn_get_schema('hawthorne', 'products');
    $use_master_products = Registry::get('addons.master_products.status') == ObjectStatuses::ACTIVE;
    if ($use_master_products) {
        $service = ServiceProvider::getService();
    }
    $hawthorne_company_id = Registry::get('addons.cp_hawthorne_integration.company_id');
    $path_to_files = $hawthorne_company_id ? $hawthorne_company_id . '/exim/backup/images/' : 'exim/backup/images/';

    fn_set_progress('import', __("processing"));
    foreach ($hawthorne_data as $data) {
        
        $unparsed = json_decode($data['main'], true);
        foreach ($hawthorne_schema as $hawthorne => $cscart) {
            if (isset($unparsed[$hawthorne])) {
                if ($hawthorne == HAWTHORNE_PARSING_CATEGORY_FIELD) {
                    $product_data['category_ids'][] = fn_cp_hawthorne_get_category_id($unparsed[$hawthorne]);
                } else {
                    $product_data[$cscart] = $unparsed[$hawthorne];
                }
            }
        }
        if (isset($product_data[HAWTHORNE_PARSING_WEIGHT_FIELD]) && isset($product_data['weight_unit_code'])) {
            $product_data[HAWTHORNE_PARSING_WEIGHT_FIELD] = fn_cp_hawthorne_convert_weight($product_data[HAWTHORNE_PARSING_WEIGHT_FIELD], $product_data['weight_unit_code']);
        }
        fn_set_progress('echo', $product_data['product']);
        if ($use_master_products) {
            $product_data['company_id'] = '0';
        } else {
            $product_data['company_id'] = $hawthorne_company_id;
        }
        if (!empty($product_data['price'])) {
            $product_data['old_hawthorne_price'] = $product_data['price'];
            $product_data['price'] = fn_cp_hawthorne_recalculate_price($product_data['price']);
        }

        $existing_product_id = fn_cp_hawthorne_get_product_id_by_code($product_data['product_code'], $product_data['company_id']);
        if (!$existing_product_id) {
            if ($product_id = fn_update_product($product_data)) {
                if (!empty($product_data['image_file'])) {
                    $image_name = stripslashes($product_data['image_file']);
                    fn_exim_import_images($path_to_files, $image_name, $image_name, '0', 'M', $product_id, 'product');
                }
                if ($use_master_products) {
                    $service->createVendorProduct($product_id, $hawthorne_company_id);
                }
                $return[] = $product_id;
            }
        }
        db_query('UPDATE ?:cp_hawthorne_import SET detailed = ?s WHERE id = ?i', YesNo::YES, $data['id']);
        unset($product_data);

        $import_category_id  = Registry::get('addons.cp_hawthorne_integration.import_category_id');
        fn_update_product_count([$import_category_id]);
    }
    return count($return);
}

/**
 * Parse data saved in cp_hawthorne_import table and update amount in stock and prices
 * 
 * @return void
 */
function fn_cp_hawthorne_update_products($action = '')
{
    $hawthorne_data = db_get_array('SELECT * FROM ?:cp_hawthorne_import WHERE detailed = ?s', YesNo::NO);
    $hawthorne_schema = fn_get_schema('hawthorne', 'products');
    $use_master_products = Registry::get('addons.master_products.status') == ObjectStatuses::ACTIVE;
    $update_detailed = $update_old_hawthorne_price = $reindex_product_ids = [];
    $hawthorne_company_id = Registry::get('addons.cp_hawthorne_integration.company_id');
    foreach ($hawthorne_data as $data) {
        
        $unparsed = json_decode($data['main'], true);
        foreach ($hawthorne_schema as $hawthorne => $cscart) {
            if (isset($unparsed[$hawthorne])) {
                if ($hawthorne == HAWTHORNE_PARSING_CATEGORY_FIELD) {
                    $product_data['category_ids'][] = fn_cp_hawthorne_get_category_id($unparsed[$hawthorne]);
                } else {
                    $product_data[$cscart] = $unparsed[$hawthorne];
                }
            }
        }
        if (isset($product_data[HAWTHORNE_PARSING_WEIGHT_FIELD]) && isset($product_data['weight_unit_code'])) {
            $product_data[HAWTHORNE_PARSING_WEIGHT_FIELD] = fn_cp_hawthorne_convert_weight($product_data[HAWTHORNE_PARSING_WEIGHT_FIELD], $product_data['weight_unit_code']);
        } else {
            $product_data[HAWTHORNE_PARSING_WEIGHT_FIELD] = 0;
        }
        if (!empty($product_data['price'])) {
            $product_data['new_hawthorne_price'] = $product_data['price'];
            $product_data['price'] = fn_cp_hawthorne_recalculate_price($product_data['price']);
        }
        if (isset($product_data['product_code'])) {
            $existing_product_id = fn_cp_hawthorne_get_product_id_by_code($product_data['product_code'], $hawthorne_company_id);
            if ($use_master_products) {
                $master_product_id = fn_cp_hawthorne_get_master_product_id_by_code($product_data['product_code']);
                $reindex_product_ids[] = $master_product_id;
            }
            if ($existing_product_id && isset($product_data['price']) && $product_data['price'] != null) {
                if (fn_cp_hawthorne_update_price($existing_product_id, $product_data)) {
                    $update_old_hawthorne_price[] = [
                        'product_id' => $existing_product_id,
                        'old_hawthorne_price' => $product_data['new_hawthorne_price']
                    ];
                    $update_old_hawthorne_price[] = [
                        'product_id' => $master_product_id,
                        'old_hawthorne_price' => $product_data['new_hawthorne_price']
                    ];
                    if (defined('DEVELOPMENT') && DEVELOPMENT == true) {
                        fn_log_event('products', 'update', [
                            'product_id' => $existing_product_id,
                            'product_code' => $product_data['product_code'],
                            'price' => $product_data['price']
                        ]);
                    }
                }
            }
            if ($existing_product_id && isset($product_data['amount']))  {
                if ($action == 'weight') {
                    $update_products[] = [
                        'product_id' => $existing_product_id,
                        'amount'     => $product_data['amount'],
                        'weight'     => $product_data['weight']
                    ];
                    if ($master_product_id) {
                        $update_products[] = [
                            'product_id' => $master_product_id,
                            'amount'     => $product_data['amount'],
                            'weight'     => $product_data['weight']
                        ];
                    }
                } else {
                    $update_products[] = [
                        'product_id' => $existing_product_id,
                        'amount'     => $product_data['amount'],
                    ];
                }
            }
        }
        $update_detailed[] = [
            'detailed' => YesNo::YES,
            'id'       => $data['id']
        ];
        unset($product_data);
        unset($master_product_id);
    }
    db_replace_into('cp_hawthorne_import', $update_detailed, true);
    if (!empty($update_products)) {
        db_replace_into('products', $update_products, true);
    }
    if (!empty($update_old_hawthorne_price)) {
        db_replace_into('products', $update_old_hawthorne_price, true);
    }
    if (!empty($reindex_product_ids)) {
        fn_cp_hawthorne_reindex_master_products($reindex_product_ids);
    }
    return count($update_products);
}

/**
 * Get category_id by it's name if special setting is empty
 *
 * @return mixed
 */
function fn_cp_hawthorne_get_category_id($category_name)
{
    static $return_category_ids;
    static $import_category_id;
    if (!$import_category_id) {
        $import_category_id = Registry::get('addons.cp_hawthorne_integration.import_category_id');
    }
    if ($import_category_id) {
        $return = $import_category_id;
    } else {
        if ($category_name) {
            if (isset($return_category_ids[$category_name])) {
                $return = $return_category_ids[$category_name];
            } else {
                $category_id = db_get_field('SELECT category_id FROM ?:category_descriptions WHERE category = ?s', $category_name);
                $return_category_ids[$category_name] = $category_id;
                $return = $category_id;
            }
        } else {
            $return = false;
        }
    }
    return $return;
}

/**
 * Get product_id by product_code
 * 
 * @param string   $product_code
 * @param integer  $company_id
 *
 * @return mixed
 */
function fn_cp_hawthorne_get_product_id_by_code($product_code, $company_id)
{
    static $all_product_ids;
    if (empty($all_product_ids)) {
        $condition = db_quote(' AND company_id = ?i', $company_id);
        $all_product_ids = db_get_hash_single_array('SELECT product_code, product_id FROM ?:products WHERE 1' . $condition, ['product_code', 'product_id']);
    }
    return isset($all_product_ids[$product_code]) ? $all_product_ids[$product_code] : 0;
}

/**
 * Get product_id of common product by product_code
 * 
 * @param string   $product_code
 *
 * @return mixed
 */
function fn_cp_hawthorne_get_master_product_id_by_code($product_code)
{
    static $master_product_ids;
    if (empty($master_product_ids)) {
        $master_product_ids = db_get_hash_single_array(
            'SELECT product_code, product_id 
            FROM ?:products 
            WHERE company_id = ?i', 
            ['product_code', 'product_id'], 
            0
        );
    }
    return isset($master_product_ids[$product_code]) ? $master_product_ids[$product_code] : 0;
}

/**
 * Get the command for cron
 * 
 * @return mixed
 */
function fn_cp_hawthorne_get_cron_hint()
{
    $cron_pass = Registry::get('addons.cp_hawthorne_integration.cron_password');
    $script = Registry::get('config.customer_index');
    $hint = 'php ' . Registry::get('config.dir.root') . '/' . $script . ' --dispatch=hawthorne.update_by_cron --cron_pass=' . $cron_pass;

    return $hint;
}

/**
 * Convert all weights of products into poungs (lbs)
 * 
 * @param float   $weight      Weight of products measured in different units
 * @param string  $unit        Code of weight measurement unit
 *
 * @return float
 */
function fn_cp_hawthorne_convert_weight($weight, $unit)
{
    if ($unit == HAWTHORNE_WEIGHT_POUND) {
        $return = $weight;
    } else if ($unit == HAWTHORNE_WEIGHT_GRAM) {
        $return = $weight/454;
    } else if ($unit == HAWTHORNE_WEIGHT_KILOGRAM) {
        $return = $weight/0.454;
    } else {
        $return = 0;
    }

    return $return;
}

/**
 * Update minimum prices and offer counts for selected master products
 * 
 * @param array   $product_ids      IDs of products that need updating of min price for master products
 *
 * @return void
 */
function fn_cp_hawthorne_reindex_master_products($product_ids)
{
    if (is_array($product_ids)) {
        $all_vendors_storefront_ids = db_get_fields('SELECT storefront_id FROM ?:storefronts');
        $condition = db_quote('products.master_product_id IN (?n)', $product_ids);
        $reindexed_pices = db_get_array(
            'SELECT products.master_product_id as product_id, storefronts.storefront_id, MIN(prices.price) AS price'
            . ' FROM ?:product_prices AS prices'
            . ' LEFT JOIN ?:products AS products ON products.product_id = prices.product_id'
            . ' INNER JOIN ?:companies AS companies ON companies.company_id = products.company_id'
            . ' LEFT JOIN ?:storefronts_companies AS storefronts_companies ON storefronts_companies.company_id = companies.company_id'
            . ' LEFT JOIN ?:storefronts AS storefronts ON storefronts.storefront_id = storefronts_companies.storefront_id OR storefronts.storefront_id IN (?n)'
            . ' WHERE ?p'
            . ' GROUP BY products.master_product_id, storefronts.storefront_id ORDER BY NULL',
            $all_vendors_storefront_ids,
            $condition
        );
        db_replace_into('master_products_storefront_min_price', $reindexed_pices, true);

        $reindexed_amounts = db_get_array(
            'SELECT products.master_product_id as product_id, storefronts.storefront_id, COUNT(*) AS count, SUM(amount) as amount'
            . ' FROM ?:products AS products'
            . ' INNER JOIN ?:companies AS companies ON companies.company_id = products.company_id'
            . ' LEFT JOIN ?:storefronts_companies AS storefronts_companies ON storefronts_companies.company_id = companies.company_id'
            . ' LEFT JOIN ?:storefronts AS storefronts ON storefronts.storefront_id = storefronts_companies.storefront_id OR storefronts.storefront_id IN (?n)'
            . ' WHERE ?p'
            . ' GROUP BY products.master_product_id, storefronts.storefront_id ORDER BY NULL',
            $all_vendors_storefront_ids,
            $condition
        );
        if (!empty($reindexed_amounts)) {
            foreach ($reindexed_amounts as $reindex) {
                $reindex_offers_count[] = [
                    'product_id' => $reindex['product_id'],
                    'storefront_id' => $reindex['storefront_id'],
                    'count' => $reindex['count']
                ];
                $reindex_amounts[] = [
                    'product_id' => $reindex['product_id'],
                    'amount' => $reindex['amount']
                ];
            }
            db_replace_into('master_products_storefront_offers_count', $reindex_offers_count, true);
            db_replace_into('products', $reindex_amounts, true);
        }
    }
}

/**
 * Get IDs of settings that we have to make numeric
 * 
 * @param array  $options        Full array for addon's settings
 *
 * @return array
 */
function fn_cp_hawthorne_get_numeric_settings_ids($options)
{
    $numeric_setting_names = (array) HAWTHORNE_NUMERIC_SETTING_NAMES;
    $numeric_setting_ids = [];
    foreach ($options as $section => &$settings) {
        foreach ($settings as &$setting) {
            if (in_array($setting['name'], $numeric_setting_names)) {
                $numeric_setting_ids[$setting['name']] =  $setting['object_id'];

            }
        }
    }
    return $numeric_setting_ids;
}

/**
 * Recalculate prices accoring to profit settings
 * 
 * @param  float  $price        Price of a product
 *
 * @return float
 */
function fn_cp_hawthorne_recalculate_price($price)
{
    static $settings;
    if (empty($settings)) {
        $settings['margin_percent'] = Settings::instance()->getValue('margin_percent', 'cp_hawthorne_integration');
        $settings['margin_absolute'] = Settings::instance()->getValue('margin_absolute', 'cp_hawthorne_integration');
    }
    if ($settings['margin_percent'] > 0) {
        $price = $price * (1 + $settings['margin_percent'] / 100);
    }
    if ($settings['margin_absolute'] > 0) {
        $price = $price + $settings['margin_absolute'];
    }
    return $price;
}

/**
 * Update price if hawthorne has changed it
 * 
 * @param  integer  $product_id        ID of product
 * @param  array    $product_data      Data of product
 *
 * @return boolean
 */
function fn_cp_hawthorne_update_price($product_id, $product_data)
{
    $return = false;
    $old_hawthorne_price = fn_cp_hawthorne_get_old_hawthorne_price($product_id);
    if (!empty($product_data['new_hawthorne_price']) && $old_hawthorne_price != $product_data['new_hawthorne_price']) {
        fn_update_product_prices($product_id, $product_data);
        $return = true;
    }
    return $return;
}

/**
 * Get old_hawthorne_price of product by product_id
 * 
 * @param integer   $product_id
 *
 * @return float
 */
function fn_cp_hawthorne_get_old_hawthorne_price($product_id)
{
    static $old_hawthorne_prices;
    if (empty($old_hawthorne_prices)) {
        $old_hawthorne_prices = db_get_hash_single_array(
            'SELECT product_id, old_hawthorne_price 
            FROM ?:products', 
            ['product_id', 'old_hawthorne_price']
        );
    }
    return isset($old_hawthorne_prices[$product_id]) ? $old_hawthorne_prices[$product_id] : 0;
}

/**
 * Update prices for all products that have old_hawthorne_price data
 * 
 * @return array
 */
function fn_cp_hawthorne_mass_prices_update()
{
    $selected_company_id = Registry::get('addons.cp_hawthorne_integration.company_id');
    $hawthorne_products = db_get_array('SELECT product_id, old_hawthorne_price FROM ?:products WHERE old_hawthorne_price > 0 AND company_id = ?i', $selected_company_id);
    $update_prices = $product_ids = [];
    foreach ($hawthorne_products as $product) {
        $new_price = fn_cp_hawthorne_recalculate_price($product['old_hawthorne_price']);
        $update_prices[] = [
            'product_id' => $product['product_id'],
            'price' => $new_price,
            'lower_limit' => 1,
            'usergroup_id' => 0
        ];
    }
    if (!empty($update_prices)) {
        $product_ids = array_column($hawthorne_products, 'product_id');
        db_replace_into('product_prices', $update_prices, true);
    }
    return $product_ids;
}