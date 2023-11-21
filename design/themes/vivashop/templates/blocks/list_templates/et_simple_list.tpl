{if $product}

{assign var="obj_id" value=$obj_id|default:$product.product_id}
{assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}

<div class="{if !$et_show_age_verification}ty-scroller-list__item{/if}">
	{include file="common/product_data.tpl" obj_id=$obj_id product=$product show_product_amount=true show_et_grid_stock=true show_et_rating=true et_product_scroller=true}

	{$image_width=$block.properties.thumbnail_width}
	{$image_height=$block.properties.thumbnail_width}
	
	{if $et_image_height}
		{$image_height=$et_image_height}
	{/if}
	{if $et_image_width}
		{$image_width=$et_image_width}
	{/if}

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

	<div class="et-scroller-item">
		{assign var="form_open" value="form_open_`$obj_id`"}
		{$smarty.capture.$form_open nofilter}
			<div class="ty-scroller-list__img-block">
		    <div class="et-image-title-wrapper">
		    	{if $et_show_age_verification}
  		    	<div class="et-scroller-image-wrapper ">
  	  				<div class="et-relative">
  	  					<a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>
	  	  					<span class="ty-no-image" style="max-height: {$image_height|default:$image_width}px; width: {$image_width|default:$image_height}px;"><img src="./design/themes/vivashop/media/images/et-empty.png" height="{$image_height|default:$image_width}" width="{$image_width|default:$image_height}" class="et-no-image" alt=""/><i class="ty-no-image__icon et-icon-verify" title="{__("verify")}"></i></span>
	  	  				</a>
  	  				</div>
  	  			</div>
		    	{else}

			    	{include file="common/image.tpl" assign="object_img" images=$product.main_pair image_width=$image_width image_height=$image_height no_ids=true et_lazy=true et_custom_lazy="et_scroller_image"}

			    	{function name="et_scroller_mobile_btns" product_id=$product_id obj_prefix=$obj_prefix}{strip}
			    	  <div class="et-grid-btns clearfix1 visible-phone">
			    	    {if $settings.General.enable_compare_products == "Y" && !$hide_compare_list_button}
			    	      {include file="buttons/add_to_compare_list.tpl" product_id=$product_id show_et_icon_grid=true}
			    	    {/if}
			    	    {if $addons.wishlist.status == "A" && !$hide_wishlist_button}
			    	      {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product_id`" but_name="dispatch[wishlist.add..`$product_id`]" but_role="text" show_et_icon_grid=true}
			    	    {/if}
			    	  </div>
			    	{/strip}{/function}
			    	<div class="et-scroller-image-wrapper ">
		  				<div class="et-relative">
		  					{assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
		  					{$smarty.capture.$product_labels nofilter}
				    		<a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>{$object_img nofilter}</a>
				    		{et_scroller_mobile_btns product_id=$product.product_id obj_prefix=$obj_prefix}
		  				</div>
			    	</div>
			    {/if}

	    		<div class="et-title-hover">
	    			<div class="et-title-hover-inner ">
	    				{assign var="name" value="name_$obj_id"}<bdi>{$smarty.capture.$name nofilter}</bdi>
	    			</div>
	    		</div>
		    </div>
			</div>
			<div class="ty-scroller-list__description">
				<div class="ty-simple-list clearfix">
					{if $et_show_age_verification}
						<div class="et-info-wrapper et-info-wrapper-age-verif">
							<div class="ty-age-verification__txt">{__("product_need_age_verification")}</div>
							<div class="ty-simple-list__buttons clearfix">
								<div class="buttons-container">
								    <a href="{$product_url|fn_url}" {$et_add_blank nofilter} class="ty-btn ty-btn__secondary text-button" title="{__("verify")}">{__("verify")}</a>
								</div>
							</div>
						</div>
					{else}
						<div class="et-info-wrapper">
							{if !$hide_price}
								<div class="ty-simple-list__price clearfix">
									{assign var="price" value="price_`$obj_id`"}
									{$smarty.capture.$price nofilter}

									{if $show_old_price || $show_clean_price || $show_list_discount}
										{assign var="clean_price" value="clean_price_`$obj_id`"}
										{$smarty.capture.$clean_price nofilter}
										
										{assign var="list_discount" value="list_discount_`$obj_id`"}
										{$smarty.capture.$list_discount nofilter}
									{/if}

									{if $show_old_price || $show_clean_price || $show_list_discount}
										{assign var="old_price" value="old_price_`$obj_id`"}
										{if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}{/if}
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

							{if "MULTIVENDOR"|fn_allowed_for}
		 						{$et_on_vs=(strpos($smarty.request.dispatch,'companies')===0)}
		 						{if !$et_on_vs}
									<div class="et-scrl-vendor">
										{if !($addons.master_products.status == "A" && !$product.company_id)}
											<span class="et-scrl-vendor_label">{__("et_pp_sold_by")}:</span><i class="et-icon-mobile-sold-by hidden"></i> <a href="{"companies.view?company_id=`$product.company_id`"|fn_url}" class="et-scrl-vendor_name" {if !$et_on_vs}target="_blank"{/if}>{$product.company_name}</a>
										{else}
											<span class="et-scrl-vendor_label">{__("et_pp_sold_by")}:</span><i class="et-icon-mobile-sold-by hidden"></i> <a href="{"products.view?product_id=`$product.product_id`"|fn_url}" class="et-scrl-vendor_name">{$product.master_product_offers_count} {__('et_master_vendors',[$product.master_product_offers_count])}</a>
										{/if}
									</div>
								{/if}
							{/if}

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
					{/if}
				</div>    

			</div>
		{assign var="form_close" value="form_close_`$obj_id`"}
		{$smarty.capture.$form_close nofilter}
	</div>
</div>

{/if}