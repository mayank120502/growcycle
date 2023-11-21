{** block-description:blog.recent_posts_scroller **}

<div class="et-blog-scroller-text">
	<span>{$block.content.description}</span>
</div>

{if $items}

{assign var="obj_prefix" value="`$block.block_id`000"}

<div class="et-scroller">
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

	<div class="ty-mb-l">
		<div class="ty-blog-recent-posts-scroller">
			<div id="scroll_list_{$block.block_id}" class="owl-carousel ty-scroller-list">
			{foreach from=$items item="page"}
				<div class="et-blog-list-scroller">
					<div class="et-blog__item">
						{$href="pages.view?page_id=`$page.page_id`"|fn_url}
						<div class="et-scroller-image-wrapper">
							<a href="{$href}">
								<div class="et-blog__img-block">
									{include file="common/image.tpl" obj_id=$page.page_id images=$page.main_pair image_width=368 image_height=207 et_lazy=true}
									<div class="et-blog__date">
										{$page.timestamp|date_format:"%d"}<br/>
										{$page.timestamp|date_format:"%b"}<br/>
										{$page.timestamp|date_format:"%Y"}
									</div>
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
							{$subpage=$page.page_id|fn_get_page_data}
							{if $subpage.description}
								<div class="et-blog__description">
									{$subpage.description|strip_tags|truncate:150:"...":true nofilter}
								</div>
							{/if}
							<div class="et-blog__btn">{include file="buttons/button.tpl" but_text=__("et_read_more") but_href=$href but_meta="ty-btn__primary" but_role="text"}</div>
						</div>
					</div>
				</div>
			{/foreach}
			</div>
		</div>
	</div>
</div>

{include file="common/scroller_init_with_quantity.tpl" prev_selector="#owl_prev_`$obj_prefix`" next_selector="#owl_next_`$obj_prefix`" et_outside_nav=true et_no_rewind=true}

{/if}