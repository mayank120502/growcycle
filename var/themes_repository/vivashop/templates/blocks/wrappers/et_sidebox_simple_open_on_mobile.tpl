{if $content|trim && !$et_is_vendor_search}
	<div class="{$sidebox_wrapper|default:"ty-sidebox"}{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if} et-sidebox-simple">
		<h2 class="ty-sidebox__title 1cm-combination {if $header_class} {$header_class}{/if}">
			{hook name="wrapper:sidebox_general_title"}
			{if $smarty.capture.title|trim}
			<span class="hidden-phone">
				{$smarty.capture.title nofilter}
			</span>
			{else}
				<span class="ty-sidebox__title-wrapper hidden-phone">{$title nofilter}</span>
			{/if}
				{if $smarty.capture.title|trim}
					<span class="visible-phone">
						{$smarty.capture.title nofilter}
					</span>
				{else}
					<span class="ty-sidebox__title-wrapper visible-phone">{$title nofilter}</span>
				{/if}
			{/hook}
		</h2>
		<div >{$content|default:"&nbsp;" nofilter}</div>
	</div>
{/if}