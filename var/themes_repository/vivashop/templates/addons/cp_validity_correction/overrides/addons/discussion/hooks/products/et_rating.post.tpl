{if ($product.discussion_type && $product.discussion_type != 'D') || ($addons.product_reviews.status === "ObjectStatuses::ACTIVE"|enum)}
  <div class="ty-discussion__rating-wrapper" id="average_rating_product_{$obj_prefix}{$obj_id}">{strip}
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

      {include file="addons/product_reviews/views/product_reviews/components/product_reviews_stars.tpl"
          rating=$et_rating
          button=true
          scroll_to_elm="product_reviews_offset"
          et_on_vs=true 
          et_no_rating=$_et_no_rating
      }

      {if $et_rating>=0}
        <div class="et-rating-graph_wrapper">
          <a class="cm-external-click" data-ca-scroll="product_reviews_offset" data-ca-external-click-id="discussion">
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
                    <a class="cm-external-click" data-ca-scroll="product_reviews_offset" data-ca-external-click-id="discussion">{__("et_read_all")} {$et_total_reviews} {__("reviews", [$et_total_reviews])}</a>
                  </div>
                {/if}
              </div>
            </div>
          {/if}
        </div>
      {/if}
    </div>
    {if $et_total_reviews>=0}
      <a class="ty-discussion__review-a cm-external-click" data-ca-scroll="product_reviews_offset" data-ca-external-click-id="discussion">({$et_total_reviews}<span class="hidden-phone"> {__("reviews", [$et_total_reviews])}</span>)</a>
    {/if}
    {include
        file="addons/product_reviews/views/product_reviews/components/write_product_review_button.tpl"
        name=__("product_reviews.write_review")
        product_id=$product.product_id
        locate_to_product_review_tab=true
        but_meta="ty-btn__text ty-discussion__review-write"
    }
  {/strip}<!--average_rating_product_{$obj_prefix}{$obj_id}--></div>
{/if}
