{hook name="products:main_info_title"}
    {if !$hide_title}
        {if $product.cp_st_h1 && $addons.cp_seo_templates.use_custom_h1 == "Y"}
            <h1 class="ty-product-block-title" {live_edit name="product:cp_st_h1:{$product.cp_st_h1}"}>{$product.cp_st_h1 nofilter}</h1>
        {else}
            <h1 class="ty-product-block-title" {live_edit name="product:product:{$product.product_id}"}>{$product.product nofilter}</h1>
        {/if}
    {/if}
{/hook}
