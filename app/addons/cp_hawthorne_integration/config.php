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

fn_define('HAWTHORNE_PART_ID', 'Hawthorne part id');
fn_define('HAWTHORNE_API_URL', 'https://services.hawthornegc.com/');
fn_define('HAWTHORNE_AUTH_PATH', 'V2/token');
fn_define('HAWTHORNE_EXPIRATION_TIME', 3600);
fn_define('HAWTHORNE_IMPORT_PATH', 'V2/Part/Details');
fn_define('HAWTHORNE_REFERENCE_ID', 'growweedbates_');
fn_define('HAWTHORNE_PARSING_CATEGORY_FIELD', 'CategoryName');
fn_define('HAWTHORNE_PARSING_WEIGHT_FIELD', 'weight');
fn_define('HAWTHORNE_IMPORT_LIMIT', 1000);
fn_define('HAWTHORNE_WEIGHT_GRAM', 'G');
fn_define('HAWTHORNE_WEIGHT_KILOGRAM', 'KG');
fn_define('HAWTHORNE_WEIGHT_POUND', 'LB');
fn_define('HAWTHORNE_NUMERIC_SETTING_NAMES', ['margin_percent', 'margin_absolute']);
