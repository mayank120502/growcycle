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

use Tygh\Storage;

defined('BOOTSTRAP') || die('Access denied');

/**
 * @var array  $auth
 * @var string $mode
 */

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    return;
}

if ($mode === 'details') {
    Tygh::$app['view']->assign([
        'cp_order_attachments' => Storage::instance('cp_order_attachments')->getList($_REQUEST['order_id'] ?? 0)
    ]);
}

if ($mode === 'cp_download_attachment') {
    $order_id = $_REQUEST['order_id'] ?? 0;

    if (!db_get_field(
        "SELECT 1 
            FROM ?:orders
            WHERE order_id = ?i ?p
        ", $order_id, fn_get_company_condition()
    )) {
        return [CONTROLLER_STATUS_DENIED];
    }

    $file_name = $_REQUEST['file_name'] ?? '';
    Storage::instance('cp_order_attachments')->get("$order_id/$file_name");
}
