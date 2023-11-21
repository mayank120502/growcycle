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

namespace Tygh\Enum\Addons\CpMinimalOrderAmount;

class NotificationDisplayTypes
{
    /**
     * @const SEPARATE Notifications will be in separate notifications containers
     */
    const SEPARATE = 'S';

    /**
     * @const INTO_ONE Notifications will be in single notifications container
     */
    const INTO_ONE = 'I';

    /**
     * Returns notifications display types
     * 
     * @return array
     */
    public static function getDisplaytypes()
    {
        $variants = [
            self::SEPARATE  => __('cp_minimal_order_amount.separate_notifications'),
            self::INTO_ONE  => __('cp_minimal_order_amount.into_one_notifications')
        ];

        return $variants;
    }
}
