{* Override *}
{if $user_data.user_type == 'P'}
    {include file="common/letter_header.tpl"}

    {__("dear")} {if $user_data.firstname}{$user_data.firstname}{else}{__("to_affiliate")}{/if},<br><br>

    {__("create_profile_notification_header")} {$company_data.company_name}.<br><br>

    {__("text_partner_create_profile")}</p><br><br>

    {hook name="profiles:create_profile"}
    {/hook}

    {include file="profiles/profiles_info.tpl" created=true}

    {include file="common/letter_footer.tpl"}
{else}
    {include file="common/letter_header.tpl"}

    {__("dear")} {if $user_data.firstname}{$user_data.firstname}{else}{$user_data.user_type|fn_get_user_type_description|lower}{/if},<br><br>

    {__("create_profile_notification_header")} {$company_data.company_name}.<br><br>

    {hook name="profiles:create_profile"}
    {/hook}

    {include file="profiles/profiles_info.tpl" created=true}

    {include file="common/letter_footer.tpl"}
{/if}
{* /Override *}