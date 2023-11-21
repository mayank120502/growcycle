<?php
use Tygh\Registry;
use Tygh\BlockManager\Block;
use Tygh\Languages\Languages;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_et_quick_info_update($data, $block_id, $lang_code=DESCR_SL){

  if (isset($block_id) && !empty($block_id)){
  	/* EXISTING BLOCK */
  	$block_sql          = array();
  	if (isset($data['settings'])){
  		$block_sql['data']  = serialize($data['settings']);
  	}
  	$block_sql['position']    = $data['position'];


  	db_query("UPDATE ?:et_quick_info SET ?u WHERE block_id = ?i", $block_sql, $block_id);

  	/* Block data */
  	$block_data           = array();
  	if (isset($data['title'])){
  		$block_data['title']  = $data['title'];
  	}

  	$block_data_sql             = array();
  	$block_data_sql['block_id'] 	= $block_id;
  	$block_data_sql['data']     = serialize($block_data);

  	if (!empty($block_data)){
	  	db_query("UPDATE ?:et_quick_info_title SET ?u WHERE block_id = ?i AND lang_code = ?s", $block_data_sql, $block_id, $lang_code);

	  	if (isset($data['update_all_langs']) && $data['update_all_langs']=="Y"){
	  	  db_query("UPDATE ?:et_quick_info_title SET ?u WHERE block_id = ?i", $block_data_sql, $block_id);
	  	}
	  }
	  if (fn_allowed_for('ULTIMATE') && isset($data['company_id']))
	  {
	  	$text_data['block_id']	=	$block_id;
	  	$text_data['company_id']=	$data['company_id'];
	  	$text_data['data'] 			= $data['text'];
			$text_data['content_id']=	$data['content_id'];
	  	fn_et_quick_info_update_company_text($text_data);
	  }


 }else{
    /* NEW BLOCK */

    /* Block */
    $block_sql            = array();
    $block_sql['data']    = serialize($data['settings']);
    $block_sql['position']    = $data['position'];

    $block_id=db_query("INSERT INTO ?:et_quick_info ?e", $block_sql);

    /* Block data (current language) */
    $block_data           = array();
    $block_data['title']  = $data['title'];

    $block_data_sql               = array();
    $block_data_sql['block_id']   	 = $block_id;
    $block_data_sql['data']       = serialize($block_data);
    $block_data_sql['lang_code']  = $lang_code;

    db_query("INSERT INTO ?:et_quick_info_title ?e", $block_data_sql);

    /* Block data (other languages) */
    $lang_codes = Languages::getAll();
    unset($lang_codes[$lang_code]);
    foreach ($lang_codes as $block_data_sql['lang_code'] => $v) {
      db_query("INSERT INTO ?:et_quick_info_title ?e", $block_data_sql);
    }

    if (fn_allowed_for('ULTIMATE')) 
    {
    	$text_data['block_id']	=	$block_id;
    	$text_data['company_id']=	$data['company_id'];
    	$text_data['data'] 			= $data['text'];

    	fn_et_quick_info_update_company_text($text_data);
    }
  }

  return $block_id;
}

function fn_et_get_quick_info($params=array(), $lang_code=CART_LANGUAGE){

	$block = $joins = array();
	$condition_block = $limit = '';
	$get_product_data = false;
	static $cache = array();

	if (!empty($params['limit'])) {
	  $limit = db_quote(' LIMIT 0, ?i', $params['limit']);
	}
	if (isset($params['item_ids']) && !empty($params['item_ids'])) {
	  $params['block_id']=$params['item_ids'];
	}

	if (!empty($params['block_id'])) {
	  $condition_block.=db_quote(" AND ?:et_quick_info.block_id = ?s",$params['block_id']);
	}

	if (!empty($params['active'])) {
	  $condition_block.=db_quote(" AND ?:et_quick_info.status = 'A'");
	}

	$sortings = array(
	 'position' => '?:et_quick_info.position'
	 );
	$sorting = db_sort($params,$sortings, 'position','asc');

	$fields = array (
	  '?:et_quick_info.block_id',
	  '?:et_quick_info.data as settings',
	  '?:et_quick_info.status',
	  '?:et_quick_info.position',
	  '?:et_quick_info_title.data as data',
	);

	if (isset($params['short']) && $params['short']==true) {
	  /* SHORT INFO */

	  $condition_block.=db_quote(" AND ?:et_quick_info_title.lang_code = ?s",$lang_code);
	  $block_data = db_get_hash_array(
	    "SELECT ?p FROM ?:et_quick_info " .
	    "LEFT JOIN ?:et_quick_info_title 
	      ON ?:et_quick_info_title.block_id = ?:et_quick_info.block_id ".
	    "WHERE 1 ?p ?p ?p",
	    'block_id', implode(", ", $fields), $condition_block, $limit, $sorting
	  );
	  foreach ($block_data as $key => $value) {
	    $block_data[$key]['settings']=unserialize($value['settings']);
	    $block_data[$key]['data']=unserialize($value['data']);
	  }
	  return array($block_data, $params);

	}else{
		if (!isset($cache[$params['block_id']])) {
			$condition_block.=db_quote(" AND ?:et_quick_info_title.lang_code = ?s",$lang_code);
			$block_data = db_get_row(
				  "SELECT ?p FROM ?:et_quick_info " .
				  "LEFT JOIN ?:et_quick_info_title 
				    ON ?:et_quick_info_title.block_id = ?:et_quick_info.block_id ".
				  "WHERE 1 ?p ?p ?p",
				  implode(", ", $fields), $condition_block, $limit, $sorting
				);

			if (!empty($block_data)){
			  /* Format return data */
				$block_data['settings']=unserialize($block_data['settings']);
				$block_data['data']=unserialize($block_data['data']);

				if (fn_allowed_for('ULTIMATE')) {
					$block_id=$block_data['block_id'];
					$et_block_text=fn_et_quick_info_get(Registry::get('runtime.company_id'),false,$block_id);

					$block_data['data']['text']=$et_block_text[$block_id]['v_data']['text'];
					$block_data['data']['content_id']=$et_block_text[$block_id]['content_id'];

				}


			  $cache[$params['block_id']]         = $block_data;
			}else{
			  $cache[$params['block_id']]         = array();
			}
		}
		
		$return_data= $cache[$params['block_id']];
		return array($return_data, $params);
	}
}

/* DELETE DATABASE VALUES */

function fn_et_quick_info_delete_by_id($block_id){
  if (!empty($block_id)) {

    db_query("DELETE FROM ?:et_quick_info_title WHERE block_id = ?i", $block_id);
    db_query("DELETE FROM ?:et_quick_info WHERE block_id = ?i", $block_id);

    $c_ids = db_get_fields("SELECT content_id FROM ?:et_quick_info_data WHERE block_id = ?i", $block_id);
    foreach ($c_ids as $c_id) {
    	db_query("DELETE FROM ?:et_quick_info_descr WHERE content_id = ?i", $c_id);
    }

    db_query("DELETE FROM ?:et_quick_info_data WHERE block_id = ?i", $block_id);
  }
}



function fn_et_quick_info_get($company_id,$show_empty=false,$block_id=false,$lang_code=DESCR_SL){
	$sortings = array(
	 'position' => '?:et_quick_info.position'
	 );
	$params=array();
	$sorting = db_sort($params,$sortings, 'position','asc');

  if ($show_empty==true){
		
	  	$fields = array (
	  	  '?:et_quick_info.block_id',
	  	  '?:et_quick_info.data as settings',
	  	  '?:et_quick_info.status',
	  	  '?:et_quick_info.position',
	  	  '?:et_quick_info_title.data as data',
	  	);
			$condition_block="";

		  $condition_block.=db_quote(" AND ?:et_quick_info_title.lang_code = ?s",$lang_code);
		  $condition_block.=db_quote(" AND ?:et_quick_info.status = 'A'");

		  $data = db_get_hash_array(
		    "SELECT ?p FROM ?:et_quick_info " .
		    "LEFT JOIN ?:et_quick_info_title 
		      ON ?:et_quick_info_title.block_id = ?:et_quick_info.block_id ".
		    "WHERE 1 ?p ?p",
		    'block_id', implode(", ", $fields), $condition_block, $sorting
		  );

		  foreach ($data as $key => $value) {
		  	if (isset($data[$key]['settings'])){
		    	$data[$key]['settings']=unserialize($value['settings']);
		    }
		    if (isset($data[$key]['data'])){
		    	$data[$key]['data']=unserialize($value['data']);
		    }	

		    $v_fields = array (
		      '?:et_quick_info.block_id',
		      '?:et_quick_info.data as settings',
		      '?:et_quick_info.status',
		      '?:et_quick_info.position',
		      '?:et_quick_info_data.content_id as content_id',
		      '?:et_quick_info_descr.data as v_data',
		    );

	    	$v_condition_block="";

	      $v_condition_block.=db_quote(" AND ?:et_quick_info_descr.lang_code = ?s",$lang_code);
	      $v_condition_block.=db_quote(" AND ?:et_quick_info.status = 'A'");
	      $v_condition_block.=db_quote(" AND ?:et_quick_info.block_id = ?i",$key);
	      $v_condition_block.=db_quote(" AND ?:et_quick_info_data.company_id = ?i",$company_id);

	    	$v_data = db_get_row(
	    	  "SELECT ?p FROM ?:et_quick_info " .
	    	  "LEFT JOIN ?:et_quick_info_data 
	    	    ON ?:et_quick_info_data.block_id = ?:et_quick_info.block_id ".
	    	  "LEFT JOIN ?:et_quick_info_descr 
	    	    ON ?:et_quick_info_descr.content_id = ?:et_quick_info_data.content_id ".
	    	  "WHERE 1 ?p ?p",
	    	  implode(", ", $v_fields), $v_condition_block, $sorting
	    	);
				if (!empty($v_data)){
	    		$data[$key]['v_data']=unserialize($v_data['v_data']);
	    		$data[$key]['content_id']=$v_data['content_id'];
	    	}
		  }
		  
		  
	}else{
		$fields = array (
		  '?:et_quick_info.block_id',
		  '?:et_quick_info.data as settings',
		  '?:et_quick_info.status',
		  '?:et_quick_info.position',
		  '?:et_quick_info_title.data as data',
		  '?:et_quick_info_data.content_id as content_id',
		  '?:et_quick_info_descr.data as v_data',
		);



		$condition_block="";

	  $condition_block.=db_quote(" AND ?:et_quick_info_title.lang_code = ?s",$lang_code);
	  $condition_block.=db_quote(" AND ?:et_quick_info_descr.lang_code = ?s",$lang_code);
	  
	  $condition_block.=db_quote(" AND ?:et_quick_info.status = 'A'");

	  if (!empty($company_id)) {
	    $condition_block.=db_quote(" AND ?:et_quick_info_data.company_id = ?i",$company_id);
	  }
	  if (($block_id!=false)) {
	    $condition_block.=db_quote(" AND ?:et_quick_info.block_id = ?i",$block_id);
	  }



	  $data = db_get_hash_array(
	    "SELECT ?p FROM ?:et_quick_info " .
	    "LEFT JOIN ?:et_quick_info_title 
	      ON ?:et_quick_info_title.block_id = ?:et_quick_info.block_id ".
	    "LEFT JOIN ?:et_quick_info_data 
	      ON ?:et_quick_info_data.block_id = ?:et_quick_info.block_id ".
	    "LEFT JOIN ?:et_quick_info_descr 
	      ON ?:et_quick_info_descr.content_id = ?:et_quick_info_data.content_id ".
	    "WHERE 1 ?p ?p",
	    'block_id', implode(", ", $fields), $condition_block, $sorting
	  );

	  foreach ($data as $key => $value) {
	  	if (isset($data[$key]['settings'])){
	    	$data[$key]['settings']=unserialize($value['settings']);
	    }

	    
	    if (isset($data[$key]['data'])){
	    	$data[$key]['data']=unserialize($value['data']);
	    }	

	    if (isset($data[$key]['v_data'])){
	    	$data[$key]['v_data']=unserialize($value['v_data']);
	    }	
	  }
	}



  return $data;
}


function fn_et_quick_info_update_status($id,$status){
  db_query("UPDATE ?:et_quick_info SET status = ?s WHERE block_id = ?i", $status, $id);
  fn_set_notification('N', __('notice'), __('status_changed'));

  return true;
}

function fn_et_quick_info_update_company(&$company_data, &$company_id, &$lang_code){

	$data['company_id']=$company_id;
	$data['lang_code']=$lang_code;

	if (!empty($company_data['et_quick_info'])){
		foreach ($company_data['et_quick_info'] as $key => $value) {
			$data['block_id']=$value['block_id'];

			if (!empty($value['content_id'])){
				$data['content_id']=$value['content_id'];
			}else{
				$data['content_id']=NULL;
			}

			$data['data']=$value['text'];

			fn_et_quick_info_update_company_text($data);
		}
	}
}

function fn_et_quick_info_update_company_text($data,$lang_code=DESCR_SL){

  if (isset($data['content_id']) && !empty($data['content_id'])){
  	/* EXISTING BLOCK */
  	$content_id    			= $data['content_id'];
  	
  	$block_sql          = array();

  	db_query("UPDATE ?:et_quick_info_data SET ?u WHERE content_id = ?i", $block_sql, $content_id);

  	/* Block data */
  	$block_data           = array();
  	$block_data['text']  = $data['data'];

  	$block_data_sql             = array();
  	$block_data_sql['content_id'] 	= $content_id;
  	$block_data_sql['data']     = serialize($block_data);

  	db_query("UPDATE ?:et_quick_info_descr SET ?u WHERE content_id = ?i AND lang_code = ?s", $block_data_sql, $content_id, $lang_code);

 }else{
    /* NEW BLOCK */

    /* Block */
    $block_sql            = array();
    $block_sql['block_id']    = $data['block_id'];
    $block_sql['company_id']    = $data['company_id'];

    $content_id=db_query("INSERT INTO ?:et_quick_info_data ?e", $block_sql);

    /* Block data (current language) */
    $block_data           = array();
    $block_data['text']  = $data['data'];

    $block_data_sql               = array();
    $block_data_sql['content_id'] = $content_id;
    $block_data_sql['data']       = serialize($block_data);
    $block_data_sql['lang_code']  = $lang_code;

    db_query("INSERT INTO ?:et_quick_info_descr ?e", $block_data_sql);

    /* Block data (other languages) */
    $lang_codes = Languages::getAll();
    unset($lang_codes[$lang_code]);
    foreach ($lang_codes as $block_data_sql['lang_code'] => $v) {
      db_query("INSERT INTO ?:et_quick_info_descr ?e", $block_data_sql);
    }
  }
}

function fn_et_quick_info_get_product_data_post(&$product_data, $auth, $preview, $lang_code){
	if (AREA == 'C'){
		if (fn_allowed_for('ULTIMATE')) {
			$company_id=Registry::get('runtime.company_id');
			$product_data['et_quick_info']=fn_et_quick_info_get($company_id);
			if (empty($product_data['et_quick_info'])){
				$product_data['et_quick_info']=fn_et_quick_info_get(0);
			}
		}else{
			if (isset($product_data['company_id'])){
				$company_id=$product_data['company_id'];
				$product_data['et_quick_info']=fn_et_quick_info_get($company_id);
			}
		}

	}
}

function fn_et_quick_info_update_language_post($language_data, $lang_id, $action){
	if ($action == 'add') {

		$data = db_get_array("SELECT * FROM ?:et_quick_info_descr WHERE lang_code = ?s", DEFAULT_LANGUAGE);
		foreach ($data as $_data) {
		  $_data['lang_code']=$language_data['lang_code'];

		  db_query("REPLACE INTO ?:et_quick_info_descr ?e", $_data);
		}
		$data = db_get_array("SELECT * FROM ?:et_quick_info_title WHERE lang_code = ?s", DEFAULT_LANGUAGE);
		foreach ($data as $_data) {
		  $_data['lang_code']=$language_data['lang_code'];

		  db_query("REPLACE INTO ?:et_quick_info_title ?e", $_data);
		}

	}
}