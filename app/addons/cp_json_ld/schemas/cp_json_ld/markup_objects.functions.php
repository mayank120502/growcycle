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

function fn_cp_json_ld_search_markup_data($params = [])
{
    if (Registry::get('addons.cp_json_ld.use_search_markup') != 'Y') {
        return [];
    }
    return ['url' => fn_url()];
}

function fn_cp_json_ld_company_markup_data($params = [])
{
    $settings = Registry::get('addons.cp_json_ld');
    if ($settings['company_markup_display_on'] != 'all'
        && !($settings['company_markup_display_on'] == 'page' && !empty($params['page_id']) && $params['page_id'] == $settings['company_markup_page'])
    ) {
        return [];
    }
    $company_id = Registry::get('runtime.company_id');
    $logos = fn_get_logos($company_id);
    $company = Registry::get('settings.Company');
    $company['logo'] = isset($logos['theme']['image']['image_path']) ? $logos['theme']['image']['image_path'] : '';

    return $company;
}

function fn_cp_json_ld_product_markup_data($params = [])
{
    if (Registry::get('addons.cp_json_ld.use_product_markup') != 'Y') {
        return [];
    }
    $product = Tygh::$app['view']->getTemplateVars('product');
    return $product;
}

function fn_cp_json_ld_breadcrumbs_markup_data($params = [])
{
    if (Registry::get('addons.cp_json_ld.use_breadcrumbs_markup') != 'Y') {
        return [];
    }
    $markup_data = [];
    $breadcrumbs = Tygh::$app['view']->getTemplateVars('breadcrumbs');
    $current_url = Registry::get('config.current_url');
    if (!empty($breadcrumbs) && count($breadcrumbs) > 1) {
        foreach ($breadcrumbs as $bc) {
            $markup_data['breadcrumbs'][] = [
                'name'  => !empty($bc['title']) ? $bc['title'] : '',
                'url'   => !empty($bc['link']) ? fn_url($bc['link']) : fn_url($current_url)
            ];
        }
    }
    return $markup_data;
}

function fn_cp_json_ld_blog_markup_data($params = [])
{
    $json_settings = Registry::get('addons.cp_json_ld');
    if (empty($json_settings['use_markup_for']['blog']) || $json_settings['use_markup_for']['blog'] != 'Y') {
        return [];
    }

    $page = Tygh::$app['view']->getTemplateVars('page');
    if (empty($page['page_type']) || $page['page_type'] != 'B') {
        return [];
    }

    $markup_data = [];
    $company_id = Registry::get('runtime.company_id');

    $is_root = (isset($page['parent_id']) && $page['parent_id'] == 0) ? true : false;

    $article_date = !empty($page['timestamp']) ? date('c', $page['timestamp']) : '';
    $markup_data = [
        'type'              => $is_root ? 'blog' : 'article',
        'name'              => strip_tags($page['page']),
        'url'               => fn_url('pages.view&page_id=' . $page['page_id'], 'C'),
        'date_published'    => $article_date,
        'date_modified'     => $article_date,
        'author'            => !empty($page['author']) && !$is_root ? $page['author'] : '',
        'description'       => !empty($page['description']) ? $page['description'] : ''
    ];
    
    $logos = fn_get_logos($company_id);
    $markup_data['publisher_data'] = [
        'name' => Registry::get('settings.Company.company_name'),
        'logo' => isset($logos['theme']['image']['image_path']) ? $logos['theme']['image']['image_path'] : ''
    ];

    $markup_data['image'] = !empty($page['main_pair']['icon']['image_path']) ? $page['main_pair']['icon']['image_path'] : '';
    
    return $markup_data;
}