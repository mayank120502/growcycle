{hook name="index:meta_amp"}
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset={$smarty.const.CHARSET}" data-ca-mode="{$store_trigger}" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width, minimum-scale=1" />
    {hook name="index:meta_description_amp"}
        <meta name="description" content="{$meta_description|html_entity_decode:$smarty.const.ENT_COMPAT:"UTF-8"|default:$location_data.meta_description}" />
    {/hook}
    <meta name="keywords" content="{$meta_keywords|default:$location_data.meta_keywords}" />
    {if $amp_google_tracking_code}
        <meta name="amp-google-client-id-api" content="googleanalytics">
    {/if}
{/hook}
