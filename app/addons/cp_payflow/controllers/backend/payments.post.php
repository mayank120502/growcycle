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

use Tygh\Enum\Addons\Paypal\Processors;
use Tygh\Tygh;

if (!defined('BOOTSTRAP')) {
    die('Access denied');
}

if ($mode == 'processor') {

    $processor_id = null;
    if (isset($_REQUEST['processor_id'])) {
        $processor_id = $_REQUEST['processor_id'];
    } elseif (isset($_REQUEST['payment_id'])) {
        $payment = fn_get_payment_method_data($_REQUEST['payment_id']);
        if (isset($payment['processor_id'])) {
            $processor_id = $payment['processor_id'];
        }
    }

    $is_cp_payflow_processor = false;
    if ($processor_id !== null) {
        $is_cp_payflow_processor = fn_is_cp_payflow_processor($processor_id);
    }

    if ($is_cp_payflow_processor) {
        /** @var string $processor_script */
        $processor_script = db_get_field(
            'SELECT processor_script FROM ?:payment_processors'
                . ' WHERE processor_id = ?i',
            $processor_id
        );

        /** @var array $script_to_type_map */
        $script_to_type_map = Processors::getAllWithTypes();

        if (isset($script_to_type_map[$processor_script])) {
            $type = $script_to_type_map[$processor_script];
        } else {
            $type = null;
        }

        $cp_payflow_currencies = fn_paypal_get_currencies($type);

        /** @var \Tygh\SmartyEngine\Core $view */
        $view = Tygh::$app['view'];

        $view->assign('cp_payflow_currencies', $cp_payflow_currencies);
    }
}
