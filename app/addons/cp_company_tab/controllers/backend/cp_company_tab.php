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

defined('BOOTSTRAP') or die('Access denied');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if ($mode == 'manage') {

        fn_trusted_vars('company_tab_content');
        if (isset($_REQUEST['company_tab_content'])) {
            $params = $_REQUEST['company_tab_content'];
            fn_cp_company_tab_content_update($params);
            fn_set_notification(NotificationSeverity::NOTICE, __('notice'), __('text_changes_saved'));
        }
    }
    return [CONTROLLER_STATUS_OK, 'cp_company_tab.manage'];
}

if ($mode == 'manage') {

    $runtime_company_id = fn_get_runtime_company_id();
    $company_tab_content = fn_cp_company_tab_content($runtime_company_id);

    Tygh::$app['view']->assign([
        'company_tab_content' => $company_tab_content
    ]);
}
