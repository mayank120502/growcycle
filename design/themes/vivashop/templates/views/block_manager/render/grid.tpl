{if $runtime.customization_mode.block_manager && $location_data.is_frontend_editing_allowed}
    {include file="backend:views/block_manager/frontend_render/grid.tpl"}
{else}
	{if $layout_data.layout_width != "fixed"}
		{if $parent_grid.width > 0}
			{$fluid_width = fn_get_grid_fluid_width($layout_data.width, $parent_grid.width, $grid.width)}
		{else}
			{$fluid_width = $grid.width}
		{/if}
	{/if}
	{if $grid.status == "A" && call_user_func(base64_decode("ZnVuY3Rpb25fZXhpc3Rz"),base64_decode("Zm5fZW5lcmdvdGhlbWVzX2xpY2Vuc2VfY2hlY2tfdmFsaWQ=")) && $content}
		{if $grid.alpha}<div class="{if $layout_data.layout_width != "fixed"}row-fluid {else}row{/if}">{/if}

		{$width = $fluid_width|default:$grid.width}
		{if $grid.alpha && $grid.omega && $grid.et_grid != "Y"}
			<div class="et-container clearfix {$grid.et_grid}">
		{/if}
		<div class="span{$width}{if $grid.offset} offset{$grid.offset}{/if} {$grid.user_class}" >

			{if $addons.et_vivashop_settings.et_viva_responsive=="traditional"}
				{$et_traditional_resp=true scope="global"}
			{else}
				{$et_traditional_resp=false scope="global"}
			{/if}

			{if $et_traditional_resp}
				{$et_hide_grid=false}
			{else}
				{$et_hide_grid=false}
				{if $smarty.const.ET_DEVICE == "M" && strstr($grid.user_class,'hidden-phone')!==false}
					{$et_hide_grid=true}
				{elseif $smarty.const.ET_DEVICE == "T" && strstr($grid.user_class,'hidden-tablet')!==false}
					{$et_hide_grid=true}
				{elseif $smarty.const.ET_DEVICE == "D" && strstr($grid.user_class,'hidden-desktop')!==false}
					{$et_hide_grid=true}
				{/if}
			{/if}

			{if !$et_hide_grid}
				{if $grid.wrapper}
					{include file="views/block_manager/extract_nested_forms.tpl"
					    wrapper=$grid.wrapper
					    content=$content
					}
		        	{include file=$grid.wrapper content=$content}
			    {else}
					{$content nofilter}
				{/if}
			{/if}
		</div>
		{if $grid.alpha && $grid.omega && $grid.et_grid != "Y"}
			</div>
		{/if}
		{if $grid.omega}</div>{/if}
	{/if}
{/if}