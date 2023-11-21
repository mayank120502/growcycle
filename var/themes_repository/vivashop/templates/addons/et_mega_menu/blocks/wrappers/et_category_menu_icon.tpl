{if $content|trim}
    {assign var="dropdown_id" value=$block.snapping_id}
    <div class="ty-dropdown-box et-category-menu et-category-menu-icon {if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">
        <div class="ty-dropdown-box__title cm-combination {if $header_class}{$header_class}{/if} open">
            {hook name="wrapper:onclick_dropdown_title"}
            {if $smarty.capture.title|trim}
                <i class="et-icon-menu"></i>
            {else}
                <a><i class="et-icon-menu"></i></a>
            {/if}
            {/hook}
            <span class="et-tooltip-arrow"></span>
        </div>
        <div class="cm-popup-box ty-dropdown-box__content">
            {$content|default:"&nbsp;" nofilter}
        </div>
    </div>
{/if}