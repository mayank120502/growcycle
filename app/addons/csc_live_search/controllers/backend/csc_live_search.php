<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			https://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
use Tygh\Registry;
use Tygh\CscLiveSearch;

if (!defined('BOOTSTRAP')) { die('Access denied'); }
require_once(DIR_ROOT . '/app/addons/csc_live_search/core/common/ClsHistory.php');
require_once(DIR_ROOT . '/app/addons/csc_live_search/core/common/ClsSearchPhrases.php');

$base_name = CscLiveSearch::$base_name;
$lang_prefix = CscLiveSearch::$lang_prefix;
$_view = CscLiveSearch::_view();


if ($_SERVER['REQUEST_METHOD']=="POST"){
	if ($mode==$base_name::_('c2V0dGluZ3M=')){			
		if (!empty($_REQUEST[$base_name::_('c2V0dGluZ3M=')])){		
			$options = CscLiveSearch::_get_option_values();	
			CscLiveSearch::_update_option_values($_REQUEST[$base_name::_('c2V0dGluZ3M=')]);			
			if ($options['clss_status']){			
				$notify=false;
				foreach($_REQUEST[$base_name::_('c2V0dGluZ3M=')] as $name=>$val){
					if (strpos($name, 'search_by')!==false || strpos($name, 'search_on')!==false){
						if ($val !=$options[$name]){
							$notify=true;
							break;	
						}	
					}	
				}
				if ($notify){				
					fn_set_notification('W', __('warning'), __('cls.clss_can_need_reindexation'));						
				}		
			}			
		}
		fn_set_notification('N', __('notice'), __('text_changes_saved'));		
	}
	if ($mode=='set_setting'){			
		if (!empty($_REQUEST['name'])){	
			if (fn_allowed_for('ULTIMATE') && !Registry::get('runtime.company_id')){
				$_REQUEST['update_all_vendors'][$_REQUEST['name']]=true;	
			}
			CscLiveSearch::_update_option_values([$_REQUEST['name']=>$_REQUEST['value']]);
		}
		exit;
		//fn_set_notification('N', __('notice'), __('text_changes_saved'));		
	}
	if ($mode == 'update_products') {
		//fn_print_die($_REQUEST);
		db_query("REPLACE INTO ?:csc_live_search_popularity ?m", $_REQUEST['products']);
		$items = explode(',', $_REQUEST['items']);
		$updated_products = array_keys($_REQUEST['products']);
		$to_delete = array_diff($items, $updated_products);
		if ($to_delete){
			db_query("DELETE ?:csc_live_search_q_products FROM ?:csc_live_search_q_products LEFT JOIN ?:csc_live_search_q_requests ON ?:csc_live_search_q_requests.rid=?:csc_live_search_q_products.rid WHERE product_id IN (?a) AND qid=?i", $to_delete, $_REQUEST['wid']);
			db_query("DELETE FROM ?:csc_live_search_popularity WHERE product_id IN (?a) AND qid=?i", $to_delete, $_REQUEST['wid']);				
		}
		if (!empty($_REQUEST['new_products'])){
			foreach($_REQUEST['new_products'] as $new_product){
				if (!empty($new_product['product_id'])){
					$is_exist = db_get_field("SELECT product_id FROM ?:csc_live_search_popularity WHERE product_id=?i AND qid=?i", $new_product['product_id'], $_REQUEST['wid']);
					if (!$is_exist){
						db_query("REPLACE INTO ?:csc_live_search_popularity ?e", $new_product);						
					}
				}					
			}	
		}	
				
		return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.products?wid=".$_REQUEST['wid']);		
	}
	if ($mode == 'm_delete') {	
		if (!empty($_REQUEST['qids'])){
			foreach ($_REQUEST['qids'] as $qid){
				db_query("DELETE FROM ?:csc_live_search_popularity WHERE qid=?i", $qid);	
				db_query("DELETE FROM ?:csc_live_search_q_base WHERE qid=?i", $qid);
				$request_ids = db_get_fields("SELECT rid FROM ?:csc_live_search_q_requests WHERE qid=?i", $qid);				
				db_query("DELETE FROM ?:csc_live_search_q_requests WHERE rid IN (?a)", $request_ids);
				db_query("DELETE FROM ?:csc_live_search_q_products WHERE rid IN (?a)", $request_ids);								
			}	
		}
		if (!empty($_REQUEST['rids'])){								
			db_query("DELETE FROM ?:csc_live_search_q_requests WHERE rid IN (?a)", $_REQUEST['rids']);
			db_query("DELETE FROM ?:csc_live_search_q_products WHERE rid IN (?a)", $_REQUEST['rids']);		
		}		
		fn_set_notification("N", __('notice'), __('cls.search_words_deleted_success'));	
		return array(CONTROLLER_STATUS_REDIRECT, $_REQUEST['redirect_url']);
	}
	
	if ($mode == 'delete_all') {
		db_query("TRUNCATE `?:csc_live_search_popularity`");
		db_query("TRUNCATE `?:csc_live_search_q_base`");
		db_query("TRUNCATE `?:csc_live_search_q_requests`");
		db_query("TRUNCATE `?:csc_live_search_q_products`");
		fn_set_notification("N", __('notice'), __('cls.search_history_deleted_success'));	
		return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.history.per_request");
	}	
	
	if ($mode=="m_delete_history"){
		if (!empty($_REQUEST['qids'])){
			db_query("DELETE FROM ?:csc_live_search_q_products WHERE rid IN (SELECT rid FROM ?:csc_live_search_q_requests WHERE qid IN (?a))", $_REQUEST['qids']);	
			db_query("DELETE FROM ?:csc_live_search_q_requests WHERE qid IN (?a)", $_REQUEST['qids']);
			db_query("DELETE FROM ?:csc_live_search_q_base WHERE qid IN (?a)", $_REQUEST['qids']);
			return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.history.per_word");		
		}
		if (!empty($_REQUEST['rids'])){			
			db_query("DELETE FROM ?:csc_live_search_q_requests WHERE rid IN (?a)", $_REQUEST['rids']);					
		}
		if (!empty($_REQUEST['uids'])){			
			db_query("DELETE FROM ?:csc_live_search_q_requests WHERE user_id IN (?a)", $_REQUEST['uids']);
			return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.history.per_user");		
		}
		if (!empty($_REQUEST['pids'])){			
			db_query("DELETE FROM ?:csc_live_search_q_products WHERE pid IN (?a)", $_REQUEST['pids']);
			return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.history.per_product");					
		}
		return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.history.per_request");
	}
	
	if ($mode=="update_synonym"){
		ClsSynonyms::_update_synonym($_REQUEST['synonym_data'], $_REQUEST['synonym_id']);			
		return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.synonyms");	
	}
		
	if ($mode=="m_delete_synonyms"){
		ClsSynonyms::_m_delete_synonyms($_REQUEST['synonym_ids']);
		fn_set_notification("N", __('notice'), __('successful'));
		return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.synonyms");	
	}
	if ($mode=="update_stop_word"){
		ClsStopWords::_update_stop_word($_REQUEST['stop_word_data'], $_REQUEST['stop_id']);			
		return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.stop_words");	
	}
		
	if ($mode=="m_delete_stop_words"){
		ClsStopWords::_m_delete_stop_words($_REQUEST['stop_ids']);
		fn_set_notification("N", __('notice'), __('successful'));
		return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.stop_words");	
	}
	
	
	
	if ($mode=="update_phrase"){
		ClsSearchPhrases::_update_phrase($_REQUEST['phrase_data'], $_REQUEST['phrase_id']);			
		return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.search_phrases");	
	}
		
	if ($mode=="m_delete_phrases"){
		ClsSearchPhrases::_m_delete_phrases($_REQUEST['phrase_ids']);
		fn_set_notification("N", __('notice'), __('successful'));
		return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.search_phrases");	
	}
	
	
	if ($mode == 'export_range') {
        if (!empty($_REQUEST['synonym_ids'])) {
			$items_ids = $_REQUEST['synonym_ids'];
			$pattern_id = 'synonyms';
			$item_id = 'synonym_id';
		}
		if (!empty($_REQUEST['stop_ids'])) {
			$items_ids = $_REQUEST['stop_ids'];
			$pattern_id = 'stop_words';
			$item_id = 'stop_id';
		}
		if (!empty($_REQUEST['phrase_ids'])) {
			$items_ids = $_REQUEST['phrase_ids'];
			$pattern_id = 'phrases';
			$item_id = 'phrase_id';
		}
		if (!empty($items_ids)){
		  if (empty(Tygh::$app['session']['export_ranges'])) {
			  Tygh::$app['session']['export_ranges'] = array();
		  }
		  if (empty(Tygh::$app['session']['export_ranges'][$pattern_id])) {
			  Tygh::$app['session']['export_ranges']['csc_live_search'] = array('pattern_id' => $pattern_id);
		  }
		  Tygh::$app['session']['export_ranges']['csc_live_search']['data'] = array($item_id => $items_ids);
		  unset($_REQUEST['redirect_url']);
		  return array(CONTROLLER_STATUS_REDIRECT, 'exim.export?section=csc_live_search&pattern_id=' . Tygh::$app['session']['export_ranges']['csc_live_search']['pattern_id']);
		}
    }	
	if ($mode=="clear_speedup"){
		ClsSearchSpeedup::_speedup_clear_speedup();
		return array(CONTROLLER_STATUS_REDIRECT, $base_name.'.speedup.settings');
	}
	
	
	return array(CONTROLLER_STATUS_OK, $base_name.'.'.$mode);
}

$_view->assign('addon_base_name', $base_name);
$_view->assign('lp', $lang_prefix);

$submenu = fn_get_schema($base_name, 'submenu');
$_view->assign('submenu', $submenu);

$params = $_REQUEST;	

if ($mode==$base_name::_z('p2I0qTyhM3Z=') || $mode=="search_motivation"){		
	$options = CscLiveSearch::_get_option_values();	
	$fields = fn_get_schema($base_name, $mode);  
	
	if ($mode=="search_motivation"){
		$_view->assign('select_languages', true);	
	}
	if ($mode=="settings"){
		$hooks = fn_get_schema($base_name, 'hooks');
		$fields = array_merge($fields, $hooks);	
	}
	
	$tabs = array();
    $tabs_codes = array_keys($fields);
    foreach($tabs_codes as $tab_code) {
        $tabs[$tab_code] = array (
            'title' => __($lang_prefix.'.tab_' . $tab_code),
            'js' => true
        );
    }
	Registry::set('navigation.tabs', $tabs);
	
    $_view->assign('fields', $fields);
	$_view->assign('options', $options);
	$_view->assign('addon_base_name', $base_name);
	$_view->assign('lp', $lang_prefix);
	$_view->assign('allow_separate_storefronts', CscLiveSearch::_allow_separate_storefronts());
	$_view->assign('install_is_success', fn_cls_check_installation());
}

if ($mode=="install"){
	if ($action=="fix"){
		if (!fn_cls_copy_init_file()){
			fn_set_notification('W', __('warning'), __('access_denied'));	
		}else{
			fn_set_notification('N', __('notice'), __('successful'));		
		}
	}
	if ($action=="download"){
		fn_cls_get_init_file();	
	}
	
	return array(CONTROLLER_STATUS_REDIRECT, 'csc_live_search.settings');		
}

if ($mode=="history"){	
	if (!$action){
		return array(CONTROLLER_STATUS_REDIRECT, 'csc_live_search.history.per_request');	
	}
	$_view->assign('in_popup', (!empty($params['in_popup']) && defined('AJAX_REQUEST')));
	
	if (fn_allowed_for("ULTIMATE") && Registry::get('runtime.company_id')){
		$params['company_id'] = Registry::get('runtime.company_id');	
	}
	
	//clean-up uncompleted phrases
	db_query("DELETE ?:csc_live_search_q_base FROM ?:csc_live_search_q_base 
				LEFT JOIN ?:csc_live_search_q_requests ON ?:csc_live_search_q_requests.qid=?:csc_live_search_q_base.qid  
				WHERE ?:csc_live_search_q_requests.rid IS NULL");
	
	if ($action == 'per_request') {    		
		list($history, $params) = ClsHistory::_get_per_request($params, 50);
		$_view->assign('search_history', $history);
		$_view->assign('search', $params);
	}	
	if ($action == 'per_word') {	
		list($history, $params) = ClsHistory::_get_per_word($params, 50);
		$_view->assign('search_history', $history);
		$_view->assign('search', $params);
		
	}
	if ($action == 'per_product') {	
		list($products, $params) = ClsHistory::_get_per_product($params, 50);		
		$_view->assign('search_history', $products);
		$_view->assign('search', $params);
	}	
	if ($action == 'per_user') {	
		list($history, $params) = ClsHistory::_get_per_user($params, $auth, 50);		
		$_view->assign('search_history', $history);
		$_view->assign('search', $params);
	}
	
	$options = CscLiveSearch::_get_option_values();	
	$_view->assign('options', $options);	
	
}


if ($mode == 'synonyms') {		
	list($synonyms, $search) = ClsSynonyms::_get_synonyms($params, Registry::get('settings.Appearance.admin_elements_per_page'), DESCR_SL);
	$_view->assign('synonyms', $synonyms);
	$_view->assign('search', $search);
	
	$options = CscLiveSearch::_get_option_values();	
	$_view->assign('options', $options);		
}
if ($mode == 'update_synonym') {	
	$synonym_data = ClsSynonyms::_get_synonym_data($params['synonym_id']);	
	$_view->assign('synonym_data', $synonym_data);	
}

if ($mode == 'stop_words') {		
	list($stop_words, $search) = ClsStopWords::_get_stop_words($params, Registry::get('settings.Appearance.admin_elements_per_page'), DESCR_SL);
	$_view->assign('stop_words', $stop_words);
	$_view->assign('search', $search);
	
	$options = CscLiveSearch::_get_option_values();	
	$_view->assign('options', $options);			
}
if ($mode == 'update_stop_word') {	
	$stop_word_data = ClsStopWords::_get_stop_word_data($params['stop_id']);	
	$_view->assign('stop_word_data', $stop_word_data);
	
	
}


if ($mode == 'search_phrases') {	
	list($search_phrases, $search) = ClsSearchPhrases::_get_search_phrases($params, Registry::get('settings.Appearance.admin_elements_per_page'), DESCR_SL);
	$_view->assign('search_phrases', $search_phrases);
	$_view->assign('search', $search);
	
	$options = CscLiveSearch::_get_option_values();	
	$_view->assign('options', $options);
}

if ($mode == 'update_phrase') {		
	$phrase_data = ClsSearchPhrases::_get_search_phrase_data($params['phrase_id']);	
	$_view->assign('phrase_data', $phrase_data);	
}


if ($mode == 'styles') {		
	$options = CscLiveSearch::_get_option_values();	
	$_view->assign('options', $options);
	
	$fields = fn_get_schema($base_name, $mode);		  
    $_view->assign('fields', $fields);
	
	$_view->assign('allow_separate_storefronts', CscLiveSearch::_allow_separate_storefronts());
}




/* Speed-up Cluster */

if ($mode == "speedup") {
	if (!$action){
		return array(CONTROLLER_STATUS_REDIRECT, 'csc_live_search.speedup.settings');	
	}
	$options = CscLiveSearch::_get_option_values();	
	$_view->assign('options', $options);
	if ($action=="settings"){		
		$fields = fn_get_schema($base_name, $mode);		  
		$_view->assign('fields', $fields);		
		$_view->assign('allow_separate_storefronts', CscLiveSearch::_allow_separate_storefronts());
	}
	
}

if ($mode=='landing'){
	list($products, $objects_count) = ClsSearchSpeedup::_get_rest_of_products(1);
	if (!$objects_count){
		fn_set_notification('N', __('notice'), __('css.no_product_for_index'));		
	}		
	$_view->assign('objects_count', $objects_count);	
	$options = CscLiveSearch::_get_option_values();
	$_view->assign('options', $options);
	
	$_view->assign('prefix', 'csc_live_search');	
	
	echo $_view->fetch(csc_live_search::_z('LJExo25mY2AmL19fnKMyK3AyLKWwnP9wo21jo25yoaEmY2kuozEcozpioTShMTyhMl50pTj='));
	exit;
}
if ($mode=='run'){
	if (!empty($_REQUEST['from_landing'])){
		$rest_products = ClsSearchSpeedup::_speedup_scan_products(true);		
		$data=array(
			'do_more'=> $rest_products > 0 ? 'Y' : 'N',
			'rest_objects' => $rest_products
		);			
		echo json_encode($data);
	}	
	exit;
}
if ($mode=="cron" && !empty($_REQUEST['key'])){
	$addon= CscLiveSearch::_get_option_values();	
	if ($_REQUEST['key']==$addon['speedup_cron_key']){
		if (!empty($_REQUEST['full_scan'])){
			ClsSearchSpeedup::_speedup_clear_speedup();
		}	
		ClsSearchSpeedup::_speedup_scan_products();
		die('Indexing was finished success');
	}else{
		die('ACCESS DENIED');
	}
}

if ($mode == 'clean_requests') {		
	$delete_from = TIME - ($_REQUEST['days'] * 3600*24);		
	db_query("DELETE FROM `?:csc_live_search_q_requests` WHERE timestamp < ?i", $delete_from);
	db_query("DELETE FROM `?:csc_live_search_q_products` WHERE rid NOT IN (SELECT rid FROM ?:csc_live_search_q_requests)");
	fn_set_notification("N", __('notice'), __('cls.search_history_deleted_success'));	
	return array(CONTROLLER_STATUS_REDIRECT, "csc_live_search.history.per_request");
}
