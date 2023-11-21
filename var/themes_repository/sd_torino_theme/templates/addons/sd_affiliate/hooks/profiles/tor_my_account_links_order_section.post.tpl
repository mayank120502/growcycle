{$user_type = $smarty.session.auth.user_type}

{if ($user_type == "AffiliateUserTypes::PARTNER"|enum)
    || ($user_type == "AffiliateUserTypes::CUSTOMER"|enum
    && $addons.sd_affiliate.allow_all_customers_be_affiliates == "Y"
)}
    {include "views/profiles/components/my_account_links_item.tpl"
        item_dispatch="affiliate_plans.list"
        item_name=__("affiliates_partnership")
    }
{/if}
