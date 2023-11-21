{if $settings.General.enable_compare_products == "Y"}
<div class="mobile-sticky-menu-item et-mobile-sticky-compare">
	{$compared_products_count=count(fn_get_comparison_products())}
	<div id="et-cw_{$block.block_id}">
		<a href="{"product_features.compare"|fn_url}" class="mobile-sticky-menu-link {if $smarty.request.dispatch=="product_features.compare"}active{/if}">
			<span class="et-sticky-icon-wrapper">
				<i class="et-icon-btn-compare"></i>
				{if $compared_products_count>0}
					<span class="et-compare-count">{$compared_products_count}</span>
				{else}
					<span class="et-compare-count empty">0</span>
				{/if}
			</span>
		</a>
	<!--et-cw_{$block.block_id}--></div>
</div>
{/if}