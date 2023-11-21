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

    $company_id = fn_get_runtime_company_id();

    if ($mode == 'update') {
        fn_cp_jld_update_company_description($_REQUEST['company_data'], $company_id, DESCR_SL);
    }

    return array(CONTROLLER_STATUS_OK, 'cp_json_ld_company.update');
}

if ($mode == 'update') {

    $company_id = fn_get_runtime_company_id();
    $data = fn_cp_json_ld_get_company_data($company_id);

    Tygh::$app['view']->assign('company_data', $data);
}
