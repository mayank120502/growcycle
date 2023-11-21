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

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_cp_payflow_install()
{
    fn_cp_payflow_uninstall();

    $data = [
        'processor' => 'CP: Payflow',
        'processor_script' => 'cp_payflow.php',
        'processor_template' => 'views/orders/components/payments/cc.tpl',
        'admin_template' => 'cp_payflow.tpl',
        'callback' => 'N',
        'type' => 'P',
        'addon' => 'cp_payflow'
    ];

    db_query('INSERT INTO ?:payment_processors ?e', $data);
}

function fn_cp_payflow_uninstall()
{
    db_query('DELETE FROM ?:payment_processors WHERE processor_script = ?s', 'cp_payflow.php');
}

function fn_is_cp_payflow_processor($processor_id = 0)
{
    return (bool) db_get_field("SELECT 1 FROM ?:payment_processors WHERE processor_id = ?i AND addon = ?s", $processor_id, 'cp_payflow');
}