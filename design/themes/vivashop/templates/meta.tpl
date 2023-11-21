{hook name="index:meta"}
{if $display_base_href}
<base href="{$config.current_location}/" />
{/if}

<meta http-equiv="Content-Type" content="text/html; charset={$smarty.const.CHARSET}" data-ca-mode="{$store_trigger}" data-vs-ver="3.9.4151"/>

{if $smarty.const.ET_FT_WIDTH|default:0 == "1"}
	<meta name="viewport" content="width=1024" />
{else}
	<meta name="viewport" content="initial-scale=1.0, width=device-width" />
{/if}


{hook name="index:meta_description"}
<meta name="description" content="{$meta_description|html_entity_decode:$smarty.const.ENT_COMPAT:"UTF-8"|default:$location_data.meta_description}" />
{/hook}
<meta name="keywords" content="{$meta_keywords|default:$location_data.meta_keywords}" />
<meta name="format-detection" content="telephone=no">
{/hook}
{$location_data.custom_html nofilter}
<link rel="apple-touch-icon" href="{$logos.favicon.image.image_path|fn_query_remove:'t'}">