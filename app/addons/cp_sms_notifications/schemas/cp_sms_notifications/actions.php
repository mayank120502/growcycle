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

$schema = array( 
    'order_status' => array(
        'name' => 'order_status',
        'title' => __('cp_sn_action_order_change'),
        'default_content' => '',
        'multiple' => true,
        'multiple_template' => 'addons/cp_sms_notifications/components/multiple_order_statuses.tpl'
    ),
    'shipment' => array(
        'name' => 'shipment',
        'title' => __('cp_sn_action_shipment'),
        'default_content' => ''
    )
);

return $schema;