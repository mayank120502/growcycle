{if $content|trim}
    <div class="et-footer-info {if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">
        <h2 class="et-footer-info_title clearfix" id="sw_footer-general_{$block.block_id}">
            <span>{$title nofilter}</span>
        </h2>
        <div class="clearfix et-footer-info-content" id="footer-general_{$block.block_id}">{$content|default:"&nbsp;" nofilter}</div>
    </div>

{/if}