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

use Tygh\Enum\YesNo;

if (!defined('BOOTSTRAP')) {
    die('Access denied');
}

if ($mode == 'cp_contact_vendor') {
    $auth = Tygh::$app['session']['auth'];

    if (empty($auth['user_id'])) {

        return [CONTROLLER_STATUS_REDIRECT, 'cp_nbt_login.start_login'];
    }

    $user_data = fn_cp_nbt_get_phone($auth['user_id']);
    if ($user_data['cp_phone_verified'] == YesNo::NO) {

        return [CONTROLLER_STATUS_REDIRECT,
            "cp_nbt_login.start_login?return_url=" . urlencode($_REQUEST['return_url'])
        ];
    }
}