{if $product.youtube_videos}
    {foreach $product.youtube_videos as $youtube}
        <div class="mt1 mb1">
            <amp-youtube
                data-videoid="{$youtube.youtube_link}"
                credentials="omit"
                data-param-controls=2
                layout="responsive"
                width="480"
                height="270">
            </amp-youtube>
        </div>
    {/foreach}
{/if}