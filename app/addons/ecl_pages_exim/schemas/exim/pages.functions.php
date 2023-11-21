<?php
/*****************************************************************************
*                                                                            *
*                   All rights reserved! eCom Labs LLC                       *
* http://www.ecom-labs.com/about-us/ecom-labs-modules-license-agreement.html *
*                                                                            *
*****************************************************************************/

use Tygh\Registry;
use Tygh\Tools\SecurityHelper;

function fn_exim_set_pages($_page_id, $pages_data, $pages_delimiter, $store_name = '')
{
    if (fn_is_empty($pages_data)) {
        return false;
    }

    $paths = array();

    foreach ($pages_data as $lang => $data) {
        $_paths = array($data);

        foreach ($_paths as $k => $page_path) {
            $page = (strpos($page_path, $pages_delimiter) !== false) ? explode($pages_delimiter, $page_path) : array($page_path);
            foreach ($page as $key_page => $page) {
                $paths[$k][$key_page][$lang] = $page;
            }
        }
    }

    $company_id = 0;
    if (fn_allowed_for('ULTIMATE')) {
        if (Registry::get('runtime.company_id')) {
            $company_id = Registry::get('runtime.company_id');
        } else {
            $company_id = fn_get_company_id_by_name($store_name);

            if (!$company_id) {
                $company_data = array('company' => $store_name, 'email' => '');
                $company_id = fn_update_company($company_data, 0);
            }
        }
    }

    foreach ($paths as $key_path => $pages) {

        if (!empty($pages)) {
            $parent_id = '0';

            $updated_page = array_pop($pages);

            if (!empty($pages)) {
                foreach ($pages as $pg) {
                    $page_condition = '';
                    if (fn_allowed_for('ULTIMATE')) {
                        if (!empty($paths_store[$key_path]) && !Registry::get('runtime.company_id')) {
                            $path_company_id = fn_get_company_id_by_name($paths_store[$key_path]);
                            $page_condition = fn_get_company_condition('?:pages.company_id', true, $path_company_id);
                        } else {
                            $page_condition = fn_get_company_condition('?:pages.company_id', true, $company_id);
                        }
                    }

                    reset($pg);
                    $main_lang = key($pg);
                    $main_cat = array_shift($pg);

                    $page_id = db_get_field("SELECT ?:pages.page_id FROM ?:page_descriptions INNER JOIN ?:pages ON ?:pages.page_id = ?:page_descriptions.page_id $page_condition WHERE ?:page_descriptions.page = ?s AND lang_code = ?s AND parent_id = ?i", $main_cat, $main_lang, $parent_id);

                    if (!empty($page_id)) {
                        $parent_id = $page_id;
                    } else {

                        $page_data = array(
                            'parent_id' => $parent_id,
                            'page' =>  $main_cat,
                            'timestamp' => TIME,
                        );

                        if (fn_allowed_for('ULTIMATE')) {
                            $page_data['company_id'] = !empty($path_company_id) ? $path_company_id : $company_id;
                        }

                        $page_id = fn_update_page($page_data);

                        foreach ($pg as $lang => $pg_data) {
                            $page_data = array(
                                'parent_id' => $parent_id,
                                'page' => $pg_data,
                                'timestamp' => TIME,
                            );

                            if (fn_allowed_for('ULTIMATE')) {
                                $page_data['company_id'] = $company_id;

                                $shared_obj = array(
                                    'share_company_id' => $company_id,
                                    'share_object_id' => $page_id,
                                    'share_object_type' => 'pages'
                                );
                                db_query("REPLACE INTO ?:ult_objects_sharing ?e", $shared_obj);
                            }

                            fn_update_page($page_data, $page_id, $lang);
                        }

                        $parent_id = $page_id;
                    }

                }
            }

            foreach ($updated_page as $lang_code => $pg_name) {
                $page_data = array(
                    'parent_id' => $parent_id,
                    'page' => $pg_name,
                    //'timestamp' => TIME,
                );

                if (fn_allowed_for('ULTIMATE')) {
                    $page_data['company_id'] = $company_id;

                    $shared_obj = array(
                        'share_company_id' => $company_id,
                        'share_object_id' => $_page_id,
                        'share_object_type' => 'pages'
                    );
                    db_query("REPLACE INTO ?:ult_objects_sharing ?e", $shared_obj);
                }

                fn_update_page($page_data, $_page_id, $lang_code);
            }
        }
    }

    return true;
}

function fn_exim_pages_ultimate_share($primary_object_ids, $import_data, $auth)
{
    if (fn_allowed_for('ULTIMATE')) {

        foreach ($import_data as $_lang) { 
            foreach($_lang as $_data) {
                
                $company_id = 0;
                if (Registry::get('runtime.company_id')) {
                    $company_id = Registry::get('runtime.company_id');
                } else {
                    $store_name = !empty($_data['company']) ? $_data['company'] : '';
                    $company_id = fn_get_company_id_by_name($store_name);

                    if (!$company_id) {
                        $company_data = array('company' => $store_name, 'email' => '');
                        $company_id = fn_update_company($company_data, 0);
                    }
                }
                $old_skip_sharing_selection = Registry::get('runtime.skip_sharing_selection');
                Registry::set('runtime.skip_sharing_selection', true);
                $_page_id = db_get_field("SELECT page_id FROM ?:pages WHERE page_code = ?s", $_data['page_code']);
                Registry::set('runtime.skip_sharing_selection', $old_skip_sharing_selection);

                if (!empty($_page_id) && !empty($company_id)) {
                    $shared_obj = array(
                        'share_company_id' => $company_id,
                        'share_object_id' => $_page_id,
                        'share_object_type' => 'pages'
                    );
            
                    db_query("REPLACE INTO ?:ult_objects_sharing ?e", $shared_obj);
                }
            }
        }
    }
}
function fn_import_check_page_company_id(&$primary_object_id, &$object, &$pattern, &$options, &$processed_data, &$processing_groups, &$skip_record)
{
    if (Registry::get('runtime.company_id')) {
        if ($pattern['pattern_id'] == 'pages') {
            $object['company_id'] = Registry::get('runtime.company_id');
        }

        if (!empty($primary_object_id)) {
            reset($primary_object_id);
            list($field, $value) = each($primary_object_id);
            $company_id = db_get_field('SELECT company_id FROM ?:pages WHERE ' . $field . ' = ?s', $value);

            if ($company_id != Registry::get('runtime.company_id')) {
                $processed_data['S']++;
                $skip_record = true;
            }
        }
    }
}

function fn_exim_set_page_company($page_id, $company_name)
{
    $company_id = fn_exim_set_company('pages', 'page_id', $page_id, $company_name);

    return $company_id;
}

function fn_import_fill_pages_alt_keys($pattern, &$alt_keys, &$object, &$skip_get_primary_object_id)
{
    if (Registry::get('runtime.company_id')) {
        $alt_keys['company_id'] = Registry::get('runtime.company_id');

    } elseif (!empty($object['company'])) {
        // field store is set
        $company_id = fn_get_company_id_by_name($object['company']);
        if ($company_id !== null) {
            $alt_keys['company_id'] = $company_id;
        } else {
            $skip_get_primary_object_id = true;
        }
    } else {
        // field store is not set
        if (fn_allowed_for('ULTIMATE')) {
            $skip_get_primary_object_id = true;
        }
    }
}

function fn_exim_get_form($_page_id, $lang_code, $data)
{
    $page_type = $data['Page type'];

    if ($page_type == 'F') {
        $content = array();
        // Get form fields
        list($content['elements_data'],$content['general']) = fn_get_form_elements($_page_id, false, $lang_code);
        $json_string = json_encode($content);
        return $json_string;
    }

    return '';
}

function fn_exim_get_polls($_page_id, $lang_code, $data)
{
    $page_type = $data['Page type'];

    if ($page_type == 'P') {

        $poll = db_get_row("SELECT page_id, start_date, end_date, show_results FROM ?:polls WHERE page_id = ?i", $_page_id);

        if (empty($poll)) {
            return '';
        } else {
            $descriptions = db_get_hash_single_array("SELECT type, description FROM ?:poll_descriptions WHERE object_id = ?i AND lang_code = ?s AND type IN ('H', 'F', 'R')", array('type', 'description'), $_page_id, $lang_code);
        
            if (!empty($descriptions)) {
                $poll['header'] = $descriptions['H'];
                $poll['footer'] = $descriptions['F'];
                $poll['results'] = $descriptions['R'];
            }
        
            // Get questions and answers
            $poll['questions'] = db_get_hash_array("SELECT ?:poll_items.item_id, ?:poll_items.type, ?:poll_items.position, ?:poll_descriptions.description, ?:poll_items.required FROM ?:poll_items LEFT JOIN ?:poll_descriptions ON ?:poll_items.item_id = ?:poll_descriptions.object_id AND ?:poll_descriptions.type = 'I' AND ?:poll_descriptions.lang_code = ?s WHERE ?:poll_items.parent_id = ?i AND ?:poll_items.type IN ('Q','M', 'T') ORDER BY ?:poll_items.position", 'item_id', $lang_code, $_page_id);
        
            $poll['has_required_questions'] = false;
            foreach ($poll['questions'] as $question_id => $entry) {
                $poll['questions'][$question_id]['answers'] = db_get_hash_array("SELECT ?:poll_items.item_id, ?:poll_items.type, ?:poll_items.position, ?:poll_descriptions.description FROM ?:poll_items LEFT JOIN ?:poll_descriptions ON ?:poll_items.item_id = ?:poll_descriptions.object_id AND ?:poll_descriptions.type = 'I' AND ?:poll_descriptions.lang_code = ?s WHERE ?:poll_items.parent_id = ?i AND ?:poll_items.type IN ('A', 'O') ORDER BY ?:poll_items.position", 'item_id', $lang_code, $question_id);
        
                if ($entry['required'] == 'Y') {
                    $poll['has_required_questions'] = true;
                }
        
                // Check if answer has comments
                if ($entry['type'] == 'T') {
                    $count = db_get_field("SELECT COUNT(item_id) FROM ?:polls_answers WHERE item_id = ?i AND answer_id = 0", $question_id);
                    $poll['questions'][$question_id]['has_comments'] = $count ? true : false;
        
                } else {
                    foreach ($poll['questions'][$question_id]['answers'] as $k => $rec) {
                        if ($rec['type'] == 'O') {
                            $count = db_get_field("SELECT count(item_id) FROM ?:polls_answers WHERE item_id = ?i AND answer_id = ?i AND comment != ''", $question_id, $k);
                            $poll['questions'][$question_id]['answers'][$k]['has_comments'] = $count ? true : false;
                        } else {
                            $poll['questions'][$question_id]['answers'][$k]['has_comments'] = false;
                        }
                    }
                }
            }
        
            // Check if poll completed by the current user
            $ip = fn_get_ip();
            $poll['completed'] = db_get_field(
                "SELECT vote_id FROM ?:polls_votes WHERE page_id = ?i AND ip_address = ?s",
                $_page_id,
                fn_ip_to_db($ip['host'])
            );
        
            if (!empty($poll['completed']) || AREA == 'A') {
                fn_polls_get_results($poll);
            }
    
            $json_string = json_encode($poll);
            return $json_string;
        }
    
    }

    return '';
}

function fn_exim_get_tags($_page_id)
{
    list($tags) = fn_get_tags(array(
        'object_type' => 'A',
        'object_id' => $_page_id
    ));

    $json_string = json_encode($tags);

    return empty($tags)? '' : $json_string;
}

function fn_exim_set_polls($_page_id, $_page_type, $_column, $lang_code)
{
    if ($_page_type == 'P') {
        fn_print_r("fn_exim_set_polls");
        if (!empty($_column[$lang_code])) {
            $data = json_decode($_column[$lang_code], true);

            if (empty($_page_id)) {
                return;
            }
        
            $exists = db_get_field('SELECT COUNT(*) FROM ?:polls WHERE page_id = ?i', $_page_id) ? true : false;
        
            $types = array (
                'H' => 'header',
                'F' => 'footer',
                'R' => 'results'
            );
        
            if (empty($exists)) {
                $data['page_id'] = $_page_id;
                db_query('INSERT INTO ?:polls ?e', $data);
        
                foreach ($types as $type => $elm) {
                    $_data = array (
                        'description' => $data[$elm],
                        'object_id' => $_page_id,
                        'type' => $type,
                        'page_id' => $_page_id
                    );
        
                    foreach (fn_get_translation_languages() as $_data['lang_code'] => $v) {
                        db_query("INSERT INTO ?:poll_descriptions ?e", $_data);
                    }
                }
        
            } else {
                unset($data['page_id']);
                db_query('UPDATE ?:polls SET ?u WHERE page_id = ?i', $data, $_page_id);
        
                foreach ($types as $type => $elm) {
                    $_data = array (
                        'description' => $data[$elm],
                    );
        
                    db_query('UPDATE ?:poll_descriptions SET ?u WHERE object_id = ?i AND lang_code = ?s AND type = ?s', $_data, $page_id, $lang_code, $type);
                }
            }

            fn_exim_polls_update_question($data['questions'], $_page_id, $lang_code);
        }
    }
}

function fn_exim_set_form($_page_id, $_page_type, $_column, $lang_code)
{
    if ($_page_type == 'F') {
        fn_print_r("fn_exim_set_form");
        if (!empty($_column[$lang_code])) {
            $data = json_decode($_column[$lang_code], true);
            fn_exim_form_builder_update_page($data, $_page_id, $lang_code);
        }
    }
}

function fn_exim_set_tags($_page_id, $_data)
{
    $tags = json_decode($_data, true);

    if (isset($tags)) {
        if (!empty($_data)) {
            fn_update_tags(array(
                'object_type' => 'P',
                'object_id' => $_page_id,
                'values' => $tags
            ), false);
        } else {
            $params = array(
                'object_id' => $_page_id,
                'object_type' => 'P',
                'company_id' => Registry::get('runtime.company_id')
            );
            fn_delete_tags_by_params($params);
        }
    }
}

function fn_exim_form_builder_update_page($form, $page_id, $lang_code = DESCR_SL)
{
    $elements_data = empty($form['elements_data']) ? array() : $form['elements_data'];
    $general_data = empty($form['general']) ? array() : $form['general'];

    $elm_ids = array();

    if (!empty($elements_data)) {

        // process elements
        foreach ($elements_data as $data) {

            if (empty($data['description']) && $data['element_type'] != FORM_SEPARATOR) {
                continue;
            }

            if (!empty($data['element_type']) && strpos(FORM_HEADER . FORM_SEPARATOR, $data['element_type']) !== false) {
                $data['required'] = 'N';
            }

            $exists = db_get_field("SELECT COUNT(*) FROM ?:form_options WHERE page_id = ?i AND element_id = ?i", $page_id, $data['element_id']) ? true : false;;
            $data['page_id'] = $page_id;

            if ($exists) {
                $data['object_id'] = $element_id = $data['element_id'];
                db_query('UPDATE ?:form_options SET ?u WHERE element_id = ?i', $data, $element_id);
                db_query('UPDATE ?:form_descriptions SET ?u WHERE object_id = ?i AND lang_code = ?s', $data, $element_id, $lang_code);
            } else {
                unset($data['element_id']);
                $data['object_id'] = $element_id = db_query('INSERT INTO ?:form_options ?e', $data);
                foreach (fn_get_translation_languages() as $data['lang_code'] => $_v) {
                    db_query('INSERT INTO ?:form_descriptions ?e', $data);
                }
            }

            $elm_ids[] = $element_id;

            // process variants
            if (!empty($data['variants'])) {
                foreach ($data['variants'] as $k => $v) {

                    if (empty($v['description'])) {
                        continue;
                    }

                    $v['parent_id'] = $element_id;
                    $v['element_type'] = FORM_VARIANT; // variant
                    $v['page_id'] = $page_id;

                    if (!empty($v['element_id'])) {
                        $v['object_id'] = $v['element_id'];
                        db_query('UPDATE ?:form_options SET ?u WHERE element_id = ?i', $v, $v['element_id']);
                        db_query('UPDATE ?:form_descriptions SET ?u WHERE object_id = ?i AND lang_code = ?s', $v, $v['element_id'], $lang_code);
                    } else {
                        $v['object_id'] = $v['element_id'] = db_query('INSERT INTO ?:form_options ?e', $v);
                        foreach (fn_get_translation_languages() as $v['lang_code'] => $_v) {
                            db_query('INSERT INTO ?:form_descriptions ?e', $v);
                        }
                    }

                    $elm_ids[] = $v['element_id'];
                }
            }

        }
    }

    // update or insert general form data
    if (!empty($general_data)) {
        SecurityHelper::sanitizeObjectData('form_general_data', $general_data);
        //$gdata = fn_trusted_vars('general_data', true);
        foreach ($general_data as $type => $data) {

            $elm_id = db_get_field("SELECT element_id FROM ?:form_options WHERE page_id = ?i AND element_type = ?s", $page_id, $type);
            $_description = array();
            $_data = array (
                'element_type' => $type,
                'page_id' => $page_id,
                'status' => 'A',
            );

            if (in_array($type, array(FORM_RECIPIENT, FORM_IS_SECURE, FORM_SUBJECT))) {
                $_data['value'] = $data;
                if ($type == FORM_SUBJECT && !empty($_data['value']) && !in_array($_data['value'], $elm_ids)) {
                    // reset value to Form name if field specified as Subject was deleted
                    $_data['value'] = '';
                }
            }

            $_description = array(
                'description' => $data
            );

            if (empty($elm_id)) {
                $_description['object_id'] = $elm_id = db_query('INSERT INTO ?:form_options ?e', $_data);
                foreach (fn_get_translation_languages() as $_description['lang_code'] => $_v) {
                    db_query('INSERT INTO ?:form_descriptions ?e', $_description);
                }
            } else {
                db_query('UPDATE ?:form_options SET ?u WHERE element_id = ?i', $_data, $elm_id);
                db_query('UPDATE ?:form_descriptions SET ?u WHERE object_id = ?i AND lang_code = ?s', $_description, $elm_id, $lang_code);
            }

            $elm_ids[] = $elm_id;
        }
    }

    // Delete obsolete elements
    $obsolete_ids = db_get_fields("SELECT element_id FROM ?:form_options WHERE page_id = ?i AND element_id NOT IN (?n)", $page_id, $elm_ids);

    if (!empty($obsolete_ids)) {
        db_query("DELETE FROM ?:form_options WHERE parent_id IN (?n)", $obsolete_ids);
        db_query("DELETE FROM ?:form_options WHERE element_id IN (?n)", $obsolete_ids);
        db_query("DELETE FROM ?:form_descriptions WHERE object_id IN (?n)", $obsolete_ids);
    }
}

function fn_exim_polls_update_question($data, $page_id, $lang_code = DESCR_SL)
{
    $result_ids = array();

    // Process question
    foreach ($data as $k => $question) {
        // question type
        $question_type = $question['type'];
        $item_id = db_get_field("SELECT item_id FROM ?:poll_items WHERE item_id = ?i", $question['item_id']);

        // Update questions
        if (!empty($item_id)) {
            db_query("UPDATE ?:poll_items SET ?u WHERE item_id = ?i", $question, $item_id);
    
            unset($question['type']);
            db_query("UPDATE ?:poll_descriptions SET ?u WHERE object_id = ?i AND type = 'I' AND lang_code = ?s", $question, $item_id, $lang_code);
        } else {
            $question['parent_id'] = $page_id;
            $question['page_id'] = $page_id;
    
            $item_id = $question['object_id'] = db_query("REPLACE INTO ?:poll_items ?e", $question);
            $question['type'] = 'I';
            foreach (fn_get_translation_languages() as $question['lang_code'] => $_v) {
                db_query("REPLACE INTO ?:poll_descriptions ?e", $question);
            }
        }
    
        // Add-Update/delete answers
        if (!empty($question['answers'])) {
            $answers_ids = array();

            foreach ($question['answers'] as $k => &$v) {
                if (empty($v['description'])) {
                    continue;
                }

                unset($v['item_id']);
                $v['page_id'] = $page_id;
                $v['parent_id'] = $item_id;
                $v['object_id'] = db_query("REPLACE INTO ?:poll_items ?e", $v);
                $answers_ids[] = $v['object_id'];
    
                $v['type'] = 'I';
                foreach (fn_get_translation_languages() as $v['lang_code'] => $_v) {
                    db_query("REPLACE INTO ?:poll_descriptions ?e", $v);
                }
            }
    
            // Delete obsolete items
            $d_ids = db_get_fields("SELECT item_id FROM ?:poll_items WHERE item_id NOT IN (?n) AND parent_id = ?i", $answers_ids, $item_id);
            if (!empty($d_ids)) {
                db_query("DELETE FROM ?:poll_items WHERE item_id IN (?n)", $d_ids);
                db_query("DELETE FROM ?:poll_descriptions WHERE object_id IN (?n) AND type = 'I'", $d_ids);
            }
        } else {
            $d_ids = db_get_fields("SELECT item_id FROM ?:poll_items WHERE parent_id = ?i", $item_id);
            db_query("DELETE FROM ?:poll_items WHERE parent_id  = ?i", $item_id);
            db_query("DELETE FROM ?:poll_descriptions WHERE object_id IN (?n) AND type = 'I'", $d_ids);
        }

        $result_ids[] = $item_id;
    }

    return $result_ids;
}

function fn_exim_get_pages_discussion($_page_id)
{

    $data = fn_get_discussion($_page_id, 'A');

    if (!empty($data['type'])) {
        $return = $data['type'];
    } else {
        $return = false;
    }

    return $return;
}

function fn_exim_set_pages_discussion($_page_id, $value)
{
    $allow_discussion_type = 'BCRD';

    if (empty($value) || strpos($allow_discussion_type, $value) === false) {
        $value = 'D';
    }

    $page_company_id = db_get_field('SELECT company_id FROM ?:pages WHERE page_id = ?i', $_page_id);

    if (!empty($page_company_id)) {
        $product_data['company_id'] = $page_company_id;
    } else {
        if (Registry::get('runtime.company_id')) {
            $page_company_id = Registry::get('runtime.company_id');
        }
    }

    $discussion = array(
        'object_type' => 'A',
        'object_id' => $_page_id,
        'type' => $value,
        'company_id' => $page_company_id
    );

    fn_update_discussion($discussion);

    return true;
}

function fn_get_page_path($page_id = 0, $lang_code = CART_LANGUAGE, $path_separator = '/')
{
    $page_path = false;

    if (!empty($page_id)) {

        $id_path = db_get_field("SELECT id_path FROM ?:pages WHERE page_id = ?i", $page_id);

        $page_names = db_get_hash_single_array(
            "SELECT page_id, page FROM ?:page_descriptions WHERE page_id IN (?n) AND lang_code = ?s",
            array('page_id', 'page'), explode('/', $id_path), $lang_code
        );

        $path = explode('/', $id_path);
        $_page_path = '';
        foreach ($path as $v) {
            $_page_path .= $page_names[$v] . $path_separator;
        }
        $_page_path = rtrim($_page_path, $path_separator);

        $page_path = (!empty($_page_path) ? $_page_path : false);
    }

    return $page_path;
}