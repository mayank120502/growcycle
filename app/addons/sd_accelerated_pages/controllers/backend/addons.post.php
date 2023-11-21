<?php
 use Tygh\Registry; use Tygh\BlockManager\Layout; defined('BOOTSTRAP') or die('Access denied'); $is_amp = isset($_REQUEST['addon']) && $_REQUEST['addon'] == 'sd_accelerated_pages'; if ($_SERVER['REQUEST_METHOD'] == 'POST' && $is_amp) { if ($mode == 'update' && isset($_REQUEST['logotypes_image_data'])) { fn_attach_image_pairs( 'logotypes', 'logos' ); } return array(CONTROLLER_STATUS_OK); } if ($mode == 'update' && $is_amp) { $company_id = fn_get_runtime_company_id(); $simple_ultimate = Registry::ifGet('runtime.simple_ultimate', 0) != 0; $is_root = false; if (fn_allowed_for('ULTIMATE') && !$simple_ultimate && !Registry::ifGet('runtime.company_id', 0) ) { $is_root = true; Tygh::$app['view']->assign('is_root', true); } if ($is_root || $simple_ultimate) { $company_id = fn_get_default_company_id(); } Tygh::$app['view']->assign('company_id', $company_id); if (!empty($company_id) || fn_allowed_for('MULTIVENDOR')) { $layout_id = fn_sd_accelerated_pages_get_layout_id($company_id); $layout_data = Layout::instance()->get($layout_id); $logos = fn_get_logos( $company_id, $layout_data['layout_id'], $layout_data['style_id'] ); if (empty($logos['theme'])) { fn_sd_accelerated_pages_create_logo( $company_id, $layout_data['layout_id'] ); $logos = fn_get_logos( $company_id, $layout_data['layout_id'], $layout_data['style_id'] ); } if (!empty($logos)) { Tygh::$app['view']->assign('logos', $logos); } $logo_types = fn_get_logo_types(); if (isset($logo_types['theme'])) { $logo_types = array( 'theme' => $logo_types['theme'], 'favicon' => $logo_types['favicon'], ); Tygh::$app['view']->assign('logo_types', $logo_types); } } } 