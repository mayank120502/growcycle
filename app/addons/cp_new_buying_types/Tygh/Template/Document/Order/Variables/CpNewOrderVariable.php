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

namespace Tygh\Template\Document\Order\Variables;

use Tygh\Enum\Addons\CpNewBuyingTypes\ProductBuyingTypes;
use Tygh\Template\Document\Order\Context;
use Tygh\Tools\Formatter;

class CpNewOrderVariable extends OrderVariable
{
    public function __construct(Context $context, array $config, Formatter $formatter)
    {
        parent::__construct($context, $config, $formatter);
        $order = $context->getOrder();

        if ($order->data['cp_buying_type'] === ProductBuyingTypes::START_ORDER) {
            $this->data['total'] = __('cp_new_buying_types.to_be_negotiated');
        }
    }
}
