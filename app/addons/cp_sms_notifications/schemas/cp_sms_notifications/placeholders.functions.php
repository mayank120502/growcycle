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

function fn_cp_sn_get_status_name($object_data)
{   
    if (empty($object_data['status'])) {
        return '';
    }
    $status = $object_data['status'];
    $order_statuses = fn_get_simple_statuses(STATUSES_ORDER);
    return !empty($order_statuses[$status]) ? $order_statuses[$status] : '';
}

function fn_cp_sn_get_order_firstname($object_data)
{
    $val = '';
    if (!empty($object_data['firstname'])) {
        $val = $object_data['firstname'];
    } elseif (!empty($object_data['s_firstname'])) {
        $val = $object_data['s_firstname'];
    }
    return $val;
}

function fn_cp_sn_get_order_lastname($object_data)
{
    $val = '';
    if (!empty($object_data['lastname'])) {
        $val = $object_data['lastname'];
    } elseif (!empty($object_data['s_lastname'])) {
        $val = $object_data['s_lastname'];
    }
    return $val;
}
