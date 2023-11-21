{if $addons.ecl_order_weight.display_on_checkout == 'Y' && $cart.weight > 0}
<li class="ty-cart-statistic__item ty-statistic-list-subtotal">
    <span class="ty-cart-statistic__title">{__("weight")}</span>
    <span class="ty-cart-statistic__value">{$cart.weight} {$settings.General.weight_symbol}</span>
</li>
{/if}