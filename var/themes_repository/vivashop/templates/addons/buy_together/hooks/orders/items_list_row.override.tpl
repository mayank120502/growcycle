{if $product.extra.buy_together}
	{assign var="conf_price" value=$product.price|default:"0"}
	{assign var="conf_subtotal" value=$product.display_subtotal|default:"0"}
	{assign var="conf_discount" value=$product.extra.discount|default:"0"}
	{assign var="conf_tax" value=$product.tax_value|default:"0"}

	{assign var="_colspan" value=4}
	{assign var="c_product" value=$product}
	{foreach from=$order_info.products item="sub_oi"}
		{if $sub_oi.extra.parent.buy_together && $sub_oi.extra.parent.buy_together == $product.cart_id}
			{capture name="is_conf"}1{/capture}
			{math equation="item_price * amount + conf_price" amount=$sub_oi.extra.min_qty|default:"1" item_price=$sub_oi.price|default:"0" conf_price=$conf_price assign="conf_price"}
			{math equation="discount + conf_discount" discount=$sub_oi.extra.discount|default:"0" conf_discount=$conf_discount assign="conf_discount"}
			{math equation="tax + conf_tax" tax=$sub_oi.tax_value|default:"0" conf_tax=$conf_tax assign="conf_tax"}
			{math equation="subtotal + conf_subtotal" subtotal=$sub_oi.display_subtotal|default:"0" conf_subtotal=$conf_subtotal assign="conf_subtotal"}
		{/if}
	{/foreach}

	<tr class="ty-buy-together-orders ty-valign-top">
		<td class="ty-valign-top">
			<div class="clearfix">
				<div class="ty-float-left ty-orders-detail__table-image">
					{hook name="orders:product_icon"}
						{if $product.is_accessible}<a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{/if}
							{include file="common/image.tpl" obj_id=$key images=$product.main_pair image_width=$settings.Thumbnails.product_cart_thumbnail_width image_height=$settings.Thumbnails.product_cart_thumbnail_height}
						{if $product.is_accessible}</a>{/if}
					{/hook}
				</div>

				<div class="ty-overflow-hidden ty-orders-detail__table-description-wrapper">
					<div class="ty-ml-s ty-orders-detail__table-description">
			{if $product.is_accessible}<a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{/if}
				<span class="et-product-title-general">{$product.product nofilter}</span>
			{if $product.is_accessible}</a>{/if}

			{if $product.extra.is_edp == "Y"}
				<div class="ty-right"><a href="{"orders.order_downloads?order_id=`$order_info.order_id`"|fn_url}">[{__("download")}]</a></div>
			{/if}
			{if $product.product_code}
				<div class="ty-orders-detail__table-code"><strong>{__("sku")}:</strong>&nbsp;{$product.product_code}</div>
			{/if}
			{hook name="orders:product_info"}
				{if $product.product_options}{include file="common/options_info.tpl" product_options=$product.product_options}{/if}
			{/hook}
			
			{if $smarty.capture.is_conf}
				<div class="et-orders__buy-together-title"><strong class="combination-link ty-hand">{__("buy_together")}</strong></div>

				<div class="ty-buy-together-orders__products" >
					<div class="ty-cart-content-products">
					<div class="ty-caret-info"><span class="ty-caret-outer"></span><span class="ty-caret-inner"></span></div>
						{foreach from=$order_info.products item="product" key="sub_key"}
						{if $product.extra.parent.buy_together && $product.extra.parent.buy_together == $c_product.cart_id}
							<div class="ty-cart-content-products__item">
								<div>
									{if $product.is_accessible}<a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{/if}<strong>{$product.product|truncate:50:"...":true nofilter}</strong>{if $product.is_accessible}</a>{/if}&nbsp;
									{if $product.product_code}
									<p><strong>{__("sku")}:</strong>&nbsp;{$product.product_code}</p>
									{/if}
									{hook name="orders:product_info"}
									{if $product.product_options}
										{include file="common/options_info.tpl" product_options=$product.product_options}
									{/if}
									{/hook}
									</span>
								</div>
								<div class="ty-control-group1">
									<strong class="ty-product-options-name">{__("price")}:</strong>
									<span class="ty-product-options-content">
										{include file="common/price.tpl" value=$product.price}
									</span>
								</div>
								<div class="ty-control-group1">
									<strong class="ty-product-options-name">{__("quantity")}:</strong>
									<span class="ty-product-options-content">
										{$product.amount}
									</span>
								</div>
								{if $order_info.use_discount}
								<div class="ty-control-group1">
									<strong class="ty-product-options-name">{__("discount")}:</strong>
									<span class="ty-product-options-content">
										{if $product.extra.discount|floatval}{include file="common/price.tpl" value=$product.extra.discount}{else}-{/if}
									</span>
								</div>
								{/if}
								{if $order_info.taxes && $settings.Checkout.tax_calculation != "subtotal"}
								<div class="ty-control-group1">
									<strong class="ty-product-options-name">{__("tax")}:</strong>
									<span class="ty-product-options-content">
										{include file="common/price.tpl" value=$product.tax_value}
									</span>
								</div>
								{/if}
								<div class="ty-control-group1">
									<strong class="ty-product-options-name">{__("subtotal")}:</strong>
									<span class="ty-product-options-content">
										{include file="common/price.tpl" value=$product.display_subtotal}
									</span>
								</div>
							</div>
						{/if}
						{/foreach}
					</div>
				</div>

			{/if}
					</div>
				</div>
			</div>
		</td>
		<td class="ty-center">
			{include file="common/price.tpl" value=$conf_price}
		</td>
		<td class="ty-center">&nbsp;{$product.amount}</td>
		{if $order_info.use_discount}
			{assign var="_colspan" value=$_colspan+1}
			<td class="ty-right">
				{include file="common/price.tpl" value=$conf_discount}
			</td>
			{/if}
		{if $order_info.taxes && $settings.Checkout.tax_calculation != "subtotal"}
			{assign var="_colspan" value=$_colspan+1}
			<td class="ty-center">
				{include file="common/price.tpl" value=$conf_tax}
			</td>
		{/if}
		<td class="ty-right">
			&nbsp;{include file="common/price.tpl" value=$conf_subtotal}
		</td>
	</tr>
{/if}