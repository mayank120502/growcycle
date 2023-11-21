{if $addons.step_by_step_checkout.status != 'A'}
    <script class="cm-ajax-force">
        (function(_, $) {
            $(document).ready(function() {
                if ($('#litecheckout_form').length && typeof(gtag) != 'undefined') {
                    let sd_ga_checkout = JSON.parse('{$sd_ga_checkout|json_encode|escape:javascript nofilter}');
                    let vendor_tracking_codes = JSON.parse('{$vendor_tracking_codes|json_encode|escape:javascript nofilter}');
                    let items = [
                        {foreach $cart_products as $product}
                            {
                                '{$sd_ga_params_name_ga4}id': '{$product.product_id}',
                                '{$sd_ga_params_name_ga4}name': '{$product.product}',
                                '{$sd_ga_params_name_ga4}brand': '{fn_sd_ga_get_brand($product.product_id)}',
                                '{$sd_ga_params_name_ga4}category': '{fn_sd_ga_get_main_category($product)}',
                                'quantity': '{$product.amount}',
                                'company_id': '{$product.company_id}',
                                'price': '{$product.price}'
                            },
                        {/foreach}
                    ];

                    if ($('#litechekout_payments_form').length || $('#litecheckout_payments_form').length) {
                        fn_sd_ga_send_event('begin_checkout', items);
                        fn_sd_ga_vendor_send('begin_checkout', items, vendor_tracking_codes);
                    }

                    if ($('#litecheckout_step_customer_info').length) {
                        fn_sd_ga_send_event('checkout_progress', ['{$smarty.const.CHECKOUT_STEP_TWO}', items]);
                        fn_sd_ga_vendor_send('checkout_progress', ['{$smarty.const.CHECKOUT_STEP_TWO}', items], vendor_tracking_codes);
                    }

                    if ($('#litecheckout_step_shipping').length) {
                        fn_sd_ga_send_event('checkout_progress', ['{$smarty.const.CHECKOUT_STEP_THREE}', items]);
                        fn_sd_ga_vendor_send('checkout_progress', ['{$smarty.const.CHECKOUT_STEP_THREE}', items], vendor_tracking_codes);
                    }

                    if ($('#litecheckout_step_payment').length) {
                        fn_sd_ga_send_event('checkout_progress', ['{$smarty.const.CHECKOUT_STEP_FOUR}', items]);
                        fn_sd_ga_vendor_send('checkout_progress', ['{$smarty.const.CHECKOUT_STEP_FOUR}', items], vendor_tracking_codes);
                    }

                    $('#litecheckout_final_section').on('click', function() {
                        let chosen_shippings = null;
                        $.ceEvent('on', 'ce.formpost_' + $(this).parents('form').prop('name'), function(form, elm) {
                            if (sd_ga_checkout) {
                                for (key in sd_ga_checkout) {
                                    if (key == 'step_one') {
                                        fn_sd_ga_send_event('set_checkout_option', ['{$smarty.const.CHECKOUT_STEP_ONE}', sd_ga_checkout[key]])
                                    }
                                    if (key == 'step_three') {
                                        chosen_shippings = sd_ga_checkout[key];
                                    }
                                }
                            }
                            if (!chosen_shippings) {
                                chosen_shippings = form.serializeArray().filter(function(field) {
                                    return field.name.search(/shipping_ids/) != -1;
                                });
                                chosen_shippings = chosen_shippings.map(function(shipping) {
                                    return shipping.value;
                                }, []);
                            }
                            if (chosen_shippings.length != 0) {
                                let shipping_names = JSON.parse('{$shipping_names|json_encode|escape:javascript nofilter}');
                                chosen_shippings = chosen_shippings.map(function(shipping) {
                                    return shipping_names[shipping];
                                }, []).join(', ');
                                fn_sd_ga_send_event('set_checkout_option', ['{$smarty.const.CHECKOUT_STEP_THREE}', chosen_shippings])
                            }

                            let payment_name = form.serializeArray().filter(function(field) {
                                return field.name == 'payment_id';
                            });
                            if (payment_name.length != 0) {
                                payment_name.forEach(function(payment) {
                                    fn_sd_ga_send_event('set_checkout_option', ['{$smarty.const.CHECKOUT_STEP_FOUR}', payment.value]);
                                });
                            }
                        });
                    });
                }
            });

            function fn_sd_ga_vendor_send(event, params, vendors)
            {
                if (vendors) {
                    if (event == 'checkout_progress') {
                        [step, params] = params;
                    }
                    for (tracker in vendors) {
                        vendor_items = params.filter(function(item) {
                            return item.company_id == tracker;
                        });
                        if (event == 'checkout_progress') {
                            vendor_params = [step, vendor_items];
                        } else {
                            vendor_params = vendor_items;
                        }
                        if (vendor_items.length != 0) {
                            fn_sd_ga_send_event(event, vendor_params, vendors[tracker]);
                        }
                    }
                }
            }

            function fn_sd_ga_send_event(event, params, tracker = 'default') {
                if (event == 'set_checkout_option' || event == 'checkout_progress') {
                    [step, params] = params;
                }
                args = {
                    'send_to': tracker
                };
                if (event == 'begin_checkout' || event == 'checkout_progress') {
                    args.params = params;
                    {if $cart.coupons}
                        args.coupon = '{$cart.coupons|json_encode|escape:javascript nofilter}';
                    {else}
                        args.coupon = '';
                    {/if}
                }
                if (event == 'set_checkout_option' || event == 'checkout_progress') {
                    args.checkout_step = step;
                }
                if (event == 'set_checkout_option') {
                    args.checkout_option = params;
                }
                gtag('event', event, args);

            }
        }(Tygh, Tygh.$));
    </script>
{/if}
