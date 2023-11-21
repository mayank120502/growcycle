{** block-description:blog.et_sidebar_latest_posts_scroller **}

{if $items}

{assign var="obj_prefix" value="`$block.block_id`000"}

<div class="et-scroller et-latest-blog-scroller-wrapper">
		<div class="owl-theme ty-owl-controls" id="owl_outside_nav_{$block.block_id}">
			<div class="owl-controls clickable owl-controls-outside" >
				<div class="owl-buttons">
				  <div id="owl_next_{$obj_prefix}" class="owl-next">
				    {if $language_direction == 'rtl'}
				      <i class="et-icon-arrow-left"></i>
				    {else}
				      <i class="et-icon-arrow-right"></i>
				    {/if}
				  </div>
				  <div id="owl_prev_{$obj_prefix}" class="owl-prev">
				    {if $language_direction == 'rtl'}
				      <i class="et-icon-arrow-right"></i>
				    {else}
				      <i class="et-icon-arrow-left"></i>
				    {/if}
				  </div>
				</div>
		</div>
	</div>

	<div class="ty-mb-l">
		<div class="ty-blog-recent-posts-scroller et-latest-blog-scroller">
			<div id="scroll_list_{$block.block_id}" class="owl-carousel ty-scroller-list">
			{foreach from=$items item="page"}
				<div class="et-blog-list-scroller">
					<div class="et-blog__item">
						{$href="pages.view?page_id=`$page.page_id`"|fn_url}
						{$data=$page.page_id|fn_get_page_data}
						<div class="et-scroller-image-wrapper">
							<a href="{$href}">
								<div class="et-blog__img-block">
									{include file="common/image.tpl" obj_id=$data.page_id images=$data.main_pair image_width=480 image_height=271}
								</div>
							</a>
						</div>
						<div class="et-blog-item__details-wrapper">
							<a href="{$href}" class="et-blog-item__title-link">
								<span class="ty-blog__post-title">
									{$page.page}
								</span>
							</a>
							<div class="et-blog-item__details clearfix">
								<div class="et-blog__author"><i class="et-icon-blog-user2"></i> <span>{$page.author}</span></div>
								{hook name="blog:comments"}{/hook}
							</div>
						</div>
					</div>
				</div>
			{/foreach}
			</div>
		</div>
	</div>
</div>


{include file="common/scroller_init_with_quantity.tpl" prev_selector="#owl_prev_`$obj_prefix`" next_selector="#owl_next_`$obj_prefix`" et_outside_nav=true }
{/if}