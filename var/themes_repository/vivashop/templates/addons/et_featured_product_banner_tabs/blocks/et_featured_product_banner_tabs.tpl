{* block-description:et_featured_products_banner *}
{$tabs_suffix = "`$block.grid_id`_`$items.block_id`"}

<div class="et_full_width_block_wrapper ty-mainbox-container clearfix et-categ-title et-fpb et-fpb-{$items.block_id}">
	<div class="ty-mainbox-body et_grid_width_content clearfix ">
		<div class="et-main-categ" {if $items.q_blocks_data.color_type|default:"S" == "C"}style="color: {$items.q_blocks_data.color}; border-color: {$items.q_blocks_data.bkg_color};"{/if}>
			{$items.q_blocks.title}
		</div>

		<div class="et-additional-categ">
			{if $items.q_blocks_data.color_type|default:"S" == "C"}
				<style>
					.et-fpb-{$items.block_id} a{
						color: {$items.q_blocks_data.tabs_color};
					}
					.et-fpb-{$items.block_id} a.et-hover,
					.et-fpb-{$items.block_id} li.active a{
						color: {$items.q_blocks_data.tabs_color_active};
						border-color: {$items.q_blocks_data.tabs_color_active};
					}
				</style>
			{/if}
			<ul id="tabs_{$tabs_suffix}">
				{foreach from=$items.tabs item=item name="tab"}{strip}
					{$tab_suffix = "`$tabs_suffix`_`$item.tab_id`"}
					<li class="tab_color_{$items.block_id} {if $smarty.foreach.tab.first}active{/if}" id="tab_{$tab_suffix}">
						{if $smarty.foreach.tab.first}
							<a>{$item.q_tabs_data.title}</a>
						{else}
							<a class="cm-ajax cm-ajax-full-render" href="{"et_featured_product_banner_tabs.load&tab_id=`$item.tab_id`&tab_content_id=content_tab_`$tab_suffix`&tab_link_id=tab_`$tab_suffix`&sl=`$smarty.const.CART_LANGUAGE`"|fn_url}" data-ca-target-id="content_tab_{$tab_suffix},tab_{$tab_suffix}" rel="nofollow">{$item.q_tabs_data.title}</a>
						{/if}
					</li>
				{/strip}{/foreach}
			</ul>
		</div>
	</div>
</div>

<div class="row-fluid et-categ-block-wrapper">
	<div class="et-container clearfix">
		<div class="et-categ-block">
			<div class="et-categ-block-tabs">
				{if $items.tabs}
					<div class="">
						{foreach from=$items.tabs item=item name="tab"}
							{$tab_suffix = "`$tabs_suffix`_`$item.tab_id`"}
							<div 
								id="content_tab_{$tab_suffix}" 
								class="et-tab">

								{if $smarty.foreach.tab.first}

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

										#content_tab_{$tab_suffix} .et-link-thumb__inner-wrapper .et-title-hover{
											padding-top: {$new_et_title_hover}px;
										}
										#content_tab_{$tab_suffix} .et-link-thumb__inner-wrapper .product-title{
											min-height: {$new_title_height}px;
										}
										#content_tab_{$tab_suffix} .et-link-thumb__inner-wrapper .et-link-thumb__item:hover .et-title-hover-inner{
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
								{else}
									<div class="owl-item loading"></div>
								{/if}
							</div>
						{/foreach}
					</div>
				{/if}
			</div>
		</div>
	</div>
</div>

{include file="common/scroller_init.tpl"}