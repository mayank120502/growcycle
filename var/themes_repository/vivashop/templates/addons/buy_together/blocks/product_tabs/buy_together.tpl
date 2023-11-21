{** block-description:buy_together **}

{script src="js/tygh/exceptions.js"}

{if $chains}

  {if !$config.tweaks.disable_dhtml && !$no_ajax}
    {assign var="is_ajax" value=true}
  {/if}

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
  
  {foreach from=$chains key="key" item="chain"}
    {include file="addons/buy_together/components/buy_together_chain_form.tpl"}
  {/foreach}
  
{/if}
