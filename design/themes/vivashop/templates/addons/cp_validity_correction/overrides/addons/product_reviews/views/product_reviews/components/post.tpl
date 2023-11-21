{*
    $product_review
*}
{if $product_review}
    {$date_machine_format = "%Y-%m-%dT%H:%M:%S"}
    <div class="ty-product-review-post">
        <div class="et-discussion-post__content clearfix">
            <div class="et-discussion-details ty-float-left">
                <div>
                    <div class="et-discussion-post__author">
                        {if $product_review.user_data.name}
                            {$product_review.user_data.name}
                        {else}
                            {__("anonymous")}
                        {/if}
                    </div>
                    <div class="ty-discussion-post__rating">
                        {include file="addons/product_reviews/views/product_reviews/components/product_reviews_stars.tpl"
                            rating=$product_review.rating_value
                        }
                    </div>
                    
                    <div class="et-discussion-post__date hidden-phone hidden-tablet">
                        {if $product_review.product_review_timestamp}
                            {$datetime = $product_review.product_review_timestamp|date_format:$date_machine_format}
                            <time class="ty-product-review-post-customer__date1"{if $datetime} datetime="{$datetime}"{/if}>
                                {$product_review.product_review_timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}
                            </time>
                        {/if}
                    </div>
                    
                </div>

                <div>
                    <div class="et-discussion-post__date hidden-desktop">
                        {$datetime = $product_review.product_review_timestamp|date_format:$date_machine_format}
                        {if $product_review.product_review_timestamp}
                            <time class="ty-product-review-post-customer__date1"{if $datetime} datetime="{$datetime}"{/if}>
                                {$product_review.product_review_timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}
                            </time>
                        {/if}
                    </div>

                    {if $product_review.user_data.is_buyer === "YesNo::YES"|enum}
                        <div class="ty-product-review-post-customer__verified">
                            <i class="et-icon-selected-filters"></i>
                            {__("product_reviews.verified_purchase")}
                        </div>
                    {/if}

                    <div class="hidden-phone1">
                        {if $addons.product_reviews.review_ask_for_customer_location !== "none"}
                            {if $addons.product_reviews.review_ask_for_customer_location === "country"
                                && ($product_review.user_data.country_code || $product_review.user_data.country)
                            }
                                <div class="ty-product-review-post-customer__location">
                                    <div class="ty-product-review-post-customer__location-flag">
                                        <i class="ty-flag ty-flag-{$product_review.user_data.country_code|lower} ty-product-review-post-customer__location-flag-content"></i>
                                    </div>
                        
                                    <div class="ty-product-review-post-customer__location-text">
                                        <div class="ty-product-review-post-customer__location-country">{$product_review.user_data.country}</div>
                                    </div>
                                </div>
                            {elseif $addons.product_reviews.review_ask_for_customer_location === "city"}
                                <div class="ty-product-review-post-customer__location">
                                    <div class="ty-product-review-post-customer__location-text">
                                        <div class="ty-product-review-post-customer__location-city">{$product_review.user_data.city}</div>
                                    </div>
                                </div>
                            {/if}
                        {/if}
                    </div>
                </div>

            </div>

            <div class="et-discussion-post {cycle values=", ty-discussion-post_even"}" id="discussion_post_{$product_review.product_review_id}">

                {$product_review.product_options = $product.product_options}
                {if $product_review.product_options}
                    <div class="ty-product-review-post-header__product-options">
                        <i class="et-icon-review-info"></i>
                        <div class="et-product-review-option-title hidden-phone">{__("et_review_variant")}:</div>
                        <div class="et-product-review-options">{include file="common/options_info.tpl" product_options=$product_review.product_options no_block=true}</div>
                    </div>
                {/if}

                {include file="addons/product_reviews/views/product_reviews/components/post_message.tpl"
                    product_review=$product_review
                }

                <div class="et-product-review-footer">
                    {include file="addons/product_reviews/views/product_reviews/components/post_footer.tpl"
                        product_review=$product_review
                    }
                </div>

                <div class="et-product-review-reply">
                    {include file="addons/product_reviews/views/product_reviews/components/post_vendor_reply.tpl"
                        product_review=$product_review
                    }
                </div>
            </div>
        </div>
    </div>
{/if}
