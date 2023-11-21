{if $content|trim}
	<div class="et_full_width_block_wrapper ty-mainbox-container clearfix{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $details_page} details-page{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">
		<div class="ty-mainbox-body et_grid_width_content">
			<h1>{$page.page}</h1>
		</div>
	</div>
{/if}

