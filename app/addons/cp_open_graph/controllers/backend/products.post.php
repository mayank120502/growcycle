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

if ($mode == 'update') {

    Registry::set('navigation.tabs.cp_open_graph', array (
        'title' => __('cp_open_graph'),
        'js' => true
    ));

    if (!empty($_REQUEST['product_id'])) {
        $og_data = fn_cp_og_get_object_data('product', $_REQUEST);
        if (!empty($og_data['is_manual'])) {
            $og_auto_data = fn_cp_og_get_object_data('product', $_REQUEST, true);
            Tygh::$app['view']->assign('og_auto_data', $og_auto_data);
            Tygh::$app['view']->assign('og_data', $og_data);
        } else {
            Tygh::$app['view']->assign('og_auto_data', $og_data);
        }
    }
}