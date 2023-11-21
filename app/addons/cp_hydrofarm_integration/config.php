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

defined('BOOTSTRAP') or die('Access denied');

fn_define('HYDROFARM_PART_ID', 'Hydrofarm part id');
fn_define('HYDROFARM_API_URL', 'https://services.hydrofarmgc.com/');
fn_define('HYDROFARM_AUTH_PATH', 'V2/token');
fn_define('HYDROFARM_EXPIRATION_TIME', 3600);
fn_define('HYDROFARM_IMPORT_PATH', 'V2/Part/Details');
fn_define('HYDROFARM_REFERENCE_ID', 'growweedbates_');
fn_define('HYDROFARM_PARSING_CATEGORY_FIELD', 'CategoryName');
fn_define('HYDROFARM_PARSING_WEIGHT_FIELD', 'weight');
fn_define('HYDROFARM_IMPORT_LIMIT', 1000);
fn_define('HYDROFARM_WEIGHT_GRAM', 'G');
fn_define('HYDROFARM_WEIGHT_KILOGRAM', 'KG');
fn_define('HYDROFARM_WEIGHT_POUND', 'LB');
fn_define('HYDROFARM_NUMERIC_SETTING_NAMES', ['margin_percent', 'margin_absolute']);
