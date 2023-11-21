<?php
function fn_cls_check_data(&$primary_object_id, &$object, &$processed_data, &$skip_record)
{
	
    static $valid_codes = array();
    if (empty($valid_codes)) {
        $valid_codes = db_get_fields('SELECT lang_code FROM ?:languages');
    }
    if (!in_array($object['lang_code'], $valid_codes)) {
        $skip_record = true;
        $processed_data['S']++;
    }
	if (!$primary_object_id){
		$object['timestamp'] = TIME;
		$object['user_id'] = $_SESSION['auth']['user_id'];
	}
	
	return true;
		
}



