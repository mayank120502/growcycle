{$position=$et_menu.products.position}
{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
{if $et_menu.products.enabled == "Y"  && ($smarty.const.ET_DEVICE == "D" || $et_traditional_resp)}

	<div class="{if $position=="T" || $position=="B"}et-menu-flow-column{else}et-menu-flow-row{/if} {if $position=="B" || $position=="R"}reverse{/if}">

		<div class="et_menu_product et-position-{$position} {if $position=="T" || $position=="B"}et_menu_product-horizontal{else}et_menu_product-vertical{/if}" id="et_menu_product-{$item.parent_id} visible-desktop">

			{if $et_menu.products.show_title=="Y" && $et_menu.products.title|trim}
				<div class="et_menu_product-title" {if $et_menu.products.color_type|default:"S" == "C"}style="{if $et_menu.products.title_bkg_transparent!="Y"}background-color: {$et_menu.products.title_bkg};{/if} color: {$et_menu.products.title_color}"{/if}>
					{$et_menu.products.title nofilter}
				</div>
			{/if}
			<div class="et-menu-products-container" data-et-category-id="{$item.category_id}" id="menu-product-{$item.category_id}_{$grid.grid_id}">
			<!--menu-product-{$item.category_id}--></div>
	</div>
{/if}