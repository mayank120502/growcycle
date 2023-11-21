{if $order_info.cp_buying_type === "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::START_ORDER"|enum}
{hook name="orders:order_total"}
    <tr class="ty-orders-summary__row">
        <td class="ty-orders-summary__total">{__("total")}:&nbsp;</td>
        <td class="ty-orders-summary__total et-orders-summary__total-price" data-ct-orders-summary="summary-total">{__('cp_new_buying_types.to_be_negotiated')}</td>
    </tr>
{/hook}
{/if}
