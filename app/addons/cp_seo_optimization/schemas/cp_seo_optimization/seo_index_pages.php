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

$schema = [
    'product_features.compare'  => 'Y',
    'profiles.add'              => 'Y',
    'auth.login_form'           => 'Y',
    'checkout.cart'             => 'Y',
    'checkout.checkout'         => 'Y',
    'auth.recover_password'     => 'Y',
    'orders.downloads'          => 'Y',
    'orders.search'             => 'Y',
    'orders.details'            => 'Y',
    '_no_page.index'            => 'Y',
    'separate_checkout.cart'    => 'Y'
];

return $schema;