{if $content|trim}
	<div class="{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if} et-banner-full-width">
		{if $content|trim}
			<div>{$content nofilter}</div>
		{/if}
	</div>
{/if}