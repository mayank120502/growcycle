{$id = $id|default:"main_login"}

{capture name="login"}
    {if $style == "popup"}
        {include file="addons/sd_fast_auth/views/auth/popup.tpl"}
    {else}
        {include file="addons/sd_fast_auth/views/auth/inline.tpl"}
    {/if}
{/capture}

{if $style == "popup"}
    {$smarty.capture.login nofilter}
{else}
    <div class="ty-login">
        {$smarty.capture.login nofilter}
    </div>

    {capture name="mainbox_title"}{__("sign_in")}{/capture}
{/if}
