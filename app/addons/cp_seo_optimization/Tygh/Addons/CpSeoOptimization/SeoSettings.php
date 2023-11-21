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

class SeoSettings
{
    private static $instance;
    private static $settings = [];

    public static function instance()
    {
        if (empty(self::$instance)) {
            self::$instance = new SeoSettings();
        }
        return self::$instance;
    }

    public function get($key, $variant = '')
    {
        if (!isset(self::$settings[$key])) {
            self::$settings[$key] = self::getSettings($key);
        }
        if (empty($variant)) {
            return self::$settings[$key];
        } else {
            return isset(self::$settings[$key][$variant]) ? self::$settings[$key][$variant] : [];
        }
    }

    public function set($key, $settings)
    {
        if (!empty($settings)) {
            self::$settings[$key] = $settings;
        }
    }

    protected function getSettings($key)
    {
        $settings = [];
        switch ($key) {
            case 'addon':
                $settings = \Tygh\Registry::get('addons.cp_seo_optimization');
                break;
            default:
                $settings = fn_get_schema('cp_seo_optimization', $key);
                break;
        }
        return $settings;
    }

    private function __construct() { }
    
    private function __clone() {}

    private function __sleep() {}

    private function __wakeup() {}
}