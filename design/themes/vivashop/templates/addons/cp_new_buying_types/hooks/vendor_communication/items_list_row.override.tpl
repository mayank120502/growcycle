<div class="ty-vendor-communication-post__date">{$message.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</div>
<div class="ty-vendor-communication-post__img">
    {if $message.user_type == "V"}
        <a href="{"companies.products?company_id=`$message.vendor_info.logos.theme.company_id`"|fn_url}">
            {include file="common/image.tpl" images=$message.vendor_info.logos.theme.image image_width="60" image_height="60" class="ty-vendor-communication-post__logo"}
        </a>
    {/if}
    {if $message.user_type === "A"}
        {include_ext file="common/icon.tpl" class="ty-icon-user"}
    {/if}
</div>
<div class="ty-vendor-communication-post__info">
    <div class="ty-vendor-communication-post {cycle values=", ty-vendor-communication-post_even"}" id="post_{$message.message_id}">
        <div class="ty-vendor-communication-post__message">{$message.message|nl2br nofilter}</div>
        {if !empty($message.cp_count)}
            <div class="vendor-communication-post__message">{__("quantity")}: {$message.cp_count}</div>
        {/if}
        <span class="ty-caret"> <span class="ty-caret-outer"></span> <span class="ty-caret-inner"></span></span>
    </div>
    <div class="ty-vendor-communication-post__author">{if $message.user_type == "C"}{__("vendor_communication.you")}{else}{$message.firstname} {$message.lastname}{/if}</div>
</div>