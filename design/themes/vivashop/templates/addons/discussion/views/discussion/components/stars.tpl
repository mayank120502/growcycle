{$link_target=$link_target|default:"auto"}
{if !($link_target === "auto"
    && ($runtime.controller == "products" || $runtime.controller == "companies")
    && $runtime.mode === "view"
    && !$product.average_rating
    && !$vs_scroll_link)
}
    {$link_target = "url"}
{/if}

<span class="ty-nowrap ty-stars clearfix {if $et_no_rating}et-no-rating{/if}">{strip}
	{if $link}
		{if $et_review_link_scroll}
			<a class="cm-external-click clearfix" data-ca-scroll="discussion" data-ca-external-click-id="discussion">
		{else}
			<a href="{$link|fn_url}" class="clearfix" {if !$et_on_vs}target="_blank"{/if}>
		{/if}
	{/if}

	{section name="full_star" loop=$stars.full}
		{include_ext file="common/icon.tpl"
            class="ty-icon-star ty-stars__icon"
        }
	{/section}
	{if $stars.part}
		{include_ext file="common/icon.tpl"
            class="ty-icon-star-half ty-stars__icon"
        }
	{/if}
	{section name="full_star" loop=$stars.empty}
		{include_ext file="common/icon.tpl"
            class="ty-icon-star-empty ty-stars__icon"
        }
	{/section}
		{if $show_et_rating}
			{$x=fn_get_discussion($product.product_id, "P",true)}
			{if $x.posts}
				<span class="et_rating_total"><bdi>({$x.search.total_items})</bdi></span>
			{/if}
		{/if}
	{if $link}
		</a>
	{/if}
{/strip}</span>