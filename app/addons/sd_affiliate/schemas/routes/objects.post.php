<?php
 use Tygh\Registry; defined('BOOTSTRAP') or die('Access denied'); $admin_affiliate_parameter = Registry::get('addons.sd_affiliate.custom_affiliate_parameter'); if (!empty($admin_affiliate_parameter)) { $schema['/' . $admin_affiliate_parameter . '/[*:custom_affiliate_parameter]'] = [ 'dispatch' => 'partner_routes.home_page_route' ]; } return $schema; 