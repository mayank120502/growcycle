    {if $smarty.request.redirect_url}
        {$current_url = $smarty.request.redirect_url|urlencode}
    {else}
        {$current_url = $config.current_url|urlencode}
    {/if}
{capture name="quick_view_url"}
  {** Sets quick view link *}
  {hook name="products:product_quick_view_url"}
  {"products.quick_view?product_id=`$product.product_id`&prev_url=`$current_url`"}
  {/hook}
{/capture}
{$quick_view_url = $smarty.capture.quick_view_url|trim}
{if $block.type && $block.type != 'main'}
  {$quick_view_url = $quick_view_url|fn_link_attach:"n_plain=Y"}
{/if}
{if $quick_nav_ids} 
  {$quick_nav_ids = ","|implode:$quick_nav_ids}
  {$quick_view_url = $quick_view_url|fn_link_attach:"n_items=`$quick_nav_ids`"}
{/if}

{if $use_vendor_url}
	{$quick_view_url = $quick_view_url|fn_link_attach:"use_vendor_url=Y"}
{/if}

{if $show_et_icon_buttons}
<a class="cm-tooltip et-quick-view cm-dialog-opener cm-dialog-auto-size" title="{__("quick_view")}" data-ca-view-id="{$product.product_id}"  data-ca-target-id="product_quick_view" href="{$quick_view_url|fn_url}" data-ca-dialog-title="{__("quick_product_viewer")}" rel="nofollow">
	<i class="et-icon-btn-qv2"></i>
</a>{elseif $show_et_icon_grid}
<a class="cm-tooltip et-quick-view et-button cm-dialog-opener cm-dialog-auto-size" title="{__("quick_view")}" data-ca-view-id="{$product.product_id}"  data-ca-target-id="product_quick_view" href="{$quick_view_url|fn_url}" data-ca-dialog-title="{__("quick_product_viewer")}" rel="nofollow">
	<i class="et-icon-btn-qv2"></i>
</a>{else}
<div class="ty-quick-view-button">
<a class="ty-btn ty-btn__secondary ty-btn__big cm-dialog-opener cm-dialog-auto-size" data-ca-view-id="{$product.product_id}" data-ca-target-id="product_quick_view" href="{$quick_view_url|fn_url}" data-ca-dialog-title="{__("quick_product_viewer")}" rel="nofollow">{__("quick_view")}</a>
</div>{/if}