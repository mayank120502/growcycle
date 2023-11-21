<h1 id="et_category_title_{$block.block_id}">
	{if $et_is_vendor_search}
		{__("search_results")} <span class="et-search_total-items" id="products_search_total_found_{$block.block_id}">({$search.total_items})<!--products_search_total_found_{$block.block_id}--></span>
	{else if $smarty.request.dispatch == "companies.products" && !({$category_data.category_id})}
		<span>
			{__("all_products")}
		</span>
	{else}
		<span {live_edit name="category:category:{$category_data.category_id}"}>{$category_data.category}
		</span>
	{/if}
<!--et_category_title_{$block.block_id}--></h1>
