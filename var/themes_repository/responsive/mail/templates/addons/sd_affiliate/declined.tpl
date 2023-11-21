{include file="common/letter_header.tpl"}

{__("dear")} {if $user_data.firstname}{$user_data.firstname}{else}{__("to_affiliate")}{/if},<br /><br />

{__("email_declined_notification_header")}<br /><br />

{if $reason_declined}
<b>{__("reason")}:</b><br />
{$reason_declined|nl2br nofilter}<br /><br />
{/if}