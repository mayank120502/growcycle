<?php
use Tygh\Registry;
include_once(Registry::get('config.dir.addons') . 'csc_live_search/schemas/exim/common.functions.php');

return array(
    'section' => 'csc_live_search',
    'pattern_id' => 'phrases',
    'name' => __('cls.phrases'),
    'key' => array('phrase', 'lang_code'),
    'order' => 2,
    'table' => 'csc_live_search_phrases',
	'notes' => [
        'cls.text_exim_import_phrases_note',        
    ],
    'permissions' => array(
        'import' => 'manage_languages',
        'export' => 'view_languages',
    ),
    'condition' => array(
        'conditions' => array('lang_code' => '@lang_code'),
    ),
	'range_options' => array(
        'selector_url' => 'csc_live_search.phrases',
        'object_name' => __('cls.phrases'),
    ),
    'options' => array(
        'lang_code' => array(
            'title' => 'language',
            'type' => 'languages',
            'default_value' => array(DEFAULT_LANGUAGE),
        ),
    ),	
    'export_fields' => array(
        'Phrase' => array(
            'db_field' => 'phrase',
            'alt_key' => true,
            'required' => true,
            'multilang' => true
        ),
        'Priority' => array(
            'db_field' => 'priority'                     
        ),
        'Language' => array(
            'db_field' => 'lang_code',
            'alt_key' => true,
            'required' => true,
            'multilang' => true
        ),
		'Date Added' => array(
            'db_field' => 'timestamp',
            'process_get' => array('fn_timestamp_to_date', '#this'),
            'convert_put' => array('fn_date_to_timestamp', '#this'),
			'export_only'=>true
        ),
		'User Added by' => array(
            'db_field' => 'user_id',
			'process_get' => array('fn_get_user_name', '#this'),
			'export_only'=>true
        ),
		'Status' => array(
            'db_field' => 'status'            
        ),
		'Recommended Product IDs'=>array(
			'db_field'=>'product_ids'
		)
		
    ),
    'import_process_data' => array(
        'check_lang_code' => array(
            'function' => 'fn_cls_check_data',
            'args' => array('$primary_object_id', '$object', '$processed_data', '$skip_record'),
            'import_only' => true,
        ),
    ),
    'order_by' => 'phrase_id'
);
