{include file="common/letter_header.tpl"}

{__("dear")} {if $user_data.firstname}{$user_data.firstname}{else}{__("to_affiliate")}{/if},<br /><br />

{__("email_approved_notification_header", ["[company]" => $company_data.company_name])}<br /><br />

{if $reason_approved}
<b>{__("reason")}:</b><br />
{$reason_approved|nl2br}<br /><br />
{/if}

{include file="profiles/profiles_info.tpl"}

{include file="common/letter_footer.tpl"}