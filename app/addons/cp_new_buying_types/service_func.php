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
use Tygh\Enum\SiteArea;

function fn_install_cp_new_buying_types()
{
    db_query(
        "ALTER TABLE ?:products ADD cp_buying_types varchar(20) NOT NULL default ?s",
        ProductBuyingTypes::VENDOR_DEFAULT
    );

    db_query(
        "ALTER TABLE ?:companies ADD cp_buying_types varchar(20) NOT NULL default ?s",
        ProductBuyingTypes::BUY
    );

    db_query(
        "ALTER TABLE ?:orders ADD cp_buying_type char(1) NOT NULL default ?s",
        ProductBuyingTypes::BUY
    );
}

function fn_uninstall_cp_new_buying_types()
{
    db_query("ALTER TABLE ?:products DROP cp_buying_types");
    db_query("ALTER TABLE ?:companies DROP cp_buying_types");
    db_query("ALTER TABLE ?:orders DROP cp_buying_type");
}

function fn_settings_variants_addons_cp_new_buying_types_buying_types_for_all(): array
{
    return fn_cp_get_all_product_buying_types();
}

function fn_settings_variants_addons_cp_new_buying_types_order_status_for_O(): array
{
    return fn_cp_new_buying_types_get_order_statuses();
}

function fn_settings_variants_addons_cp_new_buying_types_order_status_for_C(): array
{
    return fn_cp_new_buying_types_get_order_statuses();
}

function fn_settings_variants_addons_cp_new_buying_types_payment_for_O(): array
{
    return fn_cp_new_buying_types_get_payment_methods();
}

function fn_settings_variants_addons_cp_new_buying_types_payment_for_C(): array
{
    return fn_cp_new_buying_types_get_payment_methods();
}

function fn_settings_variants_addons_cp_new_buying_types_shipping_for_C(): array
{
    return fn_cp_new_buying_types_get_shipping_methods();
}

function fn_cp_new_buying_types_get_order_statuses(): array
{
    $data = [
        '' => ' -- '
    ];

    foreach (fn_get_statuses() as $status => $status_data) {
        $data[$status] = $status_data['description'];
    }

    return $data;
}

function fn_cp_new_buying_types_get_payment_methods(): array
{
    return fn_get_payments([
        'simple' => true
    ]);
}

function fn_cp_new_buying_types_get_shipping_methods(): array
{
    return array_merge([' -- '], fn_get_shippings(true));
}
