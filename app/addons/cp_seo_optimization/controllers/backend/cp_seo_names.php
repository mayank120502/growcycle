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

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if ($mode == 'delete') {
        fn_cp_seo_delete_editor_seo_name($_REQUEST['seo_name_id']);
    }
    if ($mode == 'm_delete') {
        if (!empty($_REQUEST['seo_name_ids'])) {
            foreach ($_REQUEST['seo_name_ids'] as $seo_name_id) {
                fn_cp__delete_editor_seo_name($seo_name_id);
            }
        }
    }
    if ($mode == 'm_update') {
        if (!empty($_REQUEST['seo_names'])) {
            foreach ($_REQUEST['seo_names'] as $seo_name) {
                if (empty($seo_name['seo_name_id'])) {
                    continue;
                }
                fn_cp_seo_update_editor_seo_name($seo_name['seo_name_id'], $seo_name);
            }
        }
    }
    return [CONTROLLER_STATUS_OK, 'cp_seo_names.manage'];
}

if ($mode == 'manage') {
    $params = $_REQUEST;
    list($seo_names, $search) = fn_cp_seo_get_editor_seo_names($params, Registry::get('settings.Appearance.admin_elements_per_page'));
    list($companies) = fn_get_companies([], $auth, 0);
    $schema = fn_get_schema('seo', 'objects');
    $languages = fn_get_translation_languages();

    Tygh::$app['view']->assign('seo_names', $seo_names);
    Tygh::$app['view']->assign('search', $search);
    Tygh::$app['view']->assign('companies', $companies);
    Tygh::$app['view']->assign('types', $schema);
    Tygh::$app['view']->assign('languages', $languages);
}