<div class="vendor-communication-post__content vendor-communication-post-item
    {if $post.user_type == "C"}
        vendor-communication-post__customer
    {/if}
    ">
    <div class="vendor-communication-post__date">
        {$post.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}
    </div>
    <div class="vendor-communication-post__img">
        {if $post.user_type == "V"}
            {if $auth.user_type === "UserTypes::ADMIN"|enum}
                {$show_detailed_link = true}
            {else}
                {$show_detailed_link = false}
            {/if}

            {include
                file="common/image.tpl"
                image=$post.vendor_info.logos.theme.image
                image_width="60"
                image_height="60"
                show_detailed_link=$show_detailed_link
                href={"profiles.update?user_id=`$post.vendor_info.logos.theme.company_id`"|fn_url}
                class="vendor-communication-logo__image"
            }
        {/if}
        {if $post.user_type === "A"}
            {include_ext file="common/icon.tpl" class="icon-user"}
        {/if}
    </div>
    <div class="vendor-communication-post__info">
        <div class="vendor-communication-post {cycle values=", vendor-communication-post_even"}"
            id="post_{$post.post_id}">
            <div class="vendor-communication-post__message">{$post.message|nl2br nofilter}</div>
            {if !empty($post.cp_count)}
                <div class="vendor-communication-post__message">{__("quantity")}: {$post.cp_count}</div>
            {/if}
            <span class="icon-caret">
                <span class="icon-caret-outer"></span>
                <span class="icon-caret-inner"></span>
            </span>
        </div>
        <div class="vendor-communication-post__author">
            {if $post.user_id == $auth.user_id }
                {__("vendor_communication.you")}
            {else}
                {$post.firstname} {$post.lastname}
            {/if}
        </div>
    </div>
</div>