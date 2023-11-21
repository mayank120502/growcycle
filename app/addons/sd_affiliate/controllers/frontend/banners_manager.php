<?php
 use Tygh\Registry; use Tygh\Enum\BannerLinkTypes; use Tygh\Enum\BannerTypes; defined('BOOTSTRAP') or die('Access denied'); Tygh::$app['session']['banner_product_ids'] = empty(Tygh::$app['session']['banner_product_ids']) ? [] : Tygh::$app['session']['banner_product_ids']; $banner_product_ids = & Tygh::$app['session']['banner_product_ids']; if ($_SERVER['REQUEST_METHOD'] == 'POST') { if ($mode == 'do_add_linked') { if (!empty($_REQUEST['banner_id']) && !empty($_REQUEST['product_data'])) { $add_products_ids = array_keys($_REQUEST['product_data']); $banner_product_ids[$_REQUEST['banner_id']] = array_unique( fn_array_merge($banner_product_ids[$_REQUEST['banner_id']], $add_products_ids, false) ); $_suffix = '?banner_id=' . $_REQUEST['banner_id']; } } if ($mode == 'do_delete_linked') { if (!empty($_REQUEST['banner_id']) && !empty($_REQUEST['delete'])) { $banner_product_ids[$_REQUEST['banner_id']] = array_unique( array_diff($banner_product_ids[$_REQUEST['banner_id']], $_REQUEST['delete']) ); $_suffix = '?banner_id=' . $_REQUEST['banner_id']; } } return [CONTROLLER_STATUS_OK, "banners_manager.select_product$_suffix"]; } if ($mode == 'select_product' && !empty($_REQUEST['banner_id'])) { if (!empty($_REQUEST['banner_id']) && !isset($banner_product_ids[$_REQUEST['banner_id']])) { $banner_product_ids = [$_REQUEST['banner_id'] => []]; } $banner_data = fn_get_aff_banner_data($_REQUEST['banner_id'], CART_LANGUAGE, true); $banner_data['product_ids'] = implode('-', $banner_product_ids[$_REQUEST['banner_id']]); $banner_data['example'] = fn_get_aff_banner_html('js', $banner_data); $banner_data['code'] = fn_get_aff_banner_html('js', $banner_data, '', $auth['user_id']); $banner_data['url'] = fn_get_aff_banner_url($banner_data, $auth['user_id']); Tygh::$app['view']->assign('banner', $banner_data); fn_add_breadcrumb(__('affiliates_partnership'), 'affiliate_plans.list'); fn_add_breadcrumb(__('product_banners'), 'banners_manager.manage?banner_type=P'); fn_add_breadcrumb($banner_data['title']); $linked_products = []; foreach ($banner_product_ids[$_REQUEST['banner_id']] as $prod_id) { $linked_products[$prod_id] = fn_get_product_data($prod_id, $auth); $linked_products[$prod_id]['url'] = "$banner_data[url]&product_id=$prod_id"; } Tygh::$app['view']->assign('linked_products', $linked_products); Tygh::$app['view']->assign('banner_id', $banner_data['banner_id']); } else { if ($_REQUEST['banner_type'] != BannerTypes::PRODUCTS) { Registry::set('navigation.tabs', [ 'groups' => [ 'title' => __('product_groups'), 'js' => true, ], 'categories' => [ 'title' => __('categories'), 'js' => true, ], 'products' => [ 'title' => __('products'), 'js' => true, ], 'url' => [ 'title' => __('url'), 'js' => true, ], ]); } fn_add_breadcrumb(__('affiliates_partnership'), 'affiliate_plans.list'); $banners = []; if (!empty($_REQUEST['banner_type'])) { $banners = [ 'categories' => fn_get_aff_banners($_REQUEST['banner_type'], BannerLinkTypes::CATEGORIES, true), 'products' => fn_get_aff_banners($_REQUEST['banner_type'], BannerLinkTypes::PRODUCTS, true), 'url' => fn_get_aff_banners($_REQUEST['banner_type'], BannerLinkTypes::URL, true) ]; $banners['groups'] = fn_get_aff_banners($_REQUEST['banner_type'], BannerTypes::GRAPHICS, true); if (!empty($banners['groups'])) { foreach ($banners['groups'] as $k => $banner) { if (empty($banner['group_name'])) { unset($banners['groups'][$k]); continue; } $banners['groups'][$k]['groups'] = fn_get_group_data($banner['group_id']); if ($banners['groups'][$k]['groups']['status'] == 'D') { unset($banners['groups'][$k]); continue; } if (!empty($banners['groups'][$k]['groups']['product_ids'])) { $banners['groups'][$k]['groups']['products'] = fn_get_product_name( $banners['groups'][$k]['groups']['product_ids'] ); } } } $js_banners = []; foreach ($banners as $type => $bans) { if (!empty($bans)) { foreach ($bans as $banner_id => $ban) { $js_banners[$ban['banner_id']]['example'] = fn_get_aff_banner_html('js', $ban); $js_banners[$ban['banner_id']]['code'] = fn_get_aff_banner_html('js', $ban, '', $auth['user_id']); if ($_REQUEST['banner_type'] == BannerTypes::GRAPHICS) { $image_data = fn_get_aff_banner_image_data($ban['banner_id'], 'icon'); if (!empty($image_data)) { $banners[$type][$banner_id] = fn_array_merge($ban, $image_data); } } if ($_REQUEST['banner_type'] != BannerTypes::PRODUCTS) { $js_banners[$ban['banner_id']]['url'] = fn_get_aff_banner_url($ban, $auth['user_id']); } } } } if ($_REQUEST['banner_type'] == BannerTypes::GRAPHICS) { Tygh::$app['view']->assign('mainbox_title', __('graphic_banners')); } elseif ($_REQUEST['banner_type'] == BannerTypes::PRODUCTS) { Tygh::$app['view']->assign('mainbox_title', __('product_banners')); } else { Tygh::$app['view']->assign('mainbox_title', __('text_banners')); } } Tygh::$app['view']->assign([ 'all_groups_list' => fn_get_groups_list(), 'all_categories_list' => fn_get_plain_categories_tree(0, false), 'banners' => $banners, 'js_banners' => $js_banners, 'banner_type' => $_REQUEST['banner_type'] ]); } 