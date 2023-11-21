{** block-description:blog.recent_posts **}
{if $items}
<div class="et-blog-sidebar">
	<ul class="ty-blog-sidebox__list">
		{foreach from=$items item="page"}
			<li class="et-blog-sidebar__item clearfix">
				{$data=$page.page_id|fn_get_page_data}
				<div class="et-blog-sidebar__img ty-float-left">
					<a href="{"pages.view?page_id=`$page.page_id`"|fn_url}">
					{include file="common/image.tpl" 
						image_width="72" 
						image_height="49"
						obj_id=$data.page_id images=$data.main_pair}
					</a>
				</div>
				<div class="et-blog-sidebar__text">
					<a class="et-blog-sidebar__title" href="{"pages.view?page_id=`$page.page_id`"|fn_url}">{$page.page|truncate:50:"...":true}</a>
					{strip}
					<div class="blog_sidebar_recent clearfix">
						<div class="et-blog__date"><i class="et-icon-blog-calendar"></i> <span>{$page.timestamp|date_format:"`$settings.Appearance.date_format`"}</span></div>
						{hook name="blog:comments"}{/hook}
					</div>
					{/strip}
				</div>
			</li>
		{/foreach}
	</ul>
</div>
{/if}