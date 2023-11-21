<?php
 use Tygh\Http; use Tygh\Registry; use Tygh\Tools\Url; use Tygh\Embedded; use Tygh\Addons\SchemesManager; use Tygh\Enum\ProductFeatures; use Tygh\BlockManager\Exim; use Tygh\BlockManager\Layout; use Tygh\Themes\Themes; use Tygh\Addons\SdAcceleratedPages\AMP; defined('BOOTSTRAP') or die('Access denied'); function fn_sd_accelerated_pages_get_route($req, $result, $area, &$is_allowed_url) { if ($area == 'C') { $uri = isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : ''; $is_amp_page = stripos($uri, AMP_PREFIX) !== false; $amp_link_removed = Registry::get('amp_link_removed'); if ($amp_link_removed && Registry::get('addons.seo.status') == 'A') { $accelerated_pages = fn_get_schema('accelerated_pages', 'accelerated_pages_list'); if (!empty($req['dispatch']) && in_array($req['dispatch'], $accelerated_pages)) { $is_allowed_url = true; Registry::set('is_amp_link', true); Registry::set('amp_link_removed', false); } else { $redirect_url = str_replace(AMP_PREFIX, '/', $uri); if (!empty($redirect_url)) { if (!defined('CART_LANGUAGE')) { fn_init_language($req); } fn_redirect($redirect_url); } } } if ($is_amp_page && !$amp_link_removed) { $_SERVER['REQUEST_URI'] = str_replace(AMP_PREFIX, '/', $uri); $_REQUEST['no_cache'] = true; Registry::set('origin_layout', Layout::instance(fn_get_runtime_company_id())->getDefault()); Registry::set('config.origin_location', Registry::get('config.current_location')); if ($is_amp_page) { $is_allowed_url = false; Registry::set('is_amp_link', false); Registry::set('amp_link_removed', true); } } } } function fn_sd_accelerated_pages_install() { fn_install_theme_files(AMP_THEME, AMP_THEME); if (fn_allowed_for('MULTIVENDOR')) { $companies_list = array(0); $layout_path = Registry::get('config.dir.addons') . 'sd_accelerated_pages/resources/layouts_mve.xml'; } else { $companies_list = fn_get_all_companies_ids(true); $layout_path = Registry::get('config.dir.addons') . 'sd_accelerated_pages/resources/layouts.xml'; } foreach ($companies_list as $company_id) { fn_sd_accelerated_pages_install_layout($company_id, $layout_path); } } function fn_sd_accelerated_pages_uninstall() { fn_delete_theme(AMP_THEME); fn_delete_logo('theme', null, AMP_STYLE); } function fn_sd_accelerated_pages_install_layout($company_id, $layout_path) { $layout_exists = fn_sd_accelerated_pages_get_layout_id($company_id); if ($layout_exists) { return false; } $layout_id = Exim::instance($company_id, 0, AMP_THEME)->importFromFile( $layout_path, array( 'override_by_dispatch' => true, 'clean_up' => true, 'import_style' => 'create', ) ); if (!$layout_id) { return false; } fn_sd_accelerated_pages_create_logo($company_id, $layout_id); return true; } function fn_sd_accelerated_pages_create_logo($company_id, $layout_id) { $layout_data = Layout::instance()->get($layout_id); $theme_name = fn_get_theme_path('[theme]', 'C', $company_id); $layout = Layout::instance()->getDefault($theme_name); $condition = db_quote( 'layout_id = ?i AND style_id = ?s AND company_id = ?i', $layout['layout_id'], $layout['style_id'], $company_id ); $types = array('theme', 'favicon'); foreach ($types as $type) { $source_layout_logo = db_get_row( 'SELECT type, style_id, logo_id FROM ?:logos WHERE ?p AND type = ?s', $condition, $type ); $created_logo_id = fn_update_logo( array( 'type' => $type, 'layout_id' => $layout_id, 'style_id' => $layout_data['style_id'], ), $company_id ); fn_clone_image_pairs( $created_logo_id, $source_layout_logo['logo_id'], 'logos' ); } } function fn_sd_accelerated_pages_get_logos_post($company_id, $layout_id, $style_id, &$logos) { if (AREA == 'C' && Registry::get('is_amp_link')) { if (empty($logos['theme']) && $origin = Registry::get('origin_layout')) { $logos = fn_get_logos( $company_id, $origin['layout_id'], $origin['style_id'] ); } } } function fn_sd_accelerated_pages_update_company($company_data, $company_id, $lang_code, $action) { if (fn_allowed_for('MULTIVENDOR')) { $layout_path = Registry::get('config.dir.addons') . 'sd_accelerated_pages/resources/layouts_mve.xml'; } else { $layout_path = Registry::get('config.dir.addons') . 'sd_accelerated_pages/resources/layouts.xml'; } if ($action = 'add') { fn_sd_accelerated_pages_install_layout($company_id, $layout_path); } } function fn_sd_accelerated_pages_url_post(&$url, $area, $original_url, $protocol, $company_id_in_url, $lang_code) { if ($area == 'C' && !empty($url) && Registry::get('is_amp_link')) { $request_uri = fn_get_request_uri($_SERVER['REQUEST_URI']); if (stripos($request_uri, AMP_PREFIX) || stripos($url, AMP_PREFIX)) { $request_uri = str_replace(AMP_PREFIX, '', $request_uri); $url = str_replace(AMP_PREFIX, '', $url); } if ($protocol == 'current') { $current = Registry::get('config.current_location'); $url = str_replace($current . '/', $current . AMP_PREFIX, $url); } else { $url = str_replace($request_uri, '/amp' . $request_uri, $url); } $_SERVER['REQUEST_URI'] = $url; } } function fn_sd_accelerated_pages_get_products($params) { if (empty($params['cid']) && !empty($params['category_id'])) { $params['cid'] = $params['category_id']; } if (Registry::get('settings.General.show_products_from_subcategories') == 'Y') { $params['subcats'] = 'Y'; } list($products, $search) = fn_get_products($params, Registry::get('settings.Appearance.products_per_page'), CART_LANGUAGE); fn_gather_additional_products_data($products, array( 'get_icon' => true, 'get_detailed' => true, 'get_additional' => false, 'get_options' => true, 'get_discounts' => false, 'get_features' => false )); $currencies = Registry::get('currencies'); $currency = $currencies[fn_get_secondary_currency()]; $width = Registry::get('addons.sd_accelerated_pages.product_lists_thumbnail_width'); $height = Registry::get('addons.sd_accelerated_pages.product_lists_thumbnail_height'); $amp_products = array(); foreach ($products as $id => $product) { $amp_products[$id] = array( 'product_id' => $product['product_id'], 'display_price' => fn_sd_accelerated_pages_format_price($product['price'], $currency), 'product' => $product['product'], 'url' => fn_url('products.view?product_id=' . $product['product_id'], 'C'), ); if (!empty($product['main_pair'])) { $amp_products[$id]['images_data'] = array( fn_sd_accelerated_pages_get_images($product['main_pair'], $width, $height) ); } } return array($amp_products, $search); } function fn_sd_accelerated_pages_get_images($image, $width, $height) { return array( 'small' => fn_image_to_display($image, $width / 2, $height / 2), 'medium' => fn_image_to_display($image, $width, $height), 'large' => fn_image_to_display($image, $width * 2, $height * 2), 'large2' => fn_image_to_display($image, $width * 3, $height * 3), ); } function fn_sd_accelerated_pages_filter_product_data($product) { $width = Registry::get('addons.sd_accelerated_pages.product_lists_thumbnail_width'); $height = Registry::get('addons.sd_accelerated_pages.product_lists_thumbnail_height'); $amp_product = array( 'product_code' => $product['product_code'], 'product_type' => $product['product_type'], 'price' => $product['price'], ); if (!empty($product['product_options'])) { $product_options = array(); foreach ($product['product_options'] as $option_id => $option_data) { $product_options[$option_id] = array( 'name' => $option_data['option_name'], 'type' => $option_data['option_type'] ); if (!empty($option_data['variants'])) { $product_options[$option_id]['variants'] = array(); foreach ($option_data['variants'] as $variant_id => $variant_data) { $product_options[$option_id]['variants'][$variant_id] = array( 'name' => $variant_data['variant_name'] ); } } } $amp_product['options'] = $product_options; } if (!empty($product['image_pairs'])) { $amp_product['images'] = array(); foreach ($product['image_pairs'] as $pair_id => $image_pair) { $img_data = fn_image_to_display($image_pair['detailed'], $width, $height); $amp_product['images'][$pair_id] = array( 'image_path' => $img_data['image_path'], 'position' => $image_pair['position'] ); } } return $amp_product; } function fn_sd_accelerated_pages_clear_html($description) { $amp = new AMP(); $current_location = Registry::get('config.current_location') . '/'; $parsed_url = parse_url($current_location); if (AREA == 'C') { $text = '<div class="amp-no-image flex justify-center content-center">' . __('sd_accelerated_pages.no_image') . '</div>'; $pattern = '/<img (.*?):\/\/(?!' . preg_quote($parsed_url['host'], '/') . ')(.*?)>/'; $description = preg_replace($pattern, $text, $description); } $options = array( 'request_scheme' => ($parsed_url['scheme'] == 'https') ? 'https://' : 'http://', 'server_url' => $current_location, 'base_url_for_relative_path' => $current_location, 'remove_non_converted_img_tag' => AMP_REMOVE_WRONG_IMG ); $amp->loadHtml($description, $options); return $amp->convertToAmpHtml(); } function fn_sd_accelerated_pages_get_product_data_post(&$product_data) { if (AREA == 'C' && Registry::get('is_amp_link')) { if (!empty($product_data['product_features'])) { foreach ($product_data['product_features'] as &$feature) { if ($feature['feature_type'] == ProductFeatures::GROUP && !empty($feature['subfeatures'])) { foreach ($feature['subfeatures'] as &$subfeature) { if (!empty($subfeature['full_description'])) { $subfeature['full_description'] = ''; } } } if (!empty($feature['full_description'])) { $feature['full_description'] = ''; } } } } return $product_data; } function fn_sd_accelerated_pages_update_product_pre(&$product_data) { if (!empty($product_data['amp_description'])) { $product_data['amp_description'] = fn_sd_accelerated_pages_clear_html( $product_data['amp_description'] ); } } function fn_sd_accelerated_pages_get_layout_id($company_id = null) { static $amp_layout_id = array(); if (!isset($company_id)) { $company_id = fn_get_runtime_company_id(); } if (!isset($amp_layout_id[$company_id])) { $condition = ''; if (fn_allowed_for('ULTIMATE')) { $condition = db_quote(' AND company_id = ?s', $company_id); } $amp_layout_id[$company_id] = db_get_field( 'SELECT layout_id FROM ?:bm_layouts' . ' WHERE theme_name = ?s AND style_id = ?s AND is_default = 1 ?p', AMP_THEME, AMP_STYLE, $condition ); } return $amp_layout_id[$company_id]; } function fn_sd_accelerated_pages_init_layout($params, &$layout) { if (Registry::get('is_amp_link') && AREA == 'C') { $amp_layout_id = fn_sd_accelerated_pages_get_layout_id(); if (!empty($amp_layout_id)) { $layout = Layout::instance()->get($amp_layout_id); } } } function fn_sd_accelerated_pages_before_dispatch() { if (AREA == 'C' && Registry::get('is_amp_link')) { if (Registry::get('runtime.root_template') !== 'index.tpl') { Registry::set('runtime.root_template', 'index.tpl'); } } } function fn_sd_accelerated_pages_init_templater(&$view) { if (AREA == 'C' && Registry::get('is_amp_link')) { $company_id = fn_get_runtime_company_id(); $current_theme = Themes::areaFactory(AREA, $company_id); $searched_themes = array($current_theme); $theme_dirs = Registry::ifGet('theme_dirs', array()); foreach ($searched_themes as $theme) { $theme_dirs[$company_id][$theme->getThemeName()] = array( Themes::PATH_ABSOLUTE => rtrim($theme->getThemePath(), '/') . '/', Themes::PATH_RELATIVE => rtrim($theme->getThemeRelativePath(), '/') . '/', Themes::PATH_REPO => rtrim($theme->getThemeRepoPath(), '/') . '/', ); } if (!isset($theme_dirs[0])) { $theme_dirs[0] = $theme_dirs[$company_id]; } Registry::set('theme_dirs', $theme_dirs); } } function fn_sd_accelerated_pages_init_templater_post(&$view) { if (AREA == 'C' && Registry::get('is_amp_link')) { $view->setArea(AREA, AMP_THEME, fn_get_runtime_company_id()); $view->registerFilter('pre', array('Tygh\SmartyEngine\AmpFilters', 'preInitStyles')); $view->addPluginsDir(Registry::get('config.dir.addons') . 'sd_accelerated_pages/functions/smarty_plugins'); $view->unregisterFilter('output', array('Tygh\SmartyEngine\Filters', 'outputScript')); } } function fn_sd_accelerated_pages_get_theme_path_pre(&$path, $area, $company_id, $theme_names) { if (Registry::get('is_amp_link') && fn_sd_accelerated_pages_get_layout_id()) { $path = str_replace('[theme]', AMP_THEME, $path); } } function fn_sd_accelerated_pages_check_cors($server) { $config = Registry::get('config'); $source = str_replace( $config['current_path'], '', $config['current_location'] ); $current_host = str_replace( array('-', '.'), array('--', '-'), $config['current_location'] ); $current_host = Url::normalizeDomain($current_host); $allowed_origins = array( 'https://' . $current_host . '.cdn.ampproject.org', 'https://' . $current_host . '.amp.cloudflare.com', 'https://cdn.ampproject.org', $source ); $origin = $source; if (isset($server['AMP-Same-Origin'])) { $origin = $source; } elseif (isset($server['HTTP_ORIGIN'])) { if (!in_array($server['HTTP_ORIGIN'], $allowed_origins)) { return false; } $origin = $server['HTTP_ORIGIN']; } header('Access-Control-Allow-Origin: ' . $origin); header('Access-Control-Allow-Credentials: true'); header('AMP-Access-Control-Allow-Source-Origin: ' . $source); header('Access-Control-Expose-Headers: AMP-Redirect-To, AMP-Access-Control-Allow-Source-Origin'); return true; } function fn_sd_accelerated_pages_format_price($price, $currency = '') { $value = fn_format_rate_value( $price, '', $currency['decimals'], $currency['decimals_separator'], $currency['thousands_separator'], $currency['coefficient'] ); $sign = ''; if (isset($value[0]) && $value[0] == '-') { $sign = '-'; $value = substr($value, 1); } $data = array($value); if ($currency['after'] == 'Y') { array_push($data, '&nbsp;' . $currency['symbol']); } else { array_unshift($data, $currency['symbol']); } array_unshift($data, $sign); return implode('', $data); } function fn_sd_accelerated_pages_need_cookie_policy($params) { if (defined('NO_SESSION') || fn_sd_accelerated_pages_is_widget($params)) { return false; } return !fn_sd_accelerated_pages_has_cookie_consent(); } function fn_sd_accelerated_pages_is_widget($params) { return Embedded::isEnabled() || defined('AJAX_REQUEST') && !empty($params['init_context']) && isset($params['callback']) && $params['callback'] === 'TYGH_LOADER.callback'; } function fn_sd_accelerated_pages_has_cookie_consent() { $has_cookie_consent = fn_get_cookie('has_cookie_consent'); return $has_cookie_consent === 'Y' || isset(Tygh::$app['session']['amp_cookies_agreement']); } function fn_sd_accelerated_pages_set_cookie_consent() { Tygh::$app['session']['amp_cookies_agreement'] = 'Y'; if (Registry::get('addons.gdpr.status') == 'A') { $cookies_policy_manager = Tygh::$app['addons.gdpr.cookies_policy_manager']; $cookies_policy_manager->saveAgreement(); } if (Registry::get('settings.Security.uk_cookies_law') == 'Y') { Tygh::$app['session']['cookies_accepted'] = true; } } function fn_sd_accelerated_pages_development_show_stub($placeholders, $append, &$content) { if (AREA == 'C' && Registry::get('is_amp_link')) { $seo_canonical = array( 'current' => fn_url(Registry::get('config.current_url')) ); Tygh::$app['view']->assign('seo_canonical', $seo_canonical); $content = Tygh::$app['view']->fetch('store_closed.tpl'); } } function fn_sd_accelerated_pages_sd_ga_add_tracker_fields($fields) { if (!empty(Registry::get('addons.sd_accelerated_pages.google_tracking_code'))) { $fields['useAmpClientId'] = true; } } function fn_sd_accelerated_pages_cache_warmup() { $category_ids = db_get_fields( 'SELECT category_id FROM ?:categories WHERE status = ?s', 'A' ); foreach ($category_ids as $category_id) { list($products,) = fn_sd_accelerated_pages_get_products(array( 'cid' => $category_id )); fn_echo($category_id . ' ' . str_repeat('. ', count($products)) . '<br />'); } } function fn_sd_accelerated_pages_warmup_info() { return __('sd_accelerated_pages.cache_warmup_info', array( '[url]' => fn_url('amp.cache_warmup', 'C') )); } 