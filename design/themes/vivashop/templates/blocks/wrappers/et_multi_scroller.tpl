{if $content|trim}
    <div class="et-multi-scroller et-simple-scroller {* clearfix *}{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $details_page} details-page{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if} content-tab-{$block.grid_id}_{$block.block_id} {if !empty($block.et_first)}active{/if}" id="content_tab_{$block.grid_id}_{$block.block_id}">
        <div class="et-mainbox-body et-toggle-body clearfix" id="sidebox_{$block.grid_id}_{$block.block_id}">{$content nofilter}</div>
    <!--content_tab_{$grid.grid_id}_{$block.block_id}--></div>
{/if}