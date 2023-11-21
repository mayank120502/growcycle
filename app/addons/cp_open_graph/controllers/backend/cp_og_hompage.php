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

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD']  == 'POST') {

    if ($mode == 'update') {
        if (!empty($_REQUEST['homepage']['cp_og_data'])) {
            fn_cp_og_save_manual_data($_REQUEST['homepage']['cp_og_data']);
        }
    }

    return [CONTROLLER_STATUS_OK, 'cp_og_hompage.update'];
}

if ($mode == 'update') {
    $og_data = [];
    if (fn_allowed_for('MULTIVENDOR')) {
        $storefront = Tygh::$app['storefront'];
        Tygh::$app['view']->assign('selected_storefront_id', $storefront->storefront_id);
        $og_data = fn_cp_og_get_object_data('homepage', ['storefront_id' => $storefront->storefront_id]);
    } else {
        $company_id = Registry::get('runtime.company_id');
        $og_data = fn_cp_og_get_object_data('homepage', ['company_id' => $company_id]);
    }
    
    Tygh::$app['view']->assign('og_data', $og_data);
}
