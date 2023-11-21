<div class="cp-auth-form-wrap" id="cp_auth_form_wrap_{$obj_id}">
    {if $style == "checkout"}
        <div class="ty-checkout-login-form">{include file="common/subheader.tpl" title=__("returning_customer")}
    {/if}
    <div class="cp-auth-field-wrap">
        {$login_email = $email|default:$smarty.request.email|default:$config.demo_username}
        {$login_phone = $phone|default:$smarty.request.phone|default:""}

        {$location = $location|default:$smarty.request.location}
        {$otp_action = $otp_action|default:$smarty.request.otp_action}
        {if !$location}
            {if $runtime.controller == "checkout" && $runtime.mode == "checkout"}
                {$location = "checkout"}
            {/if}
        {/if}

        {if !$no_email}
            {$auth_methods = ["phone", "email"]}
            {if $addons.cp_otp_registration.default_auth_method == "email"}
                {$auth_methods = ["email", "phone"]}
            {/if}
            <div class="ty-tabs clearfix">
                <ul class="ty-tabs__list">
                    {foreach from=$auth_methods item="method"}
                        <li class="ty-tabs__item {if $auth_field == $method} active{/if}">
                            <a class="ty-tabs__a cm-ajax cm-ajax-full-render" data-ca-target-id="cp_auth_form_wrap_{$obj_id}" href="{"auth.login_form?auth_field=`$method`&custom_id=`$obj_id`&location=`$location`&otp_action=`$otp_action`&email=`$login_email`&phone=`$login_phone`"|fn_url}">{__("cp_otp_by_`$method`")}</a>
                        </li>
                    {/foreach}
                </ul>
            </div>
        {/if}

        {if $login_type == "otp" && $addons.cp_otp_registration.fast_registration == "Y"}
            <div class="cp-auth-fast-register-text">
                {if $auth_field == "email"}
                    {__("cp_otp_fast_register_email_text")}
                {else}
                    {__("cp_otp_fast_register_phone_text")}
                {/if}
            </div>
        {/if}
        {if $auth_field == "email" && !$no_email}
            <div class="ty-control-group cp-otp-auth-field">
                <label for="login_email_{$obj_id}" class="ty-login__filed-label ty-control-group__label cm-required cm-trim cm-email">{__("email")}</label>
                <input type="text" id="login_email_{$obj_id}" name="user_data[email]" size="30" value="{$login_email}" class="ty-login__input cm-focus" />
            </div>
        {else}
            {$placeholder = $placeholder|default:$addons.cp_otp_registration.no_mask_placeholder}
            <div class="ty-control-group cm-phone cp-otp-auth-field">
                <label for="login_phone_{$obj_id}" class="ty-login__filed-label ty-control-group__label cm-mask-phone-label cm-required cm-trim">{__("phone")}</label>
                <input type="text" id="login_phone_{$obj_id}" name="user_data[phone]" size="30" value="{$login_phone}" class="ty-login__input cm-focus cm-mask-phone cp-phone" {if $placeholder}placeholder="{$placeholder}"{/if} />
            </div>
        {/if}

        {if $login_type != "otp"}
            <div class="ty-control-group ty-password-forgot">
                <label for="psw_{$obj_id}" class="ty-login__filed-label ty-control-group__label ty-password-forgot__label cm-required">{__("password")}</label>
                {if $login_type == "password"}
                    <a data-ca-dispatch="dispatch[profiles.cp_check_otp]" data-ca-check-filter=".cp-otp-auth-field" data-ca-otp-action="recover" class="cp-recover-pass ty-password-forgot__a cm-submit cm-ajax cm-ajax-full-render" rel="nofollow" tabindex="5">{__("forgot_password_question")}</a>
                {else}
                    <a href="{"auth.recover_password"|fn_url}" class="ty-password-forgot__a"  tabindex="5">{__("forgot_password_question")}</a>
                {/if}
                <input type="password" id="psw_{$obj_id}" name="password" size="30" value="{$config.demo_password}" class="ty-login__input" maxlength="32" />
            </div>
        {/if}
    </div>

    {if $style == "checkout"}
        </div>
    {/if}
    
    {include file="common/image_verification.tpl" option="login" align="left"}

    {include file="addons/cp_otp_registration/components/otp_verification.tpl" otp_type="login"}
<!--cp_auth_form_wrap_{$obj_id}--></div>