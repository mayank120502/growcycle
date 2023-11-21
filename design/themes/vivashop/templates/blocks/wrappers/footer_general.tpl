{if $content|trim}
    <div class="{$sidebox_wrapper|default:"ty-footer"}{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">
        <h2 class="ty-footer-general__header {if $header_class} {$header_class}{/if} cm-combination clearfix" id="sw_footer-general_{$block.block_id}_{$block.snapping_id}">
            {hook name="wrapper:footer_general_title"}
            {if $smarty.capture.title|trim}
                {$smarty.capture.title nofilter}
            {else}
                <span>{$title nofilter}</span>
            {/if}
            {/hook}
        <div class="et-responsive-arrow-wrapper">
            {include_ext file="common/icon.tpl"
            class="ty-icon-down-open ty-footer-menu__icon-open"
        }
        {include_ext file="common/icon.tpl"
            class="ty-icon-up-open ty-footer-menu__icon-hide"
        }
        </div>
        </h2>
        <div class="ty-footer-general__body clearfix" id="footer-general_{$block.block_id}_{$block.snapping_id}">{$content|default:"&nbsp;" nofilter}</div>
    </div>

{/if}