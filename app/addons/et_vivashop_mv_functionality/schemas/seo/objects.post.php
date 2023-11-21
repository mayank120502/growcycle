<?php

$schema['m'] = array(
    'table' => '?:companies',
    'description' => 'company',
    'dispatch' => 'companies.view',
    'item' => 'company_id',
    'condition' => '',
    'skip_lang_condition' => true,

    'name' => 'company',
    'html_options' => array('file'),
    'option' => 'seo_other_type',

    'exist_function' => function($company_id) {
        return db_get_field('SELECT 1 FROM ?:companies WHERE company_id = ?i', $company_id);
    },
);

return $schema;
