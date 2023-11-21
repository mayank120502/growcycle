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

function fn_cp_st_get_pagination_placeholder($object_data)
{
    $search = Tygh::$app['view']->getTemplateVars('search');
    if (!empty($search['page']) && $search['page'] > 1) {
        $field = __('cp_st_page_title_placeholder', [$search['page']]);
        return $field;
    }
    return '';
}

function fn_cp_st_get_storefront_placeholder($object_data)
{
    if (!empty(Tygh::$app['storefront'])) {
        return Tygh::$app['storefront']->name;
    }
    return '';
}
