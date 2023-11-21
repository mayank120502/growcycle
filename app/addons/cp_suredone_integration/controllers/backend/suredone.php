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
use Tygh\Cron\CronExpression;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

$username = Registry::get('addons.cp_suredone_integration.cp_suredone_username');
$token = Registry::get('addons.cp_suredone_integration.cp_suredone_token');

if ($_SERVER['REQUEST_METHOD']  == 'POST') {
  
    if ($mode == 'get_amount_all_product') {

        $result = fn_cp_suredone_integration_get_amount_selected_products($username, $token, $_REQUEST['product_ids']);
    }
    
    fn_set_notification('N', __('notice'), __('cp_suredone_integration.text_products_have_been_updated'));

    $suffix = '.manage';
    
    return [CONTROLLER_STATUS_OK, 'products' . $suffix];
}

if ($mode == 'process') {

    if ($action === 'add_products_into_suredone') {
    
        $params = [
            'items_per_page' => 250,
        ];
        $params['only_short_fields'] = true;
        $params['apply_disabled_filters'] = true;
        $params['extend'][] = 'companies';

        if (fn_allowed_for('ULTIMATE')) {
            $params['extend'][] = 'sharing';
        }

        if ($mode == 'p_subscr') {
            $params['get_subscribers'] = true;
        }

        list($products, $search) = fn_get_products($params, Registry::get('settings.Appearance.admin_elements_per_page'), DESCR_SL);
        fn_gather_additional_products_data($products, array('get_icon' => true, 'get_detailed' => true, 'get_options' => false, 'get_discounts' => false));
        
        foreach ($products as $product) {
        
            $ch = curl_init();

            curl_setopt($ch, CURLOPT_URL, "https://api.suredone.com/v1/editor/items/add");
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
            curl_setopt($ch, CURLOPT_HEADER, FALSE);

            curl_setopt($ch, CURLOPT_POST, TRUE);

            curl_setopt($ch, CURLOPT_POSTFIELDS, "identifier=guid&guid=" . $product['product_code'] . "&price=" . $product['price'] . "&title=" . $product['product'] . "&media1=" . $product['main_pair']['detailed']['image_path'] . "&stock=" . $product['amount']);
            
            curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                "Content-Type: application/x-www-form-urlencoded",
                "X-Auth-User: {$username}",
                "X-Auth-Token: {$token}",
            ));
            
            $response = curl_exec($ch);
            curl_close($ch);
            
            var_dump($response);
        }
        
    }

    $cron_password = Registry::get('addons.cp_suredone_integration.cron_password');

    if ($action === 'get_amount_products') {
        
        $url = 'https://api.suredone.com/v1/search/items/dateutc:>';
        fn_cp_suredone_integration_get_amount_products($username, $token, $url);
        
    } elseif ($action === 'get_amount_one_product') {

        if (defined('AJAX_REQUEST')) {

            $params = $_REQUEST;
            $params['only_short_fields'] = true;
            $params['apply_disabled_filters'] = true;
            $params['extend'][] = 'companies';

            if (fn_allowed_for('ULTIMATE')) {
                $params['extend'][] = 'sharing';
            }

            if ($mode === 'p_subscr') {
                $params['get_subscribers'] = true;
            }
                
            $stock = fn_cp_suredone_integration_get_amount_one_product($username, $token, $_REQUEST['cp_product_code']);
            
            $result_update_amount_one_product = fn_cp_suredone_integration_update_amount_one_product($stock['stock'], $_REQUEST['cp_product_id']);
            
            list($products, $search) = fn_get_products($params, Registry::get('settings.Appearance.admin_elements_per_page'), DESCR_SL);
            fn_gather_additional_products_data($products, ['get_icon' => true, 'get_detailed' => true, 'get_options' => false, 'get_discounts' => false]);
            
            Tygh::$app['view']->assign('products', $products);
            Tygh::$app['view']->display('views/products/manage.tpl');
            exit;
        }
    } elseif ($action === 'add_orders') {

        $url = 'https://api.suredone.com/v3/orders/';

        fn_cp_suredone_integration_add_orders($username, $token, $url);
        
    } elseif ($action === 'update_orders') {
   
        fn_cp_suredone_integration_update_orders($username, $token);
    
    } elseif ($action === 'add_new_products') {
    
        $cp_path = Registry::get('config.dir.files') . 'add_new_products.txt';
    
        if (!file_exists($cp_path)) {
            touch($cp_path);

            $url = 'https://api.suredone.com/v1/search/items/dateutc:>';
            fn_cp_suredone_integration_get_new_products($username, $token, $url);
            
            unlink($cp_path);
        }
            
    } elseif ($action === 'add_ebay_category') {
    
        if (defined('AJAX_REQUEST')) {

            $keyword = $_REQUEST['keyword'];
            
            $url = 'https://api.suredone.com/v1/editor/items';
            
            $ebay_categories = fn_cp_suredone_integration_get_categories_ebay($username, $token, $keyword, $url);
            
            Tygh::$app['view']->assign('cp_ebay_categories', $ebay_categories['categories']);
            Tygh::$app['view']->display('views/categories/update.tpl');
            exit;
        }        
    
    }
    
}
