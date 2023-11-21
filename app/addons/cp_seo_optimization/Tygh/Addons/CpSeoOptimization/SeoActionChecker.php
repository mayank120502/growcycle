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

namespace Tygh\Addons\CpSeoOptimization;

use Tygh\Addons\CpSeoOptimization\SeoSettings;
use Tygh\Registry;

class SeoActionChecker
{
    private static $checked_actions = [];
    private static $ignore_actions = [];
    private static $extra = [];
    private static $no_index_value = '';
    private static $use_addon_conditions = false;

    public function __construct() {}

    public static function ignoreAction($action)
    {
        if (!in_array($action, self::$ignore_actions)) {
            self::$ignore_actions[] = $action;
        }
    }

    public static function isCheckedAction($action)
    {
        return in_array($action, self::$checked_actions);
    }

    public static function addCheckedAction($action)
    {
        if (!in_array($action, self::$checked_actions)) {
            self::$checked_actions[] = $action;
        }
    }

    public function setCheckedActions($actions)
    {
        self::$checked_actions = $actions;
    }

    public function getCheckedActions()
    {
        return self::$checked_actions;
    }
    
    public function getIndexValue()
    {
        return self::$no_index_value;
    }
    
    public function getIsFromAddon()
    {
        return self::$use_addon_conditions;
    }

    public function getActionsExtra($key = '')
    {
        return !empty($key) && isset(self::$extra[$key]) ? self::$extra[$key] : self::$extra;
    }

    public function addToActionsExtra($data)
    {   
        if (empty($data)) {
            return;
        }
        self::$extra = array_merge(self::$extra, $data);
    }

    public function checkNoindexParams($params)
    {
        $seo_settings = SeoSettings::instance()->get('seo_settings');
        if (empty($seo_settings['noindex_params'])) {
            return;
        }
        if (is_array($seo_settings['noindex_params'])) {
            $noindex_params = $seo_settings['noindex_params'];
        } else {
            $noindex_params = !empty($seo_settings['noindex_params']) ? explode(',', $seo_settings['noindex_params']) : [];
        }
        if (!empty($noindex_params) && is_array($noindex_params)) {
            foreach ($noindex_params as $noindex_param) {
                $noindex_param = trim($noindex_param);
                if (isset($params[$noindex_param])) {
                    self::addCheckedAction('noindex');
                    self::$no_index_value = Registry::get('addons.cp_seo_optimization.noindex_robots');
                    break;
                }
            }
        }
    }

    public function checkLocationActions($params, $actions = [])
    {
        if (empty($params['dispatch']) || $params['dispatch'] == '_no_page') {
            return;
        }
        list($controller, $mode) = explode('.', $params['dispatch']);
        $seo_check = SeoSettings::instance()->get('seo_check');
        if (empty($seo_check[$controller][$mode]) || !is_array($seo_check[$controller][$mode])) {
            return;
        }
        $obj_data = [];
        if (!empty($seo_check[$controller][$mode]['front_object'])) {
            $obj_data = \Tygh::$app['view']->getTemplateVars($seo_check[$controller][$mode]['front_object']);
        }
        $mapping = [
            'D' => Registry::get('addons.cp_seo_optimization.noindex_robots'),
            'N' => '',
            'F' => 'noindex,follow',
            'Y' => 'noindex,nofollow',
            'I' => 'index,nofollow'
        ];
        if (!empty($obj_data['cp_seo_no_index']) && !empty($mapping[$obj_data['cp_seo_no_index']])) {
            self::$no_index_value = $mapping[$obj_data['cp_seo_no_index']];
        }
        if (
            (empty($obj_data['cp_seo_use_addon'])
            || $obj_data['cp_seo_use_addon'] != 'Y')
            && !isset($params['skip_validation'])
        ) {
            return;
        }
        self::$use_addon_conditions = true;
        $seo_settings = SeoSettings::instance()->get('seo_settings');
        foreach ($seo_check[$controller][$mode] as $setting_param => $check_objects) {
            $check_objects = is_array($check_objects) ? $check_objects : [$check_objects];
            $seo_setting = !empty($seo_settings[$setting_param]) ? $seo_settings[$setting_param] : [];
            $action = !empty($seo_setting['action']) ? $seo_setting['action'] : '';

            if (empty($action)
                || in_array($action, self::$checked_actions)
                || in_array($action, self::$ignore_actions)
                || !empty($actions) && !in_array($action, $actions)
            ) {
                continue;
            }
            foreach ($check_objects as $check_object) {
                // Check that the setting exists and whether it is enabled
                if (empty($seo_setting['items'][$check_object])
                    || (!$this->checkSettingEnabled($setting_param, $check_object)
                        && empty($seo_setting['skip_setting_check']))
                ) {
                    continue;
                }
                // Check action object and remember action
                $check_function = '';
                $action_object = $seo_setting['items'][$check_object];
                if (!empty($action_object['check_function'])) {
                    $check_function = $action_object['check_function'];
                } elseif (!empty($seo_setting['check_function'])) {
                    $check_function = $seo_setting['check_function'];
                }
                $extra = [];
                $action_check = !empty($seo_setting['default']) ? $seo_setting['default'] : false;
                if (!empty($check_function) && is_callable($check_function)) {
                    $action_check = call_user_func_array($check_function, array($params, &$extra));
                }
                if ($action_check) { // action validated
                    self::addCheckedAction($action);
                    $process_function = '';
                    if (!empty($action_object['process_function'])) {
                        $process_function = $action_object['process_function'];
                    } elseif (!empty($seo_setting['process_function'])) {
                        $process_function = $seo_setting['process_function'];
                    }
                    if (!empty($process_function) && is_callable($process_function)) {
                        call_user_func_array($process_function, array($params, &$extra));
                    }
                }
                self::addToActionsExtra($extra);
            }
        }
    }

    protected function checkSettingEnabled($setting_param, $check_object)
    {
        $setting_check = false;
        $settings = SeoSettings::instance()->get('addon');
        if (!empty($settings[$setting_param])) {
            $addon_setting = $settings[$setting_param];
            if (is_array($addon_setting)) {
                $setting_check = !empty($addon_setting[$check_object]) && $addon_setting[$check_object] == 'Y' ? true : false;
            } else {
                $setting_check = ($addon_setting == $check_object) ? true : false;
            }
        }
        return $setting_check;
    }
}