{if $addons.ecl_order_weight.display_product_weight == 'Y'}

{if $product.selected_options}
    {$value = $product.selected_options|fn_apply_options_modifiers:$product.weight:'W'}
{else}
    {$value = $product.weight}
{/if}

<div class="ty-weight-group cm-reload-{$obj_prefix}{$obj_id}" id="weight_update_{$obj_prefix}{$obj_id}">
    {if $value && $value != '0.000'}
    <span class="ty-control-group__label product-list-field">{__("weight")}:</span>
    <span class="ty-control-group__item" id="weight_{$obj_prefix}{$obj_id}">{$value} {$settings.General.weight_symbol}</span>
    {/if}
<!--weight_update_{$obj_prefix}{$obj_id}--></div>
{/if}