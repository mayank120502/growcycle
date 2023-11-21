{** block-description:original **}
{$show=false}

{if $smarty.request.dispatch=="companies.products"}
	{if $et_vs.data.filters}
	  {if $et_vs.data.filters=="vertical"}
	    {$show=true}
	  {/if}
	{elseif $addons.et_vivashop_mv_functionality.et_vendor_filters =="vertical"}
		{$show=true}
	{/if}
{elseif $addons.et_vivashop_settings.et_viva_filters=="vertical"}
  {$show=true}
{/if}

{if $show}

	{script src="js/tygh/product_filters.js"}

	{if $block.type == "product_filters"}
		{$ajax_div_ids = "product_filters_*,selected_filters_*,products_search_*,category_products_*,currencies_*,languages_*,et_mobile_filters_count,product_features_*"}
		{$curl = $config.current_url}
	{else}
		{$curl = "products.search"|fn_url}
		{$ajax_div_ids = ""}
	{/if}

	{$filter_base_url = $curl|fn_query_remove:"result_ids":"full_render":"filter_id":"view_all":"req_range_id":"features_hash":"page":"total"}
	{$is_selected_filters = $smarty.request.features_hash}
	{$show_not_found_notification = $show_not_found_notification|default:0}

	<div class="cm-product-filters"
	    data-ca-target-id="{$ajax_div_ids}"
	    data-ca-base-url="{$filter_base_url|fn_url}"
	    data-ca-tooltip-class = "ty-product-filters__tooltip"
	    data-ca-tooltip-right-class = "ty-product-filters__tooltip--right"
	    data-ca-tooltip-mobile-class = "ty-tooltip--mobile"
	    data-ca-tooltip-layout-selector = "[data-ca-tooltip-layout='true']"
	    data-ce-tooltip-events-tooltip = "mouseenter"
	    id="product_filters_{$block.block_id}">
		<div class="ty-product-filters__wrapper et-sidebar-filter-id" data-et-sidebox-id="{$block.block_id}">
			{if $items}
			{$is_filter_cp_custom_price = false}
			{foreach $items as $key => $filter}
				{if $filter.field_type == "Addons\CpCustomPrice\CpCustomPriceFilterField::FILTER_FIELD_ID"|enum}
					{$is_filter_cp_custom_price = true}
					{$cp_custom_price_filter_id = $key}
					{$filter_uid_cp_custom_price = "`$block.block_id`_`$filter.filter_id`"}
					{break}
				{/if}
			{/foreach}
				{foreach $items as $key => $filter}
					{if $key != $cp_custom_price_filter_id}
						{hook name="blocks:product_filters_variants"}
							{assign var="filter_uid" value="`$block.block_id`_`$filter.filter_id`"}
							{assign var="cookie_name_show_filter" value="content_`$filter_uid`"}
							{if $filter.display == "N"}
								{* default behaviour of cm-combination *}
								{assign var="collapse" value=true}
								{if $smarty.cookies.$cookie_name_show_filter}
									{assign var="collapse" value=false}
								{/if}
							{else}
								{* reverse behaviour of cm-combination *}
								{assign var="collapse" value=false}
								{if $smarty.cookies.$cookie_name_show_filter}
									{assign var="collapse" value=true}
								{/if}
							{/if}

							{$reset_url = ""}
							{if $filter.selected_variants || $filter.selected_range}
								{$reset_url = $filter_base_url}
								{$fh = $smarty.request.features_hash|fn_delete_filter_from_hash:$filter.filter_id}
								{if $fh}
									{$reset_url = $filter_base_url|fn_link_attach:"features_hash=$fh"|fn_link_attach:"show_not_found_notification=$show_not_found_notification"}
								{/if}
							{/if}

							<div class="ty-product-filters__block">
								<div id="sw_content_{$filter_uid}" class="ty-product-filters__switch cm-combination-filter_{$filter_uid}{if !$collapse} open{/if} cm-save-state {if $filter.display == "Y"}cm-ss-reverse{/if}">
									<span class="ty-product-filters__title">{$filter.filter}{if $filter.selected_variants} ({$filter.selected_variants|sizeof}){/if}{if $reset_url}<a class="cm-ajax cm-ajax-full-render cm-history et-clear-wrapper" href="{$reset_url|fn_url}" data-ca-event="ce.filtersinit" data-ca-target-id="{$ajax_div_ids}" ><i class="et-icon-clear"></i></a>{/if}</span>
									<i class="ty-product-filters__switch-down ty-icon-down-open"></i>
									<i class="ty-product-filters__switch-right ty-icon-up-open"></i>
								</div>

						{hook name="blocks:product_filters_variants_element"}
									{if $filter.slider}
										{if $filter.feature_type == "ProductFeatures::DATE"|enum}
											{include file="blocks/product_filters/components/product_filter_datepicker.tpl" filter_uid=$filter_uid filter=$filter}
										{else}
											{include file="blocks/product_filters/components/product_filter_slider.tpl" filter_uid=$filter_uid filter=$filter filter_cp_custom_price=$items.$cp_custom_price_filter_id is_filter_cp_custom_price=$is_filter_cp_custom_price filter_uid_cp_custom_price=$filter_uid_cp_custom_price}
										{/if}
									{else}
										{include file="blocks/product_filters/components/product_filter_variants.tpl" filter_uid=$filter_uid filter=$filter collapse=$collapse}
									{/if}
							{/hook}
							</div>
						{/hook}
					{/if}
				{/foreach}

				{if $ajax_div_ids}
					<div class="ty-product-filters__tools clearfix {if !$is_selected_filters}hidden{/if}">
						<a href="{$filter_base_url|fn_url}" rel="nofollow" class="ty-btn ty-btn__secondary et-btn-icon-text ty-product-filters__reset-button cm-ajax cm-ajax-full-render cm-history" data-ca-event="ce.filtersinit" data-ca-target-id="{$ajax_div_ids}"><i class="ty-product-filters__reset-icon ty-icon-cw"></i> <span>{__("reset")}</span></a>
					</div>
				{/if}

			{/if}
		</div>
	<!--product_filters_{$block.block_id}--></div>

	<div data-ca-tooltip-layout="true" class="hidden">
	    <button type="button" data-ca-scroll="#pagination_contents" class="cm-scroll ty-tooltip--link ty-tooltip--filter"><span class="tooltip-arrow"></span></button>
	</div>
{/if}
