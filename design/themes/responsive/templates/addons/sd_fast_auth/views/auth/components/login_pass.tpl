{hook name="auth:login_pass"}
    <div id="login_pass" class="js-login-pass{if !$show_social} hidden{/if}">
        <form name="{$id}_l_form" action="{""|fn_url}" method="post">
            <input
                type="hidden"
                name="return_url"
                value="{$smarty.request.return_url|default:$config.current_url}"
            />
            <input
                type="hidden"
                name="redirect_url"
                {if $settings.sd_fast_auth.general.redirect_after_registration == "profiles_update"}
                    value="{$config.current_url}"
                {else}
                    value="{'profiles.success_add'|fn_url}"
                {/if}
            />

            {if $show_social
                && is_array($providers_list)
                && $login_position == "bottom"
            }
                {include
                    file="addons/sd_fast_auth/views/auth/components/social_login.tpl"
                    btn=true
                    show_social=$show_social
                    login_position=$login_position
                }
                <p class="ty-center">{__("or_sign_up_with_email")}:</p>
            {/if}

            {if $style == "checkout"}
                <div class="ty-checkout-login-form">
                    {include
                        file="common/subheader.tpl"
                        title=__("returning_customer")
                    }
            {/if}

            <div class="ty-control-group">
                <label for="login_{$id}" class="
                    ty-login__filed-label
                    ty-control-group__label
                    cm-required
                    cm-trim
                    cm-email
                ">
                    {__("email")}
                </label>
                <input
                    type="text"
                    id="login_{$id}"
                    name="user_login"
                    size="30"
                    value="{$config.demo_username}"
                    class="ty-login__input cm-focus"
                />
            </div>

            <div class="ty-control-group ty-password-forgot">
                <label for="psw_{$id}" class="
                    ty-login__filed-label
                    ty-control-group__label
                    ty-password-forgot__label
                    cm-required
                ">
                    {__("password")}
                </label>
                    <a
                        href="{"auth.recover_password"|fn_url}"
                        class="ty-password-forgot__a"
                        tabindex="5"
                    >
                        {__("forgot_password_question")}
                    </a>
                <input
                    type="password"
                    id="psw_{$id}"
                    name="password"
                    size="30"
                    value="{$config.demo_password}"
                    class="ty-login__input"
                    maxlength="32"
                />
            </div>

            <div class="ty-login-reglink ty-center">
                <a
                    class="ty-login-reglink__a"
                    href="{"profiles.add"|fn_url}"
                    rel="nofollow"
                >
                    {__("register_new_account")}
                </a>
            </div>

            {if $btn}
                <p class="ty-center">{__("or")}:</p>
                <div class="sd-show-social-login ty-center js-show-social-login-sign">
                    <a rel="nofollow"
                        class="ty-btn ty-btn__secondary ty-btn__email sd-fast-auth"
                    >
                        <i class="ty-icon-empty"></i>
                        {__("social_login_btn")}
                    </a>
                </div>
            {elseif !$show_social}
                <div class="sd-show-social-login ty-center js-show-social-login-sign">
                    <a rel="nofollow">{__("fast_auth_auth.social_login")}</a>
                </div>
            {/if}

            {if $show_social && is_array($providers_list) && $login_position == "top"}
                {include
                    file="addons/sd_fast_auth/views/auth/components/social_login.tpl"
                    btn=true
                    show_social=$show_social
                    login_position=$login_position
                }
            {/if}

            {include file="common/image_verification.tpl" option="login" align="left"}

            {if $style == "checkout"}
                </div>
            {/if}

            <div class="buttons-container clearfix">
                <div class="ty-float-right">
                    {include
                        file="buttons/login.tpl"
                        but_name="dispatch[auth.login]"
                        but_role="submit"
                    }
                </div>
                <div class="ty-login__remember-me">
                    <label for="remember_me_{$id}" class="ty-login__remember-me-label">
                        <input
                            class="checkbox"
                            type="checkbox"
                            name="remember_me"
                            id="remember_me_{$id}"
                            value="Y"
                        />
                            {__("remember_me")}
                    </label>
                </div>
            </div>
        </form>
    </div>
{/hook}
