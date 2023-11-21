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

namespace Tygh\Addons\CpSeoTemplates\Snippet\Table;

use Tygh\Registry;
use Tygh\SmartyEngine\Core;
use Tygh\Template\IActiveVariable;
use Tygh\Template\Snippet\Table\ItemContext;
use Tygh\Template\IVariable;
use Tygh\Template\Snippet\Table\ProductVariable;
use Tygh\Tools\Formatter;

/**
 * Class CpSeoTemplatesProductVariable
 * @package Tygh\Addons\CpSeoTemplates\Snippet\Table
 */
class CpSeoTemplatesProductVariable extends ProductVariable
{
    protected $image;
    protected $main_pair;
    protected $product;
    protected $view;
    protected $context;
    protected $options;
    protected $formatter;
    protected $config;
    /**
     * CpSeoTemplatesProductVariable constructor.
     * 
     * @param ItemContext   $context    Instance of column context.
     * @param Formatter     $formatter  Instance of 
     */
    public function __construct(ItemContext $context, array $config, Core $view, Formatter $formatter)
    {
        parent::__construct($context, $config, $view, $formatter);
        $prod_data = $this->product = $context->getItem();
        if (!empty($prod_data['order_id'])) {
            $more_data = db_get_row("SELECT lang_code, company_id FROM ?:orders WHERE order_id = ?i", $prod_data['order_id']);
            $store_join = $more_fields = $store_cond = '';
            $lang_code = !empty($more_data['lang_code']) ? $more_data['lang_code'] : CART_LANGUAGE;
            if (fn_allowed_for('ULTIMATE')) {
                $store_join .= db_quote(' LEFT JOIN ?:ult_product_descriptions ON ?:ult_product_descriptions.product_id = pd.product_id AND ?:ult_product_descriptions.lang_code = pd.lang_code AND ?:ult_product_descriptions.company_id = ?i', $more_data['company_id']);
                $more_fields .= ', ?:ult_product_descriptions.cp_st_h1 as ult_h1';
            }
            $custome_h1 = db_get_row("SELECT pd.cp_st_h1 ?p FROM ?:product_descriptions as pd ?p WHERE pd.lang_code = ?s AND pd.product_id = ?i", $more_fields, $store_join, $lang_code, $prod_data['product_id']);
            $h1 = '';
            if (!empty($custome_h1['ult_h1'])) {
                $h1 = $custome_h1['ult_h1'];
            } elseif ($custome_h1['cp_st_h1']) {
                $h1 = $custome_h1['cp_st_h1'];
            }
            if (!empty($h1)) {
                $this->name = $h1;
            }
        }
    }
}