{assign var="image_size" value=$image_size|default:80}
{function name="feature_value"}
	{strip}
		{if $feature.features_hash && $feature.feature_type == "ProductFeatures::EXTENDED"|enum}
			<a href="{"categories.view?category_id=`$product.main_category`&features_hash=`$feature.features_hash`"|fn_url}"><bdi>
		{/if}
        {if $feature.prefix}<span class="ty-features-list__item-prefix">{$feature.prefix}</span>{/if}
		{if $feature.feature_type == "ProductFeatures::DATE"|enum}
			{$feature.value_int|date_format:"`$settings.Appearance.date_format`"}
		{elseif $feature.feature_type == "ProductFeatures::MULTIPLE_CHECKBOX"|enum}
			{foreach from=$feature.variants item="fvariant" name="ffev"}
				{$fvariant.variant|default:$fvariant.value}{if !$smarty.foreach.ffev.last}, {/if}
			{/foreach}
		{elseif $feature.feature_type == "ProductFeatures::TEXT_SELECTBOX"|enum || $feature.feature_type == "ProductFeatures::NUMBER_SELECTBOX"|enum || $feature.feature_type == "ProductFeatures::EXTENDED"|enum}
			{$feature.variant|default:$feature.value}
		{elseif $feature.feature_type == "ProductFeatures::SINGLE_CHECKBOX"|enum}
			{$feature.description}
		{elseif $feature.feature_type == "ProductFeatures::NUMBER_FIELD"|enum}
			{$feature.value_int|floatval}
		{else}
			{$feature.value}
		{/if}
        {if $feature.suffix}<span class="ty-features-list__item-suffix">{$feature.suffix}</span>{/if}
		{if $feature.feature_type == "ProductFeatures::EXTENDED"|enum && $feature.features_hash}
			</bdi></a>
		{/if}
	{/strip}
{/function}

{if $features}
{strip}
{if $et_brand_image==true}
	{if $et_brand_image_width || $et_brand_image_height}
		{$width=$et_brand_image_width}
		{$height=$et_brand_image_height}
	{elseif $et_category_list || $details_page}
		{$width=""}
		{$height=25}
	{else}
		{$width=70}
		{$height=25}
	{/if}
	{if !$no_container}<div class="ty-features-list">{/if}
		{foreach from=$features name=features_list item=feature}
			{if $feature.feature_type == "E"}
				{if $et_brand_image && $feature.variants[$feature.variant_id].image_pairs}
					{if !$et_hide_brand_label}
						<span class="et-brand-title ty-control-group__label">{$feature.description nofilter}:</span>
					{/if}
					<div class="et-brand-image">
						<a href="{"categories.view?category_id=`$product.main_category`&features_hash=`$feature.features_hash`"|fn_url}">
							{include file="common/image.tpl" images=$feature.variants[$feature.variant_id].image_pairs image_width=$width image_height=$height show_detailed_link=false obj_id="`$preview_id`_`$image_id`_mini"}
						</a>
					</div>
				{else}
					<a href="{"categories.view?category_id=`$product.main_category`&features_hash=`$feature.features_hash`"|fn_url}">
						{feature_value feature=$feature}
					</a>
				{/if}
			{/if}
		{/foreach}
	{if !$no_container}</div>{/if}
{else}
	{if !$no_container}<div class="ty-features-list">{/if}
		{foreach from=$features name=features_list item=feature}
			{if $et_category_list}<div class="et-feature-list__item">{/if}
			{if $et_category_list}<i class="fa fa-dot-circle"></i> <span>{/if}{if $et_title_span==true}<span class="{$et_class} ty-control-group__label">{/if}{$feature.description nofilter}{if $et_title_span==true}:</span>{/if}{if $feature.full_description|trim}{include file="common/help.tpl" text=$feature.description content=$feature.full_description id=$feature.feature_id show_brackets=false link_text="<span class=\"ty-tooltip-block\"><i class=\"ty-icon-help-circle\"></i></span>" wysiwyg=true}{/if}{if $et_title_span!=true}:{/if}{if $et_category_list}</span>{/if}

			{if $feature_image && $feature.variants[$feature.variant_id].image_pairs}
				{assign var="obj_id" value=$feature.variant_id}
				<a href="{"categories.view?category_id=`$product.main_category`&features_hash=`$feature.features_hash`"|fn_url}">
					{include file="common/image.tpl" image_width=$image_size images=$feature.variants[$feature.variant_id].image_pairs no_ids=true}
				</a>
			{else}
				{if $feature.feature_type != "E"}<strong>{/if}{feature_value feature=$feature}{if $feature.feature_type != "E"}</strong>{/if}{if !$smarty.foreach.features_list.last && !$et_category_list}, {/if}
			{/if}
			{if $et_category_list}</div>{/if}
		{/foreach}
	{if !$no_container}</div>{/if}
{/if}
{/strip}
{/if}