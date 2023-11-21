{if $page.page_type == $smarty.const.PAGE_TYPE_BLOG}

{if $subpages}
{capture name="mainbox_title"}{/capture}
<div class="et-blog">
	<div class="et-blog-scroll-to"></div>
	{include file="common/pagination.tpl"}
	<div class="et-blog-grid-wrapper et-columns-wrapper">
		{foreach from=$subpages item="subpage"}
			<div class="et-column4 et-blog-list">
				<div class="et-blog__item">
					<a href="{"pages.view?page_id=`$subpage.page_id`"|fn_url}">
						<div class="et-blog__img-block">
							{include file="common/image.tpl" obj_id=$subpage.page_id images=$subpage.main_pair image_width=377 image_height=212}
							<div class="et-blog__date">
								{$subpage.timestamp|date_format:"%d"}<br/>
								{$subpage.timestamp|date_format:"%b"}<br/>
								{$subpage.timestamp|date_format:"%Y"}
							</div>
						</div>
					</a>
					<div class="et-blog-item__details-wrapper">
						<a href="{"pages.view?page_id=`$subpage.page_id`"|fn_url}" class="et-blog__post-title-a">
							<span class="ty-blog__post-title">
								{$subpage.page}
							</span>
						</a>
						{if $subpage.spoiler}
							<div class="et-blog__description">
								<div class="ty-wysiwyg-content">
									{$subpage.description|strip_tags|truncate:140:"...":true nofilter}
								</div>
							</div>
						{/if}
						<div class="et-blog-item__details clearfix">
							<div class="et-blog__author"><i class="et-icon-blog-user2"></i> <span>{$subpage.author}</span></div>
							{hook name="blog:comments"}{/hook}
						</div>
					</div>
				</div>
			</div>
		{/foreach}
	</div>
	{include file="common/pagination.tpl" et_scroll_target=".et-blog-scroll-to"}
</div>
{/if}

{if $page.parent_id=="0"}
	{capture name="mainbox_title"}{/capture}
{elseif $page.description}
	{capture name="mainbox_title"}<span class="ty-blog__post-title" {live_edit name="page:page:{$page.page_id}"}>{$page.page}</span>{/capture}
{/if}
{capture name="mainbox_title"}{/capture}

{/if}