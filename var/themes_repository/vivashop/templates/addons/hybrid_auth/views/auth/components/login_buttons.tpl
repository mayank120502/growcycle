{hook name="hybrid_auth:login_buttons"}
  {if !isset($redirect_url)}
      {$redirect_url = $config.current_url}
  {/if}
    {capture name="hybrid_auth"}
    {strip}
        <input type="hidden" name="redirect_url" value="{$redirect_url}" />
        {foreach $providers_list as $provider_data}
            {if $provider_data.status === "ObjectStatuses::ACTIVE"|enum}
                <a class="cm-login-provider et-login-{$provider_data.provider}" data-idp="{$provider_data.provider_id}" data-provider="{$provider_data.provider}">
                    {if $provider_data.provider=="google"} <img src="https://developers.google.com/identity/images/g-logo.png" alt="" style="width:18px;height:18px; margin-right: 10px;">{else}<img src="{$provider_data.icon}" title="{$provider_data.provider}" alt="{$provider_data.provider}" style="width:18px;height:18px; margin-right: 10px;"/>{/if}
                    {__("login_with_`$provider_data.provider`")}
                </a>
            {/if}
        {/foreach}
    {/strip}
    {/capture}
    {if $smarty.capture.hybrid_auth}
        <div class="et-social-login">
            {if $style == "checkout" }
                {__("hybrid_auth.social_login")}:
                <p class="ty-text-center">{$smarty.capture.hybrid_auth nofilter}</p>
            {else}
                <div class="center space-top et-social-text ty-center">{__("hybrid_auth.social_login")}</div>
            {/if}
            {if $style != "checkout"}
                <div class="et-auth social-login">
                    {$smarty.capture.hybrid_auth nofilter}
                </div>
            {/if}
        </div>
    {/if}
{/hook}