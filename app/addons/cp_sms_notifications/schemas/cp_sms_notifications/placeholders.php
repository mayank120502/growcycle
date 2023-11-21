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

include_once(__DIR__ . '/placeholders.functions.php');

$schema = array( 
    'order_status' => array(
        'status' => array(
            'title' => __('status'),
            'get_function' => 'fn_cp_sn_get_status_name'
        ),
        'order_id' => array(
            'title' => __('order_id'),
            'field' => 'order_id'
        ),
        'email' => array(
            'title' => __('email'),
            'field' => 'email'
        ),
        'phone' => array(
            'title' => __('phone'),
            'field' => 'phone'
        ),
        'total' => array(
            'title' => __('total'),
            'field' => 'total'
        ),
        'firstname' => array(
            'title' => __('cp_sn_firstname'),
            'get_function' => 'fn_cp_sn_get_order_firstname'
        ),
        'lastname' => array(
            'title' => __('cp_sn_lastname'),
            'get_function' => 'fn_cp_sn_get_order_lastname'
        ),
        'address' => array(
            'title' => __('address'),
            'field' => 's_address'
        ),
        'city' => array(
            'title' => __('city'),
            'field' => 's_city'
        ),
        'country' => array(
            'title' => __('country'),
            'field' => 's_country_descr'
        )
    ),
    'shipment' => array(
        'order_id' => array(
            'title' => __('order_id'),
            'field' => 'order_id'
        ),
        'order_id' => array(
            'title' => __('order_id'),
            'field' => 'order_id'
        ),
        'email' => array(
            'title' => __('email'),
            'field' => 'email'
        ),
        'phone' => array(
            'title' => __('phone'),
            'field' => 'phone'
        ),
        'total' => array(
            'title' => __('total'),
            'field' => 'total'
        ),
        'firstname' => array(
            'title' => __('cp_sn_firstname'),
            'get_function' => 'fn_cp_sn_get_order_firstname'
        ),
        'lastname' => array(
            'title' => __('cp_sn_lastname'),
            'get_function' => 'fn_cp_sn_get_order_lastname'
        ),
        'address' => array(
            'title' => __('address'),
            'field' => 's_address'
        ),
        'city' => array(
            'title' => __('city'),
            'field' => 's_city'
        ),
        'country' => array(
            'title' => __('country'),
            'field' => 's_country'
        )
    )
);

return $schema;
