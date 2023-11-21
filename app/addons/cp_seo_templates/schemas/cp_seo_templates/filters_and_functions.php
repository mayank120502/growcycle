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

use Twig\Environment;
use Twig\TwigFilter;

$extension = new Environment;
$filters = $extension->getFilters();

$exist_filters = [];
$available_filters = [
    'abs'   => [
        'title'     => __('cp_seo_filter_abs_descr'),
    ],
    'round' => [
        'title'     => __('cp_seo_filter_round_descr'),
        'tooltip'   => __('cp_seo_filter_round_tp'),
    ],
    'title' => [
        'title'     => __('cp_seo_filter_title_descr'),
        'tooltip'   => __('cp_seo_filter_title_tp'),
    ],
    'capitalize' => [
        'title'     => __('cp_seo_filter_capitalize_descr'),
        'tooltip'   => __('cp_seo_filter_capitalize_tp'),
    ],
    'upper' => [
        'title'     => __('cp_seo_filter_upper_descr'),
    ],
    'lower' => [
        'title'     => __('cp_seo_filter_lower_descr'),
    ],
    'trim' => [
        'title'     => __('cp_seo_filter_trim_descr'),
        'tooltip'   => __('cp_seo_filter_trim_tp'),
    ],
    'reverse' => [
        'title'     => __('cp_seo_filter_reverse_descr'),
    ],
    'slice' => [
        'title'     => __('cp_seo_filter_slice_descr'),
        'tooltip'   => __('cp_seo_filter_slice_tp'),
    ],
    'first' => [
        'title'     => __('cp_seo_filter_first_descr'),
        'tooltip'   => __('cp_seo_filter_first_tp'),
    ],
    'last' => [
        'title'     => __('cp_seo_filter_last_descr'),
        'tooltip'   => __('cp_seo_filter_last_tp'),
    ],
];

$available_functions = [];
foreach ($filters as $name => $filter) {
    if ($filter instanceof TwigFilter) {
        $name = $filter->getName();
        if (!empty($available_filters[$name])) {
            $exist_filters[$name] = $available_filters[$name];
        }
    }
}

return $exist_filters;
