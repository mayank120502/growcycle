{if $product}
{assign var="obj_id" value=$obj_id|default:$product.product_id}
{assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}
{include file="common/product_data.tpl" obj_id=$obj_id product=$product show_product_amount=true show_et_grid_stock=true show_et_rating=true}

<div class="ty-simple-list clearfix">
	{assign var="form_open" value="form_open_`$obj_id`"}
	{$smarty.capture.$form_open nofilter}
		{if $item_number == "Y"}<strong>{$smarty.foreach.products.iteration}.&nbsp;</strong>{/if}
		<div class="title-wrapper">
			<div class="title-wrapper-inner">
				{assign var="name" value="name_$obj_id"}<bdi>{$smarty.capture.$name nofilter}</bdi>
			</div>
		</div>
		
		<div class="et-info-wrapper">
			{if !$hide_price}
				<div class="ty-simple-list__price clearfix">
					{assign var="price" value="price_`$obj_id`"}
					{$smarty.capture.$price nofilter}

					{if $show_old_price || $show_clean_price || $show_list_discount}
						{assign var="old_price" value="old_price_`$obj_id`"}
						{if $smarty.capture.$old_price|trim}&nbsp;{$smarty.capture.$old_price nofilter}{/if}
					{/if}

					{if $show_old_price || $show_clean_price || $show_list_discount}
						{assign var="clean_price" value="clean_price_`$obj_id`"}
						{$smarty.capture.$clean_price nofilter}
						
						{assign var="list_discount" value="list_discount_`$obj_id`"}
						{$smarty.capture.$list_discount nofilter}
					{/if}

					{if $show_discount_label}
						<div class="ty-float-left">
							{assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
	            {$smarty.capture.$product_labels nofilter}
						</div>
					{/if}
				</div>
			{/if}
				
			<div class="et-grid-stock-rating clearfix">
				{assign var="stock" value="product_amount_`$obj_id`"}
				{if $smarty.capture.$stock}
					<div class="et-grid-stock ty-float-left">
							{$smarty.capture.$stock nofilter}
					</div>
				{/if}

				{assign var="rating" value="rating_$obj_id"}
				{if $smarty.capture.$rating}
					<div class="grid-list__rating ty-float-right">
							{$smarty.capture.$rating nofilter}
					</div>
				{/if}
			</div>

			<div class="et-scrl-vendor">
				<span>{__("et_pp_sold_by")}:</span> <a href="{"companies.view?company_id=`$product.company_id`"|fn_url}">{$product.company_name}</a>
			</div>

			{if $capture_options_vs_qty}{capture name="product_options"}{/if}

			{if $show_features || $show_descr}
				<div class="ty-simple-list__feature">{assign var="product_features" value="product_features_`$obj_id`"}{$smarty.capture.$product_features nofilter}</div>
				<div class="ty-simple-list__descr">{assign var="prod_descr" value="prod_descr_`$obj_id`"}{$smarty.capture.$prod_descr nofilter}</div>
			{/if}

			{assign var="product_options" value="product_options_`$obj_id`"}
			{$smarty.capture.$product_options nofilter}
				
			{if !$hide_qty}
				{assign var="qty" value="qty_`$obj_id`"}
				{$smarty.capture.$qty nofilter}
			{/if}

			{assign var="advanced_options" value="advanced_options_`$obj_id`"}
			{$smarty.capture.$advanced_options nofilter}
			{if $capture_options_vs_qty}{/capture}{/if}
				
			{assign var="min_qty" value="min_qty_`$obj_id`"}
			{$smarty.capture.$min_qty nofilter}

			{assign var="product_edp" value="product_edp_`$obj_id`"}
			{$smarty.capture.$product_edp nofilter}

			{if $capture_buttons}{capture name="buttons"}{/if}
			{if $show_add_to_cart}
				<div class="ty-simple-list__buttons clearfix">
					{assign var="add_to_cart" value="add_to_cart_`$obj_id`"}
					{$smarty.capture.$add_to_cart nofilter}

					{assign var="list_buttons" value="list_buttons_`$obj_id`"}
					{$smarty.capture.$list_buttons nofilter}
				</div>
			{/if}
			{if $capture_buttons}{/capture}{/if}
		</div>
	{assign var="form_close" value="form_close_`$obj_id`"}
	{$smarty.capture.$form_close nofilter}
</div>

{/if}