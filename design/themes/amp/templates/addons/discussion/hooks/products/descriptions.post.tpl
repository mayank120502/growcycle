{if $product.discussion_type && $product.discussion_type != 'D' && $product.discussion.posts}
    <div id="reviews_list" class="pt3 md-pt4 md-pb4">
        <h2 class="h5 md-h4 mb2">{__("discussion_title_product")}</h2>
        {foreach $product.discussion.posts as $review}
            <section class="mb3">
                <h3 class="h7 mb1">{$review.name}</h3>
                {include file="addons/discussion/views/discussion/components/stars.tpl" stars=$review.rating_value|fn_get_discussion_rating}
                <p class="mt1">{$review.message}</p>
            </section>
        {/foreach}
    </div>
{/if}