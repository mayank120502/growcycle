<?php
 use Tygh\Registry; use Tygh\Enum\BannerLinkTypes; use Tygh\Enum\BannerTypes; defined('BOOTSTRAP') or die('Access denied'); if ($_SERVER['REQUEST_METHOD'] == 'POST') { fn_trusted_vars('banner', 'banners_data'); $suffix = ''; if ($mode == 'm_delete') { if (!empty($_REQUEST['banner_ids'])) { $deleted_banners_names = []; $undeleted_banners_names = []; foreach ($_REQUEST['banner_ids'] as $banner_id) { if (fn_allowed_for('ULTIMATE')) { $company_id = fn_get_runtime_company_id(); if ($company_id) { $banner_company_id = db_get_field( 'SELECT company_id' . ' FROM ?:aff_banners' . ' WHERE banner_id = ?i', $banner_id ); if ($banner_company_id != $company_id) { $banner_id = 0; } } else { $banner_id = 0; } } $banner_name = fn_get_aff_banner_name($banner_id, DESCR_SL); if (fn_delete_banner($banner_id)) { $deleted_banners_names[] = $banner_name; } else { $undeleted_banners_names[] = $banner_name; } } if (!empty($deleted_banners_names)) { $banners_names = '&nbsp;-&nbsp;' . implode('<br />&nbsp;-&nbsp;', $deleted_banners_names); fn_set_notification('N', __('information'), __('deleted_banners') . ':<br />' . $banners_names); } if (!empty($undeleted_banners_names)) { $banners_names = '&nbsp;-&nbsp;' . implode('<br />&nbsp;-&nbsp;', $undeleted_banners_names); fn_set_notification('W', __('warning'), __('undeleted_banners') . ':<br />' . $banners_names); } } else { fn_set_notification('E', __('error'), __('error_no_data')); } $suffix = ".manage?banner_type=$_REQUEST[banner_type]&link_to=$_REQUEST[link_to]"; } if ($mode == 'm_update') { if (!empty($_REQUEST['banners_data']) && is_array($_REQUEST['banners_data'])) { $banners_data = $_REQUEST['banners_data']; foreach ($banners_data as $banner_id => $b_data) { if (fn_allowed_for('ULTIMATE')) { $company_id = fn_get_runtime_company_id(); if ($company_id) { $banner_company_id = db_get_field( 'SELECT company_id' . ' FROM ?:aff_banners' . ' WHERE banner_id = ?i', $banner_id ); $b_data['company_id'] = !empty($banner_company_id) ? $banner_company_id : $company_id; } } db_query('UPDATE ?:aff_banners SET ?u WHERE banner_id = ?i', $b_data, $banner_id); } } $suffix = ".manage?banner_type=$_REQUEST[banner_type]&link_to=$_REQUEST[link_to]"; } if ($mode == 'update') { if ($_REQUEST['banner']['type'] == BannerTypes::TEXT || $_REQUEST['banner']['type'] == BannerTypes::PRODUCTS) { $banner_id = fn_update_banner($_REQUEST['banner'], $_REQUEST['banner_id'], DESCR_SL); } else { $banner_id = fn_update_banner($_REQUEST['banner'], $_REQUEST['banner_id'], DESCR_SL, $_REQUEST['file_banner_image_icon']); } if ($banner_id === false) { fn_set_notification('E', __('error'), __('aff_cant_create_banner')); return [CONTROLLER_STATUS_REDIRECT, 'banners_manager.manage?banner_type=T']; } $suffix = ".update?banner_id=$banner_id&banner_type=" . $_REQUEST['banner']['type'] . '&link_to=' . $_REQUEST['banner']['link_to']; if (!empty($_REQUEST['return_to_list'])) { $_REQUEST['redirect_url'] = 'banners_manager.manage?banner_type=' . $_REQUEST['banner']['type'] . '&link_to=' . $_REQUEST['banner']['link_to']; } } return [CONTROLLER_STATUS_OK, "banners_manager$suffix"]; } if ($mode == 'update') { $banner = fn_get_aff_banner_data($_REQUEST['banner_id'], DESCR_SL); if (fn_allowed_for('ULTIMATE')) { $company_id = fn_get_runtime_company_id(); if ($company_id && $banner['company_id'] != $company_id) { unset($banner); } } if (empty($banner)) { return [CONTROLLER_STATUS_NO_PAGE]; } if ($banner['type'] != BannerTypes::GRAPHICS) { $banner['code'] = fn_get_aff_banner_html('js', $banner, '', '', DESCR_SL); } if ($banner['link_to'] == BannerLinkTypes::PRODUCT_GROUPS) { Tygh::$app['view']->assign('all_groups_list', fn_get_groups_list(false, DESCR_SL)); } Tygh::$app['view']->assign('banner', $banner); Tygh::$app['view']->assign('banner_type', $banner['type']); Tygh::$app['view']->assign('link_to', $banner['link_to']); } elseif ($mode == 'add') { $banner_type = empty($_REQUEST['banner_type']) ? BannerTypes::TEXT : $_REQUEST['banner_type']; $link_to = empty($_REQUEST['link_to']) ? BannerLinkTypes::PRODUCT_GROUPS : $_REQUEST['link_to']; if ($link_to == BannerLinkTypes::PRODUCT_GROUPS) { Tygh::$app['view']->assign('all_groups_list', fn_get_groups_list(true, DESCR_SL)); } Tygh::$app['view']->assign('banner_type', $banner_type); Tygh::$app['view']->assign('link_to', $link_to); } elseif ($mode == 'manage') { $banner_type = empty($_REQUEST['banner_type']) ? BannerTypes::TEXT : $_REQUEST['banner_type']; $link_to = empty($_REQUEST['link_to']) ? ($banner_type == BannerTypes::PRODUCTS ? BannerLinkTypes::URL : BannerLinkTypes::PRODUCT_GROUPS) : $_REQUEST['link_to']; $link_types = fn_get_aff_banner_link_types($banner_type); $navigation_tabs = []; foreach ($link_types as $link_type => $title) { $navigation_tabs[$link_type] = [ 'title' => $title, 'href' => "banners_manager.manage?banner_type=$banner_type&link_to=$link_type", 'ajax' => true, ]; } Registry::set('navigation.tabs', $navigation_tabs); $banners = fn_get_aff_banners($banner_type, $link_to, false, DESCR_SL); Tygh::$app['view']->assign('banners', $banners); Tygh::$app['view']->assign('link_to', $link_to); Tygh::$app['view']->assign('banner_type', $banner_type); Tygh::$app['view']->assign('link_types', $link_types); if ($link_to == BannerLinkTypes::PRODUCT_GROUPS) { $all_groups_list = fn_get_groups_list(true, DESCR_SL); Tygh::$app['view']->assign('all_groups_list', $all_groups_list); } Registry::set('navigation.dynamic.sections', [ BannerTypes::TEXT => [ 'title' => __('text_banners'), 'href' => 'banners_manager.manage?banner_type=T', ], BannerTypes::GRAPHICS => [ 'title' => __('graphic_banners'), 'href' => 'banners_manager.manage?banner_type=G', ], BannerTypes::PRODUCTS => [ 'title' => __('product_banners'), 'href' => 'banners_manager.manage?banner_type=P', ], ]); Registry::set('navigation.dynamic.active_section', $banner_type); } elseif ($mode == 'delete') { if (!empty($_REQUEST['banner_id'])) { fn_delete_banner($_REQUEST['banner_id']); fn_set_notification('N', __('information'), __('banner_deleted')); } else { fn_set_notification('E', __('error'), __('error_no_data')); } return [CONTROLLER_STATUS_REDIRECT, "banners_manager.manage?banner_type=$_REQUEST[banner_type]&link_to=$_REQUEST[link_to]"]; } 