{** block-description:discussion_title_home_page **}
{assign var="discussion" value=0|fn_get_discussion:"E":true:$block.properties}

{if $discussion && $discussion.type != "D" && $discussion.posts}

{assign var="obj_prefix" value="`$block.block_id`000"}

{if $addons.et_vivashop_settings.status=="A"}

{$et_testimonials_bkg=$block.et_image_data.main_pair.detailed.image_path}
{$settings=$block.properties.et_settings}

<style>
#et-testimonials-{$block.block_id}{
	background: url({$et_testimonials_bkg}) top center fixed transparent;
}

{if $settings.overlay_type|default:"S"=="C" && isset($settings.use_bkg_overlay) && $settings.use_bkg_overlay=="Y"}
#et-testimonials-{$block.block_id}:before{
  {$bkg_overlay = implode(",",sscanf($settings.overlay, "#%02x%02x%02x"))}
  background: rgba({$bkg_overlay},{$settings.overlay_alpha/100});
}
{/if}

{if $settings.additional_colors_type|default:"S"=="C"}
#et-testimonials-{$block.block_id} .ty-mainbox-title{
  color: {$settings.title_color};
}

#et-testimonials-{$block.block_id} .ty-discussion-post__content{
  background: {$settings.box_color};
}
#et-testimonials-{$block.block_id} .ty-discussion-post__message,
#et-testimonials-{$block.block_id} .ty-discussion-post__author{
  color: {$settings.text_color};
}
#et-testimonials-{$block.block_id} .et-testimonial-icon{
  color: {$settings.icon_color};
  background: {$settings.icon_bkg};
}
{/if}

</style>

{/if}

<div class="et-scroller et-testimonials-scroller">
	{if $block.properties.outside_navigation == "Y"}
		<div class="owl-theme ty-owl-controls" id="owl_outside_nav_{$block.block_id}">
			<div class="owl-controls clickable owl-controls-outside" >
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
	{/if}

	<div class="ty-mb-l">
		<div class="ty-scroller-discussion-list">
			<div id="scroll_list_{$block.block_id}" class="owl-carousel ty-scroller-list">

			{foreach from=$discussion.posts item=post}
				<div class="ty-discussion-post__content ty-scroller-discussion-list__item">
					<div class="et-testimonial-icon">
						<i class="et-icon-quote"></i>
					</div>
					{hook name="discussion:items_list_row"}
					<a href="{"discussion.view?thread_id=`$discussion.thread_id`&post_id=`$post.post_id`"|fn_url}#post_{$post.post_id}">
						<div class="ty-discussion-post {cycle values=", ty-discussion-post_even"}" id="post_{$post.post_id}">

							{if $discussion.type == "C" || $discussion.type == "B"}
								<div class="ty-discussion-post__message">{$post.message|strip_tags|truncate:250 nofilter}</div>
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
					{/hook}
				</div>
			{/foreach}
			</div>
		</div>
	</div>
</div>
{include file="common/scroller_init_with_quantity.tpl" prev_selector="#owl_prev_`$obj_prefix`" next_selector="#owl_next_`$obj_prefix`" et_outside_nav=true et_no_rewind=true}

{/if}
