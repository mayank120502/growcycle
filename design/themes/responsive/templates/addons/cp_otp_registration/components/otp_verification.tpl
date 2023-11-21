<div id="otp_block_{$obj_id}">
    {$login_type = $login_type|default:$addons.cp_otp_registration.login_type|default:"password"}
    {$location = $location|default:$smarty.request.location}
    {$otp_action = $otp_action|default:$smarty.request.otp_action}
    {$next_dispatch = ""}
    {if $otp_type == "login"}
        {$but_text = __("sign_in")}
        {if $login_type == "otp" || $login_type == "two_factor"}
            {$next_dispatch = "profiles.cp_otp_login"}
            {$but_name = "dispatch[profiles.cp_check_otp]"}
            {$but_text = __("cp_otp_get_code")}
        {/if}
    {elseif $otp_type == "register"}
        {$but_text = __("register")}
        {if $login_type == "otp" || $login_type == "two_factor"}
            {$next_dispatch = "profiles.update"}
            {$but_name = "dispatch[profiles.cp_check_otp]"}
            {$but_text = __("cp_otp_get_code")}
        {/if}
    {/if}

    {if $show_email}
        {$login_email = $email|default:$smarty.request.email|default:$config.demo_username}
        {$otp_type = "login"}
        {$otp_action = "register"}
        <div class="ty-control-group cp-otp-auth-field">
            <label for="login_email_{$obj_id}" class="ty-login__filed-label ty-control-group__label cm-required cm-trim cm-email">{__("email")}</label>
            <input type="text" id="login_email_{$obj_id}" name="user_data[email]" size="30" value="{$login_email}" class="ty-login__input cm-focus" />
        </div>
    {/if}

    {if $show_otp}
        {include file="addons/cp_otp_registration/components/otp_code.tpl" otp_content_id="otp_block_`$obj_id`" return_dispatch=$next_dispatch}
    {elseif $auth_field == "phone" && !fn_cp_otp_allow_fast_registration()}
        <div class="cp-otp-register-wrap">
            {if $login_type == "otp"}
                <a data-ca-dispatch="dispatch[profiles.cp_check_otp]" data-ca-check-filter=".cp-otp-auth-field" data-ca-otp-action="register" class="cp-otp-register-link cm-submit cm-ajax cm-ajax-full-render" rel="nofollow">{__("create_account")}</a>
            {else}
                <a href="{"profiles.add"|fn_url}" class="cp-otp-register-link" rel="nofollow">{__("create_account")}</a>
            {/if}
        </div>
    {/if}

    {include file="addons/cp_otp_registration/components/otp_fail_message.tpl"}

    {if $return_dispatch}
        {$but_name = "dispatch[`$return_dispatch`]"}
        {if $otp_type == "register" || $otp_action == "register"}
            {$but_text = __("register")}
        {elseif $otp_type == "login"}
            {$but_text = __("sign_in")}
        {/if}
    {/if}

    <input type="hidden" name="return_dispatch" value="{$next_dispatch}">
    <input type="hidden" name="obj_id" value="{$obj_id}">
    <input type="hidden" name="otp_type" value="{$otp_type}">
    <input type="hidden" name="show_email" value="{$show_email}">
    <input type="hidden" name="need_register" value="{$need_register}">
    <input type="hidden" name="otp_action" value="{$otp_action}">
    <input type="hidden" name="location" value="{$location}">
    <input type="hidden" name="result_ids" value="otp_block_{$obj_id}">

    {capture name="continue_btn"}
        <div class="ty-float-left">
            <a href="#" class="cm-dialog-closer ty-btn ty-btn__primary" rel="nofollow">{__("continue")}</a>
        </div>
    {/capture}

    {if $login_type == "otp" || $login_type == "two_factor"}
        <div class="buttons-container clearfix">
            <div class="ty-float-right">
                {include file="buttons/button.tpl" but_text=$but_text but_name=$but_name but_meta="cm-ajax ty-btn__secondary" but_role="submit"}
            </div>
            {if $location == "checkout"}
                {$smarty.capture.continue_btn nofilter}
            {/if}
        </div>
    {else}
        <input type="hidden" name="result_ids" value="cp_auth_form_wrap_{$obj_id}">
        {hook name="index:login_buttons"}
            <div class="buttons-container clearfix">
                <div class="ty-float-right">
                    {include file="buttons/login.tpl" but_name="dispatch[auth.login]" but_role="submit"}
                </div>
                {if $location == "checkout"}
                    {$smarty.capture.continue_btn nofilter}
                {else}
                    <div class="ty-login__remember-me">
                        <label for="remember_me_{$obj_id}" class="ty-login__remember-me-label"><input class="checkbox" type="checkbox" name="remember_me" id="remember_me_{$obj_id}" value="Y" />{__("remember_me")}</label>
                    </div>
                {/if}
            </div>
        {/hook}
    {/if}
<!--otp_block_{$obj_id}--></div>

