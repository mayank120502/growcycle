<?php
 use Tygh\Enum\Addons\SdGoogleAnalytics\ProductIdentificationTypes; use Tygh\Enum\YesNo; use Tygh\Registry; defined('BOOTSTRAP') or die('Access denied'); if ($_SERVER['REQUEST_METHOD'] == 'POST') { return [CONTROLLER_STATUS_OK]; } if ($mode == 'checkout') { if (isset(Tygh::$app['session']['sd_ga_checkout'])) { Tygh::$app['view']->assign('sd_ga_checkout', Tygh::$app['session']['sd_ga_checkout']); } $shipping_names = json_encode(fn_get_shippings(true)); $shipping_names = str_replace('\"', '\\\"', $shipping_names); Tygh::$app['view']->assign('shipping_names', $shipping_names); } if ($mode == 'complete') { $view = Tygh::$app['view']; $orders_info = []; $order_info = $view->getTemplateVars('order_info'); if (!fn_allowed_for('MULTIVENDOR') || (fn_allowed_for('MULTIVENDOR') && $order_info['is_parent_order'] == YesNo::NO) ) { $orders_info[0] = $order_info; $orders_info[0]['ga_company_name'] = fn_get_company_name($order_info['company_id']); } else { $order_ids = explode(',', $order_info['child_ids']); foreach ($order_ids as $k => $order_id) { $_order_info = fn_get_order_info($order_id); $orders_info[$k] = $_order_info; $orders_info[$k]['ga_company_name'] = fn_get_company_name($_order_info['company_id']); } } fn_set_hook('update_ga_orders_info', $orders_info); $view->assign('orders_info', $orders_info); } 