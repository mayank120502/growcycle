<div class="ty-thumbnail-list et-link-thumb et-link-thumb__wrapper">
{foreach from=$products item="product" name="products"}{strip}
	<div class="et-link-thumb__inner-wrapper {* et-categ-block-thumb *} {if $et_column>1}ty-column{$et_column}{elseif $et_column==1}{else}ty-column6{/if}">
		{assign var="obj_id" value=$product.product_id}
		{assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}
		{include file="common/product_data.tpl" 
			product=$product 
			show_et_icon_grid=true 
			et_categ_block=true 
			show_old_price=true 
			show_et_atc=true 
			show_et_icon_buttons=false
			et_separate_buttons=false
			show_list_buttons=false
			show_product_labels=true 
			show_discount_label=true 
			show_shipping_label=true
			hide_label_text=true}
		<div class="et-link-thumb__item ty-thumbnail-list__item">
			{assign var="form_open" value="form_open_`$obj_id`"}
			{$smarty.capture.$form_open nofilter}
			<div class="et-link-thumb__img_wrapper">
				{assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
				{$smarty.capture.$product_labels nofilter}
				<a class="et-link-thumb__img_a" href="{"products.view?product_id=`$product.product_id`"|fn_url}">{include file="common/image.tpl" image_width=$et_image_width image_height=$et_image_height images=$product.main_pair obj_id=$obj_id_prefix no_ids=true}</a>
			</div>
			<div class="et-title-hover">
				<div class="et-title-hover-inner ">
					{assign var="name" value="name_$obj_id"}<bdi>{$smarty.capture.$name nofilter}</bdi>
				</div>
			</div>

			<div class="et-price">
				{assign var="price" value="price_`$obj_id`"}
				{$smarty.capture.$price nofilter}

				{assign var="old_price" value="old_price_`$obj_id`"}
				{if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}{/if}
			</div>
			{assign var="rating" value="rating_`$obj_id`"}
			<div class="et-link-thumb__rating-wrapper">
				{$smarty.capture.$rating nofilter}
			</div>
			{assign var="form_close" value="form_close_`$obj_id`"}
			{$smarty.capture.$form_close nofilter}
		</div>
	</div>
{/strip}{/foreach}
</div>