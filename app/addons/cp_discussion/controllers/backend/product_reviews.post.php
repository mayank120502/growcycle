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

use Tygh\Addons\ProductReviews\ServiceProvider as ProductReviewsProvider;
use Tygh\Enum\UserTypes;
use Tygh\Providers\StorefrontProvider;

defined('BOOTSTRAP') or die('Access denied');

$auth = & Tygh::$app['session']['auth'];
$service = ProductReviewsProvider::getService();

$storefront_id = empty($_REQUEST['storefront_id'])
    ? 0
    : (int) $_REQUEST['storefront_id'];

if (fn_allowed_for('ULTIMATE')) {
    $storefront_id = 0;
    if (fn_get_runtime_company_id()) {
        $storefront_id = StorefrontProvider::getStorefront()->storefront_id;
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (
        $mode === 'update'
        && !empty($_REQUEST['product_review_data']['product_review_id'])
    ) {
        $product_review_data = $_REQUEST['product_review_data'];
        $product_review_data['reply_user_id'] = $auth['user_id'];

        if (UserTypes::isAdmin($auth['user_type'])) {
            fn_cp_update_date_reviews($product_review_data['product_review_id'], $product_review_data);
        }
    }
}

if ($mode == 'generate_time') {
    $timestamp = fn_cp_generate_rnd_date_from_time_periods();
    $post_data['product_review_timestamp'] = $timestamp;
    $post_data['time_type'] = fn_cp_check_time_format($timestamp);
    Tygh::$app['view']->assign('product_review', $post_data);
    Tygh::$app['view']->display('addons/product_reviews/views/product_reviews/components/update/review.tpl');
}