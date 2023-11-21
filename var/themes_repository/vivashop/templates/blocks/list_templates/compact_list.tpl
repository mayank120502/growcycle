{if $products}
	{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
	{script src="js/tygh/exceptions.js"}
	{if !$no_pagination}
		{include file="common/pagination.tpl"}
	{/if}
	{if !$no_sorting}
		{include file="views/products/components/sorting.tpl"}
	{/if}
	{assign var="image_width" value=$image_width|default:60}
	{assign var="image_height" value=$image_height|default:60}

	{function name="et_compact_list_btns" product_id=$product_id obj_prefix=$obj_prefix}{strip}
		{if !$et_on_vs}
		  <div class="et_compact_list_btns visible-phone visible-tablet clearfix1">
		    {if $settings.General.enable_compare_products == "Y" && !$hide_compare_list_button}
		      {include file="buttons/add_to_compare_list.tpl" product_id=$product_id show_et_icon_grid=true}
		    {/if}
		    {if $addons.wishlist.status == "A" && !$hide_wishlist_button}
		      {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product_id`" but_name="dispatch[wishlist.add..`$product_id`]" but_role="text" show_et_icon_grid=true}
		    {/if}
		  </div>
		{/if}
	{/strip}{/function}

	<div class="ty-compact-list et-compact-list {if $use_vendor_url}et-vendor-compact{/if}">
		{hook name="products:product_compact_list_view"}
		{foreach from=$products item="product" key="key" name="products"}
			{assign var="obj_id" value=$product.product_id}
			{assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}
			{$et_category_list=true}

			{include file="common/product_data.tpl" product=$product et_category_list=$et_category_list et_category_compact=true show_rating=true show_et_rating=true show_et_grid_stock=true show_sku=true show_et_atc=true show_product_amount=true show_discount_label=true}

			{hook name="products:product_compact_list"}
				<div class="ty-compact-list__item et-compact-list__item {if $smarty.foreach.products.first}first{/if}">
					<form {if !$config.tweaks.disable_dhtml}class="cm-ajax cm-ajax-full-render"{/if} action="{""|fn_url}" method="post" name="short_list_form{$obj_prefix}">
						
						<input type="hidden" name="result_ids" value="cart_status*,wish_list*,account_info*,et-cw*" />
						<input type="hidden" name="redirect_url" value="{if $smarty.request.redirect_url}{$smarty.request.redirect_url}{else}{$config.current_url}{/if}" />
						<input type="hidden" name="product_data[{$obj_id}][product_id]" value="{$product.product_id}" />
						
						<div class="ty-compact-list__content et-compact-list__content">
							{hook name="products:product_compact_list_image"}
							<div class="ty-compact-list__image et-compact-list__image">
								<span class="et-discount-label">
									{assign var="discount_label" value="discount_label_`$obj_prefix``$obj_id`"}
									{$smarty.capture.$discount_label nofilter}
								</span>

								{if $addons.et_vivashop_mv_functionality.et_product_link=="vendor"}
									{if $product.company_id && $product.company_has_store}
									  {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
									  {if !$smarty.request.company_id}
									    {$et_add_blank='target="_blank"'}
									  {else}
									    {$et_add_blank=''}
									  {/if}
									{else}
									  {$product_detail_view_url="products.view&product_id=`$product.product_id`"}
									  {$et_add_blank=''}
									{/if}
								{else}
									{$et_add_blank=''}
									{if $use_vendor_url}
										  {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
									{else}
									  {$product_detail_view_url="products.view&product_id=`$product.product_id`"}
									{/if}
								{/if}
								
								<a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>
									{include file="common/image.tpl" image_width=$image_width image_height=$image_height images=$product.main_pair obj_id=$obj_id_prefix et_lazy=true}
								</a>
							</div>
							{/hook}

							<div class="et-compact-list__middle">
								{* Product title *}
								<div class="et-compact-list__title">
									{assign var="name" value="name_$obj_id"}<bdi>{$smarty.capture.$name nofilter}</bdi>
								</div>
								{* /Product title *}

								{if $smarty.const.ET_DEVICE != "M" || $et_traditional_resp}
									<div class="et-compact-list__stock-rating-wrapper">
										{* Stock *}
										<div class="et-compact-list__stock">
											{assign var="product_amount" value="product_amount_`$obj_id`"}
											{$smarty.capture.$product_amount nofilter}
										</div>
										{* /Stock *}
										
										{* Rating *}
										{assign var="rating" value="rating_$obj_id"}
										{if $smarty.capture.$rating|trim}
											<div class="et-compact-list__rating clearfix">
												{$smarty.capture.$rating nofilter}
											</div>
										{/if}
										{* /Rating *}

									</div>

									<div class="et-compact-list__info-wrapper">
										{* SKU *}
										{assign var="sku" value="sku_`$obj_id`"}
										{if $smarty.capture.$sku|trim && $product.product_code}
											<div class="et-compact-list__sku hidden-phone1">
												{$smarty.capture.$sku nofilter}
											</div>
										{/if}    
										{* /SKU *}  

										{* Advanced Options: price in points *}
										{$show_price_values=true}
										{$dont_show_points=false}
										{capture name="advanced_options_`$obj_id`"}
									    {hook name="products:options_advanced"}
									    {/hook}
										{/capture}

										{assign var="advanced_options" value="advanced_options_`$obj_id`"}
										{if $smarty.capture.$advanced_options|trim}
											<div class="et-adv-options ty-product-block__advanced-option clearfix">
												<div class="cm-reload-{$obj_prefix}{$obj_id}" id="advanced_options_update_{$obj_prefix}{$obj_id}">
													{$smarty.capture.$advanced_options nofilter}
												<!--advanced_options_update_{$obj_prefix}{$obj_id}--></div>
											</div>
										{/if}
										{* /Advanced Options: price in points *}

				 						{* Brand *}
										<div class="et-brand">
											{strip}
											{include file="views/products/components/product_features_short_list.tpl" features=$product|fn_get_product_features_list:'H' et_title_span=true no_container=true et_category_list=false}
											{/strip}
										</div>
										{* /Brand *}
									</div>
								{else}
									<div class="et-compact-list__info-wrapper">
										{* Stock *}
										<span class="et-compact-list__stock">
											{assign var="product_amount" value="product_amount_`$obj_id`"}
											{$smarty.capture.$product_amount nofilter}
										</span>
										{* /Stock *}
										
										{* Rating *}
										{assign var="rating" value="rating_$obj_id"}
										{if $smarty.capture.$rating|trim}
											<span class="et-compact-list__rating clearfix">
												{$smarty.capture.$rating nofilter}
											</span>
										{/if}
										{* /Rating *}

										{* SKU *}
										{assign var="sku" value="sku_`$obj_id`"}
										{if $smarty.capture.$sku|trim && $product.product_code}
											<span class="et-compact-list__sku hidden-phone1">
												{$smarty.capture.$sku nofilter}
											</span>
										{/if}    
										{* /SKU *}  

										{* Advanced Options: price in points *}
										{$show_price_values=true}
										{$dont_show_points=false}
										{capture name="advanced_options_`$obj_id`"}
									    {hook name="products:options_advanced"}
									    {/hook}
										{/capture}

										{assign var="advanced_options" value="advanced_options_`$obj_id`"}
										{if $smarty.capture.$advanced_options|trim}
											<span class="et-adv-options ty-product-block__advanced-option clearfix">
												<span class="cm-reload-{$obj_prefix}{$obj_id}" id="advanced_options_update_{$obj_prefix}{$obj_id}">
													{$smarty.capture.$advanced_options nofilter}
												<!--advanced_options_update_{$obj_prefix}{$obj_id}--></span>
											</span>
										{/if}
										{* /Advanced Options: price in points *}

				 						{* Brand *}
										<span class="et-brand">
											{strip}
											{include file="views/products/components/product_features_short_list.tpl" features=$product|fn_get_product_features_list:'H' et_title_span=true no_container=true et_category_list=false}
											{/strip}
										</span>
										{* /Brand *}
									</div>
								{/if}
							</div>

							<div class="et-compact-list__right">
								<div class="et-compact-list__price-atc">
									{if ($product.avail_since > $smarty.const.TIME)}
										{include file="common/coming_soon_notice.tpl" avail_date=$product.avail_since add_to_cart=$product.out_of_stock_actions et_category_compact=true obj_id=$obj_id_prefix}
									{/if}

									{assign var="et_soon_text" value="et-soon-text_`$obj_id_prefix`"}
									{if $smarty.capture.$et_soon_text|trim}
										{$smarty.capture.$et_soon_text nofilter}
									{/if}

									{* Price *}
									{hook name="products:list_price_block"}
									<div class="et-compact-list__price clearfix">
										{assign var="price" value="price_`$obj_id`"}
										{assign var="clean_price" value="clean_price_`$obj_id`"}
										{assign var="old_price" value="old_price_`$obj_id`"}
										{$smarty.capture.$price nofilter}
										{$smarty.capture.$clean_price nofilter}
										{if $smarty.capture.$old_price|trim}
											{$smarty.capture.$old_price nofilter}
										{/if}
									</div>
									{/hook}
									{* /Price *}
									
									{* Qty *}
									{if !$smarty.capture.capt_options_vs_qty}
										{assign var="product_options" value="product_options_`$obj_id`"}
										{assign var="qty" value="qty_`$obj_id`"}
										{$smarty.capture.$product_options nofilter}
										<div class="et-compact-list__qty et-small-value-changer {if $smarty.capture.$qty|trim && ($smarty.capture.$qty|trim)=="&nbsp;"}hidden{/if}">
										{$smarty.capture.$qty nofilter}</div>
									{/if}
									{* /Qty *}

									{* Add to cart *}
									{if $show_add_to_cart}
										{assign var="add_to_cart" value="add_to_cart_`$obj_id`"}
										<div class="et-compact-btn">{$smarty.capture.$add_to_cart nofilter}</div>
									{/if}

									{assign var="et_soon_btn" value="et-soon-btn_`$obj_id_prefix`"}
									{if $smarty.capture.$et_soon_btn|trim}
										<div class="et-compact-btn">{$smarty.capture.$et_soon_btn nofilter}</div>
									{/if}
									{* /Add to cart *}
									{et_compact_list_btns product_id=$product.product_id obj_prefix=$obj_prefix}
								</div>

								{if $smarty.const.ET_DEVICE != "M"}
									<div class="ty-compact-list__controls et-compact-list__controls">
										{* Vendor info *}
										<div class="hidden-phone">
										{hook name="products:category_compact_vendor"}
										{/hook}
										</div>
										{* /Vendor info *}

										{* Buttons: Compare/Wishlist*}
										{if !$et_on_vs}
											<div class="et-compact-list__buttons hidden-phone hidden-tablet">
												{* Compare *}
												{if $settings.General.enable_compare_products == "Y" && !$hide_compare_list_button || $product.feature_comparison == "Y"}
												    {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id}
												{/if}
												{* Wishlist *}
												{if $addons.wishlist.status == "A" && !$hide_wishlist_button}
												    {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text"}
												{/if}

											</div>
										{/if}
										{* /Buttons *}
									</div>
								{/if}
							</div>
							<div class="visible-phone">{hook name="products:category_compact_vendor"}
								{/hook}</div>
						</div>
					</form>
				</div>
			{/hook}
		{/foreach}
		{/hook}
	</div>
	{if !$no_pagination}
		{include file="common/pagination.tpl" force_ajax=$force_ajax}
	{/if}
{/if}