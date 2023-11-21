{foreach from=$vsb item=item key=key name=name}
 	{if $item.settings.type== "P" && empty($item.settings.product_data)}
 		{continue}
 	{/if}
	<div class="et-vendor-store-block et-vendor-store-block__type-{$item.settings.type}">

		{if $item.settings.show_title=="Y"}
			<div class="et_full_width_title">
				<h2 class="ty-mainbox-title et-first-spacing">
					<span>{$item.data.title}</span>
				</h2>
				<h3 class="ty-mainbox-title">
					<span>{$item.data.sub_title}</span>
				</h3>
			</div>
		{elseif $item.settings.type != "B"}
			<div class="et-first-spacing">
		{/if}

		{if $item.settings.full_width=='N'}
			<div class="container-fluid">
				<div class="et_container">
		{/if}

		{if $item.settings.type == "T"}
			{* TEXTAREA *}
			<div class="et_grid_width_content">
				<div class="ty-wysiwyg-content">
					{$item.text nofilter}
				</div>
			</div>
		
		{elseif $item.settings.type == "B"}
			{* BANNER *}
			{$block.properties=array()}
			{$block.properties.delay=5}
			{$block.properties.navigation="A"}

			<div class="et-homepage-banners">
				{if $item.new_banners}
					{include file="addons/banners/blocks/carousel.tpl" items=$item.new_banners et_id=$item.vsb_id}
				{/if}
			</div>
		
		{elseif $item.settings.type== "P"}
			{* PRODUCTS *}
			<div class="ty-mainbox-body et_grid_width_content">
				{if $item.settings.product_data}
					{$products=$item.settings.product_data}

					{include file="addons/et_vivashop_mv_functionality/blocks/list_templates/grid_list.tpl"
					products=$products
					columns=6
					form_prefix="block_manager"
					no_sorting="Y"
					no_pagination="Y"
					no_ids="Y"
					show_name=true
					show_old_price=true
					show_price=true
					show_rating=true
					show_clean_price=true
					show_list_discount=true
					show_add_to_cart=true
					but_role="action"
					show_discount_label=true
					}
				{/if}
			</div>
		{/if}

		{if $item.settings.full_width=='N'}
				</div>
			</div>
		{/if}

		{if $item.settings.show_title!="Y" && $item.settings.type != "B"}
			</div>
		{/if}

	</div>

{/foreach}