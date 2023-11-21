{$show_price=true}
{$show_old_price=true}
<div class="et-small-items">
{foreach from=$products item="product" name="products"}
	{assign var="obj_id" value=$product.product_id}
	{assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}
	{include file="common/product_data.tpl" product=$product}
	{hook name="products:product_small_item"}
	<div class="ty-column2 et-small-item-wrapper">
		<div class="et-small-item">
			{assign var="form_open" value="form_open_`$obj_id`"}
			{$smarty.capture.$form_open nofilter}
			<div class="et-small-item-img">
				<a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{include file="common/image.tpl" image_width="120" image_height="120" images=$product.main_pair obj_id=$obj_id_prefix no_ids=true}
				</a>
				{assign var="rating" value="rating_$obj_id"}
				{if $smarty.capture.$rating|trim}
					<div class="rating-wrapper">
						{$smarty.capture.$rating nofilter}
					</div>
				{/if}
			</div>
			<div class="et-small-item-descr ty-template-small__item-description">
				{assign var="name" value="name_$obj_id"}<bdi>{$smarty.capture.$name nofilter}</bdi>
				{if $show_price}
				<div class="ty-template-small__item-price">
					{assign var="price" value="price_`$obj_id`"}
					{$smarty.capture.$price nofilter}
					{assign var="old_price" value="old_price_`$obj_id`"}
					{if $smarty.capture.$old_price|trim}<br/>{$smarty.capture.$old_price nofilter}{/if}
				</div>
				{/if}
			</div>
			{assign var="form_close" value="form_close_`$obj_id`"}
			{$smarty.capture.$form_close nofilter}
		</div>
	</div>
	{/hook}
{/foreach}
</div>