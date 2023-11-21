{if $auth.user_id}
    {$approved = $smarty.session.auth.affiliate_approved}
    {$user_type = $smarty.session.auth.user_type}

    {if $user_type == "AffiliateUserTypes::PARTNER"|enum
        || $user_type == "AffiliateUserTypes::CUSTOMER"|enum
    }
        <li class="ty-account-info__item ty-dropdown-box__item">
            <a href="{fn_url("affiliate_plans.list")}" rel="nofollow" class="ty-account-info__a underlined">
                {__("affiliates_partnership")}
            </a>
        </li>
    {/if}
{else}
    <li class="ty-account-info__item ty-dropdown-box__item">
        <a class="ty-account-info__a underlined" href="{fn_url("auth.login_form")}" rel="nofollow">
            {__("affiliates_partnership")}
        </a>
    </li>
{/if}