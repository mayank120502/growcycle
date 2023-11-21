{* Override *}

{include file="common/letter_header.tpl"}

{if $user_data.user_type == 'AffiliateUserTypes::PARTNER'|enum}
    {__("dear")} {if $user_data.firstname}{$user_data.firstname}{else}{__("to_affiliate")}{/if},<br /><br />
{else}
    {__("dear")} {if $user_data.firstname}{$user_data.firstname}{else}{$user_data.user_type|fn_get_user_type_description|lower}{/if},<br /><br />
{/if}

{__("create_profile_notification_header")} {$company_data.company_name}.<br /><br />

{if $user_data.user_type == 'AffiliateUserTypes::PARTNER'|enum}
    {__("text_partner_create_profile")}<br /><br />
{/if}

{hook name="profiles:create_profile"}
{/hook}

{include file="profiles/profiles_info.tpl" created=true}

{include file="common/letter_footer.tpl"}

{* /Override *}
