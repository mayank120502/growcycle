{capture name="buttons" assign="buttons"}
{if $settings.General.enable_compare_products == "Y"}
	{$compared_products_count=count(fn_get_comparison_products())}
	<a href="{"product_features.compare"|fn_url}" class="et-header-compare">
		<i class="et-icon-btn-compare"></i>
		{if $compared_products_count>0}
			<span class="et-compare-count">{$compared_products_count}</span>
		{else}
			<span class="et-compare-count empty">0</span>
		{/if}
	</a>
{/if}

{if $addons.wishlist.status == "A"}
	{$wish_count=fn_et_get_wishlist_get_count()}
	<a href="{"wishlist.view"|fn_url}" rel="nofollow" class="et-header-wishlist">
		<i class="et-icon-btn-wishlist"></i>
		{if $wish_count>0}
			<span class="et-wishlist-count">{$wish_count}</span>
		{else}
			<span class="et-wishlist-count empty">0</span>
		{/if}
	</a>
{/if}
{/capture}

{if $buttons|trim}
<div class="et-header-links" id="et-cw_{$block.grid_id}">
	{$buttons nofilter}
<!--et-cw_{$block.grid_id}--></div>
{/if}