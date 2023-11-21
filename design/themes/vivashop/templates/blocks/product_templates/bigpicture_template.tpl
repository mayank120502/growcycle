{script src="js/tygh/exceptions.js"}
{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
{$et_image_width=772}

<div class="ty-product-block ty-product-detail et-product-page-big" data-et-offset="5" id="et-product-page">
	<div class="ty-product-block__wrapper clearfix">
		{hook name="products:view_main_info"}
			{if $product}
				{assign var="obj_id" value=$product.product_id}
				{include file="common/product_data.tpl" product=$product but_role="big" but_text=__("add_to_cart") show_et_grid_stock=true et_review_link_scroll=true et_hide_wishlist=true}
			
				{$thumbnails_size=130}

				<div class="et-product-block__inner-wrapper">

					{$width="100%"}
					{$min_height="auto"}
					{if $smarty.const.ET_DEVICE == "D" || $et_traditional_resp}
						{$width=$et_image_width+$thumbnails_size+12}
						{$width="`$width`px"}
						{$min_height="min-height: `$settings.Thumbnails.product_details_thumbnail_height`px"}
					{/if}

					<div class="ty-product-block__img-wrapper et-product-image-wrapper" style="width: {$width};">
						<div class="clearfix et-product-top">
							<div class="et-product-top-left">
								{hook name="products:main_info_title"}
									{if !$hide_title}
										<h1 id="et_prod_title" class="" {live_edit name="product:product:{$product.product_id}"}><bdi>{$product.product nofilter}</bdi></h1>
									{/if}
								{/hook}
								{if $smarty.const.ET_DEVICE == "D" || $et_traditional_resp}
									<div class="et-stock-rating visible-desktop">
										{* Stock *}
										{assign var="product_amount" value="product_amount_`$obj_id`"}
										{if $smarty.capture.$product_amount|trim}
											<div class="ty-product-block__field-group et-stock">
												{$smarty.capture.$product_amount nofilter}
											</div>
										{/if}
										{* /Stock *}

										{* Rating *}
										{capture name="et_rating"}
											{hook name="products:et_rating"}
											{/hook}
										{/capture}
										{$smarty.capture.et_rating nofilter}
										{* /Rating *}
							
										{* SKU *}
										{assign var="sku" value="sku_`$obj_id`"}
										{if $smarty.capture.$sku|trim}
											<div class="et-product-page__sku">
												{$smarty.capture.$sku nofilter}
											</div>
										{/if}    
										{* /SKU *}
							
										{* Advanced Options: price in points *}
										{assign var="advanced_options" value="advanced_options_`$obj_id`"}
										{if $smarty.capture.$advanced_options|trim}
											<div class="et-adv-options ty-product-block__advanced-option clearfix">
												{if $capture_options_vs_qty}{capture name="product_options"}{$smarty.capture.product_options nofilter}{/if}
												{$smarty.capture.$advanced_options nofilter}
												{if $capture_options_vs_qty}{/capture}{/if}
											</div>
										{/if}
										{* /Options: price in points *}

										{* Brand *}
										{hook name="products:brand"}
											<div class="et-brand">
												{include file="views/products/components/product_features_short_list.tpl" features=$product.header_features et_title_span=true}
											</div>
										{/hook}
										{* /Brand *}
							
									</div>
								{/if}
							</div>
						</div>
						{hook name="products:image_wrap"}
							{if !$no_images}
								<div class="ty-product-block__img cm-reload-{$product.product_id}" data-ca-previewer="true" id="product_images_{$product.product_id}_update">
									{include file="views/products/components/product_images.tpl" product=$product show_detailed_link="Y" 
										image_width=$et_image_width
										image_height=$et_image_width
										thumbnails_size=$thumbnails_size 
										et_vertical=true
										et_thumb_nr=5
										et_show_product_labels=true
										et_is_big_picture=true
									}
								<!--product_images_{$product.product_id}_update--></div>
							{/if}
						{/hook}
					</div>
					<div class="et-pp-info">
						<div class="et-big-sticky">

							{assign var="form_open" value="form_open_`$obj_id`"}
							{$smarty.capture.$form_open nofilter}

							<div class="hidden-desktop">
								<div class="et-stock-rating">
									{strip}
										{* Stock *}
										{assign var="product_amount" value="product_amount_`$obj_id`"}
										{if $smarty.capture.$product_amount|trim}
											<div class="ty-product-block__field-group et-stock">
												{$smarty.capture.$product_amount nofilter}
											</div>
										{/if}
										{* /Stock *}
										
										{* Rating *}
										{capture name="et_rating"}
											{hook name="products:et_rating"}
											{/hook}
										{/capture}
										{$smarty.capture.et_rating nofilter}
										{* /Rating *}
									{/strip}
								</div>
								{capture name="et_product_sku_opt_brand"}
									{* SKU *}
									{assign var="sku" value="sku_`$obj_id`"}
									{if $smarty.capture.$sku|trim}
										<div class="et-product-page__sku">
											{$smarty.capture.$sku nofilter}
										</div>
									{/if}    
									{* /SKU *}
										
									{* Advanced Options: price in points *}
									{assign var="advanced_options" value="advanced_options_`$obj_id`"}
									{if $smarty.capture.$advanced_options|trim}
										<div class="et-adv-options ty-product-block__advanced-option clearfix">
											{if $capture_options_vs_qty}{capture name="product_options"}{$smarty.capture.product_options nofilter}{/if}
											{$smarty.capture.$advanced_options nofilter}
											{if $capture_options_vs_qty}{/capture}{/if}
										</div>
									{/if}
									{* /Options: price in points *}
										
		   						{* Brand *}
									{hook name="products:brand"}
										<div class="et-brand">
											{include file="views/products/components/product_features_short_list.tpl" features=$product.header_features  et_title_span=true}
										</div>
									{/hook}
									{* /Brand *}
								{/capture}
						
								{if $smarty.capture.et_product_sku_opt_brand|trim}
									<div class="et_product_sku_opt_brand">
										{$smarty.capture.et_product_sku_opt_brand nofilter}
									</div>
								{/if}
							</div>

							<div class="et-product-left">
								{* Price *}
								<div class="et-price-wrapper clearfix">
									{assign var="old_price" value="old_price_`$obj_id`"}
									{assign var="price" value="price_`$obj_id`"}
									{assign var="clean_price" value="clean_price_`$obj_id`"}
									{assign var="list_discount" value="list_discount_`$obj_id`"}
									{assign var="discount_label" value="discount_label_`$obj_id`"}
									<div class="{if $smarty.capture.$old_price|trim || $smarty.capture.$clean_price|trim || $smarty.capture.$list_discount|trim}prices-container {/if}price-wrap">
					
										{hook name="products:main_price"}
										{if $smarty.capture.$price|trim}
											<div class="ty-product-block__price-actual">
												{$smarty.capture.$price nofilter}
											</div>
										{/if}
										{/hook}
										{if $smarty.capture.$old_price|trim || $smarty.capture.$clean_price|trim || $smarty.capture.$list_discount|trim}
											<div class="et-old-price">
												{if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}{/if}
											</div>
											<div class="et-discount-text">
												{$smarty.capture.$list_discount nofilter}
											</div>
											{if $smarty.capture.$clean_price|trim}
												<div class="et-clean-price">
													{$smarty.capture.$clean_price nofilter}
												</div>
											{/if}
										{/if}
									</div>
								</div>
								{* /Price *}
								
								{* Qty discount *}
								{capture name="et_qty_discount_min_qty"}
									{if $capture_options_vs_qty}{capture name="product_options"}{$smarty.capture.product_options nofilter}{/if}
										{if $product.prices}
											<div class="et-qty-discount">
												{include file="views/products/components/products_qty_discounts.tpl"}
											</div>
										{/if}
										{assign var="min_qty" value="min_qty_`$obj_id`"}
										{$smarty.capture.$min_qty nofilter}
									{if $capture_options_vs_qty}{/capture}{/if}
								{/capture}
								{if $smarty.capture.et_qty_discount_min_qty|trim}
									<div class="ty-product-block__field-group">
										{$smarty.capture.et_qty_discount_min_qty nofilter}
									</div>
								{/if}
								{* /Qty discount *}
								
								{* Promo text *}
								{hook name="products:promo_text"}
									{if $product.promo_text}
										<div class="et-promo-text">
											{$product.promo_text nofilter}
										</div>
									{/if}
								{/hook}
								{* /Promo text *}
					
								{* Options: dorpdown/radio/etc.. *}
								{if $capture_options_vs_qty}{capture name="product_options"}{$smarty.capture.product_options nofilter}{/if}
								<div class="ty-product-block__option et-product-options">
									{assign var="product_options" value="product_options_`$obj_id`"}
									{$smarty.capture.$product_options nofilter}
								</div>
								{if $capture_options_vs_qty}{/capture}{/if}
								{* /Options: dorpdown/radio/etc.. *}

								{* EDP *}
								{assign var="product_edp" value="product_edp_`$obj_id`"}
								{$smarty.capture.$product_edp nofilter}
								{* /EDP *}
					
								{* Description *}
								{if $show_descr}
									{assign var="prod_descr" value="prod_descr_`$obj_id`"}
									<h3 class="ty-product-block__description-title">{__("description")}</h3>
									<div class="ty-product-block__description">{$smarty.capture.$prod_descr nofilter}</div>
								{/if}
								{* /Description *}
					
								{* Buttons *}
								{if $capture_buttons}{capture name="buttons"}{/if}
								<div class="">
									{if $show_details_button}
										{include file="buttons/button.tpl" but_href="products.view?product_id=`$product.product_id`" but_text=__("view_details") but_role="submit"}
									{/if}
									{if ($product.avail_since > $smarty.const.TIME)}
										{include file="common/coming_soon_notice.tpl" avail_date=$product.avail_since add_to_cart=$product.out_of_stock_actions}
									{/if}
					
					
									<div class="clearfix">
										{* QTY changer *}
										<div class="et-value-changer et-main-qty-changer">
											{assign var="qty" value="qty_`$obj_id`"}
											{$smarty.capture.$qty nofilter}
										</div>
										{* /QTY changer *}
										
										{* Buttons: Add to cart/Buy now*}
										<div class="et-product-atc">
											{assign var="add_to_cart" value="add_to_cart_`$obj_id`"}
											{$smarty.capture.$add_to_cart nofilter}
										</div>
										{* /Buttons: Add to cart/Buy now*}
									</div>
					
									{* Buttons: Compare/Wishlist*}
									{if !($addons.master_products.status == "A" && !$product.company_id)}
										{capture name="et_pp_compare"}
											{if $settings.General.enable_compare_products == "Y" && !$hide_compare_list_button || $product.feature_comparison == "Y"}
										    {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id}
											{/if}
										{/capture}
										{capture name="et_pp_wishlist"}
											{if $addons.wishlist.status == "A" && !$hide_wishlist_button}
										    {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text"}
											{/if}
										{/capture}
										<div class="et-list-buttons-wrapper clearfix">
											{if $smarty.capture.et_pp_compare|trim && $smarty.capture.et_pp_wishlist|trim}
												<div class="ty-column2">
													{$smarty.capture.et_pp_compare nofilter}
												</div>
												<div class="ty-column2">
													{$smarty.capture.et_pp_wishlist nofilter}
												</div>
											{else}
												{$smarty.capture.et_pp_compare nofilter}
												{$smarty.capture.et_pp_wishlist nofilter}
											{/if}

										</div>
										{if $addons.vendor_communication.status == "A" && $addons.vendor_communication.show_on_product == "Y"}
											<div class="et-pp-contact ty-column1">
										    	{include file="addons/vendor_communication/views/vendor_communication/components/new_thread_button.tpl" object_id=$product.product_id show_form=false}
											</div>
										{/if}
									{/if}
									{* /Buttons *}
									
									{if !$vendor_store}
										{hook name="products:et_product_vendor"}
										{/hook}
									{/if}

									{hook name="products:et_pp_info"}
									{/hook}
								</div>
							</div>
							{hook name="products:product_form_close_tag"}
              {$form_close="form_close_`$obj_id`"}
							{$smarty.capture.$form_close nofilter}
							{/hook}

							{* Sticky bar *}
							{hook name="products:et_sticky_atc"}
							{/hook}
							{* /Sticky bar *}

							{* Popup tabs *}
							{if $show_product_tabs}
								{include file="views/tabs/components/product_popup_tabs.tpl"}
								{$smarty.capture.popupsbox_content nofilter}
							{/if}
							{* /Popup tabs *}
							{hook name="products:product_detail_bottom"}
							{/hook}
			
							{* Social buttons *}
							<div class="et-pp-social et-pp-social-mobile">
								{hook name="products:social_buttons"}{/hook}
							</div>
							{* /Social buttons *}
						</div>
					
					</div>
			
				{/if}
			{/hook}
		</div>
	</div>

	{if $smarty.capture.hide_form_changed == "Y"}
		{assign var="hide_form" value=$smarty.capture.orig_val_hide_form}
	{/if}
	{if $show_product_tabs}
    {hook name="products:product_tabs"}
			{include file="views/tabs/components/product_tabs.tpl"}
			{if $blocks.$tabs_block_id.properties.wrapper}
				{include file=$blocks.$tabs_block_id.properties.wrapper content=$smarty.capture.tabsbox_content title=$blocks.$tabs_block_id.description}
			{else}
				{$smarty.capture.tabsbox_content nofilter}
			{/if}
    {/hook}
	{/if}
</div>


<div class="product-details">
</div>

{capture name="mainbox_title"}{assign var="details_page" value=true}{/capture}