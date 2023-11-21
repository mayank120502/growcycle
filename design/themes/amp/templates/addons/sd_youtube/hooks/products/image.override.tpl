{if $type == "product_image" && $image.detailed.image_path|strpos:"youtube"}
    <amp-youtube
        data-videoid="{$image.detailed_id}"
        layout="responsive"
        data-param-modestbranding="1"
        width="480"
        height="270">
    </amp-youtube>
{/if}
