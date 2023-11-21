<?php
/*****************************************************************************
*                                                                            *
*                   All rights reserved! eCom Labs LLC                       *
* http://www.ecom-labs.com/about-us/ecom-labs-modules-license-agreement.html *
*                                                                            *
*****************************************************************************/

use Tygh\Registry;

include_once(Registry::get('config.dir.addons') . 'ecl_pages_exim/schemas/exim/pages.functions.php');
if (Registry::get('addons.seo.status') == 'A') {
    include_once(Registry::get('config.dir.addons') . 'seo/schemas/exim/seo.functions.php');
}

$schema = array(
    'section' => 'pages',
    'pattern_id' => 'pages',
    'name' => __('pages'),
    'key' => array('page_id'),
    'order' => 0,
    'table' => 'pages',
    'order_by' => 'page_id',
    'permissions' => array(
        'import' => 'manage_catalog',
        'export' => 'view_catalog',
    ),
    'references' => array(
        'page_descriptions' => array(
            'reference_fields' => array('page_id' => '#key', 'lang_code' => '#lang_code'),
            'join_type' => 'LEFT'
        ),
        'companies' => array(
            'reference_fields' => array('company_id' => '&company_id'),
            'join_type' => 'LEFT',
            'import_skip_db_processing' => true
        )
    ),
    'condition' => array(
        'use_company_condition' => true,
    ),
    'options' => array(
        'lang_code' => array(
            'title' => 'language',
            'type' => 'languages',
            'default_value' => array(DEFAULT_LANGUAGE),
        ),
        'page_delimiter' => array(
            'title' => 'page_delimiter',
            'description' => 'text_page_delimiter',
            'type' => 'input',
            'default_value' => '///'
        )
    ),
    'pre_export_process' => array(
        'add_code_for_all_pages' => array(
            'function' => 'fn_ecl_pages_exim_set_pages_codes',
            'args' => array(),
            'export_only' => true,
        ),
    ),
    'pre_processing' => array(
        'check_page_codes' => array(
            'function' => 'fn_check_page_codes',
            'args' => array('$import_data'),
            'import_only' => true,
        )
    ),
    'post_processing' => array(
        'ultimate_share' => array(
            'function' => 'fn_exim_pages_ultimate_share',
            'args' => array('$primary_object_ids', '$import_data', '$auth'),
            'import_only' => true,
        ),
    ),
    'import_get_primary_object_id' => array(
        'fill_pages_alt_keys' => array(
            'function' => 'fn_import_fill_pages_alt_keys',
            'args' => array('$pattern', '$alt_keys', '$object', '$skip_get_primary_object_id'),
            'import_only' => true,
        ),
    ),
    'range_options' => array(
        'selector_url' => 'pages.manage',
        'object_name' => __('pages'),
    ),
    'export_fields' => array(
        // Field added in this module
        'Page code' => array(
            'db_field' => 'page_code',
            'alt_key' => true,
            'required' => true,
            'alt_field' => 'page_id',
        ),
        // pages fields
        'Page id' => array(
            'db_field' => 'page_id',
            'export_only' => true
        ),
        'Page path' => array(
            'process_get' => array('fn_get_page_path', '#key', '#lang_code', '@page_delimiter'),
            'process_put' => array('fn_exim_set_pages', '#key', '#this', '@page_delimiter'),
            'multilang' => true,
            'linked' => false, // this field is not linked during import-export
        ),
        'Status' => array(
            'db_field' => 'status'
        ),
        'Page type' => array(
            'db_field' => 'page_type',
            'required' => true
        ),
        'Position' => array(
            'db_field' => 'position'
        ),
        'Date added' => array(
            'db_field' => 'timestamp',
            'process_get' => array('fn_timestamp_to_date', '#this'),
            'convert_put' => array('fn_date_to_timestamp', '#this'),
            'return_result' => true,
            'default' => array('time')
        ),
        'Localization' => array(
            'db_field' => 'localization'
        ),
        'New window' => array(
            'db_field' => 'new_window'
        ),
        'Use avail period' => array(
            'db_field' => 'use_avail_period'
        ),
        'Avail from timestamp' => array(
            'db_field' => 'avail_from_timestamp'
        ),
        'Avail till timestamp' => array(
            'db_field' => 'avail_till_timestamp'
        ),
        // page_descriptions fields
        'Language' => array(
            'table' => 'page_descriptions',
            'db_field' => 'lang_code',
            'type' => 'languages',
            'required' => true,
            'multilang' => true
        ),
        'Description' => array(
            'table' => 'page_descriptions',
            'db_field' => 'description',
            'multilang' => true,
        ),
        'Meta keywords' => array(
            'table' => 'page_descriptions',
            'db_field' => 'meta_keywords',
            'multilang' => true,
        ),
        'Meta description' => array(
            'table' => 'page_descriptions',
            'db_field' => 'meta_description',
            'multilang' => true,
        ),
        'Page title' => array(
            'table' => 'page_descriptions',
            'db_field' => 'page_title',
            'multilang' => true,
        ),
        'Link' => array(
            'table' => 'page_descriptions',
            'db_field' => 'link',
            'multilang' => true,
        ),
    ),
);

// user groups are not available for free version
if (!fn_allowed_for('ULTIMATE:FREE')) {
    $schema['export_fields']['User group IDs'] = array(
        'db_field' => 'usergroup_ids'
    );
}

if (Registry::get('addons.seo.status') == 'A') {
    $schema['references']['seo_names'] = array (
        'reference_fields' => array ('object_id' => '#key', 'type' => 'a', 'dispatch' => '', 'lang_code' => '#page_descriptions.lang_code'),
        'join_type' => 'LEFT',
        'import_skip_db_processing' => true
    );

    if (fn_allowed_for('ULTIMATE') && !Registry::get('runtime.simple_ultimate')) {
        $schema['references']['seo_names']['reference_fields']['company_id'] = '&company_id';
    }

    $schema['export_fields']['SEO name'] = array (
        'table' => 'seo_names',
        'db_field' => 'name',
        'process_put' => array ('fn_create_import_seo_name', '#key', 'a', '#this', '%Page path%', 0, '', '', '#lang_code'),
    );

    if (Registry::get('addons.seo.single_url') == 'N') {
        $schema['export_fields']['SEO name']['multilang'] = true;
    }
}

// check cs-cart feature
if (fn_allowed_for('ULTIMATE')) {
    $company_schema = array(
        'table' => 'companies',
        'db_field' => 'company',
        'process_put' => array('fn_exim_set_page_company', '#key', '#this')
    );

    $schema['export_fields']['Store'] = $company_schema;
    
    if (!Registry::get('runtime.company_id')) {
        $schema['export_fields']['Store']['required'] = true;
        $schema['export_fields']['ID path']['process_put'] = array('fn_exim_set_pages', '#key', '#this', '@page_delimiter', '%Store%');
    }
    $schema['import_process_data']['check_page_company_id'] = array(
        'function' => 'fn_import_check_page_company_id',
        'args' => array('$primary_object_id', '$object', '$pattern', '$options', '$processed_data', '$processing_groups', '$skip_record'),
        'import_only' => true,
    );
}

// Get form
if (Registry::get('addons.form_builder.status') == 'A') {
    $schema['export_fields']['Form'] = array(
        'process_get' => array('fn_exim_get_form', '#key', '#lang_code', '#row'),
        'process_put' => array('fn_exim_set_form', '#key', '%Page type%', '#this', '#lang_code'),
        'multilang' => true,
        'linked' => false, // this field is not linked during import-export
    );
}

// Get quiz
if (Registry::get('addons.polls.status') == 'A') {
    $schema['export_fields']['Polls'] = array(
        'process_get' => array('fn_exim_get_polls', '#key', '#lang_code', '#row'),
        'process_put' => array('fn_exim_set_polls', '#key', '%Page type%', '#this', '#lang_code'),
        'multilang' => true,
        'linked' => false, // this field is not linked during import-export
    );
}

// social buttons facebook_obj_type
if (Registry::get('addons.social_buttons.status') == 'A') {
    $schema['export_fields']['Facebook Obj Type'] = array(
        'db_field' => 'facebook_obj_type'
    );
}

// tags
if (Registry::get('addons.tags.status') == 'A') {
    $schema['export_fields']['Tags'] = array(
        'process_get' => array('fn_exim_get_tags', '#key'),
        'process_put' => array('fn_exim_set_tags', '#key', '#this'),
        'multilang' => true,
        'linked' => false, // this field is not linked during import-export
    );
}

// discussion
if (Registry::get('addons.discussion.status') == 'A') {
    $schema['export_fields']['Discussion'] = array (
        'process_put' => array ('fn_exim_set_pages_discussion', '#key', '#this'),
        'process_get' => array ('fn_exim_get_pages_discussion', '#key'),
        'linked' => false,
    );
}

return $schema;