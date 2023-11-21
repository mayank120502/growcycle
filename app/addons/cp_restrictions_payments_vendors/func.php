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

use Tygh\Enum\SiteArea;

function fn_cp_restrictions_payments_vendors_update_payment_pre(&$payment_data, $payment_id, $lang_code, $certificate_file, $certificates_dir, $can_remove_offline_payment_params)
{
    $payment_data['cp_company_ids'] = empty($payment_data['cp_company_ids'])
        ? null
        : (is_array($payment_data['cp_company_ids'])
            ? implode(',', $payment_data['cp_company_ids'])
            : $payment_data['cp_company_ids']);
}

function fn_cp_restrictions_payments_vendors_prepare_checkout_payment_methods_after_get_payments($cart, $auth, $lang_code, $get_payment_groups, &$payment_methods, $get_payments_params, $cache_key)
{
    if (AREA != SiteArea::STOREFRONT) {
        return;
    }

    $cart_company_ids = fn_cp_restrictions_payments_vendors_get_cart_company_ids($cart);

    foreach ($payment_methods[$cache_key] as $payment_id => $payment) {
        if (empty($payment['cp_company_ids'])) {
            continue;
        }

        $allowed_company_ids = explode(',', $payment['cp_company_ids']);
        foreach ($cart_company_ids as $company_id) {
            if (!in_array($company_id, $allowed_company_ids)) {
                unset($payment_methods[$cache_key][$payment_id]);
                break;
            }
        }
    }
}

function fn_cp_restrictions_payments_vendors_get_cart_company_ids($cart)
{
    if (empty($cart['products'])) {
        return [];
    }

    $company_ids = [];

    foreach ($cart['products'] as $product) {
        if (!empty($product['company_id'])) {
            $company_ids[] = $product['company_id'];
        }
    }

    return array_unique($company_ids);
}
