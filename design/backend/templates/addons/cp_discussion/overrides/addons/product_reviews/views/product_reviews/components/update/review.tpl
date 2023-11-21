{*
    $product_review                 array                               Product review
    $available_message_types        array                               Available message types
    $MESSAGE_CHARACTERS_THRESHOLD   int                                 Message characters threshold
    $is_allowed_update_reply        bool                                Is allowed update reply
*}

{$MESSAGE_CHARACTERS_THRESHOLD = 400}

<section class="cs-product-reviews-update-review">
    <section>
        <header>

            {* Stars *}
            <div class="control-group">
                <label class="control-label">
                    {__("product_reviews.rating")}:
                </label>
                <div class="controls">
                    {include file="addons/product_reviews/views/product_reviews/components/rating/stars.tpl"
                        rating=$product_review.rating_value
                        size="xlarge"
                    }
                </div>
            </div>

            {* Review date *}
            <div class="control-group">
                <label class="control-label">
                    {__("product_reviews.date")}:
                </label>
                <div class="controls" id="cp_time_update">
                    <p>
                        {include file="addons/cp_discussion/common/calendar.tpl"
                            date_id="elm_date_holder_`$post.post_id`"
                            date_name="product_review_data[date]"
                            date_val=$product_review.product_review_timestamp|default:$smarty.const.TIME
                            start_year=$settings.Company.company_start_year
                            date_meta="post-date"
                            show_time=true
                            time_name="product_review_data[time]"
                            meta_class="review-date"
                            type_time_name="product_review_data[time_type]" 
                            type_time_val=$product_review.time_type
                        }
                    </p>
                <!--cp_time_update--></div>
                <div class="controls">
                    <a href="{"product_reviews.generate_time"|fn_url}" class="cm-ajax btn" data-ca-target-id="cp_time_update">{__("cp_discussion.use_rnd_time")}</a>
                </div>
            </div>

            {* Helpfulness *}
            <div class="control-group">
                <label class="control-label">
                    {__("product_reviews.helpfulness")}:
                </label>
                <div class="controls">
                    <p>
                        {include file="addons/product_reviews/views/product_reviews/components/reviews/helpfulness.tpl"
                            helpfulness=$product_review.helpfulness
                        }
                    </p>
                </div>
            </div>

        </header>

        {* Message *}
        {foreach $available_message_types as $message_type}

            <div class="control-group">
                <label for="product_review_data_{$message_type}" class="control-label">
                    {__("product_reviews.$message_type")}:
                </label>
                <div class="controls">
                    <textarea name="product_review_data[{$message_type}]"
                        id="product_review_data_{$message_type}"
                        class="input-full cs-textarea-adaptive cs-textarea-adaptive--with-sidebar"
                        style="--text-length: {$product_review.message.$message_type|count_characters:true};"
                    >{$product_review.message.$message_type}</textarea>
                </div>
            </div>
        {/foreach}

        {* Review images *}
        {if $product_review.images}
            <div class="control-group">
                <label class="control-label">
                    {__("product_reviews.customer_photos")}:
                </label>
                <div class="controls">
                    {include file="addons/product_reviews/views/product_reviews/components/reviews/review_images.tpl"
                        product_review_images=$product_review.images
                        show_delete=$is_allowed_to_update_product_reviews && $smarty.const.ACCOUNT_TYPE === "admin"
                        size="large"
                    }
                </div>
            </div>
        {/if}

    </section>

    {* Vendor reply *}
    {include file="addons/product_reviews/views/product_reviews/components/update/post_vendor_reply.tpl"
        product_review_reply=$product_review.reply
        is_allowed_update_reply=$is_allowed_update_reply
    }

</section>
