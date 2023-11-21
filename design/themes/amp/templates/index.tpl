<!DOCTYPE html>
<html ⚡="" amp lang="{$smarty.const.CART_LANGUAGE}" dir="{$language_direction}" {hook name="index:html_tag_amp"}{/hook}>
<head>
    {capture name="page_title"}
        {hook name="index:title_amp"}
            {if $page_title}
                {$page_title}
            {else}
                {foreach from=$breadcrumbs item=i name="bkt"}
                    {if $language_direction == 'rtl'}
                        {if !$smarty.foreach.bkt.last}{if !$smarty.foreach.bkt.last && !$smarty.foreach.bkt.first} :: {/if}{$i.title|strip_tags}{/if}
                    {else}
                        {if !$smarty.foreach.bkt.first}{$i.title|strip_tags}{if !$smarty.foreach.bkt.last} :: {/if}{/if}
                    {/if}
                {/foreach}
                {if !$skip_page_title && $location_data.title}{if $breadcrumbs|count > 1} - {/if}{$location_data.title}{/if}
            {/if}
        {/hook}
    {/capture}
    <title>{$smarty.capture.page_title|strip|trim nofilter}</title>
    {if $seo_canonical}
        <link rel="canonical" href="{$seo_canonical.current|remote_amp_prefix}">
    {/if}

    {include file="common/meta.tpl"}
    {hook name="index:links"}
        <link href="https://fonts.googleapis.com/css?family=Open+Sans+Condensed:300,700" rel="stylesheet">

        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/solid.css" integrity="sha384-VGP9aw4WtGH/uPAOseYxZ+Vz/vaTb1ehm1bwx92Fm8dTrE+3boLfF1SpAtB1z7HW" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/regular.css" integrity="sha384-ZlNfXjxAqKFWCwMwQFGhmMh3i89dWDnaFU2/VZg9CvsMGA7hXHQsPIqS+JIAmgEq" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/fontawesome.css" integrity="sha384-1rquJLNOM3ijoueaaeS5m+McXPJCGdr5HcA03/VHXxcp2kX2sUrQDmFc3jR5i/C7" crossorigin="anonymous">
        <link href="{$logos.favicon.image.image_path|fn_query_remove:'t'}" rel="shortcut icon" type="{$logos.favicon.image.absolute_path|fn_get_mime_content_type}" />
    {/hook}

    {literal}
        <style amp-boilerplate>
            body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}
        </style>
        <noscript><style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style></noscript>
    {/literal}

    <style amp-custom="">
        {amp_styles use_scheme=true reflect_less=$reflect_less}
            {hook name="index:styles"}
                {style src="normalize.css"}
                {style src="variables.less"}
                {style src="basscss/basscss.less"}
                {style src="styles.less"}
            {/hook}
        {/amp_styles}
    </style>

    {hook name="index:head_scripts"}
        <script async src="https://cdn.ampproject.org/v0.js"></script>
        <script custom-template="amp-mustache" src="https://cdn.ampproject.org/v0/amp-mustache-0.2.js" async=""></script>

        {foreach $amp_scripts as $script => $true}
            <script async custom-element="amp-{$script}" src="https://cdn.ampproject.org/v0/{$amp_scripts_schema.$script}"></script>
        {/foreach}
    {/hook}
</head>

<body>
    {hook name="index:body"}
        {include file="common/navbar.tpl"}
        {include file="common/sidebar.tpl"}
        <div class="content">
            {hook name="index:content"}
                {render_amp_location}
            {/hook}
            {hook name="index:footer"}{/hook}
        <!--content--></div>
    {/hook}

    {if $amp_cookies_law}
        <amp-user-notification
            id="cookies_law"
            layout="nodisplay"
            data-persist-dismissal="false"
            data-show-if-href="{'amp.user_notification?elementId=cookies_law&timestamp=TIMESTAMP'|fn_url|remote_amp_prefix}"
            data-dismiss-href="{'amp.user_dismiss?elementId=cookies_law'|fn_url|remote_amp_prefix}"
        >
            <div class="justify">
                {$amp_cookies_law nofilter}
                <button on="tap:cookies_law.dismiss" class="amp-btn caps ml1">{__("sd_accelerated_pages.cookies_law_dismiss")}</button>
            </div>
        </amp-user-notification>
    {/if}

    {include file="common/scripts.tpl"}
</body>

</html>
