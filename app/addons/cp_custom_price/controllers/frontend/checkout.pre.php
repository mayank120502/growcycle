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

if (!defined('BOOTSTRAP')) { die('Access  denied'); }

$cart = &Tygh::$app['session']['cart'];

if ($mode == 'checkout' || $mode == 'cart') {
    if (isset($cart['products'])) {
        $products_with_custom_price = fn_cp_custom_price_get_products_with_custom_price();
        foreach ($cart['products'] as $cart_id => $product) {
            if (in_array($product['product_id'], $products_with_custom_price)) {
                fn_delete_cart_product($cart, $cart_id);

                if (fn_cart_is_empty($cart) == true) {
                    fn_clear_cart($cart);
                }

                fn_save_cart_content($cart, $auth['user_id']);

                $cart['recalculate'] = true;
                fn_calculate_cart_content($cart, $auth, 'A', true, 'F', true);
            }
        }
    }
}