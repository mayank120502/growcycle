{if $is_wishlist}

{if $addons.et_vivashop_mv_functionality.et_product_link=="vendor"}
    {if $product.company_id && $product.company_has_store}
      {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
      {if !$smarty.request.company_id}
        {$et_add_blank='target="_blank"'}
      {else}
        {$et_add_blank=''}
      {/if}
    {else}
      {$product_detail_view_url="products.view&product_id=`$product.product_id`"}
      {$et_add_blank=''}
    {/if}
{else}
    {$et_add_blank=''}
    {if $use_vendor_url}
          {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
    {else}
      {$product_detail_view_url="products.view&product_id=`$product.product_id`"}
    {/if}
{/if}

{if $product.combination}
    {$product_detail_view_url="`$product_detail_view_url`&combination=`$product.combination`"}
{/if}

{if $show_name}
    {if $hide_links}<strong>{else}<a href="{"$product_detail_view_url"|fn_url}" {$et_add_blank nofilter} class="product-title" title="{$product.product|strip_tags}" {live_edit name="product:product:{$product.product_id}" phrase=$product.product}>{/if}{$product.product nofilter}{if $hide_links}</strong>{else}</a>{/if}
{elseif $show_trunc_name}
    {if $hide_links}<strong>{else}<a href="{"$product_detail_view_url"|fn_url}" {$et_add_blank nofilter} class="product-title" title="{$product.product|strip_tags}" {live_edit name="product:product:{$product.product_id}" phrase=$product.product}>{/if}{$product.product|truncate:44:"...":true nofilter}{if $hide_links}</strong>{else}</a>{/if}
{/if}
{/if}