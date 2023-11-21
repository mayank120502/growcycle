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

use Tygh\Tygh;

if (!defined('BOOTSTRAP')) {
    die('Access denied');
}

$cart = &Tygh::$app['session']['cart'];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    return;
}

if ($mode === 'cart') {

    if (!empty($cart['product_groups'])) {
        fn_cp_minimal_order_amount_check_minimal_amount_by_groups($cart['product_groups'], $cart);
    }
} elseif ($mode == 'checkout') {

    if (!empty($cart['product_groups'])) {
        $cart['cp_minimal_amount_result'] = fn_cp_minimal_order_amount_check_minimal_amount_by_groups($cart['product_groups'], $cart);
        Tygh::$app['view']->assign('cart', $cart);
    }
}
