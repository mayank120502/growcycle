<?php
/*****************************************************************************
*                                                        © 2013 Cart-Power   *
*           __   ______           __        ____                             *
*          / /  / ____/___ ______/ /_      / __ \____ _      _____  _____    *
*      __ / /  / /   / __ `/ ___/ __/_____/ /_/ / __ \ | /| / / _ \/ ___/    *
*     / // /  / /___/ /_/ / /  / /_/_____/ ____/ /_/ / |/ |/ /  __/ /        *
*    /_//_/   \____/\__,_/_/   \__/     /_/    \____/|__/|__/\___/_/         *
*                                                                            *
*                                                                            *
* -------------------------------------------------------------------------- *
* This is commercial software, only users who have purchased a valid license *
* and  accept to the terms of the License Agreement can install and use this *
* program.                                                                   *
* -------------------------------------------------------------------------- *
* website: https://store.cart-power.com                                      *
* email:   sales@cart-power.com                                              *
******************************************************************************/

use Tygh\Registry;
use Tygh\SeoCache;
use Tygh\Addons\CpSeoOptimization\SeoActionChecker;
use Tygh\Addons\CpSeoOptimization\SeoSettings;

//
// Hooks
//

function fn_cp_seo_optimization_get_products_before_select(&$params, $join, &$condition, $u_condition, $inventory_join_cond, $sortings, $total, $items_per_page, $lang_code, $having)
{
    if (defined('CP_SEO_SITEMAP_RUN')) { // for sitemap
        $a_settings = Registry::get('addons.cp_seo_optimization');
        $mid_condition = [];
        $no_index_val = ['F','Y'];
        $more_condition = '';
        if (strpos($a_settings['noindex_robots'], 'noindex') !== false) {
            $no_index_val[] = 'D';
        }
        if (!empty($a_settings['noindex_hidden']['P']) && $a_settings['noindex_hidden']['P'] == 'Y') {
            $mid_condition[] = db_quote('products.status != ?s', 'A');
        }
        if (!empty($a_settings['noindex_product']['without_price']) && $a_settings['noindex_product']['without_price'] == 'Y') {
            if (!in_array('prices', $params['extend'])) {
                $params['extend'][] = 'prices';
            }
            $mid_condition[] = db_quote('prices.price = ?d', 0.00);
        }
        if (!empty($a_settings['noindex_product']['without_stock']) && $a_settings['noindex_product']['without_stock'] == 'Y') {
            $mid_condition[] = db_quote('products.amount = ?i', 0);
        }
        if (!empty($mid_condition)) {
            $implode_mid_cond = implode(' OR ', $mid_condition);
            $more_condition .= db_quote('WHEN (products.cp_seo_no_index IN (?a) AND products.cp_seo_use_addon = ?s AND (?p)) THEN 0 ', $no_index_val, 'Y', $implode_mid_cond);
        }

        $condition .= db_quote(" AND (CASE 
                        WHEN (products.cp_seo_no_index IN (?a) AND products.cp_seo_use_addon = ?s) THEN 0 ?p
                        ELSE 1 END)", $no_index_val, 'N', $more_condition);
    }
}

function fn_cp_seo_optimization_get_pages($params, $join, &$condition, $fields, $group_by, $sortings, $lang_code)
{
    if (defined('CP_SEO_SITEMAP_RUN')) { // for sitemap
        $a_settings = Registry::get('addons.cp_seo_optimization');
        $no_index_val = ['F','Y'];
        if (strpos($a_settings['noindex_robots'], 'noindex') !== false) {
            $no_index_val[] = 'D';
        }
        $condition .= db_quote(" AND ?:pages.cp_seo_no_index NOT IN (?a) AND ?:pages.cp_seo_use_addon = ?s", $no_index_val, 'N');
    }
}

function fn_cp_seo_optimization_get_route(&$req, &$result, $area, $is_allowed_url)
{
    if ($area != 'C') {
        return;
    }
    $settings = SeoSettings::instance()->get('addon');
    $url = fn_cp_seo_prepare_url($_SERVER['REQUEST_URI'], $settings);
    if ($url != $_SERVER['REQUEST_URI']) {
        $_SERVER['REQUEST_URI'] = $url;
        Registry::set('runtime.cp_force_redirect', true);
    }
    Registry::set('runtime.cp_origin_url', $_SERVER['REQUEST_URI']);
}

function fn_cp_seo_optimization_get_route_runtime($req, $area, &$result, $is_allowed_url, $controller, $mode, $action, $dispatch_extra, $current_url_params, $current_url)
{
    if ($area != 'C' || $_SERVER['REQUEST_METHOD']  != 'GET' || defined('AJAX_REQUEST')) {
        return;
    }
    $settings = SeoSettings::instance()->get('addon');
    $url = $_SERVER['REQUEST_URI'];
    $origin_url = Registry::get('runtime.cp_origin_url');
    $init_status = !empty($result[0]) ? $result[0] : INIT_STATUS_OK;
    
    $need_redirect = false;
    $processed_url = $origin_url;
    if ($url != $origin_url && $init_status != INIT_STATUS_REDIRECT) {
        $processed_url = fn_cp_seo_process_url($origin_url, $settings);
        $need_redirect = ($processed_url != $origin_url) ? true : false;
    }
    if (Registry::get('runtime.cp_force_redirect') === true) {
        $need_redirect = true;
    }
    if ($need_redirect) {
        $result = [INIT_STATUS_REDIRECT, $processed_url, false, true];
    }
}

function fn_cp_seo_optimization_url_post(&$url, $area, $original_url, $protocol, $company_id_in_url, $lang_code)
{
    if ($area != 'C') {
        return;
    }
    $check_origin_url = trim($original_url, '?');
    if (in_array($check_origin_url, ['', 'index.index', 'index.php'])) {
        return;
    }
    $settings = SeoSettings::instance()->get('addon');
    $url = fn_cp_seo_process_url($url, $settings);
}

function fn_cp_seo_optimization_seo_get_name_post(&$name, $object_type, $object_id, $dispatch, $company_id, $lang_code)
{
    $prefix_data = SeoSettings::instance()->get('seo_prefixes', $object_type);
    if (!empty($prefix_data['name'])) {
        $seo_prefix = $prefix_data['name'];
        $path = SeoCache::get('path', $object_type, $object_id, $company_id, $lang_code);
        if (defined('CP_SEO_PROD_WITH_CAT') && empty($path) && $object_type == 'p') {
            $path = db_get_field("SELECT path FROM ?:seo_names WHERE object_id = ?i AND type = ?s ?p", $object_id, $object_type, fn_get_seo_company_condition("?:seo_names.company_id"));
        }
        if (strpos($path, $seo_prefix) !== 0) {
            $path_array = empty($path) ? [] : explode('/', $path);
            fn_cp_seo_process_parent_path($path_array, $prefix_data);
            array_unshift($path_array, $seo_prefix);
            SeoCache::set($object_type, $object_id, ['seo_path' => implode('/', $path_array)], $company_id, $lang_code);
            // Parent seo cache
            SeoCache::set($prefix_data['parent'], $seo_prefix, ['seo_name' => $seo_prefix], $company_id, $lang_code);
        }
    }
}

function fn_cp_seo_optimization_validate_sef_object($path, &$seo, $vars, &$result, $objects)
{
    if (empty($seo['type']) || !empty($seo['cp_no_check_sef'])) {
        return;
    }
    $prefix_data = SeoSettings::instance()->get('seo_prefixes', $seo['type']);
    $check_path = $path;
    if (!empty($prefix_data['name']) && strpos($path, '/' . $prefix_data['name']) === 0) {
        $check_path = substr($path, strlen($prefix_data['name']) + 1);
    }
    if (!empty($seo['path'])) {
        $path_array = explode('/', $seo['path']);
        $parent_path = $check_path;
        fn_cp_seo_process_parent_path($path_array, $prefix_data, $parent_path);
        $seo['path'] = implode('/', $path_array);
        if ($parent_path != $check_path) {
            $result = false;
            return;
        }
    }
    if ($check_path != $path) {
        $result = fn_seo_validate_object($seo, $check_path, $objects);
        $seo['cp_no_check_sef'] = true; // break recursion
    }
}

function fn_cp_seo_optimization_url_before_get_storefront_location($url, $area, $protocol, $lang_code, &$company_id_in_url, $storefront_id)
{
    if (fn_allowed_for('ULTIMATE') && function_exists('fn_ult_url_before_get_storefront_location')
        && AREA == 'C' && empty($company_id_in_url)
    ) {
        fn_ult_bootstrap_company_storefront($company_id_in_url, $storefront_id);
    }
}

function fn_cp_seo_optimization_dispatch_before_display()
{
    if (AREA != 'C') {
        return;
    }
    $params = $_REQUEST;
    $addons_settings = Registry::get('addons.cp_seo_optimization');
    // Redirect for 404
    $controller_status = Registry::get('runtime.controller_status');
    if (Registry::get('runtime.controller_status') == '404') {
        $redirect_404 = $addons_settings['redirect_404'];
        if (!empty($redirect_404)) {
            $url = null;
            if ($redirect_404 == 'home') {
                $url = '';
            } elseif (strpos($redirect_404, '_') !== false) {
                list($type, $object_id) = explode('_', $redirect_404);
                $url = fn_cp_seo_get_object_url($type, $object_id);
            }
            if (isset($url)) {
                //fn_redirect($url, false, true);
                header('HTTP/1.0 301 Moved Permanently', true);
                header('Location: ' . fn_url($url), true);
            }
        }
    }

    $action_checker = new SeoActionChecker();
    $action_checker->checkNoindexParams($params);
    $action_checker->checkLocationActions($params, []);

    // Noindex
    $object_ni_value = $action_checker->getIndexValue();
    $is_from_addon = $action_checker->getIsFromAddon();
    $index_data = [];
    if ($action_checker->isCheckedAction('noindex')) {
        if (!empty($object_ni_value)) {
            $index_data['noindex'] = $object_ni_value;
        }
    } elseif (!empty($object_ni_value) && empty($is_from_addon)) {
        $index_data['noindex'] = $object_ni_value;
    }
    if (!empty($params['dispatch'])) {
        $index_rule = db_get_field("SELECT rule FROM ?:cp_seo_index_rules WHERE dispatch = ?s", $params['dispatch']);
        $index_mapping = [
            'F' => 'noindex,follow',
            'Y' => 'noindex,nofollow',
            'I' => 'index,nofollow'
        ];
        if (!empty($index_rule) && !empty($index_mapping[$index_rule])) {
            Tygh::$app['view']->assign('cp_seo_index_rule', $index_mapping[$index_rule]);
        }
    }
    Tygh::$app['view']->assign('cp_seo_index', $index_data);
    
    // Canonical
    $canonical = '';
    $seo_canonical = Tygh::$app['view']->getTemplateVars('seo_canonical');
    if ($action_checker->isCheckedAction('canonical')) {
        $canonical = $action_checker->getActionsExtra('canonical');
        
    } elseif (!empty($params['page']) && $params['page'] > 1) {
        if (!empty($seo_canonical['current'])
            && $addons_settings['first_page_canonical'] == 'Y'
        ) {
            $canonical = preg_replace('/(.*)(\/page-[\d]+)(\/)?$/si', '$1$3', $seo_canonical['current']);
        }
    }
    if (!empty($canonical)) {
        $seo_canonical['current'] = $canonical;
        Tygh::$app['view']->assign('seo_canonical', $seo_canonical);
    }
}

function fn_cp_seo_optimization_render_block_post($block, $block_schema, &$block_content, $load_block_from_cache, $display_this_block, $params)
{
    if (AREA != 'C' || strpos($block_content, '<a') === false) {
        return;
    }
    preg_match_all('/<a [^<>]*(href=[\'"]([^\'"]+)[\'"])[^<>]*>/si', $block_content, $matches);
    if (empty($matches)) {
        return;
    }
    static $extra_attrs = null;
    if (!isset($extra_attrs)) {
        $extra_attrs = [];
        $settings = SeoSettings::instance()->get('addon');
        if (!empty($settings['ext_links_nofollow']) && $settings['ext_links_nofollow'] == 'Y') {
            $extra_attrs['rel'] = 'nofollow';
        }
        if (!empty($settings['ext_links_new_window']) && $settings['ext_links_new_window'] == 'Y') {
            $extra_attrs['target'] = '_blank';
        }
    }
    if (!empty($extra_attrs)) {
        $site_url = fn_cp_seo_get_site_url();
        foreach ($matches[2] as $i => $link_url) {
            $link_html = $matches[0][$i];
            $href_html = $matches[1][$i];
            if (!fn_cp_seo_check_site_url($site_url, $link_url)) {
                $attrs_html = '';
                foreach ($extra_attrs as $attr_key => $attr_value) {
                    if (strpos($link_html, " {$attr_key}=") === false) {
                        $attrs_html .= " {$attr_key}=\"{$attr_value}\"";
                    }
                }
                if (!empty($attrs_html)) {
                    $result_link = str_replace($href_html, $href_html . $attrs_html, $link_html);
                    $block_content = str_replace($link_html, $result_link, $block_content);
                }
            }
        }
    }
}

function fn_cp_seo_optimization_update_page_before(&$page_data, $page_id, $lang_code)
{
    $page_data['cp_seo_lastmod'] = TIME;
}

function fn_cp_seo_optimization_update_category_pre(&$category_data, $category_id, $lang_code)
{
    $category_data['cp_seo_lastmod'] = TIME;
}

function fn_cp_seo_optimization_update_product_count_post($category_ids)
{
    if (empty($category_ids)) {
        return;
    }
    db_query(
        'UPDATE ?:categories SET cp_seo_lastmod = ?i WHERE category_id IN (?n)',
        TIME, $category_ids
    );
}

//
// Base functions
//

function fn_cp_seo_check_site_url($site_url, $check_url)
{
    $check_result = false;
    preg_match('/^((http[s]?:)?\/\/)(.*)/si', $check_url, $matches);
    if (empty($matches[3])
        || preg_match('~^(' . preg_quote($site_url, '~') . '([/|\?].*)?$)~si', $matches[3])
    ) {
        $check_result = true;
    }
    return $check_result;
}

function fn_cp_seo_prepare_url($url, $params = [])
{
    if (!empty($params['exclude_m_slashes'])
        && $params['exclude_m_slashes'] == 'Y'
    ) {
        $parsed_url = parse_url($url);
        if (!empty($parsed_url['path'])) {
            $path = preg_replace('/(\/){2,}/', '/', $parsed_url['path']);
            if ($path != $parsed_url['path']) {
                $url = str_replace($parsed_url['path'], $path, $url);
            }
        }
    }
    return $url;
}

function fn_cp_seo_process_url($url, $params = [])
{
    $parsed_url = parse_url($url);
    if (empty($parsed_url['query']) && !empty($params['url_slash'])) {
        $path_info = fn_pathinfo($url);
        if (!empty($path_info['extension'])) {
            return $url;
        }
        if ($params['url_slash'] == 'add') {
            if (substr($url, -1) != '/' && !preg_match('/\.html$/', $url)) {
                $url .= '/';
            }
        } elseif ($params['url_slash'] == 'remove') {
            if (substr($url, -1) == '/') {
                $url = rtrim($url, '/');
            }
        }
    }
    return $url;
}

function fn_cp_seo_process_parent_path(&$path_array, $prefix_data, &$real_path = '')
{
    if (isset($prefix_data['path_limit'])) {
        $offset = 0;
        $path_limit = intval($prefix_data['path_limit']);
        if ($path_limit < 0) {
            $offset = $path_limit;
            $path_limit = abs($path_limit);
        }
        $path_array = !empty($path_limit)
            ? array_slice($path_array, $offset, $path_limit)
            : [];

        if (!empty($real_path) && !empty($path_limit)) {
            $old_real_path = $real_path;
            $real_path = ltrim($real_path, '/');
            $slash = ($old_real_path != $real_path) ? '/' : '';
            $real_path = $slash . implode('/', array_slice(explode('/', $real_path), $offset, $path_limit));
        }
    }
}

//
// Common functions
//

function fn_cp_seo_get_site_url()
{
    static $site_url = null;
    if (!isset($site_url)) {
        $site_url = Registry::get('config.current_host') . Registry::get('config.current_path');
    }
    return $site_url;
}

function fn_cp_seo_is_bot()
{
    $result = false;
    if (!empty($_SERVER['HTTP_USER_AGENT'])) {
        $result = preg_match(
            '/bot|crawl|curl|dataprovider|search|get|spider|find|java|majesticsEO'
            . '|google|yahoo|teoma|contaxe|yandex|libwww-perl|facebookexternalhit/i',
            $_SERVER['HTTP_USER_AGENT']
        );
    }
    return $result;
}

function fn_cp_seo_get_start_day_time()
{
    return strtotime('now 00:00:00');
}

//
// Object SEO settings
//

function fn_cp_seo_get_objects()
{
    return SeoSettings::instance()->get('seo_objects');
}

function fn_cp_seo_get_object_canonical($type, $object_id)
{
    $canonical = '';
    $data = fn_cp_seo_get_object_data($type, $object_id);
    if (empty($data['extra']['canonical'])) {
        return $canonical;
    }
    $extra = $data['extra']['canonical'];
    if (!empty($extra['type'])) {
        if (!empty($extra['object_id'])) {
            $canonical = fn_cp_seo_get_object_url($extra['type'], $extra['object_id']);
        } elseif (!empty($extra['src'])) {
            $canonical = fn_url($extra['src']);
        }
    }
    return $canonical;
}

function fn_cp_seo_get_object_noindex($type, $object_id)
{
    $data = fn_cp_seo_get_object_data($type, $object_id);
    return !empty($data['no_index']) && $data['no_index'] == 'Y' ? true : false;
}

function fn_cp_seo_get_object_url($type, $object_id)
{
    $url = '';
    $object = SeoSettings::instance()->get('seo_objects', $type);
    if (!empty($object['link'])) {
        $link = str_replace('[object_id]', $object_id, $object['link']);
        $url = fn_url($link);
    }
    return $url;
}

function fn_cp_seo_get_object_data($type, $object_id)
{
    static $data = [];
    if (!isset($data[$type][$object_id])) {
        $link_id = fn_cp_seo_get_link_id($type, $object_id);
        $data[$type][$object_id] = !empty($link_id) ? fn_cp_seo_get_link_data($link_id) : [];
    }
    return $data[$type][$object_id];
}

function fn_cp_seo_update_object_data($type, $object_id, $data)
{
    if (!isset($data['cp_seo_use'])) {
        return false;
    }
    $link_id = fn_cp_seo_get_link_id($type, $object_id);
    if ($data['cp_seo_use'] == 'Y') {
        if (!empty($data['cp_seo_data'])) {
            fn_cp_seo_update_link_data($link_id, $data['cp_seo_data']);
        }
    } elseif (!empty($link_id)) {
        fn_cp_seo_delete_link_data($link_id); // delete if not used
    }
}

function fn_cp_seo_get_link_id($type, $object_id = 0, $src = '', $lang_code = CART_LANGUAGE)
{
    $condition = db_quote('type = ?s', $type);
    $condition .= ($type == 'S')
        ? db_quote(' AND src = ?s', $src)
        : db_quote(' AND object_id = ?i', $object_id);

    if (fn_allowed_for('ULTIMATE')) {
        $condition .= fn_get_company_condition('company_id');
    }    
    if (Registry::get('addons.seo.single_url') == 'Y') {
        $lang_code = Registry::get('settings.Appearance.frontend_default_language');
    }
    $condition .= db_quote(' AND lang_code = ?s', $lang_code);
    
    $link_id = db_get_field('SELECT link_id FROM ?:cp_seo_links WHERE ?p', $condition);

    return $link_id;
}

function fn_cp_seo_get_link_data($link_id)
{   
    if (empty($link_id)) {
        return [];
    }
    $data = db_get_row('SELECT * FROM ?:cp_seo_links WHERE link_id = ?i', $link_id);
    if (!empty($data)) {
        $data['extra'] = !empty($data['extra']) ? unserialize($data['extra']) : [];
    }
    return $data;
}

function fn_cp_seo_update_link_data($link_id, $data)
{
    if (empty($data['type']) || (empty($data['object_id']) && empty($data['src']))) {
        return false;
    }

    $object_id = !empty($data['object_id']) ? $data['object_id'] : 0;
    $src = !empty($data['src']) ? $data['src'] : '';

    if (Registry::get('addons.seo.single_url') == 'Y') {
        $data['lang_code'] = Registry::get('settings.Appearance.frontend_default_language');
    }
    $data['extra'] = !empty($data['extra']) && is_array($data['extra']) ? serialize($data['extra']) : '';

    $link_id = fn_cp_seo_get_link_id($data['type'], $object_id, $src, $data['lang_code']);
    if (!empty($link_id)) {
        db_query('UPDATE ?:cp_seo_links SET ?u WHERE link_id = ?i', $data, $link_id);
    } else {
        $link_id = db_query('INSERT INTO ?:cp_seo_links ?e', $data);
    }

    return true;
}

function fn_cp_seo_delete_link_data($link_id)
{   
    db_query('DELETE FROM ?:cp_seo_links WHERE link_id = ?i', $link_id);
}

//
// SEO names editor
//

function fn_cp_seo_get_editor_seo_names($params = [], $items_per_page = 0, $lang_code = DESCR_SL)
{
    $default_params = [
        'page' => 1,
        'items_per_page' => $items_per_page
    ];
    $params = array_merge($default_params, $params);

    $params['company_id'] = fn_get_runtime_company_id();
    
    $fields = [
        '?:seo_names.*',
        '?:companies.company',
    ];
    $limit = $condition = '';
    $join = db_quote('LEFT JOIN ?:companies ON ?:seo_names.company_id = ?:companies.company_id');

    if (!empty($params['name'])) {
        $condition .= db_quote(' AND ?:seo_names.name LIKE ?l', '%' . $params['name'] . '%');
    }
    if (!empty($params['object_id'])) {
        $condition .= db_quote(' AND ?:seo_names.object_id = ?i', $params['object_id']);
    }
    if (!empty($params['company_id']) && fn_allowed_for('ULTIMATE')) {
        $condition .= db_quote(' AND ?:seo_names.company_id = ?i', $params['company_id']);
    }
    if (!empty($params['type'])) {
        $condition .= db_quote(' AND ?:seo_names.type = ?s', $params['type']);
    }
    if (!empty($params['seo_dispatch'])) {
        $condition .= db_quote(' AND ?:seo_names.dispatch LIKE ?l', '%' . $params['seo_dispatch'] . '%');
    }
    if (!empty($params['lang_code'])) {
        $condition .= db_quote(' AND ?:seo_names.lang_code = ?s', $params['lang_code']);
    }
    if (!empty($params['path'])) {
        $condition .= db_quote(' AND ?:seo_names.path LIKE ?l', '%' . $params['path'] . '%');
    }

    $sortings = [
        'name' => '?:seo_names.name',
        'object_id' => '?:seo_names.object_id',
        'company' => '?:companies.company',
        'type' => '?:seo_names.type',
        'dispatch' => '?:seo_names.dispatch',
        'path' => '?:seo_names.path',
        'lang_code' => '?:seo_names.lang_code',
    ];
    $sorting = db_sort($params, $sortings, 'name', 'asc');

    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field('SELECT count(*) FROM ?:seo_names ?p WHERE 1 ?p', $join, $condition);
        $limit = db_paginate($params['page'], $params['items_per_page']);
    }

    $seo_names = db_get_array(
        'SELECT ?p FROM ?:seo_names ?p WHERE 1 ?p ?p ?p',
        implode(', ', $fields), $join, $condition, $sorting, $limit
    );
    
    return [$seo_names, $params];
}

function fn_cp_seo_delete_editor_seo_name($seo_name_id)
{
    $check_result = fn_cp_seo_check_names_params($seo_name_id, $params);
    if (!$check_result) {
        return false;
    }
    if (!empty($params)) {
        $condition = db_quote('?w', $params);
        db_query('DELETE FROM ?:seo_names WHERE ?p', $condition);
    }
    return true;
}

function fn_cp_seo_update_editor_seo_name($seo_name_id, $data)
{
    $check_result = fn_cp_seo_check_names_params($seo_name_id, $params);
    if (!$check_result) {
        return false;
    }
    $condition = db_quote('?w', $params);
    if ($params['object_id'] != $data['object_id'] 
        || $params['type'] != $data['type']
        || $params['dispatch'] != $data['dispatch']
        || $params['lang_code'] != $data['lang_code']
        || $params['company_id'] != $data['company_id']
    ) {
        $required_fields = fn_cp_seo_get_names_required_fields();
        $check_data = array_filter($data, function ($field_key) use ($required_fields) {
            return in_array($field_key, $required_fields);
        }, ARRAY_FILTER_USE_KEY);
        $check_condition = db_quote('?w', $check_data);
        $exists = db_get_field('SELECT name FROM ?:seo_names WHERE ?p', $check_condition);
        if (empty($exists)) {
            db_query('UPDATE ?:seo_names SET ?u WHERE ?p', $data, $condition);
        } else {
            fn_set_notification('E', __('error'), __('cp_seo_name_exists_text', ['[name]' => $exists]));
            return false;
        }
    } else {
        $old_name = trim($data['old_name']);
        $name = trim($data['name']);
        if (empty($name) || $old_name == $name) {
            return false;
        }
        $exists = db_get_field(
            'SELECT name FROM ?:seo_names WHERE name = ?s AND company_id = ?i AND lang_code = ?s',
            $name, $data['company_id'], $data['lang_code']
        );
        if (empty($exists)) {
            db_query('UPDATE ?:seo_names SET name = ?s WHERE ?p', $name, $condition);
        } else {
            fn_set_notification('E', __('error'), __('cp_seo_name_exists_text', ['[name]' => $exists]));
            return false;
        }
    }
    return true;
}

function fn_cp_seo_check_names_params($seo_name_id, &$params)
{
    if (empty($seo_name_id)) {
        return [];
    }
    $required_fields = fn_cp_seo_get_names_required_fields();
    $result = true;
    $params = [];
    $name_params = explode('_', $seo_name_id);
    foreach ($required_fields as $key => $field) {
        if (!isset($name_params[$key])) {
            $result = false;
            break;
        }
        $params[$field] = $name_params[$key];
    }
    return $result;
}

function fn_cp_seo_get_names_required_fields()
{
    return ['object_id', 'type', 'dispatch', 'lang_code', 'company_id'];
}

// Addon.xml functions

function fn_cp_seo_setting_variants($setting)
{
    static $schema = null;
    $schema = isset($schema) ? $schema : fn_get_schema('cp_seo_optimization', 'seo_settings', 'php', true);
    if (empty($schema[$setting]['items']) || !is_array($schema[$setting]['items'])) {
        return [];
    }
    $item_variants = [];
    foreach ($schema[$setting]['items'] as $key => $item) {
       $item_variants[$key] = !empty($item['descr']) ? $item['descr'] : $key;
    }
    return $item_variants;
}

function fn_cp_seo_optimization_install()
{
    $time = TIME;
    $tables = ['?:categories', '?:pages'];
    foreach ($tables as $table) {
        $exists = db_get_field('SHOW COLUMNS FROM ?p WHERE Field = ?s', $table, 'cp_seo_lastmod');
        if (!empty($exists)) {
            db_query('UPDATE ?p SET cp_seo_lastmod = ?i', $table, $time);
        }
    }
    $rules = [
        'product_features.compare'  => 'Y',
        'profiles.add'              => 'Y',
        'auth.login_form'           => 'Y',
        'checkout.cart'             => 'Y',
        'checkout.checkout'         => 'Y',
        'auth.recover_password'     => 'Y',
        'orders.downloads'          => 'Y',
        'orders.search'             => 'Y',
        'orders.details'            => 'Y',
        '_no_page.index'            => 'Y',
        'separate_checkout.cart'    => 'Y'
    ];
    if (fn_allowed_for('MULTIVENDOR')) {
        $rules['companies.apply_for_vendor'] = 'Y';
    }
    if (!empty($rules)) {
        if (fn_allowed_for('ULTIMATE')) {
            $companies = db_get_fields("SELECT company_id FROM ?:companies");
        } else {
            $companies[] = 0;
        }
        foreach($companies as $com_id) {
            foreach($rules as $dip => $val) {
                $put_data = [
                    'dispatch'  => $dip,
                    'rule'      => $val,
                    'company_id'=> $com_id
                ];
                db_query("INSERT INTO ?:cp_seo_index_rules ?e", $put_data);
            }
        }
    }
}

function fn_cp_seo_get_index_rules($params = [], $items_per_page = 0)
{
    $default_params = [
        'page' => 1,
        'items_per_page' => $items_per_page
    ];
    $params = array_merge($default_params, $params);
    $join = $condition = $limit = '';
    
    if (fn_allowed_for('ULTIMATE')) {
        $condition .= fn_get_company_condition('?:cp_seo_index_rules.company_id');
    }
    $sortings = [
        'dispatch'  => '?:cp_seo_index_rules.dispatch',
        'rule'      => '?:cp_seo_index_rules.rule',
    ];
    $sorting = db_sort($params, $sortings, 'dispatch', 'asc');
    
    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field('SELECT count(*) FROM ?:cp_seo_index_rules ?p WHERE 1 ?p', $join, $condition);
        $limit = db_paginate($params['page'], $params['items_per_page']);
    }
    $rules = db_get_array("SELECT ?:cp_seo_index_rules.* FROM ?:cp_seo_index_rules ?p WHERE 1 ?p ?p ?p", $join, $condition, $sorting, $limit);
    
    return [$rules, $params];
}

function fn_cp_seo_update_index_rule($data = [], $rule_id = 0)
{
    if (!empty($data['dispatch'])) {
        $rules = fn_get_schema('cp_seo_optimization', 'seo_index_pages');
        if (empty($rule_id) && !empty($rules[$data['dispatch']])) {
            return $rule_id;
        }
        if (!empty($rule_id)) {
            db_query('UPDATE ?:cp_seo_index_rules SET ?u WHERE rule_id = ?i', $data, $rule_id);
        } else {
            $rule_id = db_query("INSERT INTO ?:cp_seo_index_rules ?e", $data);
        }
    }
    return $rule_id;
}

function fn_cp_seo_delete_rule($rule_id = 0)
{
    if (!empty($rule_id)) {
        db_query("DELETE FROM ?:cp_seo_index_rules WHERE rule_id = ?i", $rule_id);
    }
    return true;
}

function fn_cp_seo_m_update_rules($rules = [])
{
    if (!empty($rules)) {
        foreach($rules as $rule_id => $r_data) {
            if (!empty($r_data['rule'])) {
                db_query('UPDATE ?:cp_seo_index_rules SET rule = ?s WHERE rule_id = ?i', $r_data['rule'], $rule_id);
            }
        }
    }
    return true;
}

function fn_cp_seo_optimization_uninstall()
{
    $filts = db_get_array("SELECT * FROM ?:product_filters");
    if (!empty($filts)) {
        $reset_f = reset($filts);
        if (!empty($reset_f) && isset($reset_f['cp_seo_index_result'])) {
            db_query("ALTER TABLE ?:product_filters DROP cp_seo_index_result");
        }
    }
    return true;
}
