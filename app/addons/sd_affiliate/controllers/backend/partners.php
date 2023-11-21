<?php
 use Tygh\Registry; use Tygh\Enum\UserStatuses; use Tygh\Enum\AffiliateUserTypes; defined('BOOTSTRAP') or die('Access denied'); if ($_SERVER['REQUEST_METHOD'] == 'POST') { fn_trusted_vars('update_data'); if ($mode == 'm_update') { if (!empty($_REQUEST['update_data']) && is_array($_REQUEST['update_data'])) { foreach ($_REQUEST['update_data'] as $partner_id => $p_data) { fn_update_partner_profile($partner_id, $p_data); } } } if ($mode == 'approve') { $_data = fn_get_partner_data($_REQUEST['user_id']); if (empty($_data['approved']) || $_data['approved'] != UserStatuses::APPROVED) { $p_data = ['approved' => UserStatuses::APPROVED]; fn_update_partner_profile($_REQUEST['user_id'], $p_data); $user_data = fn_get_user_info($_REQUEST['user_id']); $profile_fields = fn_get_profile_fields($user_data['user_type']); if ($user_data['user_type'] == 'P' && Registry::get('settings.General.quick_registration') == 'Y') { $profile_fields['C'] = ''; } $usergroups = fn_get_usergroups(); $contact_fields = []; if (!empty($profile_fields['C'])) { $contact_fields = fn_split($profile_fields['C'], 2, true, false); } $mailer = Tygh::$app['mailer']; $mailer->send([ 'to' => $user_data['email'], 'from' => 'default_company_users_department', 'data' => [ 'user_data' => $user_data, 'usergroups' => $usergroups, 'url' => $user_data['company_id'] ? fn_url('?company_id=' . $user_data['company_id'], 'C') : fn_url('', 'C'), 'is_allowed_for' => !fn_allowed_for('ULTIMATE:FREE'), 'profile_fields' => $profile_fields, 'contact_fields' => $contact_fields ], 'template_code' => 'affiliate_approve_user', 'tpl' => 'addons/sd_affiliate/approved.tpl', 'company_id' => $user_data['company_id'] ], 'A'); } } if ($mode == 'm_approve') { if (!empty($_REQUEST['user_ids'])) { foreach ($_REQUEST['user_ids'] as $partner_id) { $_data = fn_get_partner_data($partner_id); if (empty($_data['approved']) || $_data['approved'] != UserStatuses::APPROVED) { $p_data = ['approved' => UserStatuses::APPROVED]; fn_update_partner_profile($partner_id, $p_data); $user_data = fn_get_user_info($partner_id); $profile_fields = fn_get_profile_fields($user_data['user_type']); if ($user_data['user_type'] == 'P' && Registry::get('settings.General.quick_registration') == 'Y' ) { $profile_fields['C'] = ''; } $usergroups = fn_get_usergroups(); $contact_fields = []; if (!empty($profile_fields['C'])) { $contact_fields = fn_split($profile_fields['C'], 2, true, false); } $mailer = Tygh::$app['mailer']; $mailer->send([ 'to' => $user_data['email'], 'from' => 'default_company_users_department', 'data' => [ 'user_data' => $user_data, 'usergroups' => $usergroups, 'url' => $user_data['company_id'] ? fn_url('?company_id=' . $user_data['company_id'], 'C') : fn_url('', 'C'), 'is_allowed_for' => !fn_allowed_for('ULTIMATE:FREE'), 'profile_fields' => $profile_fields, 'contact_fields' => $contact_fields ], 'template_code' => 'affiliate_approve_user', 'tpl' => 'addons/sd_affiliate/approved.tpl', 'company_id' => $user_data['company_id'] ], 'A'); } } } } if ($mode == 'decline') { $_data = fn_get_partner_data($action); if (empty($_data['approved']) || $_data['approved'] != UserStatuses::DECLINED) { $p_data = ['approved' => UserStatuses::DECLINED]; $update_result = fn_update_partner_profile($action, $p_data); if ($update_result) { $user_data = fn_get_user_info($action, false); $mailer = Tygh::$app['mailer']; $mailer->send([ 'to' => $user_data['email'], 'from' => 'company_users_department', 'data' => [ 'user_data' => $user_data, 'reason_declined' => $_REQUEST["action_reason_declined_$action"], ], 'template_code' => 'affiliate_decline_user', 'tpl' => 'addons/sd_affiliate/declined.tpl', 'company_id' => $user_data['company_id'] ], 'A'); } } } if ($mode == 'm_decline') { if (!empty($_REQUEST['user_ids'])) { foreach ($_REQUEST['user_ids'] as $partner_id) { $_data = fn_get_partner_data($partner_id); if (empty($_data['approved']) || $_data['approved'] != UserStatuses::DECLINED) { $p_data = ['approved' => UserStatuses::DECLINED]; $update_result = fn_update_partner_profile($partner_id, $p_data); if ($update_result) { $user_data = fn_get_user_info($partner_id, false); $mailer = Tygh::$app['mailer']; $mailer->send([ 'to' => $user_data['email'], 'from' => 'company_users_department', 'data' => [ 'user_data' => $user_data, 'reason_declined' => $_REQUEST['action_reason_declined'], ], 'template_code' => 'affiliate_decline_user', 'tpl' => 'addons/sd_affiliate/declined.tpl', 'company_id' => $user_data['company_id'] ], 'A'); } } } } } return [CONTROLLER_STATUS_REDIRECT, 'partners.manage']; } if ($mode == 'tree') { $partners = fn_get_partners_tree(); Tygh::$app['view']->assign('partners', $partners); Tygh::$app['view']->assign('affiliate_plans', fn_sd_affiliate_get_plans_list(DESCR_SL)); } elseif ($mode == 'manage') { $params = $_REQUEST; $params['user_type'] = AffiliateUserTypes::PARTNER; list($partners, $search) = fn_get_users( $params, $auth, Registry::get('settings.Appearance.admin_elements_per_page'), 'affiliates' ); Tygh::$app['view']->assign([ 'search' => $search, 'partners' => $partners, 'user_type' => AffiliateUserTypes::PARTNER, 'affiliate_plans' => fn_sd_affiliate_get_plans_for_partners($partners), 'general_affiliate_plans' => fn_sd_affiliate_get_plans_list(DESCR_SL), 'countries' => fn_get_simple_countries(true, CART_LANGUAGE), 'states' => fn_get_all_states() ]); } 