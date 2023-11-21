{if !$et_category_list}
<input type="hidden" name="appearance[dont_show_points]" value="{$dont_show_points}" />
{/if}
{if $show_price_values && !$dont_show_points}
    {include file="addons/reward_points/views/products/components/product_representation.tpl"}
{/if}