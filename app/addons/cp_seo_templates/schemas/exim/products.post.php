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

$schema['export_fields']['Custom H1'] = array(
    'table' => 'product_descriptions',
    'db_field' => 'cp_st_h1',
    'multilang' => true,
    'process_get' => array('fn_export_product_descr', '#key', '#this', '#lang_code', 'cp_st_h1'),
    'process_put' => array('fn_import_product_descr', '#this', '#key', 'cp_st_h1')
);

$schema['export_fields']['Custom Breadcrumb'] = array(
    'table' => 'product_descriptions',
    'db_field' => 'cp_st_custom_bc',
    'multilang' => true,
    'process_get' => array('fn_export_product_descr', '#key', '#this', '#lang_code', 'cp_st_custom_bc'),
    'process_put' => array('fn_import_product_descr', '#this', '#key', 'cp_st_custom_bc')
);

return $schema;
