<?php
use Tygh\Registry;
use Tygh\Settings;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'update' && $_SERVER['REQUEST_METHOD'] != 'POST') {
  $company_data = Registry::get('view')->getTemplateVars('company_data');
  if (isset($company_data['company_id'])) {
    
    /* Vendor Extra details */
    $vendor_extra_details=fn_et_vivashop_mv_functionality_get_ved($company_data['company_id']);
    if (!empty($vendor_extra_details)){
      Registry::get('view')->assign('vendor_extra_details', $vendor_extra_details);
      Registry::set('navigation.tabs.et_ved', array (
          'title' => __("et_social_links"),
          'js' => true
        ));
    }

    if (!empty($vendor_map)){
      Registry::get('view')->assign('vendor_map', $vendor_map);
    }

  }else{
    return array(CONTROLLER_STATUS_DENIED);
  }
}

if ($mode == 'update' || $mode == 'add') {
    /* Vendor Store settings*/
    $company_data = Registry::get('view')->getTemplateVars('company_data');
    if (!empty($company_data)){
      fn_et_vivashop_mv_functionality_unserialize($company_data);
    }
    Registry::get('view')->assign('company_data', $company_data);
    
    if (isset($company_data['company_id'])) {
        $et_vs=fn_et_vivashop_mv_functionality_pp_block_get($company_data['company_id']);
        if (!empty($et_vs)){
          Registry::get('view')->assign('et_vs', $et_vs);
        }
    }

    $et_default_settings=fn_get_et_vivashop_mv_functionality_settings();
    Registry::get('view')->assign('et_default_settings', $et_default_settings);
    Registry::set('navigation.tabs.et_vs', array (
    'title' => __("et_store_settings"),
    'js' => true
  ));
}


// change company
use Tygh\Enum\StorefrontStatuses;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

// Ajax content
if ($mode == 'et_get_companies_list') {


    // Check if we trying to get list by non-ajax
    if (!defined('AJAX_REQUEST')) {
        return array(CONTROLLER_STATUS_REDIRECT, fn_url());
    }

    //TODO make single function

    $params = array_merge(array(
        'render_html' => 'Y'
    ), $_REQUEST);

    $condition = '';
    if (!empty($params['q'])) {
        $pattern = $params['q'];
    } elseif (!empty($params['pattern'])) {
        $pattern = $params['pattern'];
    } else {
        $pattern = '';
    }
    if (isset($_REQUEST['page'], $_REQUEST['page_size'])) {
        $limit = (int) $_REQUEST['page_size'];
        $start = ($_REQUEST['page'] - 1) * $limit;
    } else {
        $start = !empty($params['start']) ? $params['start'] : 0;
        $limit = (!empty($params['limit']) ? $params['limit'] : 10) + 1;
    }

    $condition = '1=1';

    if (AREA == 'C') {
        $condition .= " AND status = 'A' ";
    }

    fn_set_hook('get_companies_list', $condition, $pattern, $start, $limit, $params);

    if ($pattern) {
        $condition .= db_quote(' AND company LIKE ?l', $pattern . '%');
    }

    if (!empty($params['ids'])) {
        $condition .= db_quote(' AND company_id IN (?n)', $params['ids']);
    }

    $objects = db_get_hash_array("SELECT company_id, company_id as value, company_id as id, company AS name, company AS text, CONCAT('switch_company_id=', company_id) as append FROM ?:companies WHERE $condition ORDER BY company LIMIT ?i, ?i", 'value', $start, $limit);
    $total = (int) db_get_field('SELECT COUNT(*) FROM ?:companies WHERE ?p', $condition);

    if (fn_allowed_for('ULTIMATE')) {
        foreach ($objects as &$object) {
            $object['storefront_status'] = fn_ult_get_storefront_status($object['company_id']);
        }
        unset($object);
    }

    if (defined('AJAX_REQUEST') && sizeof($objects) < $limit) {
        Tygh::$app['ajax']->assign('completed', true);
    } else {
        array_pop($objects);
    }

    if (empty($params['start']) && empty($params['pattern'])) {
        $all_vendors = array();

        if (!empty($params['show_all']) && $params['show_all'] == 'Y') {
            $all_vendors[0] = array(
                'id'              => (!empty($params['search']) && $params['search'] == 'Y') ? '' : 0,
                'company_id'      => (!empty($params['search']) && $params['search'] == 'Y') ? '' : 0,
                'value'           => (!empty($params['search']) && $params['search'] == 'Y') ? '' : 0,
                'text'            => empty($params['default_label']) ? __('all_vendors') : __($params['default_label']),
                'name'            => empty($params['default_label']) ? __('all_vendors') : __($params['default_label']),
                'append'          => '',
                'data'            => [
                    'id'              => (!empty($params['search']) && $params['search'] == 'Y') ? '' : 0,
                    'company_id'      => (!empty($params['search']) && $params['search'] == 'Y') ? '' : 0,
                    'value'           => (!empty($params['search']) && $params['search'] == 'Y') ? '' : 0,
                    'text'            => empty($params['default_label']) ? __('all_vendors') : __($params['default_label']),
                    'name'            => empty($params['default_label']) ? __('all_vendors') : __($params['default_label']),
                    'append'          => '',
                    'url'             => fn_url('products.update?product_id=0')
                ]
            );
            $total++;
        }

        $objects = $all_vendors + $objects;
    }
    
    $objects = array_values(array_map(function ($company) {

        return [
            'id'              => $company['id'],
            'company_id'      => $company['company_id'],
            'value'           => $company['value'],
            'text'            => $company['text'],
            'name'            => $company['name'],
            'append'           => $company['append'],
            'data'            => [
                'id'              => $company['id'],
                'company_id'      => $company['company_id'],
                'value'           => $company['value'],
                'text'            => $company['text'],
                'name'            => $company['name'],
                'append'          => $company['append'],
                'url'             => fn_url('products.update?product_id=' . $company['id'])
            ]
        ];
    }, $objects));

    Tygh::$app['ajax']->assign('objects', $objects);
    Tygh::$app['ajax']->assign('total_objects', $total);

    if (defined('AJAX_REQUEST') && !empty($params['action'])) {
        Tygh::$app['ajax']->assign('action', $params['action']);
    }

    if (!empty($params['onclick'])) {
        Tygh::$app['view']->assign('onclick', $params['onclick']);
    }

    Tygh::$app['view']->assign(array(
        'objects'     => $objects,
        'id'          => !empty($params['result_ids']) ? $params['result_ids'] : '',
        'object_type' => 'companies',
    ));


    if ($params['render_html'] === 'Y') {
        Tygh::$app['view']->assign('et_dispatch', $_REQUEST['et_dispatch']);
        Tygh::$app['view']->display('addons/et_vivashop_mv_functionality/components/et_ajax_select_object.tpl');
    }
    exit;
}
