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

namespace Tygh\Enum\Addons\CpNewBuyingTypes;

use ReflectionClass;
use Tygh\Registry;

/**
 * @package Tygh\Enum
 */
class ProductBuyingTypes
{
    public const VENDOR_DEFAULT = 'V';
    public const BUY = 'B';
    public const CONTACT_VENDOR = 'C';
    public const START_ORDER = 'O';

    public static function getAll($ignore_types = [self::VENDOR_DEFAULT], $but_text = false): array
    {
        $types = [];
        $lang_postfix = $but_text ? '.but_text' : '';

        foreach ((new ReflectionClass(static::class))->getConstants() as $type) {
            if (!$ignore_types || !in_array($type, $ignore_types, true)) {
                $types[$type] = __("cp_new_buying_types.types.{$type}{$lang_postfix}");
            }
        }

        return $types;
    }

    public static function getDefault(): string
    {
        return self::BUY;
    }


    public static function getAdditional($but_text = false): array
    {
        return self::getAll([self::VENDOR_DEFAULT, self::BUY], $but_text);
    }
}
