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

function fn_settings_variants_addons_cp_suredone_integration_cp_company_id() {

    $company_ids = db_get_array("SELECT company_id, company FROM ?:companies WHERE lang_code = ?s", DESCR_SL);
    
    foreach ($company_ids as $company_id) {
        $result[$company_id['company_id']] = $company_id['company'];
    }

    return $result;
}

function fn_cp_suredone_integration_rma_update_details_post($data, $show_confirmation_page, $show_confirmation, $is_refund, $_data, $confirmed) {
    
    if ($_data['status'] === 'C') {
    
        $username = Registry::get('addons.cp_suredone_integration.cp_suredone_username');
        $token = Registry::get('addons.cp_suredone_integration.cp_suredone_token');
        
        foreach ($data['accepted'] as $item_id => $item) {
        
            $guid = db_get_field("SELECT product_code FROM ?:order_details WHERE item_id = ?i", $item_id);
            
            $url = 'https://api.suredone.com/v1/editor/items/edit/?guid=' . $guid;
            $item_into_suredone = fn_cp_suredone_integration_get_requests($username, $token, $url);
            
            $amount_after_return = ($item_into_suredone['stock']) + ($item['amount']);
            
            $url = 'https://api.suredone.com/v1/editor/items/edit';
            $request = 'identifier=guid&guid=' . $guid . '&stock=' . $amount_after_return;
           
            $result = fn_cp_suredone_integration_update_requests($username, $token, $url, $request);
            
        }
    }
}

function fn_cp_suredone_integration_delete_order($order_id) {
    
    $oid = db_get_field("SELECT oid FROM ?:cp_order_status_sending_into_suredone WHERE order_id = ?i", $order_id);
    
    if (!empty($oid)) {
        $order_info = fn_get_order_info($order_id, false, true, true, false);
        $products = $order_info['products'];
        
        $username = Registry::get('addons.cp_suredone_integration.cp_suredone_username');
        $token = Registry::get('addons.cp_suredone_integration.cp_suredone_token');
        
        $url = "https://api.suredone.com/v3/orders/";
        $response = fn_cp_suredone_integration_get_requests($username, $token, $url . $oid);
        
        //get an array of products in the order
        $products_into_order = $response['orders'][0]['items'];
        
        //get order status
        $status_into_suredone_order = $response['orders'][0]['status'];
        
        if ($status_into_suredone_order === 'ORDERED' && ($order_info['status'] == 'F' || $order_info['status'] == 'D' || $order_info['status'] == 'B' || $order_info['status'] == 'I' || $order_info['status'] == 'E' || $order_info['status'] == 'N')) {

            foreach ($products_into_order as $key => $product_into_order) {
                
                $url = 'https://api.suredone.com/v1/editor/items/edit/?guid=' . $product_into_order['sku'];
                $item = fn_cp_suredone_integration_get_requests($username, $token, $url);
                $new_quantity = $item['stock'] + $product_into_order['quantity'];
                
                $url = 'https://api.suredone.com/v1/editor/items/edit';
                $request = 'identifier=guid&guid=' . $item['sku'] . '&stock=' . $new_quantity;
                fn_cp_suredone_integration_update_requests($username, $token, $url, $request);
            }
            
            $status = [
                'status' => 'CANCELED',
            ];                    
            
            $url = 'https://api.suredone.com/v3/orders/';
            
            $result = fn_cp_suredone_integration_patch_requests($username, $token, $url . $oid, json_encode($status, true));
        
        }
        
        if ($status_into_suredone_order === 'CANCELED' && ($order_info['status'] == 'P' || $order_info['status'] == 'C' || $order_info['status'] == 'O' || $order_info['status'] == 'Y' || $order_info['status'] == 'A')) {

            foreach ($products_into_order as $key => $product_into_order) {
                
                $url = 'https://api.suredone.com/v1/editor/items/edit/?guid=' . $product_into_order['sku'];
                $item = fn_cp_suredone_integration_get_requests($username, $token, $url);
                $new_quantity = $item['stock'] - $product_into_order['quantity'];
                
                $url = 'https://api.suredone.com/v1/editor/items/edit';
                $request = 'identifier=guid&guid=' . $item['sku'] . '&stock=' . $new_quantity;
                fn_cp_suredone_integration_update_requests($username, $token, $url, $request);
            }
            
            $status = [
                'status' => 'ORDERED',
            ];                    
            
            $url = 'https://api.suredone.com/v3/orders/';
            
            $result = fn_cp_suredone_integration_patch_requests($username, $token, $url . $oid, json_encode($status, true));
        
        }
        
        $url = 'https://api.suredone.com/v3/orders/' . $oid;
        
        $request = [
            'status'    => 'ARCHIVED',
            'archived'  => 1,
        ];
        
        $result = fn_cp_suredone_integration_patch_requests($username, $token, $url, json_encode($request, true));
        
    }
}

function fn_cp_suredone_integration_cron_url_info() {
    $cron_pass = Registry::get('addons.cp_suredone_integration.cron_password');
    $cron_url = fn_url('suredone.process&cron_password=' . $cron_pass);
    
    $hint = __('cp_product_analogues_cron_url', array('[http_location]' => $cron_url));
    $admin_ind = Registry::get('config.admin_index');
    $hint .= '<br>php ' .Registry::get('config.dir.root') .'/' . $admin_ind . ' --dispatch=suredone.process --cron_password=' . $cron_pass;
    
    return $hint;
}

function fn_cp_suredone_integration_place_order_manually_post(            
            $cart,
            $params,
            $customer_auth,
            $action,
            $issuer_id,
            $force_notification,
            $order_info,
            $edp_data,
            $is_order_placed_notification_required)
{

    if ($action === 'save') {

        $oid = db_get_field("SELECT oid FROM ?:cp_order_status_sending_into_suredone WHERE order_id = ?i", $order_info['order_id']);
        
        if (!empty($oid)) {
        
            $url = 'https://api.suredone.com/v3/orders/' . $oid;
            
            $username = Registry::get('addons.cp_suredone_integration.cp_suredone_username');
            $token = Registry::get('addons.cp_suredone_integration.cp_suredone_token');
            
            $response = fn_cp_suredone_integration_get_requests($username, $token, $url);
         
            foreach ($response['orders'][0]['items'] as $item) {

                $url = 'https://api.suredone.com/v1/editor/items/edit/?guid=' . $item['sku'];
                $item_into_suredone = fn_cp_suredone_integration_get_requests($username, $token, $url);
                $new_quantity = $item_into_suredone['stock'] + $item['quantity'];
                
                $url = 'https://api.suredone.com/v1/editor/items/edit';
                $request = 'identifier=guid&guid=' . $item['sku'] . '&stock=' . $new_quantity;
                $result = fn_cp_suredone_integration_update_requests($username, $token, $url, $request);

                if ($result['result'] == 'success') {
                
                    $url = 'https://api.suredone.com/v3/orders/' . $oid;
                    
                    $request = [
                        'items' => [
                            [
                            'itemid' => $item['itemid'],
                            'quantity' => 0,
                            ],
                        ],
                    ];
                    
                    $request = json_encode($request);
                    $result = fn_cp_suredone_integration_patch_requests($username, $token, $url, $request);
                }
                
                foreach ($order_info['products'] as $product) {

                    if ($item['sku'] === $product['product_code']) {

                        $update_stock = $new_quantity - $product['amount'];

                        $url = 'https://api.suredone.com/v1/editor/items/edit';
                        $request = 'identifier=guid&guid=' . $item['sku'] . '&stock=' . $update_stock;
                        $result = fn_cp_suredone_integration_update_requests($username, $token, $url, $request);

                        if ($result['result'] == 'success') {
                        
                            $url = 'https://api.suredone.com/v3/orders/' . $oid;
                            
                            $request = [
                                'items' => [
                                    [
                                    'itemid' => $item['itemid'],
                                    'quantity' => $product['amount'],
                                    ],
                                ],
                            ];
                            
                            $request = json_encode($request);
                            $result = fn_cp_suredone_integration_patch_requests($username, $token, $url, $request);
                        }
                    }
                }
            }
            
            
            
            foreach ($response['orders'][0]['items'] as $item) {
                $exist_item_into_order_sd[] = $item['sku'];
            }
            
            foreach ($order_info['products'] as $product) {
                if (!in_array($product['product_code'], $exist_item_into_order_sd)) {
                   
                    $url = 'https://api.suredone.com/v1/editor/items/edit/?guid=' . $product['product_code'];
                    $item_into_suredone = fn_cp_suredone_integration_get_requests($username, $token, $url);
                    
                    $update_stock = $item_into_suredone['stock'] - $product['amount'];

                    $url = 'https://api.suredone.com/v1/editor/items/edit';
                    $request = 'identifier=guid&guid=' . $product['product_code'] . '&stock=' . $update_stock;
                    $result = fn_cp_suredone_integration_update_requests($username, $token, $url, $request);

                    if ($result['result'] == 'success') {
                    
                        $url = 'https://api.suredone.com/v3/orders/' . $oid;
                        
                        $request = [
                            'items' => [
                                [
                                'sku' => $product['product_code'],
                                'quantity' => $product['amount'],
                                ],
                            ],
                        ];
                        
                        $request = json_encode($request);
                        $result = fn_cp_suredone_integration_patch_requests($username, $token, $url, $request);

                    }
                    
                }
                
            }
            
        } else {

            $data['order_id'] = $order_info['order_id'];
            $data['timestamp'] = TIME;

            $cp_status = db_get_field('SELECT cp_status FROM ?:cp_order_status_sending_into_suredone WHERE order_id = ?i', $data['order_id']);
            
            if (empty($cp_status)) {
                $data['cp_status'] = 'S';
                db_query('INSERT INTO ?:cp_order_status_sending_into_suredone ?e', $data);
            }
        }
    }
}

function fn_cp_suredone_integration_place_order($order_id, $action, $order_status, $cart, $auth) {

    $data['order_id'] = $order_id;
    $data['timestamp'] = TIME;
    
    $cp_status = db_get_field('SELECT cp_status FROM ?:cp_order_status_sending_into_suredone WHERE order_id = ?i', $data['order_id']);

    if (empty($cp_status)) {
        $data['cp_status'] = 'S';
        db_query('INSERT INTO ?:cp_order_status_sending_into_suredone ?e', $data);
    }
}

function fn_cp_suredone_integration_get_amount_selected_products($username, $token, $ids) {

    $guids = db_get_fields('SELECT product_code FROM ?:products WHERE product_id IN (?n)', $_REQUEST['product_ids']);
  
    foreach ($guids as $guid) {
        
        $url = 'https://api.suredone.com/v1/editor/items/edit/?guid=' . $guid;
        $item = fn_cp_suredone_integration_get_requests($username, $token, $url);

        if (empty($item['stock'])) {
            return false;
        }
        
        $result[] = db_query('UPDATE ?:products SET amount = ?i WHERE product_code = ?s', $item['stock'], $guid);
    }
    
    return $result;
}

function fn_cp_suredone_integration_get_amount_products($username, $token, $url) {

    $process = 'get_amount_products';
    
    $timestamp = db_get_field("SELECT timestamp FROM ?:cp_time_last_update_about_producs_into_suredone WHERE cp_suredone_process = ?s", $process);

    if (empty($timestamp)) {
        $time = db_query('INSERT INTO ?:cp_time_last_update_about_producs_into_suredone (timestamp, cp_suredone_process) VALUES (?i, ?s)', 1431252083, $process);
        $timestamp = 1431252083;
    }
    
    $format = '%Y-%m-%d' . 'T' . '%H:%M:%S';

    $time_last_update = '"' . fn_date_format($timestamp, $format) . '"';
    
    $page = db_get_field('SELECT page FROM ?:cp_time_last_update_about_producs_into_suredone WHERE cp_suredone_process = ?s', $process);
    
    if (empty($page)) {
        $page = 1;
    }    
    
    $url .= $time_last_update . '?page=' . $page;

    $response = fn_cp_suredone_integration_get_requests($username, $token, $url);
   
    $items = (array_filter($response, "fn_cp_suredone_integration_numeric_key"));
  
    if (empty($items)) {
        db_query('UPDATE ?:cp_time_last_update_about_producs_into_suredone SET timestamp = ?i, page = ?i WHERE cp_suredone_process = ?s', strtotime($response['time']), 1, $process);
        return true;
    } else {
        foreach ($items as $item) {
            db_query('UPDATE ?:products SET amount = ?i WHERE product_code = ?s', $item['stock'], $item['guid']);
            db_query('UPDATE ?:cp_time_last_update_about_producs_into_suredone SET product_code = ?s WHERE cp_suredone_process = ?s', $item['guid'], $process);
        }
        $page++;
        db_query('UPDATE ?:cp_time_last_update_about_producs_into_suredone SET page = ?i WHERE cp_suredone_process = ?s', $page, $process);
        return true;
    }
}

function fn_cp_suredone_integration_get_amount_one_product($username, $token, $product_code) {

    $url = 'https://api.suredone.com/v1/editor/items/edit/?guid=' . $product_code;
    
    return fn_cp_suredone_integration_get_requests($username, $token, $url);

}

function fn_cp_suredone_integration_update_amount_one_product($stock, $id) {

    return db_query('UPDATE ?:products SET amount = ?i WHERE product_id = ?s', $stock, $id);
}

//Placement of new orders by cron, in case of successful placement of the order, the status is changed to 'O' in the database
function fn_cp_suredone_integration_add_orders($username, $token, $url) {
    
    $params['items_per_page'] = '';
    $params['cp_status'] = 'S';
    
    list($orders, $search, $totals) = fn_get_orders($params, Registry::get('settings.Appearance.admin_elements_per_page'), true);

    if (!empty($orders)) {

    $item_info = fn_get_schema('cp_suredone_integration', 'add_orders');
     
        foreach ($orders as $order) {
            $order_info = fn_get_order_info($order['order_id'], false, true, true, false);
            
            $data = [
                'cs_' . $order['order_id'],
                'cs-cart',
                $order['total'],               
            ];
            
            $i = 0;
            foreach ($order_info['products'] as $product) {
                $data[3][$i] = [
                    'sku' => $product['product_code'],
                    'quantity' => $product['amount'],
                ];
                $i++;
            }
            
            $data[5] = 'true';
            $data[6] = 'ORDERED';
            $data[] = $data;
            
            $item_info['data'] = $data;
            unset($data);

            $request = json_encode($item_info, true);
            $response = fn_cp_suredone_integration_update_requests($username, $token, $url, $request);

            if (isset($response['results']['successful'])) {
                $oid = '';
                fn_cp_search_key('oid', $response, $oid);
                db_query('UPDATE ?:cp_order_status_sending_into_suredone SET cp_status = "O", oid = ?i WHERE order_id = ?i', $oid, $order['order_id']);
            } else {
                db_query('UPDATE ?:cp_order_status_sending_into_suredone SET cp_status = "N" WHERE order_id = ?i', $order['order_id']);
            }
        }
    }
}

function fn_cp_suredone_integration_get_orders($params, $fields, $sortings, &$condition, $join, $group) {
    if (isset($params['cp_status'])) {
        $order_id_to_send = db_get_fields('SELECT order_id FROM ?:cp_order_status_sending_into_suredone WHERE cp_status = ?s', $params['cp_status']);
        $condition .= db_quote(' AND ?:orders.order_id IN (?n)', $order_id_to_send);
    }
    
}

function fn_cp_suredone_integration_change_order_status_post($order_id, $status_to, $status_from, $force_notification, $place_order, $order_info, $edp_data) {
    
    $oid = db_get_field("SELECT oid FROM ?:cp_order_status_sending_into_suredone WHERE order_id = ?i", $order_id);

    if ($oid != 0) {
        db_query('UPDATE ?:cp_order_status_sending_into_suredone SET cp_status = "U", cp_status_to = ?s WHERE order_id = ?i', $status_to, $order_id);
    }
}


//Update order information
function fn_cp_suredone_integration_update_orders($username, $token) {
    
    $params['items_per_page'] = '';
    $params['cp_status'] = 'U';
    
    list($orders, $search, $totals) = fn_get_orders($params, Registry::get('settings.Appearance.admin_elements_per_page'), true);   
    if (!empty($orders)) {

        foreach ($orders as $order) {
            
            $oid = db_get_field('SELECT oid FROM ?:cp_order_status_sending_into_suredone WHERE order_id = ?i', $order['order_id']);

            if (!empty($oid) && $oid != 0) {
            
                $url = "https://api.suredone.com/v3/orders/";
                
                $response = fn_cp_suredone_integration_get_requests($username, $token, $url . $oid);
                
                //get an array of products in the order
                $products_into_order = $response['orders'][0]['items'];
                
                //get order status
                $status_into_suredone_order = $response['orders'][0]['status'];

                //product restocking update
                foreach ($products_into_order as $key => $product_into_old_order) {
                    
                    $url = 'https://api.suredone.com/v1/editor/items/edit/?guid=';
                    
                    $products_into_order[$key]['itemdetails'] = fn_cp_suredone_integration_get_requests($username, $token, $url . $product_into_old_order['sku']);
                }
                
                if ($status_into_suredone_order === 'ORDERED' && ($order['status'] == 'F' || $order['status'] == 'D' || $order['status'] == 'B' || $order['status'] == 'I' || $order['status'] == 'E' || $order['status'] == 'N')) {
                
                    foreach ($products_into_order as $key => $product_into_order) {
                        $product_residue = ($products_into_order[$key]['itemdetails']['stock']) + ($products_into_order[$key]['quantity']);
                        
                        $request_data = 'identifier=guid&guid=' . $product_into_order['sku'] . '&stock=' . $product_residue;

                        $url = 'https://api.suredone.com/v1/editor/items/edit';
                        
                        fn_cp_suredone_integration_update_requests($username, $token, $url, $request_data);
                    }
                    
                    $status = [
                        'status' => 'CANCELED',
                    ];
                    
                    $url = 'https://api.suredone.com/v3/orders/';
                    
                    $result = fn_cp_suredone_integration_patch_requests($username, $token, $url . $oid, json_encode($status, true));

                }
                
                if ($status_into_suredone_order === 'CANCELED' && ($order['status'] == 'P' || $order['status'] == 'C' || $order['status'] == 'O' || $order['status'] == 'Y' || $order['status'] == 'A')) {
                
                    foreach ($products_into_order as $key => $product_into_order) {
                        $product_residue = ($products_into_order[$key]['itemdetails']['stock']) - ($products_into_order[$key]['quantity']);
                        
                        $request_data = 'identifier=guid&guid=' . $product_into_order['sku'] . '&stock=' . $product_residue;
                        
                        $url = 'https://api.suredone.com/v1/editor/items/edit';
                        
                        fn_cp_suredone_integration_update_requests($username, $token, $url, $request_data);
                    }
                    
                    $status = [
                        'status' => 'ORDERED',
                    ];                    
                    
                    $url = 'https://api.suredone.com/v3/orders/';
                    
                    $result = fn_cp_suredone_integration_patch_requests($username, $token, $url . $oid, json_encode($status, true));

                }
                
                if (isset($result['results']['successful'])) {              
                    db_query('UPDATE ?:cp_order_status_sending_into_suredone SET cp_status = ?s WHERE order_id = ?i', $order['status'], $order['order_id']);
                } else {
                    db_query('UPDATE ?:cp_order_status_sending_into_suredone SET cp_status = "N" WHERE order_id = ?i', $order['order_id']);
                }
            }
        }
    }
}

function fn_cp_suredone_integration_get_new_products($username, $token, $url) {

    $process = 'add_new_products';

    $timestamp = db_get_field("SELECT timestamp FROM ?:cp_time_last_update_about_producs_into_suredone WHERE cp_suredone_process = ?s", $process);

    if (empty($timestamp)) {
        $time = db_query('INSERT INTO ?:cp_time_last_update_about_producs_into_suredone (timestamp, cp_suredone_process) VALUES (?i, ?s)', 1431252083, $process);
        $timestamp = 1431252083;
    }

    $format = '%Y-%m-%d' . 'T' . '%H:%M:%S';

    $time_last_update = '"' . fn_date_format($timestamp, $format) . '"';
    
    $page = db_get_field('SELECT page FROM ?:cp_time_last_update_about_producs_into_suredone WHERE cp_suredone_process = ?s', $process);
    
    if (empty($page)) {
        $page = 1;
    }

    $url .= $time_last_update . '?page=' . $page;

    //getting data about new products
    $response = fn_cp_suredone_integration_get_requests($username, $token, $url);
  
    $items = (array_filter($response, "fn_cp_suredone_integration_numeric_key"));

    if (!empty($items)) {
        $default_category_id = db_get_field("SELECT category_id FROM ?:categories WHERE cp_use_for_upload_products_suredone = 'Y'");
        
        $company_id = Registry::get('addons.cp_suredone_integration.cp_company_id');

        foreach ($items as $item) {
      
            if (!empty($item['ebaycatid'])) {
                $ebay2catid = db_get_field("SELECT category_id FROM ?:categories WHERE cp_ebay_suredone_category = ?i", $item['ebaycatid']);
            }
     
            if (!empty($ebay2catid)) {
                $category_id = $ebay2catid;
            } else {
                $category_id = $default_category_id;
            }
            
            $media = [];
                        
            fn_cp_suredone_integration_add_images($item, 'media', $media, 1);
                    
            $products[] = [
                'product_data'  => [
                    'product'           =>  $item['title'],
                    'category_ids'      => [
                        $category_id,
                    ],
                    'price'             =>  $item['price'],
                    'full_description'  =>  '<p>' . $item['longdescription'] . '</p>',
                    'status'            =>  'A',
                    'product_code'      =>  $item['guid'],
                    'amount'            =>  $item['stock'],
                    'company_id'        =>  $company_id,
                ],
                'media' => $media,
            ];
        }

        foreach ($products as $product) {
        
            $cp_product_id = db_get_field('SELECT product_id FROM ?:products WHERE product_code = ?s', $product['product_data']['product_code']);

            if (empty($cp_product_id)) {
                if (!empty($product['media'])) {
                    fn_cp_load_images($product['media'], $_REQUEST);
                }
                $product_id = fn_update_product($product['product_data']);
                db_query('UPDATE ?:cp_time_last_update_about_producs_into_suredone SET product_code = ?s WHERE cp_suredone_process = ?s', $product['product_data']['product_code'], $process);
            }
        }

        $page++;
        db_query('UPDATE ?:cp_time_last_update_about_producs_into_suredone SET page = ?i WHERE cp_suredone_process = ?s', $page, $process);
        return true;
    }
    db_query('UPDATE ?:cp_time_last_update_about_producs_into_suredone SET timestamp = ?i, page = ?i WHERE cp_suredone_process = ?s', strtotime($response['time']), 1, $process);
    return true;
}

function fn_cp_suredone_integration_numeric_key($key) {

    if (isset($key['id'])) {
        return $key;
    }
}

function fn_cp_suredone_integration_get_categories_ebay($username, $token, $keyword, $url) {

    $request_data = 'ebay-category-search=' . $keyword;
    return fn_cp_suredone_integration_update_requests($username, $token, $url, $request_data);

}

function fn_cp_suredone_integration_get_requests($username, $token, $url) {
    
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    curl_setopt($ch, CURLOPT_HEADER, FALSE);

    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        "Content-Type: application/x-www-form-urlencoded",
        "X-Auth-User: {$username}",
        "X-Auth-Token: {$token}"
    ));

    $response = json_decode(curl_exec($ch), true);
    $response['time'] = isset($response['time']) ? $response['time'] : time();
    curl_close($ch);
    
    return $response;
}

function fn_cp_suredone_integration_update_requests($username, $token, $url, $request) {

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    curl_setopt($ch, CURLOPT_HEADER, FALSE);

    curl_setopt($ch, CURLOPT_POST, TRUE);

    curl_setopt($ch, CURLOPT_POSTFIELDS, $request);

    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        "Content-Type: application/x-www-form-urlencoded",
        "X-Auth-User: {$username}",
        "X-Auth-Token: {$token}"
    ));

    $response = json_decode(curl_exec($ch), true);
    curl_close($ch);
    
    return $response;
}

function fn_cp_suredone_integration_patch_requests($username, $token, $url, $request) {

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    curl_setopt($ch, CURLOPT_HEADER, FALSE);

    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PATCH");
    
    curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
    
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        "Content-Type: multipart/x-www-form-urlencoded",
        "X-Auth-User: {$username}",
        "X-Auth-Token: {$token}",
        "X-Auth-Integration: {partnername}"
    ));

    $response = json_decode(curl_exec($ch), true);
    curl_close($ch);
    
    return $response;
}

function fn_cp_search_key($searchKey, $arr, &$oid) {
    if (isset($arr[$searchKey])) {
        $oid = $arr[$searchKey];
    }

    foreach ($arr as $key => $param) {
        if (is_array($param)) {
            fn_cp_search_key($searchKey, $param, $oid);
        }
    }
}

function fn_cp_load_images($image_urls, &$params) {	
	/* unset $_REQUEST variables if convers many products*/
	unset(
		$params['product_main_image_data'],
		$params['type_product_main_image_detailed'],
		$params['file_product_main_image_detailed'],
		$params['product_add_additional_image_data'],
		$params['type_product_add_additional_image_detailed'],
		$params['file_product_add_additional_image_detailed']
	);
	/* unset $_REQUEST variables if convers many products*/
	$images_folder = fn_get_files_dir_path()."cp_ebay_images";
	fn_mkdir($images_folder);

    foreach ($image_urls as $position => $url) {
    	$headers = @get_headers($url);
    	
    	if (preg_match("|200|", $headers[0])) {

    		$path_info = pathinfo($url);

	    	$img_name = mt_rand(0, 100000)."ebay_iamge.".$path_info['extension'];

	    	if (!copy($url,$images_folder."/".$img_name)){
	    		echo "failed";
	    	}

	        if (!isset($params['product_main_image_data'])) {
	            $params['product_main_image_data'][$position] = array(
	                'detailed_alt' => '',
	                'type' => 'M',
	                'object_id' => 0,
	                'position' => $position,
	                'is_new' => 'Y'
	            );
	            $params['type_product_main_image_detailed'][$position] = "server";
	            $params['file_product_main_image_detailed'][$position] = "cp_ebay_images/".$img_name;
	        }else {
	            $params['product_add_additional_image_data'][$position] = array(
	                'detailed_alt' => '',
	                'type' => 'A',
	                'object_id' => 0,
	                'position' => $position,
	                'is_new' => 'Y'
	            );
	            $params['type_product_add_additional_image_detailed'][$position] = "server";
	            $params['file_product_add_additional_image_detailed'][$position] = "cp_ebay_images/".$img_name;
	        }
	    }
    }
    if (!isset($params['product_main_image_data'])) {
    	fn_set_notification('W', __('warning'), __('cp_ebay_can_not_find_img'));
    }  
}

function fn_cp_suredone_integration_add_images($item, $name_image, &$media, $i) {
    
    if (!empty($item[$name_image . $i])) {
    
        $media[] = $item[$name_image . $i];
        $i++;
        fn_cp_suredone_integration_add_images($item, $name_image, $media, $i);
    }
}





























