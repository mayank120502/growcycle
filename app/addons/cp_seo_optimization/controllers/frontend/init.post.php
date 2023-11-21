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

use Tygh\Registry;
use Tygh\Addons\CpSeoOptimization\SeoActionChecker;
use Tygh\Addons\CpSeoOptimization\SeoSettings;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    return;
}

$addons_settings = Registry::get('addons.cp_seo_optimization');
// HTML minify
if (!defined('AJAX_REQUEST') && $addons_settings['html_minify'] == 'Y') {
    Registry::get('view')->loadFilter('output', 'trimwhitespace');
}

// 301 Last-Modified
$use_for = Registry::ifGet('addons.cp_seo_optimization.lastmod_for', 'none');
$is_bot = fn_cp_seo_is_bot();
if ($use_for == 'all'
    || $use_for == 'robots' && $is_bot
    || $use_for == 'users' && !$is_bot
) {
    $params = $_REQUEST;
    $params['skip_validation'] = true;
    $action_checker = new SeoActionChecker();
    $action_checker->checkLocationActions($params, ['lastmod']);
    
    $last_modified = $action_checker->getActionsExtra('lastmod');
    if ($action_checker->isCheckedAction('lastmod') && !empty($last_modified)) {
        if (!empty($_SERVER['HTTP_IF_MODIFIED_SINCE'])) {
            $modified_since = strtotime(substr($_SERVER['HTTP_IF_MODIFIED_SINCE'], 5));
            if (!empty($_SERVER['SERVER_PROTOCOL'])
                && !empty($modified_since)
                && $modified_since >= $last_modified
            ) {
                $header = $_SERVER['SERVER_PROTOCOL'] . ' 304 Not Modified';
                header($header);
                exit;
            }
        } else {
            $header = 'Last-Modified: ' . gmdate('D, d M Y H:i:s', $last_modified) . ' GMT';
            header($header);
        }
    }
}
SeoActionChecker::ignoreAction('lastmod'); // to avoid using this action further
