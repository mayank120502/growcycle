{$average_rating = $product.discussion.average_rating}
{if $product.discussion_type && $product.discussion_type != 'D' && $average_rating > 0}
    <div class="col-12 md-col-6 self-start pb1">
        <div class="inline-block align-top">
        {include file="addons/discussion/views/discussion/components/stars.tpl" stars=$average_rating|fn_get_discussion_rating}
        </div>
        {if $product.discussion.posts}
            <div id="reviews_link" class="inline-block align-middle">
                <a on="tap:reviews_list.scrollTo(duration=200)" class="ml2 amp-link">
                    {$product.discussion.search.total_items} {__("reviews", [$product.discussion.search.total_items])}
                </a>
            </div>
        {/if}
    </div>
{/if}