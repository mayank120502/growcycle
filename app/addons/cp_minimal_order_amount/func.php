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
use Tygh\Enum\NotificationSeverity;
use Tygh\Enum\YesNo;
use Tygh\Registry;
use Tygh\Tygh;

if (!defined('BOOTSTRAP')) {
    die('Access denied');
}

/** HOOKS */

/**
 * `allow_place_order_post` - hook handler
 * cp_minimal_amount_result = sets on checkout.checkout 
 * 
 * @param array|null $cart            Array of the cart contents and user information necessary for purchase
 * @param array|null $auth            Array with authorization data
 * @param int|null   $parent_order_id Parent order id
 * @param int        $total           Order total
 * @param bool       $result          Flag determines if order can be placed
 */
function fn_cp_minimal_order_amount_allow_place_order_post($cart, $auth, $parent_order_id, $total, &$result)
{
    $controller = Registry::get('runtime.controller');
    $mode = Registry::get('runtime.mode');

    if ($controller == 'checkout' && $mode == 'checkout' && isset($cart['cp_minimal_amount_result'])) {
        $result = $cart['cp_minimal_amount_result'];
    }
}
/** HOOKS */

/**
 * cp_minimal_order_amount Install function
 * 
 * Add column `cp_min_order_amount` to companies table:
 */
function fn_cp_minimal_order_amount_install()
{
    if (!fn_cp_minimal_order_amount_if_column_exist('companies', 'cp_min_order_amount')) {
        db_query("ALTER TABLE ?:companies ADD cp_min_order_amount DECIMAL(12,2) NOT NULL default 0.00");
    }
}

/**
 * cp_minimal_order_amount Uninstall function
 * 
 * Drop column `cp_min_order_amount` from companies table:
 */
function fn_cp_minimal_order_amount_uninstall()
{
    if (fn_cp_minimal_order_amount_if_column_exist('companies', 'cp_min_order_amount')) {
        db_query("ALTER TABLE ?:companies DROP cp_min_order_amount");
    }
}

/**
 * Checks whether the column exists or not
 *
 * @param string $table Table name without prefix
 * @param string $column Column name
 *
 * @return bool
 */
function fn_cp_minimal_order_amount_if_column_exist($table, $column)
{
    $db_name = Registry::get('config.db_name');
    $table_prefix = Registry::get('config.table_prefix');
    $table_name = $table_prefix . $table;

    $result = db_get_field("SELECT * FROM information_schema.COLUMNS 
                                    WHERE TABLE_SCHEMA = ?s
                                    AND TABLE_NAME = ?s
                                    AND COLUMN_NAME = ?s", $db_name, $table_name, $column);

    return (bool) $result;
}

/**
 * Checks whether each vendor cart has collected the minimal order amount
 * 
 * @param array|null $cart Array of the cart contents and user information necessary for purchase
 * @param array $product_groups Cart product groups
 * @param bool $show_notifications Flag that determines whether notifications should be displayed
 * 
 * @return bool $can_buy Flag that determines whether the order is available
 */
function fn_cp_minimal_order_amount_check_minimal_amount_by_groups($product_groups, $cart, $show_notifications = true)
{
    $can_buy = true;
    $notifications = [];

    foreach ($product_groups as $group) {
        if (
            empty($group['company_id'])
            || empty($group['products'])
            || !$company_min_order_amount = fn_cp_minimal_order_amount_get_company_minimal_amount($group['company_id'])
        ) {
            continue;
        }

        $group_subtotal = 0;

        if (count($product_groups) == 1 && !empty($cart['subtotal'])) {
            $group_subtotal = $cart['subtotal'];
        } else {
            foreach ($group['products'] as $product) {
                if (!empty($product['price']) && !empty($product['amount'])) {
                    $group_subtotal += $product['price'] * $product['amount'];
                }
            }
        }

        if (Registry::get('addons.cp_minimal_order_amount.include_shipping_cost') == YesNo::YES && !empty($group['chosen_shippings'])) {
            $chosen_shiping = reset($group['chosen_shippings']);
            $group_subtotal += !empty($chosen_shiping['rate']) ? $chosen_shiping['rate'] : 0;

            unset($chosen_shiping);
        }
        
        if ($group_subtotal < $company_min_order_amount) {
            $can_buy = false;
            $company_name = !empty($group['company']) ? $group['company'] : fn_get_company_name($group['company_id']);
            $formatter = Tygh::$app['formatter'];

            $notification = __('cp_minimal_order_amount.can_not_place_order', ["[company]" => $company_name, "[min_amount]" => $formatter->asPrice($company_min_order_amount)]);

            if (Registry::get('addons.cp_minimal_order_amount.notifications_display_type') == NotificationDisplayTypes::SEPARATE && $show_notifications) {
                fn_set_notification(NotificationSeverity::WARNING, __('warning'), $notification);
            } else {
                $notifications[$group['company_id']] = $notification;
            }
        }
    }

    /** Set notifications to register if it's direct payment */

    if (!empty($notifications)) {
        if ($show_notifications) {
            $notification = implode("<br />", $notifications);
            fn_set_notification(NotificationSeverity::WARNING, __('warning'), $notification);
        } else {
            foreach ($notifications as $notification_company_id => $notification) {
                Registry::set('cp_minimal_order_amount.notifications.' . $notification_company_id, $notification);
            }
            
        }
    }

    return $can_buy;
}

/**
 * Checks whether there is a minimal order amount for the selected company
 * 
 * @param int $company_id Company identificator
 * 
 * @return double|false Company minimal amount or false
 */
function fn_cp_minimal_order_amount_get_company_minimal_amount($company_id)
{
    $min_amount = db_get_field("SELECT cp_min_order_amount FROM ?:companies WHERE company_id = ?i", $company_id);

    return !empty($min_amount) ? $min_amount : false;
}

/**
 * Checks whether each vendor cart has collected the minimal order amount with direct payment add-on
 * 
 * @param array $product_groups Direct payments product groups
 * 
 */
function fn_cp_minimal_order_amount_check_minimal_amount_by_separate_groups($product_groups)
{
    foreach ($product_groups as $group) {
        fn_cp_minimal_order_amount_check_minimal_amount_by_groups($group, [], false);
    }

    $notifications = Registry::get('cp_minimal_order_amount.notifications');

    if (!empty($notifications)) {
        if (Registry::get('addons.cp_minimal_order_amount.notifications_display_type') == NotificationDisplayTypes::SEPARATE) {
            foreach ($notifications as $notification) {
                fn_set_notification(NotificationSeverity::WARNING, __('warning'), $notification);
            }   
        }else {
            $notification = implode("<br />", $notifications);
            fn_set_notification(NotificationSeverity::WARNING, __('warning'), $notification);
        }
    }
}
