{hook name="products:notification_items"}
	{if $added_products}
		{foreach from=$added_products item=product key="key"}
			{hook name="products:notification_product"}
			<div class="ty-product-notification__item clearfix">
				<div class="et-product-notification__item-wrapper">
					<div class="et-product-notification__image">{include file="common/image.tpl" image_width="50" image_height="50" images=$product.main_pair no_ids=true class="ty-product-notification__image"}</div>
					
					<div class="ty-product-notification__content clearfix">
							<a href="{"products.view?product_id=`$product.product_id`"|fn_url}" class="ty-product-notification__product-name">{$product.product_id|fn_get_product_name nofilter}</a>
                    {if !($settings.Checkout.allow_anonymous_shopping == "hide_price_and_add_to_cart" && !$auth.user_id)}
								<div class="ty-product-notification__price">
									{if !$hide_amount}
                                <span class="none">{$product.amount}</span><span dir="{$language_direction}">&nbsp;x&nbsp;</span>{include file="common/price.tpl" value=$product.display_price span_id="price_`$key`" class="none"}
										{/if}
								</div>
							{/if}
					</div>
				</div>
				{if $product.product_option_data}
					{include file="common/options_info.tpl" product_options=$product.product_option_data}
				{/if}
			</div>
			{/hook}
		{/foreach}
	{else}
		{$empty_text}
	{/if}
{/hook}
