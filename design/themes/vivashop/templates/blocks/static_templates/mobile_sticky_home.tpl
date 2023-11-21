<div class="mobile-sticky-menu-item">
	{$url=""}
	{if $use_vendor_url && (isset($smarty.request.company_id) || isset($object_id))}
		{if $smarty.request.company_id}
			{$url="companies.view&company_id=`$smarty.request.company_id`"}
		{else}
			{$url="companies.view&company_id=`$object_id`"}
		{/if}
	{/if}

	<a href="{$url|fn_url}" class="mobile-sticky-menu-link {if $smarty.request.dispatch=="index.index"}active{/if}">
		<i class="et-icon-fib-premium"></i>
	</a>
</div>