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

use Tygh\Enum\Addons\CpNewBuyingTypes\ProductBuyingTypes;
use Tygh\Enum\NotificationSeverity;
use Tygh\{Registry, Storage};

defined('BOOTSTRAP') || die('Access denied');

/**
 * @var array  $auth
 * @var string $mode
 */

/** @var array $start_order_cart */
$start_order_cart = &Tygh::$app['session']['cp_start_order_cart'];

if (!empty($_SERVER['HTTP_REFERER'])) {
    $url_info = parse_url($_SERVER['HTTP_REFERER']);
    
    if (!empty($url_info['query'])) {
        parse_str($url_info['query'], $query);     

        if (!empty($query['start_order'])) {
            $_REQUEST['start_order'] = true;
        }
    }
}

$is_start_order = fn_cp_check_is_start_order();

if ($mode === 'cp_send_inquiry' || $is_start_order) {
    if ($is_start_order) {
        $_REQUEST['payment_id'] = fn_cp_get_buying_type_payment_id(ProductBuyingTypes::START_ORDER);
    }

    if (!empty(Tygh::$app['session']['cp_original_cart'])) {
        Tygh::$app['session']['cart'] = Tygh::$app['session']['cp_original_cart'];
        unset(Tygh::$app['session']['cp_original_cart']);
    }
    
    Tygh::$app['session']['cp_original_cart'] = Tygh::$app['session']['cart'];
    Tygh::$app['session']['cart'] = $start_order_cart;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if ($mode === 'place_order') {
        if ($is_start_order) {
            $error = false;

            if (count($start_order_cart['products']) !== 1) {
                $error = true;
            } else {
                foreach ($start_order_cart['products'] as $product) {
                    if (!fn_cp_check_product_by_buying_type($product['product_id'], ProductBuyingTypes::START_ORDER)) {
                        $error = true;
                    }
                }
            }

            if ($error) {
                fn_set_notification(
                    NotificationSeverity::ERROR,
                    __('error'),
                    __('error_occurred')
                );

                return [CONTROLLER_STATUS_REDIRECT, 'checkout.checkout'];
            }
        }
    }

    if ($mode === 'cp_save_start_order') {
        $return_url = $_REQUEST['redirect_url'] ?? '';
        $product_id = $_REQUEST['product_id'] ?? 0;
        $amount = $_REQUEST['product_data'][$product_id]['amount'] ?? 1;

        if (
            !defined('AJAX_REQUEST')
            || !fn_cp_check_product_by_buying_type($product_id, ProductBuyingTypes::START_ORDER)
            || (
                empty($auth['user_id'])
                && Registry::get('settings.Checkout.allow_anonymous_shopping') !== 'allow_shopping'
            )
        ) {
            fn_set_notification(
                NotificationSeverity::ERROR,
                __('error'),
                __('error_occurred')
            );
        } else {
            fn_clear_cart($start_order_cart);

            fn_add_product_to_cart([
                $product_id => [
                    'product_id' => $product_id,
                    'amount'     => $amount,
                ]
            ], $start_order_cart, $auth);

            $start_order_cart['change_cart_products'] = true;
            $start_order_cart['cp_buying_type'] = ProductBuyingTypes::START_ORDER;
            fn_calculate_cart_content($start_order_cart, $auth, 'E');

            Tygh::$app['ajax']->assign('force_redirection', fn_url('checkout.checkout?start_order=1'));
            exit();
        }

        return [CONTROLLER_STATUS_NO_CONTENT];
    }

    if ($mode === 'cp_send_inquiry') {
        $product_id = $_REQUEST['product_id'] ?? 0;
        $amount = $_REQUEST['amount'] ?: 1;

        if (
            empty($auth['user_id'])
            || empty($product_id)
            || !fn_cp_check_product_by_buying_type($product_id, ProductBuyingTypes::CONTACT_VENDOR)
        ) {
            fn_set_notification(NotificationSeverity::ERROR, __('error'), __('cp_new_buying_types.error.bad_type_C'));
            return [CONTROLLER_STATUS_REDIRECT, fn_url($product_id ? "products.view?product_id=$product_id" : '')];
        }

        $cart = [];
        fn_clear_cart($cart);

        if ($payment_id = fn_cp_get_buying_type_payment_id(ProductBuyingTypes::CONTACT_VENDOR)) {
            $cart = fn_checkout_update_payment($cart, $auth, $payment_id);
        }

        if ($shipping_id = fn_cp_get_buying_type_shipping_id(ProductBuyingTypes::CONTACT_VENDOR)) {
            fn_checkout_update_shipping($cart, [$shipping_id]);
        }

        fn_add_product_to_cart([
            $product_id => [
                'product_id' => $product_id,
                'amount'     => $amount,
            ]
        ], $cart, $auth);

        $cart['change_cart_products'] = true;
        $cart['cp_buying_type'] = ProductBuyingTypes::CONTACT_VENDOR;
        $cart['notes'] = $_REQUEST['message'];
        fn_calculate_cart_content($cart, $auth, 'E');

        [$order_id] = fn_place_order($cart, $auth);

        if ($order_id) {
            $settings = Registry::get('addons.cp_new_buying_types');
            $uploaded_data = fn_filter_uploaded_data(
                'attachments',
                explode(',', $settings['attachment_supported_formats'])
            );

            if (!empty($uploaded_data)) {
                $uploaded_data = array_values($uploaded_data);
                $order_attachments = Storage::instance('cp_order_attachments');
                
                for ($i = 0; $i < $settings['max_attachments']; $i++) {
                    if (empty($uploaded_data[$i])) {
                        break;
                    }

                    $file_name = $uploaded_data[$i]['name'];
                    $path = "$order_id/$file_name";

                    $order_attachments->put($path, [
                        'file' => $uploaded_data[$i]['path']
                    ]);
                }
            }

            fn_set_notification(NotificationSeverity::NOTICE, __('notice'), __('cp_new_buying_types.successful_send_inquiry'));
        } else {
            fn_set_notification(NotificationSeverity::ERROR, __('error'), __('cp_new_buying_types.error.bad_type_C'));
        }

        return [CONTROLLER_STATUS_REDIRECT, fn_url($_REQUEST['return_url'] ?? "products.view?product_id=$product_id")];
    }

    if ($mode === 'add') {
        if (empty($_REQUEST['product_data'])) {
            return;
        }

        foreach ($_REQUEST['product_data'] as $key => $product_datum) {
            $product_id = (int)(!empty($product_datum['product_id']) ? $product_datum['product_id'] : $key);

            if (!fn_cp_check_product_by_buying_type($product_id, ProductBuyingTypes::BUY)) {
                unset($_REQUEST['product_data'][$key]);
            }
        }
    }

    return;
}
