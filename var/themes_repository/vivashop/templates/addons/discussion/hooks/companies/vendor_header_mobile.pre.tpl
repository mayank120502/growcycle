{capture name="et_vendor_rating"}
			{if in_array($addons.discussion.company_discussion_type, ['B', 'R'])}
				{if $et_vendor_review.average_rating}
					{$average_rating = $et_vendor_review.average_rating}
				{elseif $et_vendor_review.discussion.average_rating}
					{$average_rating = $et_vendor_review.discussion.average_rating}
				{/if}
				{if $average_rating >= 0}
					{if $average_rating>0}
					  {$_et_no_rating=false}
					{else}
					  {$_et_no_rating=true}
					{/if}
					<div class="et-rating-graph__trigger">
						{include file="addons/discussion/views/discussion/components/stars.tpl"
							stars=$average_rating|fn_get_discussion_rating
							link="companies.discussion&thread_id={$et_vendor_review.thread_id}" 
							et_on_vs="false"
							et_no_rating=$_et_no_rating
						}
						<div class="et-rating-graph_wrapper">
						  <a href="{"companies.discussion?thread_id=`$et_vendor_review.thread_id`"|fn_url}" ><span class="et-rating-graph_average">{$et_vendor_review.average_rating}</span></a>
						  
						  {if $et_vendor_review.et_count && !$et_featured_vendor_block}
						    <i class="et-icon-menu-arrow"></i>
						    <div class="et-rating-graph hidden">
						      <div class="et-rating-graph_popup">
						        <span class="et-tooltip-arrow"></span>
						        <div class="et-rating-graph_info-top">
						          {__("et_exteded_out_of",["[average_rating]" => $et_vendor_review.average_rating])}
						        </div>
						        <ul class="et-rating-graph__ul">
						        {foreach from=$et_vendor_review.et_count item=item key=key name=name}
						          {if $et_vendor_review.search.total_items}
						            {$width=($item/$et_vendor_review.search.total_items)*100}
						          {else}
						            {$width=0}
						          {/if}
						          <li class="clearfix">
						            <div class="et-rating-graph__title"><span>{$key}&nbsp;{__("et_star",[$key])}</span></div>
						            <div class="et-rating-graph__bar-bkg">
						              <b class="et-rating-graph__bar" data-et-width="{$width}" style="width:{$width}%;"></b>
						            </div>
						            <div class="et-rating-graph__count"><span>{$item}</span></div>
						          </li>

						        {/foreach}
						        </ul>
						        {if $et_vendor_review.search.total_items}
						          <div class="et-rating-graph_info-bottom">
						            <a href="{"companies.discussion?thread_id=`$et_vendor_review.thread_id`"|fn_url}" class="clearfix">{__("et_read_all")} {$et_vendor_review.search.total_items} {__("reviews", [$et_vendor_review.search.total_items])}</a>
						          </div>
						        {/if}
						      </div>
						    </div>
						  {/if}
						</div>
					</div>
					<a href="{"companies.discussion?thread_id=`$et_vendor_review.thread_id`"|fn_url}" class="ty-discussion__review-quantity">({$et_vendor_review.search.total_items} {__("reviews", [$et_vendor_review.search.total_items])})</a>
				{/if}

			{/if}
		{/capture}

		{if $smarty.capture.et_vendor_rating|trim}
			<div class="et-vendor-rating-mobile">
				<div class="et-vendor-header-top__info">
					<div class="et-vendor-info et-vendor-rating">
						{$smarty.capture.et_vendor_rating nofilter}
					</div>
				</div>
			</div>
		{/if}