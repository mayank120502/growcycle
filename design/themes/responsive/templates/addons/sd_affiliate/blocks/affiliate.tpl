{** block-description:affiliate **}
{$approved = $smarty.session.auth.affiliate_approved}
{if ($auth.user_type == "AffiliateUserTypes::PARTNER"|enum && $approved)
    || ($auth.user_type == "AffiliateUserTypes::CUSTOMER"|enum && $addons.sd_affiliate.allow_all_customers_be_affiliates == "Y")
}
    {include file="addons/sd_affiliate/common/affiliate_menu.tpl"}
{/if}
