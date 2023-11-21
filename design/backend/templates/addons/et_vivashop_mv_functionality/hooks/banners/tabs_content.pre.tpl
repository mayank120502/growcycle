<div>
	{if isset($banner.company_id)}
		{$company_id=$banner.company_id}
	{elseif $runtime.company_id==0}
		{$company_id=fn_get_session_data('et_company_id')}
	{else}
		{$company_id=$runtime.company_id}
	{/if}
<input type="hidden" value="{$company_id}" name="banner_data[company_id]">
</div>