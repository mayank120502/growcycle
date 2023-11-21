{script src="js/addons/sd_google_analytics/sd_google_analytics.js"}

<script>
    (function(_, $) {
        $(document).ready(function(){
            if (typeof(gtag) != 'undefined') {
                $.ceEvent('on', 'ce.formpost_' + $('button[name="dispatch[auth.login]"]').closest('form').attr('name'), function() {
                    if (typeof(gtag) != 'undefined') {
                        gtag('event', 'login', {
                            'send_to': 'default',
                            'method': 'password'
                        });

                        {if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
                            {foreach $vendor_tracking_codes as $tracker}
                                gtag('event', 'login', {
                                    'send_to': '{$tracker}',
                                    'method': 'password'
                                });
                            {/foreach}
                        {/if}
                    }
                });

                $.ceEvent('on', 'ce.formpost_main_login_form', function() {
                    if (typeof(gtag) != 'undefined') {
                        gtag('event', 'login', {
                            'send_to': 'default',
                            'method': 'password'
                        });

                        {if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
                            {foreach $vendor_tracking_codes as $tracker}
                                gtag('event', 'login', {
                                    'send_to': '{$tracker}',
                                    'method': 'password'
                                });
                            {/foreach}
                        {/if}
                    }
                });

                $.ceEvent('on', 'ce.formpost_profiles_register_form', function() {
                    if (typeof(gtag) != 'undefined') {
                        gtag('event', 'sign_up', {
                            'send_to': 'default',
                        });

                        {if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
                            {foreach $vendor_tracking_codes as $tracker}
                                gtag('event', 'sign_up', {
                                    'send_to': '{$tracker}',
                                });
                            {/foreach}
                        {/if}
                    }
                });

            }
        });
    }(Tygh, Tygh.$));
</script>

{* adds the add-to-cart and remove-from-cart events to the cart page (dispatch=checkout.cart) *}

{if $sd_ga}
    <script type="text/javascript" class="cm-ajax-force">
        (function(_, $) {
            $(document).ready(function(){
                if (typeof(gtag) != 'undefined') {
                    {if $sd_ga.deleted}
                        gtag('event', 'remove_from_cart', {
                            'send_to': 'default',
                            'items': [
                                {foreach $sd_ga.deleted as $product}
                                    {
                                        '{$sd_ga_params_name_ga4}id': '{$product.id|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}name': '{$product.name|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}brand': '{$product.brand|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}category': '{$product.category|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}variant': '{$product.variant|escape:javascript nofilter}',
                                        'quantity': '{$product.quantity}',
                                        'price': '{$product.price}'
                                    },
                                {/foreach}
                            ]
                        });

                        {foreach $sd_ga.deleted as $product}
                            {if !empty($product.tracker)}
                                gtag('event', 'remove_from_cart', {
                                    'send_to': '{$product.tracker.ga_code}',
                                    'items': [
                                        {
                                            '{$sd_ga_params_name_ga4}id': '{$product.id|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}name': '{$product.name|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}brand': '{$product.brand|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}category': '{$product.category|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}variant': '{$product.variant|escape:javascript nofilter}',
                                            'quantity': '{$product.quantity}',
                                            'price': '{$product.price}',
                                        }
                                    ]
                                });
                            {/if}
                        {/foreach}
                    {/if}
                    {if $sd_ga.added}
                        gtag('event', 'add_to_cart', {
                            'send_to': 'default',
                            'items': [
                                {foreach $sd_ga.added as $product}
                                    {
                                        '{$sd_ga_params_name_ga4}id': '{$product.id|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}name': '{$product.name|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}brand': '{$product.brand|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}category': '{$product.category|escape:javascript nofilter}',
                                        '{$sd_ga_params_name_ga4}variant': '{$product.variant|escape:javascript nofilter}',
                                        'quantity': '{$product.quantity}',
                                        'price': '{$product.price}'
                                    },
                                {/foreach}
                            ]
                        });

                        {foreach $sd_ga.added as $product}
                            {if {$product.tracker}}
                                var vendor_tracker = JSON.parse('{$product.tracker|json_encode|escape:javascript nofilter}');
                                gtag('event', 'add_to_cart', {
                                    'send_to': vendor_tracker.ga_code,
                                    'items': [
                                        {
                                            '{$sd_ga_params_name_ga4}id': '{$product.id|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}name': '{$product.name|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}brand': '{$product.brand|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}category': '{$product.category|escape:javascript nofilter}',
                                            '{$sd_ga_params_name_ga4}variant': '{$product.variant|escape:javascript nofilter}',
                                            'quantity': '{$product.quantity}',
                                            'price': '{$product.price}',
                                        }
                                    ]
                                });
                            {/if}
                        {/foreach}
                    {/if}
                }
           });
        }(Tygh, Tygh.$));
    </script>
{/if}
