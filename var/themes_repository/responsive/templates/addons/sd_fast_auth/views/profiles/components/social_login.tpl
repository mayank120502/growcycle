{hook name="auth:social_login"}
    <div id="social_login"
        class="{if $login_position == "top"}top {/if}js-social-login-reg"
    >
        {$title = __("sign_in")}
        {if $inline && $style == "checkout"}
            <div class="ty-checkout-login-form">
                {include file="common/subheader.tpl"
                    title=__("returning_customer")
                }
        {/if}
        {if is_array($providers_list)}
            {if !isset($redirect_url)}
                {$config.current_url = "redirect_url"}
            {/if}

            <p class="ty-center">{__("sd_fast_auth.registration_social_title")}:</p>

            {$smarty.capture.hybrid_auth nofilter}
            <input type="hidden" name="redirect_url" value="{$redirect_url}" />

            {foreach $providers_list as $provider_data}
                {if $provider_data.status == "A"}
                    {if $smarty.const.PRODUCT_VERSION|version_compare:$smarty.const.SD_FAST_AUTH_NEW_CSCART_VERSION:">="}
                        {$provider_data_provider_id = $provider_data.provider_id}
                    {else}
                        {$provider_data_provider_id = $provider_data.provider}
                    {/if}
                    <a rel="nofollow"
                        class="
                            cm-login-provider
                            sd-fast-auth
                            sd-social-button
                            sd-social-button--{$provider_data.provider}
                        "
                        data-idp="{$provider_data_provider_id}"
                    >
                        {if $provider_data.provider == "facebook" || $provider_data.provider == "twitter"}
                            <i class="icon ty-icon-{$provider_data.provider}"></i>
                        {else}
                            <img class="icon icon-{$provider_data.provider}"
                                src="{$images_dir}/addons/sd_fast_auth/{$provider_data.provider}.svg"
                                alt="{$provider_data.provider|ucfirst}"
                            />
                        {/if}

                        {$provider_data.provider|ucfirst}
                    </a>
                {/if}
            {/foreach}
        {else}
            {if $inline}
                <p class="ty-no-items">{__("no_items")}</p>
            {else}
                <script>
                    (function(_, $) {
                        $('.js-social-login-reg').hide();
                        $('.js-login-pass-reg').show();
                        $('.js-show-social-login-reg').hide();
                    }(Tygh, Tygh.$));
                </script>
            {/if}
        {/if}

        {if !$show_social}
            {if $btn}
                <p class="ty-center">{__("or")}:</p>
                <div class="js-show-login-pass-reg ty-center sd-show-login-pass">
                    <a class="ty-btn ty-btn__secondary ty-btn__email sd-fast-auth" rel="nofollow">
                        <i class="ty-icon-empty"></i>
                        {__("registration_new_profile")}
                    </a>
                </div>
            {else}
                <div class="js-show-login-pass-reg ty-center sd-show-login-pass">
                    <a rel="nofollow">{__("registration_new_profile")}</a>
                </div>
            {/if}
        {/if}
        {if $inline && $style == "checkout"}
            </div>
        {/if}
    </div>
{/hook}
