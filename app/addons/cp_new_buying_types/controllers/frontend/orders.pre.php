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

defined('BOOTSTRAP') || die('Access denied');

/**
 * @var array  $auth
 * @var string $mode
 */

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    return;
}

if ($mode === 'reorder') {
    $order_buying_type = db_get_field(
        "SELECT cp_buying_type 
            FROM ?:orders
            WHERE order_id = ?i
        ", $_REQUEST['order_id']
    );

    if ($order_buying_type !== ProductBuyingTypes::BUY) {
        return [CONTROLLER_STATUS_REDIRECT, 'orders.details?order_id=' . $_REQUEST['order_id']];
    }
}
