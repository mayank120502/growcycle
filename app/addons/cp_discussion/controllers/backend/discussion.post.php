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

if (!defined('BOOTSTRAP')) {
    die('Access denied');
}

if ($mode == 'generate_time') {
    $timestamp = fn_cp_generate_rnd_date_from_time_periods();
    $post_data['timestamp'] = $timestamp;
    $post_data['time_type'] = fn_cp_check_time_format($timestamp);
    Tygh::$app['view']->assign('post_data', $post_data);
    Tygh::$app['view']->display('addons/discussion/views/discussion_manager/components/new_discussion_popup.tpl');
}