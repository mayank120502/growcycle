{if $amp_google_tracking_code}
    <amp-analytics type="googleanalytics"{if $amp_cookies_law} data-consent-notification-id="cookies_law"{/if}>
        <script type="application/json">
            {
                "vars": {
                    "account": "{$amp_google_tracking_code}"
                },
                "triggers": {
                    "trackPageview": {
                        "on": "visible",
                        "request": "pageview"
                    },
                    "trackEvent": {
                        "selector": "#button_cart",
                        "on": "click",
                        "request": "event",
                        "vars": {
                            "eventCategory": "buy",
                            "eventAction": "buy-click"
                        }
                    }
                }
            }
        </script>
    </amp-analytics>
{/if}

{if $amp_pixel_tracking_code}
    <amp-pixel
        src="https://www.facebook.com/tr?id={$amp_pixel_tracking_code}&amp;ev=PageView&amp;cd[media_platform]=Google_AMP"
        layout="nodisplay"
    >
    </amp-pixel>
{/if}
