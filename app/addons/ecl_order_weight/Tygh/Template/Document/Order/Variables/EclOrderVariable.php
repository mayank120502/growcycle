<?php
/*****************************************************************************
*                                                                            *
*                   All rights reserved! eCom Labs LLC                       *
* http://www.ecom-labs.com/about-us/ecom-labs-modules-license-agreement.html *
*                                                                            *
*****************************************************************************/

namespace Tygh\Template\Document\Order\Variables;

use Tygh\Template\Document\Order\Variables\OrderVariable;
use Tygh\Template\Document\Order\Context;
use Tygh\Tools\Formatter;
use Tygh\Registry;

class EclOrderVariable extends OrderVariable
{
    public function __construct(Context $context, array $config, Formatter $formatter)
    {
        parent::__construct($context, $config, $formatter);

        $order = $context->getOrder();

        $this->data['weight'] = $order->data['weight'] . ' ' . Registry::get('settings.General.weight_symbol');

    }
    public static function attributes()
    {

        $variables = parent::attributes();
        $variables[] = 'weight';
        return $variables;
    }
}