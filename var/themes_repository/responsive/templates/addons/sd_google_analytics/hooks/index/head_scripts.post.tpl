{$gtag_url = "https://www.googletagmanager.com/gtag/js?id="|cat:"{$addons.sd_google_analytics.tracking_code}"}
{if $auth.user_id}
    {$coverage_user_id = ""|fn_sd_ga_get_coverage_user_id}
{/if}

<script async src="{$gtag_url}" data-no-defer></script>
<script data-no-defer>
    window.dataLayer = window.dataLayer || [];
    function gtag(){
        dataLayer.push(arguments);
    }
    gtag('js', new Date());

    gtag('config', '{$addons.sd_google_analytics.tracking_code}', {
        'groups': 'default',
        {if $sd_ga_crossdomain && $addons.sd_google_analytics.enable_cross_domain_tracking == "Y"}
            'linker': {
                'accept_incoming': true,
                'domains': ['{$sd_ga_crossdomain|escape:javascript nofilter}'],
            }
        {/if}
    });

    {if $sd_ga_params}
        gtag('set', JSON.parse('{$sd_ga_params|escape:javascript nofilter}'));
    {/if}

    {if $coverage_user_id.ga_user_id_law && $coverage_user_id.validator_data}
        gtag('set', 'user_id', '{$coverage_user_id.validator_data}');
    {/if}
</script>

{if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
    <script data-no-defer">
        {foreach $vendor_tracking_codes as $vendor => $code}
            gtag('config', '{$code}', {
                'groups': '{$vendor}', 'send_page_view': false
            });
        {/foreach}
    </script>
{/if}
