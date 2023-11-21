{if $runtime.controller == "checkout" && $runtime.mode == "checkout"}
    {include file="addons/sd_google_analytics/common/new_checkout.tpl"}
{/if}

{$ga_product_info = fn_sd_ga_get_array_data()}

{if $ga_product_info}
    {if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
        {foreach $ga_product_info.add_impression as $ga_info}
            <input type="hidden" name="product_data[{$ga_info.id}][vendor_tracking_code]" value="{$vendor_tracking_codes[$ga_info.company_id]}" />
            {$company_ids[] = $ga_info.company_id}
        {/foreach}
        {$company_ids = array_unique($company_ids)}
    {/if}

    {if $smarty.request.dispatch == "products.search"}
        <script class="cm-ajax-force">
            (function(_, $) {
                $(document).ready(function() {
                    if (typeof(gtag) != 'undefined') {
                        {if $ga_product_info.add_impression}
                             gtag('event', 'view_search_results', {
                                'send_to': 'default',
                                'items': [
                                    {foreach $ga_product_info.add_impression as $ga_info}
                                        {
                                            '{$sd_ga_params_name_ga4}id': '{$ga_info.id|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}name': '{$ga_info.name|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}brand': '{$ga_info.brand|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}category': '{$ga_info.category|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}variant': '{$ga_info.variant|escape:javascript nofilter}',
                                            'price': '{$ga_info.price|escape:javascript nofilter}'
                                        },
                                    {/foreach}
                                ]
                            });
                            {if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
                                {foreach $company_ids as $company_id}
                                    gtag('event', 'view_search_results', {
                                        'send_to': '{$vendor_tracking_codes[$company_id]}',
                                        'items': [
                                            {foreach $ga_product_info.add_impression as $ga_info}
                                                {if $ga_info.company_id == $company_id}
                                                    {
                                                        '{$sd_ga_params_name_ga4}id': '{$ga_info.id|escape:javascript nofilter}',
                                                        '{$sd_ga_params_name_ga4}name': '{$ga_info.name|escape:javascript nofilter}',
                                                        '{$sd_ga_params_name_ga4}brand': '{$ga_info.brand|escape:javascript nofilter}',
                                                        '{$sd_ga_params_name_ga4}category': '{$ga_info.category|escape:javascript nofilter}',
                                                        '{$sd_ga_params_name_ga4}variant': '{$ga_info.variant|escape:javascript nofilter}',
                                                        'price': '{$ga_info.price|escape:javascript nofilter}'
                                                    },
                                                {/if}
                                            {/foreach}
                                        ]
                                    });
                                    gtag('event', 'page_view', {
                                        'send_to': '{$vendor_tracking_codes[$company_id]}'
                                    });
                                {/foreach}
                            {/if}
                        {/if}
                    }
                });
            }(Tygh, Tygh.$));
        </script>
    {/if}

    <script class="cm-ajax-force">
        (function(_, $) {
            $(document).ready(function() {
                if (typeof(gtag) != 'undefined') {
                    {if $ga_product_info.add_impression}
                         gtag('event', 'view_item_list', {
                            'send_to': 'default',
                            'items': [
                                {foreach $ga_product_info.add_impression as $ga_info}
                                    {
                                        '{$sd_ga_params_name_ga4}id': '{$ga_info.id|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}name': '{$ga_info.name|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}list_name': '{$ga_info.list|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}brand': '{$ga_info.brand|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}category': '{$ga_info.category|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}variant': '{$ga_info.variant|escape:javascript nofilter}',
                                        'list_position': '{$ga_info.position|escape:javascript nofilter}',
                                        'price': '{$ga_info.price|escape:javascript nofilter}'
                                    },
                                {/foreach}
                            ]
                        });
                        {if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
                            {foreach $company_ids as $company_id}
                                gtag('event', 'view_item_list', {
                                    'send_to': '{$vendor_tracking_codes[$company_id]}',
                                    'items': [
                                        {foreach $ga_product_info.add_impression as $ga_info}
                                            {if $ga_info.company_id == $company_id}
                                                {
                                                    '{$sd_ga_params_name_ga4}id': '{$ga_info.id|escape:javascript nofilter}',
                                                    '{$sd_ga_params_name_ga4}name': '{$ga_info.name|escape:javascript nofilter}',
                                                    '{$sd_ga_params_name_ga4}list_name': '{$ga_info.list|escape:javascript nofilter}',
                                                    '{$sd_ga_params_name_ga4}brand': '{$ga_info.brand|escape:javascript nofilter}',
                                                    '{$sd_ga_params_name_ga4}category': '{$ga_info.category|escape:javascript nofilter}',
                                                    '{$sd_ga_params_name_ga4}variant': '{$ga_info.variant|escape:javascript nofilter}',
                                                    'list_position': '{$ga_info.position|escape:javascript nofilter}',
                                                    'price': '{$ga_info.price|escape:javascript nofilter}'
                                                },
                                            {/if}
                                        {/foreach}
                                    ]
                                });
                                gtag('event', 'page_view', {
                                    'send_to': '{$vendor_tracking_codes[$company_id]}'
                                });
                            {/foreach}
                        {/if}
                    {/if}
                    {if $ga_product_info.add_product}
                        gtag('event', 'view_item', {
                            'send_to': 'default',
                            'content_type': 'product',
                            'items': [
                                {foreach $ga_product_info.add_product as $ga_info}
                                    {
                                        '{$sd_ga_params_name_ga4}id': '{$ga_info.id|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}name': '{$ga_info.name|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}brand': '{$ga_info.brand|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}category': '{$ga_info.category|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}variant': '{$ga_info.variant|escape:javascript nofilter}',
                                        'price': '{$ga_info.price|escape:javascript nofilter}',
                                    },
                                {/foreach}
                            ]
                        });
                        {if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
                            {$vendor_product = reset($ga_product_info.add_product)}
                            {if $vendor_tracking_codes[$vendor_product.company_id]}
                                gtag('event', 'view_item', {
                                    'send_to': '{$vendor_tracking_codes[$vendor_product.company_id]}',
                                    'content_type': 'product',
                                    'items': [
                                        {
                                            '{$sd_ga_params_name_ga4}id': '{$vendor_product.product_id|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}name': '{$vendor_product.name|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}brand': '{$vendor_product.brand|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}category': '{$vendor_product.category|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}variant': '{$vendor_product.variant|escape:javascript nofilter}',
                                            'price': '{$vendor_product.price|escape:javascript nofilter}',
                                        },
                                    ]
                                });
                                gtag('event', 'page_view', {
                                    'send_to': '{$vendor_tracking_codes[$vendor_product.company_id]}'
                                });
                            {/if}
                        {/if}
                    {/if}
                    {if $ga_product_info.add_promo}
                        {foreach $ga_product_info.add_promo as $ga_product_promotions}
                            gtag('event', 'view_promotion', {
                                'send_to': 'default',
                                'promotions': [
                                    {foreach $ga_product_promotions as $promotion}
                                        {
                                            '{$sd_ga_params_name_ga4}id': '{$promotion.id|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}name': '{$promotion.name|escape:javascript nofilter}'
                                        },
                                    {/foreach}
                                ]
                            });
                        {/foreach}
                        {if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
                            {foreach $company_ids as $company_id}
                                {foreach $ga_product_info.add_promo as $ga_product_promotions}
                                    gtag('event', 'view_promotion', {
                                        'send_to': '{$vendor_tracking_codes[$company_id]}',
                                        'promotions': [
                                            {foreach $ga_product_promotions as $promotion}
                                                {if $promotion.company_id == $company_id}
                                                    {
                                                        '{$sd_ga_params_name_ga4}id': '{$promotion.id|escape:javascript nofilter}',
                                                        '{$sd_ga_params_name_ga4}name': '{$promotion.name|escape:javascript nofilter}'
                                                    },
                                                {/if}
                                            {/foreach}
                                        ]
                                    });
                                {/foreach}
                            {/foreach}
                        {/if}
                    {/if}

                    {if $ga_product_info.add_promo_banners}
                        {foreach $ga_product_info.add_promo_banners as $ga_banners_info}
                            gtag('event', 'view_promotion', {
                                'send_to': 'default',
                                'promotions': [
                                    {foreach $ga_banners_info as $ga_banner_info}
                                        {
                                            '{$sd_ga_params_name_ga4}id': '{$ga_banner_info.id|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}name': '{$ga_banner_info.name|escape:javascript nofilter}'
                                        },
                                    {/foreach}
                                ]
                            });
                        {/foreach}
                        {if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
                            {foreach $company_ids as $company_id}
                                {foreach $ga_product_info.add_promo_banners as $ga_banners_info}
                                    gtag('event', 'view_promotion', {
                                        'send_to': '{$vendor_tracking_codes[$company_id]}',
                                        'promotions': [
                                            {foreach $ga_banners_info as $ga_banner_info}
                                                {
                                                    '{$sd_ga_params_name_ga4}id': '{$ga_banner_info.id|escape:javascript nofilter}',
                                                    '{$sd_ga_params_name_ga4}name': '{$ga_banner_info.name|escape:javascript nofilter}'
                                                },
                                            {/foreach}
                                        ]
                                    });
                                {/foreach}
                            {/foreach}
                        {/if}
                    {/if}

                    {if $ga_product_info.add_promo_banners}
                        {foreach $ga_product_info.add_promo_banners as $snapping_id => $ga_banners_info}
                            var parent_elm_slider = $('#banner_slider_' + {$snapping_id});
                            if (!parent_elm_slider.length) {
                                var parent_elm_original = $('#banner_original_' + {$snapping_id});
                            }
                            var bkey_wisiwyg = bkey_image = 0;
                            var elm = '';
                            {foreach $ga_banners_info as $banner_key => $ga_banner_info}
                                if (parent_elm_slider.length) {
                                    elm = parent_elm_slider.find('.ty-banner__image-item')[{$banner_key}];
                                } else {
                                    {if $ga_banner_info.wysiwyg == "Y"}
                                        elm = parent_elm_original[bkey_wisiwyg];
                                        bkey_wisiwyg++;
                                    {else}
                                        elm = parent_elm_original[bkey_image];
                                        bkey_image++;
                                    {/if}
                                }
                                $(elm).on('click', 'a', function() {
                                    gtag('event', 'select_content', {
                                        'send_to': 'default',
                                        'promotions': [
                                            {
                                                '{$sd_ga_params_name_ga4}id': '{$ga_banner_info.id|escape:javascript nofilter}',
                                                '{$sd_ga_params_name_ga4}name': '{$ga_banner_info.name|escape:javascript nofilter}'
                                            }
                                        ]
                                    });
                                });
                            {/foreach}
                        {/foreach}
                    {/if}
                }
            });
        }(Tygh, Tygh.$));
    </script>
{/if}
