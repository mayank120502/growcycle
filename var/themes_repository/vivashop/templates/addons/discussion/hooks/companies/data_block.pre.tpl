{if $show_rating && in_array($addons.discussion.company_discussion_type, ['B', 'R'])}
  {if $company.average_rating}
    {$average_rating = $company.average_rating}
  {elseif $company.discussion.average_rating}
    {$average_rating = $company.discussion.average_rating}
  {/if}

  {if $company.company_id}
    {$company_id=$company.company_id}
  {else if $product.company_id}
    {$company_id=$product.company_id}
  {/if}

  {$x=fn_get_discussion($company_id, 'M', false)}
  {$company.thread_id=$x.thread_id}
  {if empty($company.et_count)&& !empty($x.et_count)}
    {$company.et_count=$x.et_count}
    {$company.et_count_total=$x.et_count_total}
  {/if}

  {if $show_empty_rating && !$average_rating}
    {$average_rating="0.00"}
  {/if}
  
  {$et_href="companies.discussion&thread_id=`$company.thread_id`"|fn_url}

  {if $average_rating || $show_empty_rating}
    {if $average_rating>0}
      {$_et_no_rating=false}
    {else}
      {$_et_no_rating=true}
    {/if}

    {include file="addons/discussion/views/discussion/components/stars.tpl"
    stars=$average_rating|fn_get_discussion_rating 
    link=$et_href et_no_rating=$_et_no_rating 
    link_target="url"}

    <div class="et-rating-graph_wrapper">
      <a href="{$et_href}" {if !$et_on_vs}target="_blank"{/if}><span class="et-rating-graph_average">{$average_rating}</span></a>


      {if $company.et_count && !$et_featured_vendor_block}
        <i class="et-icon-menu-arrow hidden-phone"></i>
        <div class="et-rating-graph hidden">
          <div class="et-rating-graph_popup">
            <span class="et-tooltip-arrow"></span>
            <div class="et-rating-graph_info-top">
              {__("et_exteded_out_of",["[average_rating]" => $average_rating])}
            </div>
            <ul class="et-rating-graph__ul">
            {foreach from=$company.et_count item=item key=key name=name}
              {if $company.search.total_items}
                {$width=($item/$company.search.total_items)*100}
              {elseif $company.et_count_total}
                {$width=($item/$company.et_count_total)*100}
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
            {$total=false}
            {if $company.search.total_items}
              {$total=$company.search.total_items}
            {elseif $company.et_count_total}
              {$total=$company.et_count_total}
            {/if}

            {if $total}
              <div class="et-rating-graph_info-bottom">
                <a href="{$et_href}" class="clearfix" {if !$et_on_vs}target="_blank"{/if}>{__("et_read_all")} {$total} {__("reviews", [$total])}</a>
              </div>
            {/if}
          </div>
        </div>
      {/if}
    </div>
    {/strip}
  {else}
    {strip}
      {include file="addons/discussion/views/discussion/components/stars.tpl"
        stars=0|fn_get_discussion_rating 
        link=$et_href et_on_vs=$et_on_vs
link_target="url"
}
      <a href="{$et_href}" class="ty-discussion__review-quantity" {if !$et_on_vs}target="_blank"{/if}>(0)</a>
    {/strip}
  {/if}
  {if ($company.discussion.posts_count && $show_posts_count|default:true) || $show_empty_rating}
    {if $show_links}<a href="{$et_href}" class="ty-discussion__review-quantity" {if !$et_on_vs}target="_blank"{/if}>{else}<span>{/if}({$company.discussion.posts_count} {__("reviews", [$company.discussion.posts_count])}){if $show_links}</a>{else}</span>{/if}
  {/if}
{/if}
