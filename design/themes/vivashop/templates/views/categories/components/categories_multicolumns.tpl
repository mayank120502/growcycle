{split data=$categories size=$columns|default:"3" assign="splitted_categories"}
<div class="ty-subcategories">
	{strip}
	{foreach from=$splitted_categories item="scats"}
		<div class="ty-subcategories-block">
			{foreach from=$scats item="category"}
				{if $category}
					<div class="ty-column{$columns} ty-subcategories-block__item">
						{$href=$category|fn_form_dropdown_object_link:$block.type}
						<a href="{if $href}{$href}{else}{"categories.view?category_id=`$category.category_id`"|fn_url}{/if}" class="ty-subcategories-block__a">
							{if $category.main_pair}
								{include file="common/image.tpl"
									show_detailed_link=false
									images=$category.main_pair
									no_ids=true
									image_id="category_image"
									image_width=$settings.Thumbnails.category_lists_thumbnail_width
									image_height=$settings.Thumbnails.category_lists_thumbnail_height
									class="ty-subcategories-img"
								}
							{/if}
							{$category.category}
							</a>
					</div>
				{/if}
			{/foreach}
		</div>
	{/foreach}
	{/strip}
</div>

{capture name="mainbox_title"}{$title}{/capture}