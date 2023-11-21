{* Product title rows *}
{if isset($addons.et_vivashop_settings.et_viva_product_title_rows)}
	{* Grid *}
	{$grid_one_row_height=17}
	{$grid_one_item_wrapper=461}

	{$grid_new_row_height=$grid_one_row_height*$addons.et_vivashop_settings.et_viva_product_title_rows}
	{$grid_new_item_wrapper=$grid_one_item_wrapper+$grid_new_row_height}

	{* {$grid_home_one_row_height=19} *}
	{$grid_home_one_row_height=17}
	{$grid_home_new_row_height=$grid_home_one_row_height*$addons.et_vivashop_settings.et_viva_product_title_rows}
	{$grid_home_new_item_wrapper=$grid_one_item_wrapper+$grid_home_new_row_height}

	<style>
		.et-grid-item-wrapper .product-title{
			white-space: normal;
			min-height: {$grid_new_row_height}px;
			height: {$grid_new_row_height}px;
		}

		.et-home-grid .et-grid-item-wrapper .product-title{
			min-height: {$grid_home_new_row_height}px;
			height: {$grid_home_new_row_height}px;
		}

		.et-home-grid .et-grid-item-wrapper.et-hover .product-title{
			height: auto;
		}
	</style>

	{* Scroller *}
	{$scroller_padding_height=16}
	{$scroller_one_row_height=18}
	{$scroller_new_row_height=$scroller_one_row_height*$addons.et_vivashop_settings.et_viva_product_title_rows}
	{$scroller_new_row_height_padded=$scroller_padding_height+$scroller_new_row_height}

	<style>
		.et-scroller .et-scroller-item .et-title-hover{
			padding-top: {$scroller_new_row_height_padded}px;
		}
		.et-scroller .et-scroller-item .et-title-hover-inner .product-title{
			min-height: {$scroller_new_row_height}px;
		}
		.et-scroller-item:hover .et-title-hover-inner{
			transform: translateY({$scroller_new_row_height_padded}px) translateY(-100%);
		}
	</style>

	{* Vendor store grid*}
	
	{$grid_vendor_one_row_height=19}
	{$grid_vendor_one_item_wrapper=403}

	{$grid_vendor_new_row_height=$grid_vendor_one_row_height*$addons.et_vivashop_settings.et_viva_product_title_rows}
	{$grid_vendor_new_item_wrapper=$grid_vendor_one_item_wrapper+$grid_vendor_new_row_height}

	<style>
		.et-vendor-store-block .et-grid-item-wrapper .product-title{
			white-space: normal;
			min-height: {$grid_vendor_new_row_height}px;
			height: {$grid_vendor_new_row_height}px;
		}

	</style>
	{* /Vendor store grid*}
{/if}

{* Scroller button position *}
{if $addons.et_vivashop_settings.et_viva_scroll_up=="off"}
	<style>
		#scroll-up{
			display: none !important;
		}
	</style>
{elseif $addons.et_vivashop_settings.et_viva_scroll_up=="left"}
	<style>
		#scroll-up{
			left: 60px;
			right: auto;
		}
	</style>
{/if}

{* Brand page type *}
{if $addons.et_vivashop_settings.et_viva_brand_page=="text"}
	<style>
		.et-brand-page-img{
			display: none !important;
		}
	</style>
{else}
	<style>
		.et-brand-page-name{
			display: none !important;
		}
		.ty-features-all .ty-features-all__group{
	    display: block;
	    width: 100%;
		}
		.ty-features-all .ty-features-all__list-item{
	    text-align: center;
	    display: inline-block;
	  }
		.ty-features-all .vs-brand-name{
	    display: none;
	  }
	</style>
{/if}