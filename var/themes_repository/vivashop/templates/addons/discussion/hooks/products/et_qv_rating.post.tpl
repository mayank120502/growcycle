{if ($product.discussion_type && $product.discussion_type != 'D') || ($addons.product_reviews.status === "ObjectStatuses::ACTIVE"|enum)}
  <div class="ty-discussion__rating-wrapper" id="average_rating_product">{strip}
    <div class="et-rating-graph__trigger">

      {if $product.average_rating>0}
          {$_et_no_rating=false}
      {else}
          {$_et_no_rating=true}
      {/if}

      {if $_et_no_rating}
        {$et_total_reviews=0}
        {$et_rating="0.00"}
        {$et_rating_stats=[
            5=>[count=>0],
            4=>[count=>0],
            3=>[count=>0],
            2=>[count=>0],
            1=>[count=>0]
          ]
        }
      {else}
        {$et_total_reviews=$product.product_reviews_rating_stats.total}
        {$et_rating=$product.average_rating}
        {$et_rating_stats=$product.product_reviews_rating_stats.ratings}
      {/if}

      {if $addons.et_vivashop_mv_functionality.et_product_link=="vendor"}
        {if $product.company_id && $product.company_has_store}
          {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
          {if !$smarty.request.company_id}
            {$et_add_blank='target="_blank"'}
          {else}
            {$et_add_blank=''}
          {/if}
        {else}
          {$product_detail_view_url="products.view&product_id=`$product.product_id`"}
          {$et_add_blank=''}
        {/if}
      {else}
        {$et_add_blank=''}
        {if $use_vendor_url}
            {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
        {else}
          {$product_detail_view_url="products.view&product_id=`$product.product_id`"}
        {/if}
      {/if}
      {$product_detail_view_url= "`$product_detail_view_url`&selected_section=discussion#product_reviews_offset"}

      {include file="addons/product_reviews/views/product_reviews/components/product_reviews_stars.tpl"
          rating=$et_rating
          link=true
          scroll_to_elm="product_reviews_offset"
          et_on_vs=true 
          et_no_rating=$_et_no_rating
      }

      {if $et_rating>=0}
        <div class="et-rating-graph_wrapper">
          <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>
            <span class="et-rating-graph_average">{$et_rating}</span>
            {if $et_total_reviews>=0}
              <i class="et-icon-menu-arrow hidden-phone"></i>
            {/if}
          </a>
          {if $et_total_reviews>=0}
            <div class="et-rating-graph hidden">
              <div class="et-rating-graph_popup">
                <span class="et-tooltip-arrow"></span>
                <div class="et-rating-graph_info-top">
                  {__("et_exteded_out_of",["[average_rating]" => $et_rating])}
                </div>

                <ul class="et-rating-graph__ul">
                {foreach from=$et_rating_stats item=item key=key name=name}

                  {if $et_total_reviews}
                    {$width=($item.count/$et_total_reviews)*100}
                  {else}
                    {$width=0}
                  {/if}
                  <li class="clearfix">
                    <div class="et-rating-graph__title"><span>{$key}&nbsp;{__("et_star",[$key])}</span></div>
                    <div class="et-rating-graph__bar-bkg">
                      <b class="et-rating-graph__bar" data-et-width="{$width}" style="width:{$width}%;"></b>
                    </div>
                    <div class="et-rating-graph__count"><span>{$item.count}</span></div>
                  </li>
                {/foreach}
                </ul>
                {if $et_total_reviews}
                  <div class="et-rating-graph_info-bottom">
                    <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>{__("et_read_all")} {$et_total_reviews} {__("reviews", [$et_total_reviews])}</a>
                  </div>
                {/if}
              </div>
            </div>
          {/if}
        </div>
      {/if}
    </div>
    {if $et_total_reviews>=0}
      <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter} class="ty-discussion__review-a">({$et_total_reviews}<span class="hidden-phone"> {__("reviews", [$et_total_reviews])}</span>)</a>
    {/if}

  {/strip}<!--average_rating_product--></div>
{/if}
