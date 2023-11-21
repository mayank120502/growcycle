{if $product.cp_custom_price == "YesNo::YES"|enum}
    {assign var="show_qty" value=true scope=parent}
{else}
    {assign var="show_qty" value=false scope=parent}
{/if}