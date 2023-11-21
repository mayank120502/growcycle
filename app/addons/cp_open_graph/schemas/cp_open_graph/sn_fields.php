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


$schema = [
    'fb' => [
        'prefix'    => 'cp_fb_',
        'label'     => __('cp_og_image_for_fb'),
        'tooltip'   => __('cp_og_image_for_fb_descr')
    ],
    'vk' => [
        'prefix'    => 'cp_vk_',
        'label'     => __('cp_og_image_for_vk'),
        'tooltip'   => __('cp_og_image_for_vk_descr')
    ],
    'twitter' => [
        'prefix'    => 'cp_twitter_',
        'label'     => __('cp_og_image_for_twitter'),
        'tooltip'   => __('cp_og_image_for_twitter_descr')
    ],
];

return $schema;