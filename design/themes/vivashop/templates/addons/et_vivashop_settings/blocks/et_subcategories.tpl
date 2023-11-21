{function name="show_subcateg" type=$type}{strip}
{if $type=="S" && count($subcategories)>9}{$is_scroller=true}{else}{$is_scroller=false}{/if}

{if $smarty.const.ET_DEVICE != "D"}
	{$is_scroller=false}
{/if}

{if $is_scroller}
<div class="et-scroller et-category-scroller-wrapper">
  <div class="owl-theme ty-owl-controls" id="owl_outside_nav_{$block.block_id}">
    <div class="owl-controls clickable owl-controls-outside"  >
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
  <div id="scroll_list_{$block.block_id}" class="owl-carousel ty-scroller-list">
{/if}
{foreach from=$subcategories item=category name="subcateg"}{strip}
	{if $category}
		<div class="ty-subcategories__item">
			{if $smarty.request.dispatch == "companies.products"}
				{$href="companies.products?category_id=`$category.category_id`&company_id=`$company_id`"|fn_url}
			{else}
				{$href="categories.view?category_id=`$category.category_id`"|fn_url}
			{/if}
			<a href="{$href}">
				{if $type!="T"}
				<span class="et-categ-img">
					{include file="common/image.tpl"
						show_detailed_link=false
						images=$category.main_pair
						no_ids=true
						image_id="category_image"
						image_width=$settings.Thumbnails.category_lists_thumbnail_width
						image_height=$settings.Thumbnails.category_lists_thumbnail_height
						class="ty-subcategories-img"
						et_lazy=true
					}
					<span class="et-categ-title-wrapper">
						<span class="et-hover-text">{__("et_select_category_hover_text")}</span>
					</span>
				</span>
				{/if}
				<span class="et-long-names" {live_edit name="category:category:{$category.category_id}"}>{$category.category}</span>
			</a>
		</div>
	{/if}
{/strip}{/foreach}
{if $is_scroller}
</div>
</div>
{/if}
{/strip}{/function}

{if !$et_is_vendor_search}
	{$obj_prefix="`$block.block_id`000"}
	{$et_type=$block.properties.et_type}

	<div id="et_subcategs_{$block.block_id}">
	{if $subcategories}
		<div class="et-subcategs ty-center clearfix">{strip}
			{if $et_type=="I"}
				<div class="ty-center">{show_subcateg type=$et_type}</div>
			{elseif $et_type=="T"}
				<div class="et-subcategs-text-only">{show_subcateg type=$et_type}</div>
			{elseif $et_type=="S"}
				{show_subcateg type=$et_type}
			{/if}
		{/strip}</div>
		{if count($subcategories)>10}
			{$block.properties.item_quantity=10}
		{else}
			{$block.properties.item_quantity=count($subcategories)}
		{/if}
		{$block.properties.not_scroll_automatically="Y"}
		{$block.properties.scroll_per_page="Y"}
		{$block.properties.outside_navigation="Y"}
		{$block.properties.speed=400}
		{include file="common/scroller_init.tpl" prev_selector="#owl_prev_`$obj_prefix`" next_selector="#owl_next_`$obj_prefix`" et_no_rewind=true}

	{/if}
	<!--et_subcategs_{$block.block_id}--></div>
{/if}