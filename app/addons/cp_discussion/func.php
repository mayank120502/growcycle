<?php
/*****************************************************************************
*                                                        © 2013 Cart-Power   *
*           __   ______           __        ____                             *
*          / /  / ____/___ ______/ /_      / __ \____ _      _____  _____    *
*      __ / /  / /   / __ `/ ___/ __/_____/ /_/ / __ \ | /| / / _ \/ ___/    *
*     / // /  / /___/ /_/ / /  / /_/_____/ ____/ /_/ / |/ |/ /  __/ /        *
*    /_//_/   \____/\__,_/_/   \__/     /_/    \____/|__/|__/\___/_/         *
*                                                                            *
*                                                                            *
* -------------------------------------------------------------------------- *
* This is commercial software, only users who have purchased a valid license *
* and  accept to the terms of the License Agreement can install and use this *
* program.                                                                   *
* -------------------------------------------------------------------------- *
* website: https://store.cart-power.com                                      *
* email:   sales@cart-power.com                                              *
******************************************************************************/

use Tygh\Enum\ObjectStatuses;
use Tygh\Enum\YesNo;
use Tygh\Registry;
use Tygh\Settings;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

/* HOOKS */

function fn_cp_discussion_update_discussion_posts_post($posts)
{
	foreach ($posts as $id => $post) {
		if (!empty($post['time_type'])) {
			$type = $post['time_type'] == 'P' ? 'p.m' : 'a.m';
			$time = date("H:i", strtotime($post['time'] . ' ' . $type));
			$timestamp = fn_parse_datetime($post['date'] . ' ' . $time);
			$posts_update[$id]['post_id'] = $id;
			$posts_update[$id]['timestamp'] = $timestamp;
		}
	}

	if (!empty($posts_update)) {
		/** @var \Tygh\Database\Connection $db */
		$db = Tygh::$app['db'];
		$db->replaceInto('discussion_posts', $posts_update, true, ['post_id', 'timestamp']);
	}
}

function fn_cp_discussion_product_reviews_create_pre(&$product_review_data)
{
	$addon_settings = fn_get_cp_discussion_settings();
	if (
		isset($product_review_data['product_review_timestamp'])
		&& !empty($addon_settings['general']['cp_date_reviews']['rnd_time_storefront'])
		&& $addon_settings['general']['cp_date_reviews']['rnd_time_storefront'] == YesNo::YES
		&& !empty($addon_settings['general']['cp_date_reviews']['cp_from_date'])
		&& !empty($addon_settings['general']['cp_date_reviews']['cp_to_date'])
	) {
		$product_review_data['product_review_timestamp'] = fn_cp_generate_rnd_date_from_time_periods();
	}
}

function fn_cp_discussion_add_discussion_post_post($post_data, $send_notifications)
{
	$addon_settings = fn_get_cp_discussion_settings();
	if (
		isset($post_data['timestamp'])
		&& !empty($addon_settings['general']['cp_date_reviews']['rnd_time_storefront'])
		&& $addon_settings['general']['cp_date_reviews']['rnd_time_storefront'] == YesNo::YES
		&& !empty($post_data['post_id'])
		&& !empty($addon_settings['general']['cp_date_reviews']['cp_from_date'])
		&& !empty($addon_settings['general']['cp_date_reviews']['cp_to_date'])
	) {
		db_query("UPDATE ?:discussion_posts SET timestamp = ?i WHERE post_id = ?i", fn_cp_generate_rnd_date_from_time_periods(), $post_data['post_id']);
	}
}

/* HOOKS END */

function fn_cp_discussion_set_settings()
{
	$addon_settings['cp_date_reviews']['cp_from_date'] = date('m/d/Y', strtotime("-1 day"));;
	$addon_settings['cp_date_reviews']['cp_to_date'] = date("m/d/Y");
	fn_update_cp_discussion_settings($addon_settings);
}

function fn_cp_update_date_reviews($product_review_id, array $product_review_data)
{
	if (!$product_review_id) {
		return;
	}

	$new_product_review_data = [
		'product_review_id' => $product_review_id,
	];

	$type = (!empty($product_review_data['time_type']) && $product_review_data['time_type'] == 'P') ? 'p.m' : 'a.m';
	$product_review_data['time'] = date("H:i", strtotime($product_review_data['time'] . ' ' . $type));

	if (!empty($product_review_data['date'])) {
		$new_product_review_data['product_review_timestamp'] = fn_parse_datetime($product_review_data['date'] . ' ' . $product_review_data['time']);
	}

	return db_replace_into('product_reviews', $new_product_review_data);
}

function fn_update_cp_discussion_settings($settings)
{
	foreach ($settings as $k_set => $setting) {
		if ($setting['cp_from_date'] || $setting['cp_to_date']) {
			foreach ($setting as $setting_name => &$setting_value) {
				if ($setting_name != 'rnd_time_storefront') {
					$setting_value = fn_date_to_timestamp($setting_value);
					if ($setting_name == 'cp_from_date' && $setting_value > TIME) {
						fn_set_notification('E', __('error'), __('cp_discussion.enter_time_more_current', ['[cp_date_setting]' => 'Start date']));
						return false;
					} else if ($setting_name == 'cp_to_date' && $setting_value > TIME) {
						fn_set_notification('E', __('error'), __('cp_discussion.enter_time_more_current', ['[cp_date_setting]' => 'End date']));
						return false;
					}
				}
			}
			if ($setting['cp_from_date'] >= $setting['cp_to_date']) {
				fn_set_notification('E', __('error'), __('cp_discussion.enter_error_time'));
				return false;
			}
			unset($setting_value);
		}
		$_setting[$k_set] = serialize($setting);
    }
	foreach ($_setting as $_k => $data) {
		Settings::instance()->updateValue($_k, $data);
	}
}

function fn_cp_check_time_format($timestamp)
{
	$hour = date("H", $timestamp);

	if($hour >= 12) {
        $time_type = 'P';
    } else {
        $time_type = 'A';
    }

	return $time_type;
}

function fn_get_cp_discussion_settings()
{
	$settings = Settings::instance()->getValues('cp_discussion', 'ADDON');
	if (!empty($settings['general']['cp_date_reviews'])) {
		$settings['general']['cp_date_reviews'] = unserialize($settings['general']['cp_date_reviews']);
	}

    return $settings;
}

function fn_cp_generate_rnd_date_from_time_periods()
{
	$settings = fn_get_cp_discussion_settings();
	$period = $settings['general']['cp_date_reviews'];
	$int = fn_cp_check_valid_date($period);

	return $int;
}

function fn_cp_check_valid_date($period)
{
	if ($period['cp_from_date'] > TIME) {
		return false;
	}

	do {
		$time = rand($period['cp_from_date'], $period['cp_to_date']);
		$hour = date("H", $time);
		if (!($hour > 8 && $hour < 23)) {
			$time = 0;
		}
		
	} while ($time > TIME || $time == 0);

	return $time;
}

function fn_cp_m_update_timestamp_reviews()
{
	$settings = fn_get_cp_discussion_settings();
	$period = $settings['general']['cp_date_reviews'];
	if (Registry::get('addons.discussion.status') == ObjectStatuses::ACTIVE) {
		$post_list = db_get_array("SELECT * FROM ?:discussion_posts");
		foreach ($post_list as &$post) {
			$post['timestamp'] = fn_cp_check_valid_date($period);
		}
		db_replace_into('discussion_posts', $post_list, true);
	}

	if (Registry::get('addons.product_reviews.status') == ObjectStatuses::ACTIVE) {
		$review_list = db_get_array("SELECT * FROM ?:product_reviews");
		foreach ($review_list as &$review) {
			$review['product_review_timestamp'] = fn_cp_check_valid_date($period);
		}
		db_replace_into('product_reviews', $review_list, true);
	}
}