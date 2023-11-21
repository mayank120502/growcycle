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

$schema['cp_seo_templates'] = array(
    'position' => 200,
    'section' => 'cp_seo_templates',
    'title' => __('cp_seo_templates'),
    'actions' => array(
        'generate' => array(
            'title' => __('cp_sf_generate_templates')
        )
    ),
    'content_function' => function ($params) {
        $content = '';
        $action = !empty($params['action']) ? $params['action'] : '';
        if ($action == 'generate') {
            if (!empty($params['content']['template_id'])) {
                $id = $params['content']['template_id'];
                $content =  '<a target="_blank" href="'
                    . fn_url('cp_seo_templates.update?template_id=' . $id)
                    . '">' . __('cp_seo_template') . ' #' . $id . '</a>';
            }
        }
        return $content;
    }
);

return $schema;