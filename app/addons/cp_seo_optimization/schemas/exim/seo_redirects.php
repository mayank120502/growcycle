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

include_once(__DIR__ . '/seo_redirects.functions.php');

$schema = array(
    'section' => 'cp_seo_redirects',
    'name' => __('seo.redirects_manager'),
    'pattern_id' => 'seo_redirects',
    'key' => array('redirect_id'),
    'order' => 0,
    'table' => 'seo_redirects',
    'permissions' => array(
        'import' => 'manage_seo_rules',
        'export' => 'view_seo_rules',
    ),
    'references' => array(
        'companies' => array(
            'reference_fields' => array('company_id' => '&company_id'),
            'join_type' => 'LEFT',
            'import_skip_db_processing' => true
        ),
    ),
    'options' => array(),
    'condition' => array(
        'use_company_condition' => true,
    ),
    'export_fields' => array(
        'Redirect ID' => array(
            'db_field' => 'redirect_id',
            'alt_key' => true,
            'required' => true,
        ),
        'Lang code' => array(
            'db_field' => 'lang_code',
            'required' => true
        ),
        'From' => array(
            'db_field' => 'src',
            'required' => true,
        ),
        'Type' => array(
            'db_field' => 'type',
            'required' => true,
        ),
        'Object ID' => array(
            'db_field' => 'object_id',
        ),
        'To' => array(
            'db_field' => 'dest',
        )
    )
);

if (fn_allowed_for('ULTIMATE')) {
    $schema['export_fields']['Store'] = array(
        'table' => 'companies',
        'db_field' => 'company',
    );

    if (!Registry::get('runtime.company_id')) {
        $schema['export_fields']['Store']['required'] = true;
    }
}

return $schema;
