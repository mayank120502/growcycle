{$ga_product_info = fn_sd_ga_get_array_data()}
<script class="cm-ajax-force">
    (function (_, $) {
        if (typeof _.sd_google_analytics === 'undefined') {
            _.sd_google_analytics = {};
            _.sd_google_analytics.productDataIndex = {};
        }
        {if $ga_product_info.add_product_click}
            {foreach $ga_product_info.add_product_click as $url => $product_obj}
                _.sd_google_analytics.productDataIndex['{$url nofilter}'] = {};
                _.sd_google_analytics.productDataIndex['{$url nofilter}']['product'] = {
                    '{$sd_ga_params_name_ga4}id': '{$product_obj.product.id|escape:javascript nofilter}',
                    '{$sd_ga_params_name_ga4}name': '{$product_obj.product.name|escape:javascript nofilter}',
                    '{$sd_ga_params_name_ga4}category': '{$product_obj.product.category|escape:javascript nofilter}',
                    '{$sd_ga_params_name_ga4}brand': '{$product_obj.product.brand|escape:javascript nofilter}',
                    position: '{$product_obj.product.position|escape:javascript nofilter}',
                    '{$sd_ga_params_name_ga4}variant': '{$product_obj.product.variant|escape:javascript nofilter}',
                    price:  '{$product_obj.product.price|escape:javascript nofilter}',
                    '{$sd_ga_params_name_ga4}list_name': '{$product_obj.list_name|escape:javascript nofilter}',
                    company_id: '{$product_obj.product.company_id|escape:javascript nofilter}',
                };
                _.sd_google_analytics.productDataIndex['{$url nofilter}']['list'] = '{$product_obj.list|escape:javascript nofilter}';
            {/foreach}
        {/if}
    }(Tygh, Tygh.$));
</script>
