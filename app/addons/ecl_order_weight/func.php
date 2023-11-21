<?php
/*****************************************************************************
*                                                                            *
*                   All rights reserved! eCom Labs LLC                       *
* http://www.ecom-labs.com/about-us/ecom-labs-modules-license-agreement.html *
*                                                                            *
*****************************************************************************/

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_ecl_order_weight_calculate_cart_post(&$cart, $auth, $calculate_shipping, $calculate_taxes, $options_style, $apply_cart_promotions, $cart_products, $product_groups)
{
    $cart['weight'] = 0;
    foreach ($cart_products as $key => $item) {
        $cart['weight'] += $item['weight'] * $item['amount'];
        $cart['products'][$key]['extra']['weight'] = $item['weight'];
    }
}