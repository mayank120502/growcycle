<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			http://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
$schema['post_processing']['scan_speedup'] = array(
	'function' => 'fn_cls_speedup_exim_by_product_id',
	'args' => array('$primary_object_ids', '$import_data', '$auth'),
    'import_only' => true,
);
   
return $schema;