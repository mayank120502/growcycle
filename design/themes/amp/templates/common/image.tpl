{$width_large = min($width * 2, $image.detailed.image_x)}
{$width_large2 = min($width * 3, $image.detailed.image_x)}
{$width_small = floor($width / 2)}

{$image_medium = fn_image_to_display($image, $width, $height)}
{$image_small = fn_image_to_display($image, $width_small, $height / 2)}
{$image_large = fn_image_to_display($image, $width_large, $height * 2)}
{$image_large2 = fn_image_to_display($image, $width_large2, $height * 3)}

{hook name="products:image"}
    <amp-img
        alt="{$image_medium.alt}"
        src="{$image_medium.image_path}"
        role="{$role|default: "button"}"
        {if $class}class="{$class}"{/if}
        {if $noloading}noloading{/if}
        {if $layout != "fill"}
            width="{$width}"
            height="{$height}"
        {/if}
        layout="{$layout|default: "responsive"}"
        tabindex="{$tabindex|default:0}"
        {if $option}option="$option"{/if}
        sizes="{$sizes|default:'(max-width:52rem) calc(100vw - 2rem), 40vw'}"
        srcset="{$image_small.image_path} {$width_small}w,
                {$image_medium.image_path} {$width}w,
                {if $width_large > $width}
                    {$image_large.image_path} {$width_large}w,
                {/if}
                {if $width_large2 > $width_large}
                    {$image_large2.image_path} {$width_large2}w
                {/if}
                ">
        <div placeholder="" class="amp-loader"></div>
    </amp-img>
{/hook}
