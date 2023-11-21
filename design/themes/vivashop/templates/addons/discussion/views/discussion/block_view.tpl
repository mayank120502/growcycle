{$discussion = $object_id|fn_get_discussion:$object_type:true:$smarty.request}
{assign var="et_prefix" value="`$block.block_id`000"}

{if $discussion && $discussion.type != "D"}
  {include file="common/subheader.tpl" title=$title}

  <div id="posts_list_{$object_id}" class="et-testimonials-scroller" >
  {if $discussion.posts}
    <div class="et-scroller">
      <div class="owl-theme ty-owl-controls" id="owl_outside_nav_discussion">
        <div class="owl-controls clickable owl-controls-outside" >
          {if !$obj_prefix}
            {$obj_prefix=$et_prefix}
          {/if}
          <div class="owl-buttons">
              <div id="owl_prev_{$obj_prefix}" class="owl-prev">{strip}
                {if $language_direction == 'rtl'}
                  <i class="et-icon-arrow-right"></i>
                {else}
                  <i class="et-icon-arrow-left"></i>
                {/if}
              {/strip}</div>
              <div id="owl_next_{$obj_prefix}" class="owl-next">{strip}
                {if $language_direction == 'rtl'}
                  <i class="et-icon-arrow-left"></i>
                {else}
                  <i class="et-icon-arrow-right"></i>
                {/if}
              {/strip}</div>
          </div>
        </div>
      </div>

      <div class="ty-mb-l">
        <div class="ty-scroller-discussion-list">
          <div id="scroll_list_discussion" class="owl-carousel ty-scroller-list">
            {foreach from=$discussion.posts item=post}
              <div class="ty-discussion-post__content ty-scroller-discussion-list__item">
                <div class="et-testimonial-icon">
                  <i class="et-icon-quote"></i>
                </div>

                <a href="{"discussion.view?thread_id=`$discussion.thread_id`&post_id=`$post.post_id`"|fn_url}#post_{$post.post_id}">
                  <div class="ty-discussion-post {cycle values=", ty-discussion-post_even"}" id="post_{$post.post_id}">

                    {if $discussion.type == "C" || $discussion.type == "B"}
                    <div class="ty-discussion-post__message">{$post.message|truncate:100|nl2br nofilter}</div>
                    {/if}
                  </div>
                </a>
                <div class="clearfix et-testimonial-scroller-author-wrapper">
                  <span class="ty-discussion-post__author">{$post.name}</span>
                    {if $discussion.type == "R" || $discussion.type == "B" && $post.rating_value > 0}
                      <div class="clearfix ty-discussion-post__rating">
                        {include file="addons/discussion/views/discussion/components/stars.tpl" stars=$post.rating_value|fn_get_discussion_rating}
                      </div>
                    {/if}
                </div>
              </div>
            {/foreach}
          </div>
        </div>
      </div>
    </div>
  {else}
    <p class="ty-no-items">{__("no_data")}</p>
  {/if}
  <!--posts_list_{$object_id}--></div>

  {if $object_type == "P"}
    {$new_post_title = __("write_review")}
  {else}
    {$new_post_title = __("new_post")}
  {/if}
  {$new_post_t}

  {if $discussion.type !== "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum}
    {include
        file="addons/discussion/views/discussion/components/new_post_button.tpl"
        name=__("write_review")
        obj_id=$object_id
        object_type=$discussion.object_type
    }
  {/if}

  {$block = ["block_id" => "discussion", "properties" => ["item_quantity" => 2, "scroll_per_page" => "Y", "not_scroll_automatically" => "Y", "outside_navigation" => true]]}
  {include file="common/scroller_init.tpl" block=$block prev_selector="#owl_prev_`$et_prefix`" next_selector="#owl_next_`$et_prefix`" et_no_rewind=true}

{/if}