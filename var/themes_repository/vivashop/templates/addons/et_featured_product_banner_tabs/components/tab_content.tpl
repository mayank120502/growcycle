<li class="tab_color_{$items.block_id}" id="{$tab_link_id}">

	<a>{$item.q_tabs_data.title}</a>

<!--{$tab_link_id}--></li>

<div class="et-tab" id="{$tab_content_id}">
	{* Settings *}
	{if $item.q_tabs.custom_settings.active=="Y" && $item.q_tabs.custom_settings.columns>0}
		{$et_column=$item.q_tabs.custom_settings.columns}
	{else}
		{$et_column=8}
	{/if}

	{if $item.q_tabs.custom_settings.active=="Y" && $item.q_tabs.custom_settings.image_width>0}
		{$et_image_height=$item.q_tabs.custom_settings.image_width}
		{$et_image_width=$item.q_tabs.custom_settings.image_width}
	{else}
		{$et_image_height=178}
		{$et_image_width=178}
	{/if}

	{if $item.q_tabs.custom_settings.active=="Y" && $item.q_tabs.custom_settings.title_rows>1}
		{$et_title_rows=$item.q_tabs.custom_settings.title_rows}
	{else}
		{$et_title_rows=1}
	{/if}

	{* Custom styles *}
	<style>
		{$et_title_hover=5}
		{$title_height=17}

		{$new_title_height=$title_height*$et_title_rows}
		{$new_et_title_hover=$et_title_hover+$new_title_height}

		#{$tab_content_id} .et-link-thumb__inner-wrapper .et-title-hover{
			padding-top: {$new_et_title_hover}px;
		}
		#{$tab_content_id} .et-link-thumb__inner-wrapper .product-title{
			min-height: {$new_title_height}px;
		}
		#{$tab_content_id} .et-link-thumb__inner-wrapper .et-link-thumb__item:hover .et-title-hover-inner{
			transform: translateY({$new_et_title_hover}px) translateY(-100%);
		}
	</style>

	{* Products *}
	
	{* Products template *}
	{include 
	file="addons/et_featured_product_banner_tabs/views/product_scroller.tpl"
	products=$item.product_data
	item_number=$block.properties.item_number 
	show_name=true 
	show_trunc_name=true
	show_old_price=true 
	show_clean_price=true 
	show_price=true
	show_list_discount=true 
	show_add_to_cart=true 
	show_list_buttons=true
	show_rating=true
	show_et_icon_buttons=true
	et_separate_buttons=true
	et_column=$et_column
	add_to_cart_meta="text-button-add"
	but_role="text"
	et_image_height=$et_image_height
	et_image_width=$et_image_width}
	
	{if $item.banner_data.banner_1 || $item.banner_data.banner_2}
		{$block.properties.delay=3}
		{$block.properties.navigation="A"}
		{$tab_suffix=$tab_content_id}
		<div class="et-categ-block-tabs_banner-wrapper">{strip}
			{if $item.banner_data.banner_1}
				<div class="ty-banner__image-item et-categ-block-tabs_banner">
					{include file="addons/banners/blocks/carousel.tpl" items=$item.banner_data.banner_1 et_id="`$tab_suffix`_1"}
				</div>
			{/if}
			{if $item.banner_data.banner_2}
				<div class="ty-banner__image-item et-categ-block-tabs_banner">
					{include file="addons/banners/blocks/carousel.tpl" items=$item.banner_data.banner_2 et_id="`$tab_suffix`_2"}
				</div>
			{/if}
		{/strip}</div>
	{/if}


<!--{$tab_content_id}--></div>