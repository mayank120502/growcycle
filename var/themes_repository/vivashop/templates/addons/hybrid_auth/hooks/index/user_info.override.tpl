{assign var="escaped_current_url" value=$config.current_url|escape:url}
{if !$auth.user_id}
    <a id="sw_login" class="cm-combination ty-combination-link">{__("sign_in")}</a>
{else}
    <a href="{"profiles.update"|fn_url}" class="strong">{if $user_info.firstname && $user_info.lastname}{$user_info.firstname}&nbsp;{$user_info.lastname}{elseif $user_info.firstname}{$user_info.firstname}{else}{$user_info.email}{/if}</a>
    {include file="buttons/button.tpl" but_role="text" but_href="auth.logout?redirect_url=`$escaped_current_url`" but_text=__("sign_out")}
{/if}

    <div id="login" class="cm-popup-box hidden">
        <div class="ty-login-popup">
        {include file="views/auth/login_form.tpl" style="popup" id="jrpopup"}
        </div>
    </div>
