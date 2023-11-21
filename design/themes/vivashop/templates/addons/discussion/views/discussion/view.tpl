{assign var="discussion" value=$object_id|fn_get_discussion:$object_type:true:$smarty.request}
{if $object_type == "Addons\\Discussion\\DiscussionObjectTypes::ORDER"|enum}
	{$new_post_title = __("new_post")}
{else}
	{$new_post_title = __("write_review")}
{/if}

{if $discussion && $discussion.type != "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum}
	<div class="discussion-block" id="{if $container_id}{$container_id}{else}content_discussion{/if}">
		{if $wrap == true}
			{capture name="content"}
			{include file="common/subheader.tpl" title=$title}
		{/if}
		{if $subheader}
			<h4>{$subheader}</h4>
		{/if}
		{if $discussion.et_count && $discussion.type != "Addons\\Discussion\\DiscussionTypes::TYPE_COMMUNICATION"|enum}
			<div class="et-rating-graph__product-tabs">
				<div class="et-rating-graph_info-top ty-column3 et-col-left">
					<div class="et-rating-graph__product-tabs-avg-top">{__("et_average_star_rating")}:</div>
					<div>
						{if $discussion.average_rating>0}
							{$_et_no_rating=false}
						{else}
							{$_et_no_rating=true}
						{/if}
						{include file="addons/discussion/views/discussion/components/stars.tpl" stars=$discussion.average_rating|fn_get_discussion_rating et_no_rating=$_et_no_rating}
					</div>
					<div class="et-rating-graph__product-tabs-avg-bottom"><strong>{$discussion.average_rating}</strong>&nbsp;({$discussion.et_count_total} {__("reviews", [$discussion.et_count_total])} {__("total")})</div>
				</div>

				<div class="et-rating-graph_wrapper ty-column3 et-col-middle">
					<ul class="et-rating-graph__ul">
						{foreach from=$discussion.et_count item=item key=key name=name}
							{if $discussion.et_count_total}
								{$width=($item/$discussion.et_count_total)*100}
							{else}
								{$width=0}
							{/if}
							<li class="clearfix">
								<div class="et-rating-graph__title"><span>{$key}&nbsp;{__("et_star",[$key])}</span></div>
								<div class="et-rating-graph__bar-bkg">
									<b class="et-rating-graph__bar et-rating-graph__bar-{$key}" data-et-width="{$width}" data-et-count="{$item}" style="width:{$width}%;"></b>
								</div>
								{assign var="pagination" value=$discussion.search|fn_generate_pagination}
								{if !$config.tweaks.disable_dhtml || $force_ajax}
									{assign var="ajax_class" value="cm-ajax"}
								{/if}
								{assign var="c_url" value=$config.current_url|fn_query_remove:"page"}
								<div class="et-rating-graph__count"><span class="et-rating-graph__text">{$item}</span></div>
							</li>
				
						{/foreach}
					</ul>
				</div>

				{if 
					(
						$object_type=="Addons\\Discussion\\DiscussionObjectTypes::COMPANY"|enum || 
						$object_type=="Addons\\Discussion\\DiscussionObjectTypes::PRODUCT"|enum || 
						$object_type=="Addons\\Discussion\\DiscussionObjectTypes::TESTIMONIALS_AND_LAYOUT"|enum
					) && (
						$discussion.type !== "Addons\\Discussion\\DiscussionObjectTypes::TESTIMONIALS_AND_LAYOUT"|enum
					)
				}
					<div class="et-col-right ty-column3">
						<div class="et-title">
							{if $object_type=="Addons\\Discussion\\DiscussionObjectTypes::COMPANY"|enum}
								{$et_title=__("et_product_tabs_rating_vendor_right_title")}
							{elseif $object_type=="Addons\\Discussion\\DiscussionObjectTypes::TESTIMONIALS_AND_LAYOUT"|enum}
								{if "ULTIMATE"|fn_allowed_for}
									{$et_title=__("et_product_tabs_rating_testimonial_right_title_ult")}
								{else}
									{$et_title=__("et_product_tabs_rating_testimonial_right_title")}
								{/if}
							{elseif $object_type=="Addons\\Discussion\\DiscussionObjectTypes::PRODUCT"|enum}
								{$et_title=__("et_product_tabs_rating_right_title")}
							{/if}
							{$et_title}
						</div>
						<div class="et-text">
							{if $object_type=="Addons\\Discussion\\DiscussionObjectTypes::COMPANY"|enum}
								{$et_text=__("et_product_tabs_rating_vendor_right_text")}
							{elseif $object_type=="Addons\\Discussion\\DiscussionObjectTypes::TESTIMONIALS_AND_LAYOUT"|enum}
								{$et_text=__("et_product_tabs_rating_testimonial_right_text")}
							{else}
								{$et_text=__("et_product_tabs_rating_right_text")}
							{/if}
							{$et_text}
						</div>
						<div class="et-buttons clearfix">
								{if $discussion.type !== "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum}
									{include
									    file="addons/discussion/views/discussion/components/new_post_button.tpl"
									    name=$new_post_title
									    obj_id=$object_id
									    object_type=$discussion.object_type
									    locate_to_review_tab=$locate_to_review_tab
									}
								{/if}
						</div>
					</div>
				{/if}


				<div class="et-filter-scroll-to"></div>
				<div class="et-filter">
					<div class="et-filter-title">
						{__("et_show_reviews_with")}:
					</div>

					<div class="et-filter-options-wrapper">

						<div class="et-filter-options">
							{foreach from=$discussion.et_count item=item key=key}
								<div class="et-filter-option">
									{if $item>0}
										<a href="{"`$c_url`&page=1&selected_section=discussion&rating_value=`$key`"|fn_url}" class="{$ajax_class} et-star-link et-star-link-{$key} {if $smarty.request.rating_value==$key}active{/if}" data-ca-target-id="pagination_contents_comments_{$object_id}">
									{else}
										<span class="et-star-link inactive">
									{/if}
										{$stars.full=$key}
										{$stars.empty=5-$key}

										<span>{$key}&nbsp;{__("et_star",[$key])}</span>
										{include file="addons/discussion/views/discussion/components/stars.tpl" stars=$stars}
										<span class="et-rating-count">({$item}<span class="hidden-phone"> {__("reviews", [$discussion.item])}</span>)</span>
									{if $item>0}
										</a>
									{else}
										</span>
									{/if}
								</div>
							{/foreach}
						</div>

						<div class="et-filter-option-reset">
							<a {if $discussion.posts}href="{"`$c_url`&page=1&selected_section=discussion"|fn_url|fn_query_remove:"rating_value"}"{/if} class="{$ajax_class} ty-btn__tertiary ty-btn {if !$discussion.posts}disabled{/if}" data-ca-target-id="pagination_contents_comments_{$object_id}" onclick="Tygh.$('.et-star-link.active').removeClass('active');">
								<span>{__("et_show_all_reviews")}</span>
							</a>
						</div>
					</div>
				</div>
			</div>
		{/if}

		<div id="posts_list_{$object_id}" class="clearfix">
			{if $discussion.posts}
				{include file="common/pagination.tpl" id="pagination_contents_comments_`$object_id`" extra_url="&selected_section=discussion" et_scroll_target="#et_product_tabs" et_skip_history=true search=$discussion.search}
				{foreach from=$discussion.posts item=post}
					<div class="et-discussion-post__content clearfix">
						{hook name="discussion:items_list_row"}
							<div class="et-discussion-details ty-float-left">
								<div class="et-discussion-post__author">{$post.name}</div>
								{if $discussion.type == "Addons\\Discussion\\DiscussionTypes::TYPE_RATING"|enum || $discussion.type == "Addons\\Discussion\\DiscussionTypes::TYPE_COMMUNICATION_AND_RATING"|enum && $post.rating_value > 0}
									<div class="ty-discussion-post__rating">
										{include file="addons/discussion/views/discussion/components/stars.tpl" stars=$post.rating_value|fn_get_discussion_rating link=false}
									</div>
								{/if}
								<div class="et-discussion-post__date">
									{$post.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}
								</div>
							</div>
							<div class="et-discussion-post {cycle values=", ty-discussion-post_even"}" id="post_{$post.post_id}">
								{if $discussion.type == "Addons\\Discussion\\DiscussionTypes::TYPE_COMMUNICATION"|enum || $discussion.type == "Addons\\Discussion\\DiscussionTypes::TYPE_COMMUNICATION_AND_RATING"|enum}
									<div class="ty-discussion-post__message">{$post.message|escape|nl2br nofilter}</div>
								{/if}
							</div>
						{/hook}
					</div>
				{/foreach}
				{include file="common/pagination.tpl" id="pagination_contents_comments_`$object_id`" extra_url="&selected_section=discussion" et_scroll_target=".et-filter-scroll-to" et_skip_history=true search=$discussion.search}
			{else}
				<p class="ty-no-items">{__("no_posts_found")}</p>
			{/if}
		<!--posts_list_{$object_id}--></div>
		
		{if $discussion.type !== "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum}
			<div class="margin-top">
				{include
				    file="addons/discussion/views/discussion/components/new_post_button.tpl"
				    name=$new_post_title
				    obj_id=$object_id
				    object_type=$discussion.object_type
				    locate_to_review_tab=$locate_to_review_tab
				}
			</div>
		{/if}

		{if $wrap == true}
			{/capture}
			{$smarty.capture.content nofilter}
		{else}
			{capture name="mainbox_title"}{$title}{/capture}
		{/if}
	</div>
{/if}