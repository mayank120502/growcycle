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

use Tygh\Settings;
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if ($mode == 'update' && $_REQUEST['addon'] == 'cp_json_ld') {
        $section_id = db_get_field("SELECT section_id FROM ?:settings_sections WHERE name = ?s", 'cp_json_ld');
        if (!empty($section_id)) {
            $f_avalability_id = db_get_field("SELECT object_id FROM ?:settings_objects WHERE section_id = ?i AND name = ?s", $section_id, 'feature_availability');
            $avail_vars_string = db_get_field("SELECT object_id FROM ?:settings_objects WHERE section_id = ?i AND name = ?s", $section_id, 'avail_vars_string');
            if (!empty($f_avalability_id)) {
                $for_json = [];
                if (empty($_REQUEST['addon_data']['options'][$f_avalability_id]) || $_REQUEST['addon_data']['options'][$f_avalability_id] == 'auto') {
                    $for_json = [];
                } elseif (!empty($_REQUEST['addon_data']['avail_vars'])) {
                    $for_json = $_REQUEST['addon_data']['avail_vars'];
                } else {
                    $for_json = [];
                }
                $_POST['addon_data']['options'][$avail_vars_string] = $_REQUEST['addon_data']['options'][$avail_vars_string] = json_encode($for_json);
            }
            
            $f_condition_id = db_get_field("SELECT object_id FROM ?:settings_objects WHERE section_id = ?i AND name = ?s", $section_id, 'feature_condition');
            $cond_vars_string = db_get_field("SELECT object_id FROM ?:settings_objects WHERE section_id = ?i AND name = ?s", $section_id, 'avail_conditions_string');
            if (!empty($f_condition_id)) {
                $for_json_c = [];
                if (empty($_REQUEST['addon_data']['options'][$f_condition_id])) {
                    $for_json_c = [];
                } elseif (!empty($_REQUEST['addon_data']['cond_vars'])) {
                    $for_json_c = $_REQUEST['addon_data']['cond_vars'];
                } else {
                    $for_json_c = [];
                }
                $_POST['addon_data']['options'][$cond_vars_string] = $_REQUEST['addon_data']['options'][$cond_vars_string] = json_encode($for_json_c);
            }
        }
    }
}
