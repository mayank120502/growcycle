{strip}
    <ul class="affiliate-menu clearfix">
        <li><a class="{if $runtime.controller == 'affiliate_plans'}affiliate-active-tab{/if}" href="{"affiliate_plans.list"|fn_url}">{__("affiliate_plan")}</a></li>
        {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum}
            <li><a class="{if $runtime.controller == 'partners' && $runtime.mode == 'list'}affiliate-active-tab{/if}" href="{"partners.list"|fn_url}">{__("balance_account")}</a></li>
        {/if}
        {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum 
            || ($auth.user_type == "AffiliateUserTypes::CUSTOMER"|enum && $addons.sd_affiliate.allow_all_customers_be_affiliates == 'Y')
        }
        <li><a class="{if $runtime.controller == 'aff_statistics'}affiliate-active-tab{/if}" href="{"aff_statistics.commissions"|fn_url}">{__("sd_affiliate.commissions")}</a></li>
        {/if}
        {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum}
            <li><a class="{if $runtime.controller == 'payouts'}affiliate-active-tab{/if}" href="{"payouts.list"|fn_url}">{__("payouts")}</a></li>
            <li><a class="{if $runtime.controller == 'banners_manager' && $runtime.mode == 'manage' && $smarty.request.banner_type == 'T'}affiliate-active-tab{/if}" href="{"banners_manager.manage?banner_type=T"|fn_url}">{__("text_banners")}</a></li>
            <li><a class="{if $runtime.controller == 'banners_manager' && $runtime.mode == 'manage' && $smarty.request.banner_type == 'G'}affiliate-active-tab{/if}" href="{"banners_manager.manage?banner_type=G"|fn_url}">{__("graphic_banners")}</a></li>
            <li><a class="{if $runtime.controller == 'banners_manager' && (($runtime.mode == 'manage' && $smarty.request.banner_type == 'P') || ($runtime.mode == 'select_product'))}affiliate-active-tab{/if}" href="{"banners_manager.manage?banner_type=P"|fn_url}">{__("product_banners")}</a></li>
            <li><a class="{if $runtime.controller == 'partners' && $runtime.mode == 'widget'}affiliate-active-tab{/if}" href="{"partners.widget"|fn_url}">{__("addons.sd_affiliate.widget")}</a></li>
        {/if}
    </ul>
{/strip}
