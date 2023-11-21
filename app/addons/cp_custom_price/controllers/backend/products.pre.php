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
use Tygh\Enum\YesNo;

defined('BOOTSTRAP') || die('Access denied');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if ($mode === 'update') {
        if (
            !empty($_REQUEST['product_data']['cp_custom_price'])
            && $_REQUEST['product_data']['cp_custom_price'] == YesNo::YES
        ) {
            if (
                !empty($_REQUEST['product_data']['cp_price_to'])
                && $_REQUEST['product_data']['cp_price_to'] > 0
                && empty($_REQUEST['product_data']['price'])
            ) {
                fn_set_notification('E', __('error'), __('cp_custom_price.error_save_product.empty_price_from'));
                return [CONTROLLER_STATUS_REDIRECT, 'products.update?product_id=' . $_REQUEST['product_id']];
            } elseif (
                !empty($_REQUEST['product_data']['cp_price_to'])
                && !empty($_REQUEST['product_data']['price'])
                && $_REQUEST['product_data']['cp_price_to'] <= $_REQUEST['product_data']['price']
            ) {
                fn_set_notification('E', __('error'), __('cp_custom_price.error_save_product.price_to_less_price_from'));
                return [CONTROLLER_STATUS_REDIRECT, 'products.update?product_id=' . $_REQUEST['product_id']];
            }
        }
    }
}