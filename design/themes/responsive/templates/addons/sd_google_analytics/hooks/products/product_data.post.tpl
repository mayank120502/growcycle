{$has_impression = fn_sd_ga_has_impression($product)}
{if $has_impression}
    {fn_sd_ga_collect_data("Addons\\SdGoogleAnalytics\\Events::ADD_IMPRESSION"|enum, $product, $product.category_name, $block, $smarty.request)}
    {fn_sd_ga_collect_data("Addons\\SdGoogleAnalytics\\Events::ADD_PRODUCT_CLICK"|enum, $product, $product.category_name, $block, $smarty.request)}
{/if}
{if $product.promotions}
    {fn_sd_ga_save_array_catalog_promotions($product)}
{/if}
