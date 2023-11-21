{if $addons.ecl_order_weight.display_on_checkout == 'Y' && $cart.weight > 0}
<tr>
    <td class="ty-checkout-summary__item">{__("weight")}</td>
    <td class="ty-checkout-summary__item ty-right">{$cart.weight} {$settings.General.weight_symbol}</span>
    </td>
</tr>
{/if}