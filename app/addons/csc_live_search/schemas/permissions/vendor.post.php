<?php
use Tygh\Registry;
use Tygh\CscLiveSearch;


$ls_settings = CscLiveSearch::_get_option_values();

if (!empty($ls_settings['vendor_history_access']) && $ls_settings['vendor_history_access']!='D'){
	$schema['controllers']['csc_live_search']['modes']['history'] = ['permissions' => true];
}
return $schema;
