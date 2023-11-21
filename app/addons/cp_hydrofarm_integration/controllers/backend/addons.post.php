<?php
/*****************************************************************************
*                                                        © 2013 Cart-Power   *
*           __   ______           __        ____                             *
*          / /  / ____/___ ______/ /_      / __ \____ _      _____  _____    *
*      __ / /  / /   / __ `/ ___/ __/_____/ /_/ / __ \ | /| / / _ \/ ___/    *
*     / // /  / /___/ /_/ / /  / /_/'_____'/ ____/ /_/ / |/ |/ /  __/ /        *
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

defined('BOOTSTRAP') or die('Access denied');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if ($mode == 'update' && !empty($_REQUEST['addon']) && $_REQUEST['addon'] === 'cp_hydrofarm_integration') {
        $reindex_product_ids = fn_cp_hydrofarm_mass_prices_update();
        if (!empty($reindex_product_ids)) {
            fn_cp_hydrofarm_reindex_master_products($reindex_product_ids);
        }
    }
    return [CONTROLLER_STATUS_OK];
}

$selected_addon = isset($_REQUEST['addon']) ? $_REQUEST['addon'] : '';
if ($mode == 'update' && $selected_addon == 'cp_hydrofarm_integration') {

    $options = Tygh::$app['view']->getTemplateVars('options');
    $numeric_hydrofarm_options = fn_cp_hydrofarm_get_numeric_settings_ids($options);
    Tygh::$app['view']->assign('numeric_hydrofarm_options', $numeric_hydrofarm_options);

}