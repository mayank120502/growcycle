<?php
/*****************************************************************************
*                                                                            *
*                   All rights reserved! eCom Labs LLC                       *
* http://www.ecom-labs.com/about-us/ecom-labs-modules-license-agreement.html *
*                                                                            *
*****************************************************************************/

namespace Tygh\Template\Document\PackingSlip\Variables;

use Tygh\Template\Document\PackingSlip\Variables\OrderVariable;
use Tygh\Template\Document\PackingSlip\Context;
use Tygh\Tools\Formatter;
use Tygh\Registry;

class EclOrderVariable extends OrderVariable
{
    public function __construct(Context $context, array $config, Formatter $formatter)
    {
        parent::__construct($context, $config, $formatter);

        $order = $context->getOrder();

        $weight = 0;
        if ($this->data['shipment']) {
            foreach ($this->data['shipment']['products'] as $key => $amount) {
                if (isset($order->data['products'][$key])) {
                    $weight = $order->data['products'][$key]['extra']['weight'] * $amount;
                }
            }
        } else {
            $weight = $order->data['weight'];
        }

        $this->data['weight'] = $weight . ' ' . Registry::get('settings.General.weight_symbol');

    }
    public static function attributes()
    {

        $variables = parent::attributes();
        $variables[] = 'weight';
        return $variables;
    }
}