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

defined('BOOTSTRAP') || die('Access denied');

/**
 * @var array  $auth
 * @var string $mode
 */

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    return;
}

if ($mode === 'cp_contact_vendor') {
    $product_id = $_REQUEST['product_id'] ?? 0;
    if (
        !defined('AJAX_REQUEST')
        || empty($product_id)
        || (!fn_cp_check_product_by_buying_type($product_id, ProductBuyingTypes::CONTACT_VENDOR)
            && !fn_cp_custom_price_get_custom_price_status($product_id))
    ) {
        if (defined('AJAX_REQUEST')) {
            fn_set_notification(NotificationSeverity::ERROR, __('error'), __('cp_new_buying_types.error.bad_type_C'));
        }

        return [CONTROLLER_STATUS_REDIRECT, fn_url($product_id ? "products.view?product_id=$product_id" : '')];
    }

    /** @var \Tygh\SmartyEngine\Core $view */
    $view = Tygh::$app['view'];

    $product_data = fn_get_product_data($product_id, $auth);
    fn_gather_additional_product_data($product_data, true);

    $view->assign([
        'product_data' => $product_data,
        'return_url'   => $_REQUEST['return_url'],
        'obj'          => $_REQUEST['obj']
    ]);
}
