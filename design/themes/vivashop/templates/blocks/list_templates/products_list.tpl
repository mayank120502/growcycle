{if $products}
	{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
	{script src="js/tygh/exceptions.js"}

	{if !$no_pagination}
		{include file="common/pagination.tpl"}
	{/if}

	{if !$no_sorting}
		{include file="views/products/components/sorting.tpl"}
	{/if}
	<style>

		{if $et_traditional_resp==true}
			@media screen and (min-width: 1025px){
				.ty-product-list__image{
					width: {$settings.Thumbnails.product_lists_thumbnail_width}px;
				}
			}

			@media screen and (min-width: 481px) and (max-width: 1024px){
				.ty-product-list__image{
					width: {$settings.Thumbnails.product_lists_thumbnail_width/2}px;
					min-width: 170px;
				}
			}

			@media screen and (max-width: 480px){
				.ty-product-list__image{
					width: 100%;
				}
			}
		{else}
			.ty-product-list__image{
				{if $smarty.const.ET_DEVICE == "M"}
					width: 100%;
				{elseif $smarty.const.ET_DEVICE == "T"}
					width: {$settings.Thumbnails.product_lists_thumbnail_width/2}px;
					min-width: 170px;
				{else}
					width: {$settings.Thumbnails.product_lists_thumbnail_width}px;
				{/if}
			}
		{/if}
	</style>

	{foreach from=$products item=product key=key name="products"}
		{capture name="capt_options_vs_qty"}{/capture}

		{function name="et_list_btns" product_id=$product_id obj_prefix=$obj_prefix}{strip}
			{if !$et_on_vs}
    	  <div class="et-list-btns ">
    	    {if $settings.General.enable_compare_products == "Y" && !$hide_compare_list_button}
    	      {include file="buttons/add_to_compare_list.tpl" product_id=$product_id show_et_icon_grid=true}
    	    {/if}
    	    {if $addons.wishlist.status == "A" && !$hide_wishlist_button}
    	      {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product_id`" but_name="dispatch[wishlist.add..`$product_id`]" but_role="text" show_et_icon_grid=true}
    	    {/if}
    	  </div>
    	{/if}
    {/strip}{/function}

		{hook name="products:product_block"}
			{assign var="obj_id" value=$product.product_id}
			{assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}

			{$et_category_list=true}
			{include file="common/product_data.tpl" product=$product min_qty=true et_category_list=$et_category_list show_et_rating=true show_et_grid_stock=true show_sku=true show_et_atc=true}

			<div class="ty-product-list clearfix et-list__item {if $smarty.foreach.products.first}first{elseif $smarty.foreach.products.last}last{/if} {if $use_vendor_url}et-vendor-list{/if}">
				<div class="et-list__form-wrapper">
					{assign var="form_open" value="form_open_`$obj_id`"}
					{$smarty.capture.$form_open nofilter}
					{if $bulk_addition}
						<input class="cm-item ty-float-right ty-product-list__bulk" type="checkbox" id="bulk_addition_{$obj_prefix}{$product.product_id}" name="product_data[{$product.product_id}][amount]" value="{if $js_product_var}{$product.product_id}{else}1{/if}" {if ($product.zero_price_action == "R" && $product.price == 0)}disabled="disabled"{/if} />
					{/if}

					{script src="design/themes/vivashop/js/et_product_image_gallery.js"}

					<div class="et-list__inner-wrapper">
						{* Product Images *}
						<div class="ty-product-list__image ">
							<div class="et-relative">
								{if $smarty.const.ET_DEVICE == "M" }
									{include file="views/products/components/product_icon.tpl" product=$product show_gallery=true image_width=450 image_height=450}
								{else}
									{include file="views/products/components/product_icon.tpl" product=$product show_gallery=true}
								{/if}

								{assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
								{$smarty.capture.$product_labels nofilter}

								{et_list_btns product_id=$product.product_id obj_prefix=$obj_prefix}
							</div>
						</div>
						{* /Product Images *}

						<div class="ty-product-list__content et-list__content clearfix">
						{hook name="products:product_block_content"}
							{if $js_product_var}
								<input type="hidden" id="product_{$obj_prefix}{$product.product_id}" value="{$product.product}" />
							{/if}

							{* Product title *}
							<div class="ty-product-list__item-name">
								{assign var="name" value="name_$obj_id"}
		            <bdi>{$smarty.capture.$name nofilter}</bdi>
							</div>
							{* /Product title *}

							<div class="ty-product-list__info et-product-list__info">
								<div class="et-product-list__options-wrapper">
									{* Stock *}
									<div class="et-product-list__stock">
										{assign var="product_amount" value="product_amount_`$obj_id`"}
										{$smarty.capture.$product_amount nofilter}
									</div>
									{* /Stock *}

									{* Rating *}
									{assign var="rating" value="rating_$obj_id"}
									{if $smarty.capture.$rating|trim}
										<div class="et-product-list__rating clearfix">
											{$smarty.capture.$rating nofilter}
										</div>
									{/if}
									{* /Rating *}

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
									{* /Options: price in points *}

									{* SKU *}
									{assign var="sku" value="sku_`$obj_id`"}
									{if $smarty.capture.$sku|trim && $product.product_code}
										<div class="et-product-list__sku">
											{$smarty.capture.$sku nofilter}
										</div>
									{/if}    
									{* /SKU *}   

			 						{* Brand *}
									<div class="et-brand">
										{include file="views/products/components/product_features_short_list.tpl" features=$product|fn_get_product_features_list:'H' et_title_span=true no_container=true et_category_list=false}
									</div>
									{* /Brand *}
									
									{if !$smarty.capture.capt_options_vs_qty}
										<div class="ty-product-list__option">
											{assign var="product_options" value="product_options_`$obj_id`"}
											{$smarty.capture.$product_options nofilter}
										</div>
									{/if}
								</div>

								{* Description *}
								<div class="ty-product-list__description et-product-list__description">
									{assign var="prod_descr" value="prod_descr_`$obj_id`"}
									{$smarty.capture.$prod_descr nofilter}
								</div>
								{* /Description *}
								{* Variations *}
								{hook name="products:product_multicolumns_list_control"}
								{/hook}
								{* /Variations *}

								{* Features *}
								{assign var="product_features" value="product_features_`$obj_id`"}
								<div class="et-product-list__feature ty-product-list__feature">
									{$smarty.capture.$product_features nofilter}
								</div>
								{* /Features *}
							</div>
						</div>
						<div class="et-product-list__right">

							{* Price *}
							{hook name="products:list_price_block"}
							<div class="et-list-price-ammount clearfix">
								<div class="ty-product-list__price">
									{assign var="price" value="price_`$obj_id`"}
									{$smarty.capture.$price nofilter}
								
									{assign var="clean_price" value="clean_price_`$obj_id`"}
									{$smarty.capture.$clean_price nofilter}
							
									{assign var="old_price" value="old_price_`$obj_id`"}
									{if $smarty.capture.$old_price|trim}
										<span class="et-list-old-price">{$smarty.capture.$old_price nofilter}</span>
									{/if}
								
									{assign var="list_discount" value="list_discount_`$obj_id`"}
									{$smarty.capture.$list_discount nofilter}
								</div>
							</div>
							{/hook}
							{* /Price *}

							<div class="et-list-buttons-vendor-wrapper">
								<div class="ty-product-list__control">
									<div class="et-product-list__qty-atc">
										{* Qty *}
										{assign var="min_qty" value="min_qty_`$obj_id`"}
										{$smarty.capture.$min_qty nofilter}
								
										{assign var="product_edp" value="product_edp_`$obj_id`"}
										{$smarty.capture.$product_edp nofilter}
								
										{if ($product.avail_since > $smarty.const.TIME)}
											{include file="common/coming_soon_notice.tpl" avail_date=$product.avail_since add_to_cart=$product.out_of_stock_actions et_category_list=true}
										{/if}
								
										{assign var="qty" value="qty_`$obj_id`"}
										<div class="ty-product-list__qty ty-float-left et-value-changer {if $smarty.capture.$qty|trim && ($smarty.capture.$qty|trim)=="&nbsp;"}hidden{/if}">
											{$smarty.capture.$qty nofilter}
										</div>
										{* /Qty *}
								
										{* Buttons: Add to cart/Select Options *}
										<div class="et-list-buttons">
											{assign var="add_to_cart" value="add_to_cart_`$obj_id`"}
											{$smarty.capture.$add_to_cart nofilter}

										</div>
										{* /Buttons *}
									</div>

								</div>
								{* Vendor *}
								{hook name="products:category_list_vendor"}
								{/hook}
								{* /Vendor *}
							</div>
						{/hook}
						</div>
					</div>
					{assign var="form_close" value="form_close_`$obj_id`"}
					{$smarty.capture.$form_close nofilter}
				</div>
			</div>
		{/hook}
	{/foreach}

	{if $bulk_addition}
		<script>
			(function(_, $) {

				$(document).ready(function() {

					$.ceEvent('on', 'ce.commoninit', function(context) {
						if (context.find('input[type=checkbox][id^=bulk_addition_]').length) {
							context.find('.cm-picker-product-options').switchAvailability(true, false);
						}
					});

					$(_.doc).on('click', '.cm-item', function() {
						$('#opt_' + $(this).prop('id').replace('bulk_addition_', '')).switchAvailability(!this.checked, false);
					});
				});

			}(Tygh, Tygh.$));
		</script>
	{/if}

	{if !$no_pagination}
		{include file="common/pagination.tpl" force_ajax=$force_ajax}
	{/if}

{/if}

{capture name="mainbox_title"}{$title}{/capture}
