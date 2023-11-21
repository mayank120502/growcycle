{if $page.description && $page.page_type == $smarty.const.PAGE_TYPE_BLOG}
	<div class="clearfix et-blog-post-wrapper">
		{if $page.parent_id!="0"}
			{if $page.main_pair}
				<div class="et-blog__img-block">
					{include file="common/image.tpl" obj_id=$page.page_id images=$page.main_pair }
					<div class="et-blog-post">
						<h1 class="et-blog__post-title">
							<span {live_edit name="page:page:{$page.page_id}"}>{$page.page}</span>
						</h1>
					</div>
				</div>
				<div class="et-blog-post">
					<div class="et-blog-post__details">
						<div class="et-blog__author"><i class="et-icon-blog-user2"></i> <span>{$page.author}</span></div>
						<div class="et-blog__date"><i class="et-icon-blog-calendar"></i> <span>{$page.timestamp|date_format:"`$settings.Appearance.date_format`"}</span></div>
						{hook name="blog:comments"}{/hook}
					</div>
				</div>
			{else}
				<div class="et-blog-post">
					<h1 class="et-blog__post-title">
						<span {live_edit name="page:page:{$page.page_id}"}>{$page.page}</span>
					</h1>
					<div class="et-blog-post__details">
						<div class="et-blog__author"><i class="et-icon-blog-user2"></i> <span>{$page.author}</span></div>
						<div class="et-blog__date"><i class="et-icon-blog-calendar"></i> <span>{$page.timestamp|date_format:"`$settings.Appearance.date_format`"}</span></div>
						{hook name="blog:comments"}{/hook}
					</div>
				</div>
			{/if}
		{else}
			<h1 class="et-block-title-wrapper ty-center">
				<span {live_edit name="page:page:{$page.page_id}"} class="et-block-title-border">{$page.page}</span>
			</h1>
		{/if}
	</div>
{/if}
