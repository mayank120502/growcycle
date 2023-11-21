{include file="addons/sd_affiliate/common/affiliate_menu.tpl"}

{foreach from=$layouts key=layout_id item=layout_name}
    {capture name="widget_code_{$layout_id}"}
    <div class="tygh" id="tygh_container">
    </div>
    <script type="text/javascript" data-no-defer>
    (function() {ldelim}
    var url = 'https:' == document.location.protocol ? '{$widget_https_url}' : '{$widget_http_url}';
    var cw = document.createElement('script'); cw.type = 'text/javascript'; cw.async = true;
    cw.src = '//widget.cart-services.com/static/init.js?url=' + url + '&layout={$layout_id}';
    document.getElementById('tygh_container').appendChild(cw);
    {rdelim})();
    </script>
    <!-- Before using a widget make sure that the
    " <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"> "
    meta tag exists. -->
    {/capture}
    <div class="clearfix ty-mb-s">
        <h2>{$layout_name}</h2>
        <h6>{__("widget_code")}</h6>
        {assign var="widget_code" value="widget_code_$layout_id"}
        <textarea class="copy-field" id="widget_code_box_{$layout_id}" readonly="readonly" cols="30" rows="10">{$smarty.capture.$widget_code|replace:" data-no-defer":""}</textarea>
        <div>{__("widget_what_is_it", ["[href]" => $config.resources.widget_mode_url])}
        <a class="affiliate-widget-select cm-select-text" data-ca-select-id="widget_code_box_{$layout_id}">{__("select_all")}</a></div></br>
    </div>
{foreachelse}
    <p>{__("addons.sd_afiliate.no_available_layouts")}</p>
{/foreach}

{capture "mainbox_title"}
    {__(affiliates_partnership)} <span class="subtitle">/ {__("sd_affiliate.widget")}</span>
{/capture}