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

function fn_settings_variants_addons_cp_hawthorne_integration_company_id()
{
    $return = fn_get_short_companies();
    if (isset($return[0])) {
        unset($return[0]);
    }
    return $return;
}

function fn_settings_variants_addons_cp_hawthorne_integration_import_category_id()
{
    [$categories_tree, ] = fn_get_categories(['status' => ObjectStatuses::DISABLED, 'parent_id' => 0]);
    foreach ($categories_tree as $category) {
        $categories[$category['category_id']] = $category['category'];
    }

    return ['0' => __('none')] + $categories;
}