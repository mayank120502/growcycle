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

use Tygh\Enum\Addons\CpMinimalOrderAmount\NotificationDisplayTypes;
use Tygh\Registry;

if (!defined('BOOTSTRAP')) {
    die('Access denied');
}

/**
 * Get options for notifications display types
 * 
 * @return array $notification_display_types
 */
function fn_settings_variants_addons_cp_minimal_order_amount_notifications_display_type()
{
    if (!class_exists("Tygh\Enum\Addons\CpMinimalOrderAmount\NotificationDisplayTypes")) {
        require_once Registry::get('config.dir.addons') . 'cp_minimal_order_amount/Tygh/Enum/Addons/CpMinimalOrderAmount/NotificationDisplayTypes.php';
    }
    $notification_display_types = NotificationDisplayTypes::getDisplayTypes();

    return $notification_display_types;
}
