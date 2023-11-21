{assign var="dropdown_id" value=$block.snapping_id}
{assign var="r_url" value=$config.current_url|escape:url}
{hook name="checkout:cart_content"}
	<div class="ty-dropdown-box" id="cart_status_{$dropdown_id}">
		{if $block.wrapper!="blocks/wrappers/et_sticky_cart.tpl"}
			<div id="sw_dropdown_{$dropdown_id}" class="ty-dropdown-box__title cm-combination">
				<a href="{"checkout.cart"|fn_url}">
					{hook name="checkout:dropdown_title"}
					<span class="clearfix">
						<span class="ty-float-left et-top-cart-icon">
							<i class="et-icon-my-cart"></i>
							<span class="et-my-cart-text hidden">{__("cart")}</span>
							<span class="et-cart-content {if !$smarty.session.cart.amount}et-cart-empty{/if}">{strip}
								{if $smarty.session.cart.amount}
									{$smarty.session.cart.amount}
								{else}
									0
								{/if}
							{/strip}</span>
							<span class="et-tooltip-arrow"></span>
						</span>
					</span>
					{/hook}
				</a>
			</div>
		{/if}
		<div id="dropdown_{$dropdown_id}" class="cm-popup-box ty-dropdown-box__content ty-dropdown-box__content--cart hidden">
			{capture name="et_content"}
				{hook name="checkout:minicart"}
					<div class="cm-cart-content {if $block.properties.products_links_type == "thumb"}cm-cart-content-thumb{/if} {if $block.properties.display_delete_icons == "Y"}cm-cart-content-delete{/if}">
							<div class="ty-cart-items">
								{if $smarty.session.cart.amount}
									<ul class="ty-cart-items__list">
										{hook name="index:cart_status"}
											{assign var="_cart_products" value=$smarty.session.cart.products|array_reverse:true}
											{foreach from=$_cart_products key="key" item="product" name="cart_products"}
												{hook name="checkout:minicart_product"}
												{if !$product.extra.parent}
													<li class="ty-cart-items__list-item clearfix">
														{hook name="checkout:minicart_product_info"}
														<div class="clearfix">
															{if $block.properties.products_links_type == "thumb"}
																<div class="ty-cart-items__list-item-image">
																	<a href="{"products.view?product_id=`$product.product_id`"|fn_url}">
																		{include file="common/image.tpl" image_width="50" image_height="50" images=$product.main_pair no_ids=true}
																	</a>
																</div>
															{/if}
															<div class="ty-cart-items__list-item-desc">
																<a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{$product.product|default:fn_get_product_name($product.product_id) nofilter}</a>
															<p>
																<span class="et-product-ammount">{$product.amount}</span><span dir="{$language_direction}">&nbsp;x&nbsp;</span>{include file="common/price.tpl" value=$product.display_price span_id="price_`$key`_`$dropdown_id`" class="et-cart-product-price"}
															</p>
															</div>
															{if $block.properties.display_delete_icons == "Y"}
																<div class="ty-cart-items__list-item-tools cm-cart-item-delete">
																	{if (!$runtime.checkout || $force_items_deletion) && !$product.extra.exclude_from_calculate}
																		{include file="buttons/button.tpl" but_href="checkout.delete.from_status?cart_id=`$key`&redirect_url=`$r_url`" but_meta="cm-ajax cm-ajax-full-render" but_target_id="cart_status*" but_role="delete" but_name="delete_cart_item"}
																	{/if}
																</div>
															{/if}
														</div>
														{/hook}
													</li>
												{/if}
												{/hook}
											{/foreach}
										{/hook}
									</ul>
								{else}
									<div class="ty-cart-items__empty ty-center">{__("cart_is_empty")}</div>
								{/if}
							</div>

							{if $block.properties.display_bottom_buttons == "Y"}
							<div class="cm-cart-buttons ty-cart-content__buttons buttons-container{if $smarty.session.cart.amount} full-cart{else} hidden{/if}">
								<div class="">
									<a href="{"checkout.cart"|fn_url}" rel="nofollow" class="ty-btn ty-btn__secondary"><i class="et-icon-btn-cart"></i><span>{__("view_cart")}</span></a>
								</div>
								{if $settings.Checkout.checkout_redirect != "Y"}
								<div class="et-cart-checkout-btn">
									{include file="buttons/proceed_to_checkout.tpl" but_text=__("checkout") et_cart_dropdown=true}
								</div>
								{/if}
							</div>
							{/if}

					</div>
				{/hook}
			{/capture}
			{if $block.wrapper!="blocks/wrappers/et_sticky_cart.tpl"}
				{$smarty.capture.et_content nofilter}
			{/if}
		</div>
		{if $block.wrapper=="blocks/wrappers/et_sticky_cart.tpl"}
			{$smarty.capture.et_content nofilter}
		{/if}
	<!--cart_status_{$dropdown_id}--></div>
{/hook}