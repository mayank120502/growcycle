{if $content|trim}
  <div class="et_full_width_block_wrapper ty-mainbox-container clearfix{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $details_page} details-page{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if} et-home-testimonials lazy" id="et-testimonials-{$block.block_id}">
    {if $title || $smarty.capture.title|trim}
      <div class="et_full_width_title">
        <div class="ty-mainbox-title">
          {hook name="wrapper:mainbox_general_title"}
          {if $smarty.capture.title|trim}
            {$smarty.capture.title nofilter}
          {else}
            {$title nofilter}
          {/if}
          {/hook}
        </div>
      </div>
    {/if}
    <div class="ty-mainbox-body et_grid_width_content">{$content nofilter}</div>
  </div>
{/if}