{if $subpage}
	{$page_id=$subpage.page_id}
{elseif $page}
	{$page_id=$page.page_id}
{/if}
{assign var="discussion" value=$page_id|fn_get_discussion:"A":true:$smarty.request}
{if $discussion && $discussion.type != "D"}
<div class="et-blog-item__comments">{strip}
	<i class="et-icon-blog-comments3"></i> <span>{$discussion.posts|count}</span>
{strip}</div>
{/if}