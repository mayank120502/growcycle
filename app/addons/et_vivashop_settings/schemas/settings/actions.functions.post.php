<?php
function fn_settings_actions_addons_et_vivashop_settings_et_viva_product_title_rows($new_value, $old_value){
	
	if (!empty($old_value) && $new_value != $old_value) {
		fn_check_cache(array('ctpl'=>true,'cc'=>true));
	}
	return true;
}

function fn_settings_actions_addons_et_vivashop_settings_et_viva_scroll_up($new_value, $old_value){
	
	if (!empty($old_value) && $new_value != $old_value) {
		fn_check_cache(array('ctpl'=>true,'cc'=>true));
	}
	return true;
}