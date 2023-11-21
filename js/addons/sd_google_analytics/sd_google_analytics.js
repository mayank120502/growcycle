(function (_, $) {
    let data = $('#sd-ga-data').data();
    let sdGaParamsName = data.sdGaParamsName;
    let filterContaining = function (arr, elm) {
        let elementIsContained = function (elm) {
            return elm.contains(this);
        };
        return arr.filter(elementIsContained, elm);
    };

    function matchesUrl(url_str, clean_url)
    {
        return (url_str.length == clean_url.length)
            || isNaN(url_str.substr(clean_url.length)[0]);
    }

    function bindLinks(blockRoots)
    {
        if (blockRoots.length && typeof _.sd_google_analytics.productDataIndex !== 'undefined') {
            for (let product_url in _.sd_google_analytics.productDataIndex) {
                if (_.sd_google_analytics.productDataIndex[product_url].bound) continue;
                (function (url) {
                    $('a[href^="' + url + '"]').filter(
                        function (i) {
                            return matchesUrl(this.href, url);
                        }
                    ).click(function (e) {
                        let containingBlocks = filterContaining(blockRoots, this);
                        let tracker = $("input[name='product_data[" + escape(_.sd_google_analytics.productDataIndex[url].product.id) + "][vendor_tracking_code]'").val();

                        if (containingBlocks.length) {
                            gtag('event', 'select_content', {
                                'send_to': 'default',
                                'content_type': 'product',
                                'items': [
                                    _.sd_google_analytics.productDataIndex[url].product,
                                ]
                            });

                            if (typeof(tracker) != undefined) {
                                gtag('event', 'select_content', {
                                    'send_to': tracker,
                                    'content_type': 'product',
                                    'items': [
                                        _.sd_google_analytics.productDataIndex[url].product,
                                    ]
                                });
                            }
                        }
                    });
                    //and also for quick view urls:
                    let quickViewFragment = 'products.quick_view&product_id=' + escape(_.sd_google_analytics.productDataIndex[url].product.id) + '&';
                    $('a[href*="' + quickViewFragment + '"]').click(function (e) {
                        let containingBlocks = filterContaining(blockRoots, this);
                        let tracker = $("input[name='product_data[" + escape(_.sd_google_analytics.productDataIndex[url].product.id) + "][vendor_tracking_code]'").val();

                        if (containingBlocks.length) {
                            gtag('event', 'select_content', {
                                'send_to': 'default',
                                'non_interaction': data.noninteractiveQuickView,
                                'content_type': 'product',
                                'items': [
                                    _.sd_google_analytics.productDataIndex[url].product,
                                ]
                            });

                            if (typeof(tracker) != undefined) {
                                gtag('event', 'select_content', {
                                    'send_to': tracker,
                                    'non_interaction': data.noninteractiveQuickView,
                                    'content_type': 'product',
                                    'items': [
                                        _.sd_google_analytics.productDataIndex[url].product,
                                    ]
                                });
                            }
                        }
                    });

                })(product_url);
                _.sd_google_analytics.productDataIndex[product_url].bound = true;
            }
        }
    }

    $(document).ready(function () {
        blockRoots = $('input[class^="ga-block-marker"]').next().toArray();
        bindLinks(blockRoots);
    });

    $.ceEvent('on', 'ce.ajaxdone', function (elms, inline_scripts, params, data) {
        if (data['sd_ga'] && typeof(gtag) != 'undefined') {
            let is_add_tracker = false;
            let is_remove_tracker = false;
            let add_tracker = '';
            let remove_tracker = '';

            //adds the add-to-cart event to the details product page
            if (data['sd_ga']['added']) {
                for (let item in data['sd_ga']['added']) {
                    gtag('event', 'add_to_cart', {
                        'send_to': 'default',
                        'items': [
                            data['sd_ga']['added'][item],
                        ]
                    });

                    if (data['sd_ga']['added'][item]['tracker']) {
                        add_tracker = data['sd_ga']['added'][item]['tracker'];
                        gtag('event', 'add_to_cart', {
                            'send_to': add_tracker,
                            'items': [
                                data['sd_ga']['added'][item],
                            ]
                        });
                    }
                }
            }

            //adds the remove-from-cart event to the minicart (to the block)
            if (data['sd_ga']['deleted']) {
                for (let item in data['sd_ga']['deleted']) {
                    gtag('event', 'remove_from_cart', {
                        'send_to': 'default',
                        'items': [
                            data['sd_ga']['deleted'][item],
                        ]
                    });

                    if (data['sd_ga']['deleted'][item]['tracker']) {
                        remove_tracker = data['sd_ga']['deleted'][item]['tracker'];
                        gtag('event', 'remove_from_cart', {
                            'send_to': remove_tracker,
                            'items': [
                                data['sd_ga']['deleted'][item],
                            ]
                        });
                    }
                }
            }
        }
    });

    $.ceEvent('on', 'ce.ajaxdone', function (elms, inline_scripts, params, data) {
        if (params.result_ids && typeof _.sd_google_analytics !== 'undefined') {
            if (data.ga_array_data) {
                for (let item in data['ga_array_data']) {
                    if (item == 'add_impression' || item == 'add_product' || item == 'add_promo') {
                        for (let key in data['ga_array_data'][item]) {
                            if (item == 'add_promo') {
                                for (let promo in data['ga_array_data'][item][key]) {
                                    gtag('event', 'select_content', {
                                        'send_to': 'default',
                                        'promotions': [
                                            data['ga_array_data'][item][key][promo],
                                        ]
                                    });
                                }
                            } else if (item == 'add_product') {
                                gtag('event', 'view_item', {
                                    'send_to': 'default',
                                    'items': [
                                        {
                                            [sdGaParamsName + 'id']: data['ga_array_data'][item][key]['id'],
                                            [sdGaParamsName + 'name']: data['ga_array_data'][item][key]['name'],
                                            [sdGaParamsName + 'brand']: data['ga_array_data'][item][key]['brand'],
                                            [sdGaParamsName + 'category']: data['ga_array_data'][item][key]['category'],
                                            [sdGaParamsName + 'variant']: data['ga_array_data'][item][key]['variant'],
                                            'price': data['ga_array_data'][item][key]['price']
                                        },
                                    ]
                                });
                            } else {
                                gtag('event', 'view_item_list', {
                                    'send_to': 'default',
                                    'items': [
                                        {
                                            [sdGaParamsName + 'id']: data['ga_array_data'][item][key]['id'],
                                            [sdGaParamsName + 'name']: data['ga_array_data'][item][key]['name'],
                                            [sdGaParamsName + 'brand']: data['ga_array_data'][item][key]['brand'],
                                            [sdGaParamsName + 'category']: data['ga_array_data'][item][key]['category'],
                                            [sdGaParamsName + 'variant']: data['ga_array_data'][item][key]['variant'],
                                            [sdGaParamsName + 'list_name']: data['ga_array_data'][item][key]['list_name'],
                                            [sdGaParamsName + 'list_position']: data['ga_array_data'][item][key]['list_position'],
                                            'price': data['ga_array_data'][item][key]['price']
                                        },
                                    ]
                                });
                            }
                        }
                    }
                    if (item == 'add_product_click' && typeof _.sd_google_analytics.productDataIndex !== 'undefined') {
                        for (prod in data['ga_array_data'][item]) {
                            _.sd_google_analytics.productDataIndex[prod] = data['ga_array_data'][item][prod];
                        }
                    }
                }
            }
        }
    });


    $.ceEvent('on', 'ce.ajaxdone', function (elms, inline_scripts, params, data) {
        blockRoots = $('input[class^="ga-block-marker"]').next().toArray();
        bindLinks(blockRoots);
    });

    $(document).on('click', 'a[data-ca-target-id^=comparison_list]', function() {
        $.ceEvent('one', 'ce.ajaxdone', function (elms, inline_scripts, params, data) {
            if (typeof(gtag) != 'undefined') {
                let product = (data.ga_array_data.add_product) ? data.ga_array_data.add_product[0] : '';
                let tracker = $("input[name='product_data[" + product.id + "][ga_code]'").val();

                if (product == '') {
                    let url = new URL($('a[data-ca-target-id^=comparison_list]').attr('href'));
                    let product_id = url.searchParams.get('product_id');
                    let items = Object.values(data.ga_array_data.add_impression);

                    for (key in items) {
                        if (items[key]['id'] == product_id) {
                            product = items[key];
                            break;
                        }
                    }

                    tracker = $("input[name='product_data[" + product_id + "][vendor_tracking_code]'").val();
                }

                gtag('event', 'add_to_comparison_list', {
                    'send_to': 'default',
                    'non_interaction': data.noninteractiveComparisonList,
                    'items': [
                        {
                            [sdGaParamsName + 'id']: product['id'],
                            [sdGaParamsName + 'name']: product['name'],
                            [sdGaParamsName + 'brand']: product['brand'],
                            [sdGaParamsName + 'category']: product['category'],
                            [sdGaParamsName + 'variant']: product['variant'],
                            'price': product['price']
                        },
                    ]
                });

                gtag('event', 'add_to_comparison_list', {
                    'send_to': tracker,
                    'non_interaction': data.noninteractiveComparisonList,
                    'items': [
                        {
                            [sdGaParamsName + 'id']: product['id'],
                            [sdGaParamsName + 'name']: product['name'],
                            [sdGaParamsName + 'brand']: product['brand'],
                            [sdGaParamsName + 'category']: product['category'],
                            [sdGaParamsName + 'variant']: product['variant'],
                            'price': product['price']
                        },
                    ]
                });
            }
        });
    });

    $(document).on('click', '.cm-submit[id^="button_wishlist"]', function() {
        $.ceEvent('one', 'ce.formajaxpost_' + $(this).parents('form').prop('name'), function(form, elm) {
            if (typeof(gtag) != 'undefined') {
                let items = elm.data;
                let product_id;

                for (key in items) {
                    if (key.endsWith("[product_id]")) {
                        product_id = items[key];
                        break;
                    }
                }

                gtag('event', 'add_to_wishlist', {
                    'send_to': 'default',
                    'non_interaction': data.noninteractiveWishlist,
                    'items': [
                        {
                            [sdGaParamsName + 'id']: product_id,
                            [sdGaParamsName + 'name']: items['product_data[' + product_id + '][name]'],
                            [sdGaParamsName + 'brand']: items['product_data[' + product_id + '][brand]'],
                            [sdGaParamsName + 'category']: items['product_data[' + product_id + '][category]'],
                            [sdGaParamsName + 'variant']: items['product_data[' + product_id + '][variant]'],
                            'price': items['product_data[' + product_id + '][price]']
                        },
                    ]
                });

                let tracker = items['product_data[' + product_id + '][ga_code]'];

                gtag('event', 'add_to_wishlist', {
                    'send_to': tracker,
                    'non_interaction': data.noninteractiveWishlist,
                    'items': [
                        {
                            [sdGaParamsName + 'id']: product_id,
                            [sdGaParamsName + 'name']: items['product_data[' + product_id + '][name]'],
                            [sdGaParamsName + 'brand']: items['product_data[' + product_id + '][brand]'],
                            [sdGaParamsName + 'category']: items['product_data[' + product_id + '][category]'],
                            [sdGaParamsName + 'variant']: items['product_data[' + product_id + '][variant]'],
                            'price': items['product_data[' + product_id + '][price]']
                        },
                    ]
                });
            }
        });
    });

    $.ceEvent('on', 'ce.formajaxpost_call_requests_form', function(form, elm) {
        if (typeof(gtag) != 'undefined') {
            let items = elm.data;
            let product_id = items['call_data[product_id]'];

            gtag('event', 'buy_in_one_click', {
                'send_to': 'default',
                'non_interaction': data.noninteractiveBuyOneClick,
                'items': [
                    {
                        [sdGaParamsName + 'id']: product_id,
                        [sdGaParamsName + 'name']: items['product_data[' + product_id + '][name]'],
                        [sdGaParamsName + 'brand']: items['product_data[' + product_id + '][brand]'],
                        [sdGaParamsName + 'category']: items['product_data[' + product_id + '][category]'],
                        [sdGaParamsName + 'variant']: items['product_data[' + product_id + '][variant]'],
                        'price': items['product_data[' + product_id + '][price]']
                    },
                ]
            });

            let tracker = elm['data']['product_data[' + product_id + '][ga_code]'];

            if (typeof(tracker) != 'undefined') {
                gtag('event', 'buy_in_one_click', {
                    'send_to': tracker,
                    'non_interaction': data.noninteractiveBuyOneClick,
                    'items': [
                        {
                            [sdGaParamsName + 'id']: product_id,
                            [sdGaParamsName + 'name']: items['product_data[' + product_id + '][name]'],
                            [sdGaParamsName + 'brand']: items['product_data[' + product_id + '][brand]'],
                            [sdGaParamsName + 'category']: items['product_data[' + product_id + '][category]'],
                            [sdGaParamsName + 'variant']: items['product_data[' + product_id + '][variant]'],
                            'price': items['product_data[' + product_id + '][price]']
                        },
                    ]
                });
            }
        }
    });

    $.ceEvent('on', 'ce.formajaxpost_call_requests_form', function() {
        if (typeof(gtag) != 'undefined') {
            let product_id = $("input[name='call_data[product_id]").val();
            let tracker = $("input[name='product_data[" + product_id + "][ga_code]'").val();

            gtag('event', 'call request', {
                'send_to': 'default'
            });

            gtag('event', 'call request', {
                'send_to': tracker
            });
        }
    });
}(Tygh, Tygh.$));
