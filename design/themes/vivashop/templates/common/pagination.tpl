{assign var="id" value=$id|default:"pagination_contents"}
{assign var="pagination" value=$search|fn_generate_pagination}
{if $smarty.capture.pagination_open != "Y"}
	<div class="ty-pagination-container cm-pagination-container" id="{$id}">

	{if $save_current_page}
	<input type="hidden" name="page" value="{$search.page|default:$smarty.request.page}" />
	{/if}

	{if $save_current_url}
	<input type="hidden" name="redirect_url" value="{$config.current_url}" />
	{/if}
{/if}

{if $pagination.total_pages > 1}
	{if $settings.Appearance.top_pagination == "Y" && $smarty.capture.pagination_open != "Y" || $smarty.capture.pagination_open == "Y"}
	{assign var="c_url" value=$config.current_url|fn_query_remove:"page"}

	{if !$config.tweaks.disable_dhtml || $force_ajax}
		{assign var="ajax_class" value="cm-ajax"}
	{/if}

	{if $smarty.capture.pagination_open == "Y"}
	<div class="ty-pagination__bottom">
	{/if}
	<div class="ty-pagination clearfix">
		<a data-ca-scroll="{if $et_scroll_target}{$et_scroll_target}{else}.cm-pagination-container{/if}" class="et-pagination__prev ty-pagination__item ty-pagination__btn {if $pagination.prev_page}ty-pagination__prev {if !$et_skip_history}cm-history{/if} {$ajax_class}{else} disabled{/if}" {if $pagination.prev_page}href="{"`$c_url`&page=`$pagination.prev_page`"|fn_url}" data-ca-page="{$pagination.prev_page}" data-ca-target-id="{$id}"{/if}>{if $language_direction == 'rtl'}<i class="et-icon-pag-right"></i>{else}<i class="et-icon-pag-left"></i>{/if}<span class="ty-pagination__text">{__("previous")}</span></a>

		<div class="ty-pagination__items">
		{foreach from=$pagination.navi_pages item="pg"}
			{if $pg != $pagination.current_page}
					<a data-ca-scroll="{if $et_scroll_target}{$et_scroll_target}{else}.cm-pagination-container{/if}" href="{"`$c_url`&page=`$pg``$extra_url`"|fn_url}" data-ca-page="{$pg}" class="{if !$et_skip_history}cm-history{/if} ty-pagination__item {$ajax_class}" data-ca-target-id="{$id}">{$pg}</a>
			{else}
					<span class="ty-pagination__selected">{$pg}</span>
			{/if}
		{/foreach}
		</div>

		<a data-ca-scroll="{if $et_scroll_target}{$et_scroll_target}{else}.cm-pagination-container{/if}" class="ty-pagination__item ty-pagination__btn et-pagination__next {if $pagination.next_page}ty-pagination__next {if !$et_skip_history}cm-history{/if} {$ajax_class}{else} disabled{/if} ty-pagination__right-arrow" {if $pagination.next_page}href="{"`$c_url`&page=`$pagination.next_page``$extra_url`"|fn_url}" data-ca-page="{$pagination.next_page}" data-ca-target-id="{$id}"{/if}><span class="ty-pagination__text">{__("next")}</span>{if $language_direction == 'rtl'}<i class="et-icon-pag-left"></i>{else}<i class="et-icon-pag-right"></i>{/if}</a>

	</div>
	{if $smarty.capture.pagination_open == "Y"}
	</div>
	{/if}
	{else}
	<div class="hidden"><a data-ca-scroll="{if $et_scroll_target}{$et_scroll_target}{else}.cm-pagination-container{/if}" href="" data-ca-page="{$pg}" data-ca-target-id="{$id}" class="hidden"></a></div>
	{/if}
{/if}

{if $smarty.capture.pagination_open == "Y"}
	<!--{$id}--></div>
	{capture name="pagination_open"}N{/capture}
{elseif $smarty.capture.pagination_open != "Y"}
	{capture name="pagination_open"}Y{/capture}
{/if}
