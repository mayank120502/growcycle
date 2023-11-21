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

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    fn_trusted_vars("section_data", "new_section_data");

    if ($mode == 'update') {
        if (is_array($_REQUEST['section_data'])) {
            fn_update_cp_company_tab_sections_data($_REQUEST['section_data']);
        }
    }

    if ($mode == 'add') {
        if (is_array($_REQUEST['new_section_data'])) {
            fn_add_cp_company_tab_sections_data($_REQUEST['new_section_data']);
            fn_set_notification(NotificationSeverity::NOTICE, __("notice"), __("cp_company_tab_updated"));
        }

    }

    if ($mode == 'delete') {
        if (is_array($_REQUEST['delete'])) {
            fn_delete_cp_company_tab_sections_data($_REQUEST['delete']);
            fn_set_notification(NotificationSeverity::NOTICE, __("notice"), __("cp_company_tab_updated"));
        }
    }

    return [CONTROLLER_STATUS_OK, 'cp_company_tab_sections.manage'];
}

//
// Get language variables values
//
if ($mode == 'manage') {

    $sections_data = fn_get_cp_company_tab_sections_data();

    Tygh::$app['view']->assign([
        'sections_data' => $sections_data
    ]);


}
