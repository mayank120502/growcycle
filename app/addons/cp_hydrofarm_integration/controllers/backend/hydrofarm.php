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

use Tygh\Enum\NotificationSeverity;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD']  == 'POST') {
  
    if ($mode == 'import' && defined('AJAX_REQUEST')) {
        fn_cp_hydrofarm_import_products();
        Tygh::$app['ajax']->assign('force_redirection', fn_url('hydrofarm.import'));
    }

    if ($mode == 'process' && defined('AJAX_REQUEST')) {
        $products_imported = fn_cp_hydrofarm_process_products();
        fn_set_notification(NotificationSeverity::NOTICE, __('notice'), __('cp_hydrofarm_imported_products', ["[total]" => $products_imported]));
        Tygh::$app['ajax']->assign('force_redirection', fn_url('hydrofarm.import'));
    }
    
    return [CONTROLLER_STATUS_OK, 'hydrofarm.import'];
}

if ($mode == 'import') {
    $hydrofarm = fn_cp_hydrofarm_imported();
    Tygh::$app['view']->assign('hydrofarm', $hydrofarm);

} else if ($mode == 'master_products') {
    $hydrofarm = fn_cp_hydrofarm_imported();
    Tygh::$app['view']->assign('hydrofarm', $hydrofarm);

} else if ($mode == 'update_by_cron') {
    if (fn_cp_hydrofarm_import_products()) {
        $updatetd_products = fn_cp_hydrofarm_update_products($action);
        fn_set_notification(NotificationSeverity::NOTICE, __('notice'), __('cp_hydrofarm_updated_products', ["[total]" => $updatetd_products]));
    }
    return [CONTROLLER_STATUS_OK, 'hydrofarm.import'];
} 
