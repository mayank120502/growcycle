<div class="et-menu-products-container" {if $position=="T" || $position=="B"}data-et-has-scroller="true"{/if} id="{$container_id}">
	{$position=$et_menu.products.position}
	{if $position=="T" || $position=="B"}
		{$et_column=$et_menu.products.count}
	{else}
		{$et_column=false}
	{/if}

	{if $et_menu.products.show_discount_label=="Y"}
		{$show_discount_label=true}
	{else}
		{$show_discount_label=false}
	{/if}
	
	{include file="addons/et_mega_menu/templates/links_thumb.tpl" 
		products=$et_menu.products.detailed
		obj_prefix="`$block.grid_id`_`$block.block_id`_`$et_menu.et_menu_id`" 
		item_number=$block.properties.item_number 
		show_discount_label=$show_discount_label
		show_name=$et_menu.products.show_name 
		show_price=$et_menu.products.show_price
		show_old_price=$et_menu.products.show_old_price
		show_trunc_name=true 
		show_add_to_cart=false 
		show_list_buttons=false
		add_to_cart_meta="text-button-add"
		but_role="text"
		et_column=$et_column
		et_hide_vendor=true}
<!--{$container_id}--></div>