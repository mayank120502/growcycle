{$obj_prefix = "`$block.block_id`000"}

<div class="et-scroller et-scroller-nav-both">
	{if $block.properties.outside_navigation == "Y"}
		<div class="owl-theme ty-owl-controls" id="owl_outside_nav_{$block.block_id}">
			<div class="owl-controls clickable owl-controls-outside" >
				<div class="owl-buttons">
						<div id="owl_prev_{$obj_prefix}" class="owl-prev">{strip}
							{if $language_direction == 'rtl'}
							  <i class="et-icon-arrow-right"></i>
							{else}
							  <i class="et-icon-arrow-left"></i>
							{/if}
						{/strip}</div>
						<div id="owl_next_{$obj_prefix}" class="owl-next">{strip}
							{if $language_direction == 'rtl'}
							  <i class="et-icon-arrow-left"></i>
							{else}
							  <i class="et-icon-arrow-right"></i>
							{/if}
						{/strip}</div>
				</div>
			</div>
		</div>
	{/if}

	<div id="scroll_list_{$block.block_id}" class="owl-carousel">
		{foreach from=$brands item="brand" name="for_brands"}
			<div class="ty-scroller-list__item">
				{include file="common/image.tpl" assign="object_img" class="" image_width=$block.properties.thumbnail_width image_height=$block.properties.thumbnail_width images=$brand.image_pair no_ids=true et_lazy=true  obj_id="scr_`$block.block_id`000`$brand.variant_id`"}
				<div class="ty-center et-our-brands-item">
					<a href="{"product_features.view?variant_id=`$brand.variant_id`"|fn_url}">{$object_img nofilter}</a>
				</div>
			</div>
		{/foreach}
	</div>
</div>
{include file="common/scroller_init.tpl" items=$brands prev_selector="#owl_prev_`$obj_prefix`" next_selector="#owl_next_`$obj_prefix`" et_outside_nav=true et_mobile_items=4  et_no_rewind=true}