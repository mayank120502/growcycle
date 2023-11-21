{if $addons.wishlist.status == "A"}
<div class="mobile-sticky-menu-item et-mobile-sticky-wishlist">
	{$wish_count=fn_et_get_wishlist_get_count()}
	<div id="et-cw_{$block.block_id}">
		<a href="{"wishlist.view"|fn_url}" rel="nofollow" class="mobile-sticky-menu-link {if $smarty.request.dispatch=="wishlist.view"}active{/if}">
			<span class="et-sticky-icon-wrapper">
				<i class="et-icon-btn-wishlist"></i>
				{if $wish_count>0}
					<span class="et-wishlist-count">{$wish_count}</span>
				{else}
					<span class="et-wishlist-count empty">0</span>
				{/if}
			</span>
		</a>
	<!--et-cw_{$block.block_id}--></div>
</div>
{/if}


