<?php
 use Tygh\Registry; use Tygh\Enum\AffiliateUserTypes; defined('BOOTSTRAP') or die('Access denied'); $current_url = Registry::get('config.current_url'); Tygh::$app['view']->assign('url_has_aff_id_parameter', fn_sd_affiliate_check_parameter_in_url($current_url, "aff_id")); if (!empty(Tygh::$app['session']['partner_data']['partner_id'])) { $partner_id = Tygh::$app['session']['partner_data']['partner_id']; Tygh::$app['view']->assign('partner_code', fn_dec2any(Tygh::$app['session']['partner_data']['partner_id'])); } if (!empty($auth['user_id'])) { $auth['user_type'] = fn_sd_affiliate_get_user_type($auth['user_id']); $auth['affiliate_approved'] = fn_sd_affiliate_get_affiliate($auth['user_id']); } if (!defined('CRAWLER') && !isset($_REQUEST['bid']) && Tygh::$app['session']['auth']['user_type'] !== AffiliateUserTypes::PARTNER ) { if (!isset(Tygh::$app['session']['auth']['aff'])) { $aff_id = 0; if (isset($_REQUEST['aff_id'])) { if (isset($partner_id)) { $aff_id = $partner_id; } else { $aff_id = $_REQUEST['aff_id']; } } elseif (isset($_REQUEST['custom_affiliate_parameter'])) { if (isset($partner_id)) { $aff_id = $partner_id; } else { $aff_id = db_get_field('SELECT user_id FROM ?:aff_partner_profiles' . ' WHERE custom_aff_parameter = ?s', $_REQUEST['custom_affiliate_parameter'] ); } } fn_add_partner_action('click_ref', '', $aff_id); if (!empty($aff_id)) { Tygh::$app['session']['auth']['aff'] = $aff_id; } } } if (((Registry::get('addons.sd_affiliate.allow_all_customers_be_affiliates') == 'N' && $auth['user_type'] == AffiliateUserTypes::CUSTOMER) || !$auth['user_id']) && (in_array(Registry::get('runtime.controller'), Registry::get('affiliate_controllers')) && Registry::get('runtime.controller') != 'affiliate_plans') ) { return [CONTROLLER_STATUS_REDIRECT, fn_url()]; }