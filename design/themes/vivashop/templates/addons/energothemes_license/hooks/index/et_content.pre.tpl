{if function_exists(fn_energothemes_license_check_valid)}{if fn_energothemes_license_check_valid}

{$dispatch_class=str_replace('.','_',$location_data.dispatch)}
<div id="{$dispatch_class}">
{render_location}
</div>
{/if}{/if}