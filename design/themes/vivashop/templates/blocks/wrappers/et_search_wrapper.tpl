{if $content|trim}
	<div class="ty-mainbox-simple-container clearfix{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if} et_mainbox_simple">
		<div class="et-search-body">{$content nofilter}</div>
	</div>
{/if}
