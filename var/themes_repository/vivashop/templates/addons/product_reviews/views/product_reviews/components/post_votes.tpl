{*
    $product_review_id
    $product_review
    $config
*}

{if $product_review}
    <div class="ty-product-review-post-votes" id="product_review-post_votes_{$product_review_id}">
        {include
            file="buttons/button.tpl"
            but_id=$product_review_id
            but_href="product_reviews.vote.up?product_review_id=`$product_review_id`&return_url=`$config.current_url|escape:url`"
            but_text=$product_review.helpfulness.vote_up
            but_title=__("product_reviews.vote_up")
            but_role="et_review_thumbs"
            but_target_id="product_review-post_votes_`$product_review_id`"
            but_meta="cm-ajax et-review-thumbs-btn cm-post cm-ajax-full-render ty-product-review-post-votes__up"
            but_icon="et-icon-review-thumbs-up"
            but_rel="nofollow"
        }
        {include
            file="buttons/button.tpl"
            but_id=$product_review_id
            but_href="product_reviews.vote.down?product_review_id=`$product_review_id`&return_url=`$config.current_url|escape:url`"
            but_text=$product_review.helpfulness.vote_down
            but_title=__("product_reviews.vote_down")
            but_role="et_review_thumbs"
            but_target_id="product_review-post_votes_`$product_review_id`"
            but_meta="cm-ajax et-review-thumbs-btn cm-post cm-ajax-full-render ty-product-review-post-votes__down"
            but_icon="et-icon-review-thumbs-down"
            but_rel="nofollow"
        }
    <!--product_review-post_votes_{$product_review_id}--></div>
{/if}
