{*
    $total_product_reviews
    $config
    $curl
    $product_reviews_with_images
    $product_reviews_sorting
    $product_reviews_sorting_orders
    $product_reviews_search
    $product_reviews_avail_sorting
    $product_id
*}

{if $total_product_reviews}
    {$curl=$config.current_url|fn_query_remove:"sort_by":"with_images"}

    {* TODO *}
    {$product_reviews_with_images = ($_REQUEST.with_images === "1")}
    {$et_product_reviews_buyers_only = ($_REQUEST.only_buyers === "1")}
    {* /TODO *}

    <nav class="ty-product-review-reviews-navigation">

        {$curl=$config.current_url|fn_query_remove:"sort_by":"sort_order":"result_ids":"layout"}
        {include file="common/sorting.tpl"
            sorting=$product_reviews_sorting
            sorting_orders=$product_reviews_sorting_orders
            search=$product_reviews_search
            avail_sorting=$product_reviews_avail_sorting
            ajax_class="cm-ajax"
            pagination_id="pagination_contents_comments_`$product_id`"
        }

        <label class="ty-product-review-reviews-navigation__filter {if $product_reviews_with_images}ty-product-review-reviews-navigation__filter--active{/if} hidden-phone ">
            <a id="product_review_with_images_link"
                href="{$curl|fn_link_attach:"with_images={if $product_reviews_with_images}0{else}1{/if}&selected_section=product_reviews#pagination_contents_comments_{$product_id}"|fn_url}"
                class="ty-product-review-reviews-navigation__filter-link cm-ajax"
                data-ca-target-id="pagination_contents_comments_{$product_id}"
                rel="nofollow"
            >
                <i class="et-icon-reviews-image"></i>
                {__("product_reviews.with_photo")}
            </a>
        </label>

        {if $addons.et_extended_ratings.status=="A"}
            <label class="ty-product-review-reviews-navigation__filter hidden-phone {if $et_product_reviews_buyers_only}ty-product-review-reviews-navigation__filter--active{/if} ">
                <a id="et_product_reviews_buyers_only_link"
                    href="{$curl|fn_link_attach:"only_buyers={if $et_product_reviews_buyers_only}0{else}1{/if}&selected_section=product_reviews#pagination_contents_comments_{$product_id}"|fn_url}"
                    class="ty-product-review-reviews-navigation__filter-link cm-ajax"
                    data-ca-target-id="pagination_contents_comments_{$product_id}"
                    rel="nofollow"
                >
                    <i class="et-icon-selected-filters"></i>
                    {__("product_reviews.verified_purchase")}
                </a>
            </label>
        {/if}

        <a id="product_review_with_images_link_phone"
                href="{$curl|fn_link_attach:"with_images={if $product_reviews_with_images}0{else}1{/if}&selected_section=product_reviews#pagination_contents_comments_{$product_id}"|fn_url}"
                class="ty-product-review-reviews-navigation__filter-link cm-ajax et-product_review_with_images_link_phone hidden-desktop hidden-tablet {if $product_reviews_with_images}active{/if}"
                data-ca-target-id="pagination_contents_comments_{$product_id}"
                rel="nofollow"
            >
            <i class="et-icon-reviews-image"></i>
        </a>

        {if $addons.et_extended_ratings.status=="A"}
            <a id="et_product_reviews_buyers_only_link_phone"
                    href="{$curl|fn_link_attach:"only_buyers={if $et_product_reviews_buyers_only}0{else}1{/if}&selected_section=product_reviews#pagination_contents_comments_{$product_id}"|fn_url}"
                    class="ty-product-review-reviews-navigation__filter-link cm-ajax et-product_review_buyers_only_link_phone hidden-desktop hidden-tablet {if $et_product_reviews_buyers_only}active{/if}"
                    data-ca-target-id="pagination_contents_comments_{$product_id}"
                    rel="nofollow"
                >
                <i class="et-icon-selected-filters"></i>
            </a>
        {/if}

    </nav>
{/if}
