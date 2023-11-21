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

use Tygh\Http;
use Tygh\Registry;

/**
 * @var array $processor_data
 * @var array $order_info
 * @var int $order_id
 */

if (!defined('BOOTSTRAP')) { die('Access denied'); }

include_once(Registry::get('config.dir.payments') . 'cmpi.php');

$use_cardinal = !empty($processor_data['processor_params']['merchant_id'])
    && !empty($processor_data['processor_params']['processor_id'])
    && !empty($processor_data['processor_params']['transaction_password'])
    && !empty($processor_data['processor_params']['transaction_url']);

if ($use_cardinal) {
    if (!defined('CMPI_PROCESSED')) {
        fn_cmpi_lookup($processor_data, $order_info, $mode);
    }
} else {
    define('DO_DIRECT_PAYMENT', true);
}

if (defined('DO_DIRECT_PAYMENT')) {

    $currency = fn_paypal_get_valid_currency($processor_data['processor_params']['currency']);

    $payment_data_array = [];

    $payflow_username = $processor_data['processor_params']['username'];
    $payflow_vendor = $processor_data['processor_params']['vendor'];
    $payflow_partner = $processor_data['processor_params']['partner'];
    $payflow_password = $processor_data['processor_params']['password'];

    if ($processor_data['processor_params']['mode'] == 'test') {
        $payflow_url = "pilot-payflowpro.paypal.com";
    } else {
        $payflow_url = "payflowpro.paypal.com";
    }

    if (!empty($order_info['products'])) {
        foreach ($order_info['products'] as $key => $product) {
            $unit_price = fn_format_price($product['subtotal'] / $product['amount']);

            $payment_data_array += [
                'L_COST'. $key => $unit_price,
                'L_QTY'. $key  => $product['amount'],
                'L_DESC'. $key  => htmlspecialchars($product['product']),
            ];
        }
    }

    $total = fn_format_price_by_currency($order_info['total'], CART_PRIMARY_CURRENCY, $currency['code']);

    $payflow_expire = $order_info['payment_info']['expiry_month'] . $order_info['payment_info']['expiry_year'];
    $payflow_order_id = $processor_data['processor_params']['order_prefix'] . $order_id . (($order_info['repaid']) ? "_{$order_info['repaid']}" : '')  . '_' . fn_date_format(time(), '%H_%M_%S');

    $payment_data_array = [
        'PARTNER'   => $payflow_partner,
        'VENDOR'    => $payflow_vendor,
        'USER'      => $payflow_username,
        'PWD'       => $payflow_password,
        'TRXTYPE'   => 'S',
        'TENDER'    => 'C',  // C = Credit Card
        'ACCT'      => $order_info['payment_info']['card_number'],  // Card number
        'CVV2'      => $order_info['payment_info']['cvv2'],  // CVV2 card verification number
        'EXPDATE'   => $payflow_expire,  // Card expiration date
        'AMT'       => $total,  // Amount owed
        'CURRENCY'  => $currency['code'],
        'COMMENT1'  => $payflow_order_id,

        //Fraud Protection Services
        'EMAIL'     => $order_info['email'],
        'PHONENUM'  => $order_info['phone'],

        'SHIPTOSTREET' => $order_info['s_address'],
        'SHIPTOCITY'   => $order_info['s_city'],
        'SHIPTOSTATE'  => $order_info['s_state'],
        'SHIPTOZIP'    => $order_info['s_zipcode'],
        'SHIPTOCOUNTRY' 	=> $order_info['s_country'],

        'BILLTOSTREET' => $order_info['b_address'],
        'BILLTOCITY'   => $order_info['b_city'],
        'BILLTOSTATE'  => $order_info['b_state'],
        'BILLTOZIP'    => $order_info['b_zipcode'],
        'BILLTOCOUNTRY' 	=> $order_info['b_country'],
    ];

    $post_url = "https://{$payflow_url}:443/transaction";

    Registry::set('log_cut_data', array('CardNum', 'ExpDate', 'NameOnCard', 'CVNum'));
    $response_data = Http::post($post_url, $payment_data_array, array(
        'headers' => array(
            'Content-type: text/namevalue',
            'X-VPS-REQUEST-ID: ' . $payflow_order_id,
            'X-VPS-CLIENT-TIMEOUT: 45',
            'Connection: close'
        )
    ));

    fn_pp_save_mode($order_info);

    $response = explode('&', $response_data);
    $keys = $values = $result = [];

    foreach ($response as $value) {
        $str = explode('=', $value);
        array_push($keys,$str[0]);
        array_push($values,$str[1]);
    }

    $result = array_combine($keys, $values);
    $pp_response = [];
    $pp_response['reason_text'] = '';
    $pp_response['order_status'] = 'F';

    if (isset($result['RESULT'])) {
        $pp_response['reason_text'] = "Result: ". $result['RESULT'];
    }

    if (isset($result['RESPMSG'])) {
        $pp_response['reason_text'] .= "; " . $result['RESPMSG'] . "; ";
    }

    if (isset($result['AUTHCODE'])) {
        $pp_response['reason_text'] .= "Auth Code: " . $result['AUTHCODE'] . "; ";
    }

    if (isset($result['PNREF'])) {
        $pp_response['transaction_id'] = $result['PNREF'];
    }

    if (isset($result['IAVS'])) {
        $pp_response['descr_avs'] = $result['IAVS'];
    }

    if (isset($result['RESULT']) && $result['RESULT'] == 0) {
        $pp_response['order_status'] = Registry::get('addons.cp_payflow.order_status');
    }

}