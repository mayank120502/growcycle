<?php

$schema['vendor_store_blocks'] =  [
	'modes' => [
	    'delete' => [
	        'permissions' => 'manage_pages'
	    ],
	    'add'    => [
	        'permissions' => 'manage_pages'
	    ],
	],
	'permissions' => ['GET' => 'view_pages', 'POST' => 'manage_pages'],
];

$schema['vendor_banners'] =  [
	'modes' => [
	    'delete' => [
	        'permissions' => 'manage_pages'
	    ],
	    'add'    => [
	        'permissions' => 'manage_pages'
	    ],
	],
	'permissions' => ['GET' => 'view_pages', 'POST' => 'manage_pages'],
];


return $schema;