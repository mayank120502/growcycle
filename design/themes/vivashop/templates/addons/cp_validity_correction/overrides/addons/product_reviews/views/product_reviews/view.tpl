{*
    $container_id
    $wrap
    $title
    $subheader
    $product_id
    $product_reviews
    $product_reviews_search
    $locate_to_product_review_tab
*}

<div class="ty-product-reviews-view" id="{if $container_id}{$container_id}{else}content_product_reviews{/if}">
    {if $wrap == true}
        {capture name="content"}
        {include file="common/subheader.tpl" title=$title}
    {/if}

    {if $subheader}
        <h4>{$subheader}</h4>
    {/if}


    <div class="et-rating-graph__product-tabs">
        <div class="et-rating-graph_info-top ty-column3 et-col-left">
            <div class="et-rating-graph__product-tabs-avg-top">{__("et_average_star_rating")}:</div>
            <div>
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
                  {$et_total_reviews=$product.product_reviews_count}
                  {$et_rating=$product.average_rating}
                  {$et_rating_stats=$product.product_reviews_rating_stats.ratings}
                {/if}

                {include file="addons/discussion/views/discussion/components/stars.tpl" stars=$et_rating|fn_get_discussion_rating et_no_rating=$_et_no_rating}
            </div>
            <div class="et-rating-graph__product-tabs-avg-bottom"><strong>{$et_rating}</strong>&nbsp;({$et_total_reviews} {__("reviews", [$et_total_reviews])} {__("total")})</div>
        </div>
        <div class="et-rating-graph_wrapper ty-column3 et-col-middle">
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
                            <b class="et-rating-graph__bar et-rating-graph__bar-{$key}" data-et-width="{$width}" data-et-count="{$item.count}" style="width:{$width}%;"></b>
                        </div>
                        {assign var="pagination" value=$discussion.search|fn_generate_pagination}
                        {if !$config.tweaks.disable_dhtml || $force_ajax}
                            {assign var="ajax_class" value="cm-ajax"}
                        {/if}
                        {assign var="c_url" value=$config.current_url|fn_query_remove:"page"}
                        <div class="et-rating-graph__count"><span class="et-rating-graph__text">{$item.count}</span></div>
                    </li>
        
                {/foreach}
            </ul>
        </div>

        <div class="et-col-right ty-column3">
            <div class="et-title">
                {__("et_product_tabs_rating_right_title")}
            </div>
            <div class="et-text">
                {__("et_product_tabs_rating_right_text")}
            </div>
            <div class="et-buttons clearfix">
                {include
                    file="addons/product_reviews/views/product_reviews/components/write_product_review_button.tpl"
                    name=__("product_reviews.write_review")
                    product_id=$product_id
                    locate_to_product_review_tab=$locate_to_product_review_tab
                    but_meta="ty-btn__primary"
                }
            </div>
        </div>

        <div class="et-filter-scroll-to"></div>
        <div class="et-filter">
            <div class="et-filter-title">
                {__("et_show_reviews_with")}:
            </div>

            <div class="et-filter-options-wrapper">

                <div class="et-filter-options">
                    {foreach from=$et_rating_stats item=item key=key}
                        <div class="et-filter-option">
                            {if $item.count>0}
                                <a href="{"`$c_url`&page=1&selected_section=discussion&rating_value=`$key`"|fn_url}" class="{$ajax_class} et-star-link et-star-link-{$key} {if $smarty.request.rating_value==$key}active{/if}" data-ca-target-id="pagination_contents_comments_{$product_id}">
                            {else}
                                <span class="et-star-link inactive">
                            {/if}
                                {$stars.full=$key}
                                {$stars.empty=5-$key}

                                <span>{$key}&nbsp;{__("et_star",[$key])}</span>
                                {include file="addons/discussion/views/discussion/components/stars.tpl" stars=$stars}
                                <span class="et-rating-count">({$item.count}<span class="hidden-phone"> {__("reviews", [$item.count])}</span>)</span>
                            {if $item.count>0}
                                </a>
                            {else}
                                </span>
                            {/if}
                        </div>
                    {/foreach}
                </div>

                <div class="et-filter-option-reset">
                    <a {if $product_reviews}href="{"`$c_url`&page=1&selected_section=discussion"|fn_url|fn_query_remove:"rating_value"}"{/if} class="{$ajax_class} ty-btn__tertiary ty-btn {if !$product_reviews}disabled{/if}" data-ca-target-id="pagination_contents_comments_{$product_id}" onclick="Tygh.$('.et-star-link.active').removeClass('active');">
                        <span>{__("et_show_all_reviews")}</span>
                    </a>
                </div>
            </div>
        </div>
    </div>


    <div class="ty-product-reviews-view__main">
        <div class="ty-product-reviews-view__main-content" id="product_reviews_list_{$product_id}">

            {if $product_reviews}
                {include file="common/pagination.tpl" id="pagination_contents_comments_`$product_id`" extra_url="&selected_section=product_reviews" search=$product_reviews_search}

                <div class="et-product-review-bar">
                    {include file="addons/product_reviews/views/product_reviews/components/product_reviews_navigation.tpl"
                        total_product_reviews=et_total_reviews
                    }
                </div>

                <div class="ty-product-review-view__posts">
                    {capture name="name" assign="et_posts" append="array_variable"}
                        {foreach $product_reviews as $product_review}
                            {if (isset($smarty.request.rating_value) && $product_review.rating_value==$smarty.request.rating_value) || !(isset($smarty.request.rating_value))}
                                {include file="addons/product_reviews/views/product_reviews/components/post.tpl"
                                    product_review=$product_review
                                }
                            {/if}
                        {/foreach}
                    {/capture}
                    {$et_posts nofilter}
                    {if !($et_posts|trim)}
                        <p class="ty-no-items">{__("product_reviews.no_reviews_found")}</p>
                    {/if}
                </div>

                {include file="common/pagination.tpl" id="pagination_contents_comments_`$product_id`" extra_url="&selected_section=product_reviews" search=$product_reviews_search}
            {else}
                <p class="ty-no-items">{__("product_reviews.no_reviews_found")}</p>
            {/if}
        <!--product_reviews_list_{$product_id}--></div>
        <div class="margin-top">
        {include
            file="addons/product_reviews/views/product_reviews/components/write_product_review_button.tpl"
            name=__("product_reviews.write_review")
            product_id=$product_id
            locate_to_product_review_tab=$locate_to_product_review_tab
            but_meta="ty-btn__primary"
        }
        </div>
    </div>

    {if $wrap == true}
        {/capture}
        {$smarty.capture.content nofilter}
    {else}
        {capture name="mainbox_title"}{$title}{/capture}
    {/if}
</div>

{script src="js/addons/product_reviews/fallback.js"}
{script src="js/addons/product_reviews/index.js"}
