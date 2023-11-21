{capture "navigation_panel_item"}
    <div class="navigation-panel__flexblock">
        <span class="navigation-panel__link-icon">
            <i class="tt-icon-user"></i>
        </span>

        <span class="navigation-panel__link-name">
            {__("affiliates_partnership")}
        </span>
    </div>
{/capture}

{if $auth.user_id}
    {$approved = $smarty.session.auth.affiliate_approved}
    {$user_type = $smarty.session.auth.user_type}

    {if ($user_type == "AffiliateUserTypes::PARTNER"|enum)
        || ($user_type == "AffiliateUserTypes::CUSTOMER"|enum
        && $addons.sd_affiliate.allow_all_customers_be_affiliates == "Y"
    )}
        <li class="navigation-panel__item">
            <a href="{fn_url("affiliate_plans.list")}" rel="nofollow" class="navigation-panel__link">
                {$smarty.capture.navigation_panel_item nofilter}
            </a>
        </li>
    {/if}

    {if ($user_type == "AffiliateUserTypes::CUSTOMER"|enum
        && $addons.sd_affiliate.allow_all_customers_be_affiliates == "N"
    )}
        <li class="navigation-panel__item">
            <a href="{fn_url("profiles.update?user_type={"AffiliateUserTypes::PARTNER"|enum}")}"
                class="navigation-panel__link"
                rel="nofollow"
            >
                {$smarty.capture.navigation_panel_item nofilter}
            </a>
        </li>
    {/if}
{else}
    <li class="navigation-panel__item">
        <a class="navigation-panel__link" href="{fn_url("auth.login_form")}" rel="nofollow">
            {$smarty.capture.navigation_panel_item nofilter}
        </a>
    </li>
{/if}
