{if $smarty.session.auth.user_id
    && $smarty.session.auth.user_type == "AffiliateUserTypes::PARTNER"|enum
    && $smarty.session.auth.affiliate_approved
}
    <div class="affiliate-code">{__("addons.sd_affiliate.aff_id")}: {$smarty.session.auth.user_id}</div>
{/if}
