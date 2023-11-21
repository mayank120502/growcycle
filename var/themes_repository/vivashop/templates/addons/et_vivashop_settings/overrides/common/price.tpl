{strip}
{if $settings.General.alternative_currency == "use_selected_and_alternative"}
	{if $et_normal_price}
		{$value|format_price:$currencies.$primary_currency:$span_id:$class:false:$live_editor_name:$live_editor_phrase nofilter}
	{else}
		{$value|fn_et_format_price:$currencies.$primary_currency:$span_id:$class:false:$live_editor_name:$live_editor_phrase nofilter}
	{/if}
	{if $secondary_currency != $primary_currency}
		&nbsp;
		{if $class}<span class="{$class}">{/if}
		(
		{if $class}</span>{/if}
		{if $et_normal_price}
			<bdi>{$value|format_price:$currencies.$secondary_currency:$span_id:$class:true:$is_integer:$live_editor_name:$live_editor_phrase nofilter}</bdi>
		{else}
			<bdi>{$value|fn_et_format_price:$currencies.$secondary_currency:$span_id:$class:true:$is_integer:$live_editor_name:$live_editor_phrase nofilter}</bdi>
		{/if}
		{if $class}<span class="{$class}">{/if}
		)
		{if $class}</span>{/if}
	{/if}
{else}
	{if $et_normal_price}
		<bdi>{$value|format_price:$currencies.$secondary_currency:$span_id:$class:true:$live_editor_name:$live_editor_phrase nofilter}</bdi>
	{else}
		<bdi>{$value|fn_et_format_price:$currencies.$secondary_currency:$span_id:$class:true:$live_editor_name:$live_editor_phrase nofilter}</bdi>
	{/if}
{/if}
{/strip}