<?php
 use Tygh\Registry; defined('BOOTSTRAP') or die('Access denied'); if ($_SERVER['REQUEST_METHOD'] == 'POST') { return array(CONTROLLER_STATUS_OK); } if (Registry::get('is_amp_link')) { $params = $_REQUEST; if ($mode == 'view') { $product = Tygh::$app['view']->getTemplateVars('product'); if (isset($params['json'])) { if (!fn_sd_accelerated_pages_check_cors($_SERVER)) { header('HTTP/1.0 401 Unauthorized'); exit; }; header('Content-Type: application/json', true); echo(json_encode( fn_sd_accelerated_pages_filter_product_data($product) )); exit; } if (!empty($product['image_pairs'])) { $img_pair = reset($product['image_pairs']); $pos = 1; foreach ($product['image_pairs'] as $index => &$pair) { $path = isset($pair['detailed']['absolute_path']) ? $pair['detailed']['absolute_path'] : ''; if (file_exists($path)) { $pair['position'] = $pos; ++$pos; } else { unset($product['image_pairs'][$index]); } } Tygh::$app['view']->assign('product', $product); } $amp_scripts = Tygh::$app['view']->getTemplateVars('amp_scripts'); $amp_scripts['selector'] = true; $amp_scripts['carousel'] = true; if (strpos($product['full_description'], 'iframe') > 0) { $amp_scripts['iframe'] = true; } if (strpos($product['full_description'], 'youtube') > 0) { $amp_scripts['youtube'] = true; } if (strpos($product['full_description'], 'facebook') > 0) { $amp_scripts['facebook'] = true; } if (!empty($product['youtube_link']) || !empty($product['youtube_videos'])) { $amp_scripts['youtube'] = true; } Tygh::$app['view']->assign('amp_scripts', $amp_scripts); } } elseif ($mode == 'view' && !empty($_REQUEST['product_id']) && Registry::get('addons.seo.status') == 'A') { Tygh::$app['view']->assign('amphtml', fn_url('amp/index.php?dispatch=products.view&product_id=' . $_REQUEST['product_id'])); } 