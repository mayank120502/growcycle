{capture assign="et_content"}
{assign var="date" value=$avail_date|date_format:$settings.Appearance.date_format}
{if $add_to_cart == "N" ||  $add_to_cart == "S"}
	{assign var="et_coming_soon" value=__("product_coming_soon", ["[avail_date]" => $date])}
	{if $show_et_icon_buttons}
		{include file="buttons/button.tpl" 
			but_text=$but_text|default:$et_coming_soon
			but_id=$but_id 
			but_href=$but_href 
			but_role="et_icon"
			but_target=$but_target 
			but_name=$but_name 
			but_onclick=$but_onclick 
			et_icon="et-icon-btn-clock"
			but_extra_class="et-add-to-cart et-atc-icon-only et-btn-soon"}
	{elseif $show_et_icon_grid}
		{include file="buttons/button.tpl" 
			but_text=$but_text|default:__("et_coming_soon")
			but_id=$but_id 
			but_href=$but_href 
			but_role="et_icon_text"
			but_target=$but_target 
			but_name=$but_name 
			but_onclick=$but_onclick 
			et_icon="et-icon-btn-clock"
			but_extra_class="et-add-to-cart et-btn-soon"} 
		<div class="et-soon-txt-grid et-grid-hide">{$et_coming_soon}</div>
	{elseif $et_category_compact}
		{capture name="et-soon-text_`$obj_id_prefix`"}
			<div class="et-soon-txt-details">{$et_coming_soon}</div>
		{/capture}
		{capture name="et-soon-btn_`$obj_id_prefix`"}
			{include file="buttons/button.tpl" 
				but_text=$but_text|default:__("et_coming_soon")
				but_id=$but_id 
				but_href=$but_href 
				but_role="et_icon_text"
				but_target=$but_target 
				but_name=$but_name 
				but_onclick=$but_onclick 
				et_icon="et-icon-btn-clock"
				but_extra_class="et-add-to-cart et-btn-soon"} 
		{/capture}
	{elseif $et_category_list}
		<div class="et-soon-txt-details">{$et_coming_soon}</div>
		{include file="buttons/button.tpl" 
			but_text=$but_text|default:__("et_coming_soon")
			but_id=$but_id 
			but_href=$but_href 
			but_role="et_icon_text"
			but_target=$but_target 
			but_name=$but_name 
			but_onclick=$but_onclick 
			et_icon="et-icon-btn-clock"
			but_extra_class="et-add-to-cart et-btn-soon"} 
	{elseif $details_page}
		<div class="et-soon-txt-details">{$et_coming_soon}</div>
		<div class="et-product-atc">
			{include file="buttons/button.tpl" 
				but_text=$but_text|default:__("et_coming_soon")
				but_id=$but_id 
				but_href=$but_href 
				but_role="et_icon_text"
				but_target=$but_target 
				but_name=$but_name 
				but_onclick=$but_onclick 
				et_icon="et-icon-btn-clock"
				but_extra_class="et-add-to-cart et-btn-soon"}
		</div>
	{else}
		<div class="et-soon-txt-details">{$et_coming_soon}</div>
	{/if}
{elseif $details_page || ($et_category_list && !$et_category_compact)}
	{assign var="et_coming_soon" value=__("product_coming_soon_add", ["[avail_date]" => $date])}
	<div class="et-soon-txt-details">{$et_coming_soon}</div>
{/if}
{/capture}
{if $et_content|trim}
<div class="ty-product-coming-soon">
	{$et_content nofilter}
</div>
{/if}