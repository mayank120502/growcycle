<?php

/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			https://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
use Tygh\Registry;

$schema['top']['addons']['items']['csc_addons']['type']='title';
$schema['top']['addons']['items']['csc_addons']['href']='csc_live_search.settings';
$schema['top']['addons']['items']['csc_addons']['position']='1200';
$schema['top']['addons']['items']['csc_addons']['title']=__("cls.csc_addons");

$schema['top']['addons']['items']['csc_addons']['subitems']['csc_live_search'] = array(
    'attrs' => array(
        'class'=>'is-addon'
    ),
    'href' => 'csc_live_search.settings',	
    'position' => 300
);

$schema['top']['administration']['items']['exim']['subitems']['csc_live_search'] = array(
    'attrs' => array(
        'class'=>'is-addon'
    ),
    'href' => 'csc_live_search.settings',	
    'position' => 300
);

$schema['top']['administration']['items']['export_data']['subitems']['csc_live_search'] = array(
	'href' => 'exim.export?section=csc_live_search',
	'position' => 5050
);

$schema['top']['administration']['items']['import_data']['subitems']['csc_live_search'] = array(
	'href' => 'exim.import?section=csc_live_search',
	'position' => 5050
);


if (fn_allowed_for('MULTIVENDOR') && Registry::get('runtime.company_id')){
	$schema['central']['website']['items']['cls.search_history'] = array(
	'href' => 'csc_live_search.history',
	'position' => 5050
);	
}

return $schema;

