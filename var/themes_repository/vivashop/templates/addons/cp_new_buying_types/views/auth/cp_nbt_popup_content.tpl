{$cp_login_step = $smarty.session.cp_login_step}
<div class="cp-auth-form-wrap" id="cp_nbt_auth_form_wrap">
    {include file="blocks/static_templates/logo.tpl"}
<form name="cp_nbt_popup_form" action="{""|fn_url}" method="post" class="cm-ajax cm-ajax-full-render">

    <input type="hidden" name="result_ids" value="cp_nbt_auth_form_wrap">

    {$login_email = $email|default:$smarty.request.email|default:$config.demo_username}
    {$login_firstname = $firstname|default:$smarty.request.firstname}
    {$login_lastname = $lastname|default:$smarty.request.lastanme}
    {$login_phone = $phone|default:"+1"}

    {$location = $location|default:$smarty.request.location}

    {if !$location}
        {if $runtime.controller == "checkout" && $runtime.mode == "checkout"}
            {$location = "checkout"}
        {/if}
    {/if}

    {if $cp_login_step.mode == 'login'}
        {if $cp_login_step.step == 'email'}
            {if $cp_login_step.msg_type}
                {if $cp_login_step.msg_type == 1}
                    {$label=__("cp_new_buying_types.sign_in_to_send")}
                {elseif $cp_login_step.msg_type == 2}
                    {$label=__("cp_new_buying_types.sign_in_to_order")}
                {/if}
            {else}
                {$label=__("sign_in")}
            {/if}

        {elseif $cp_login_step.step == 'password'}
            {$label=__("cp_new_buying_types.enter_password")}
        {elseif $cp_login_step.step == 'phone'}
            {$label=__("cp_new_buying_types.please_enter_phone_number")}
            {if empty($phone) && !empty($cp_login_step.phone)}
                {$phone=$cp_login_step.phone}
            {/if}
        {/if}
    {/if}

    <div class="cp-auth-field-wrap">
        {if $cp_login_step.mode == 'login'}
            {if $cp_login_step.step == 'email'}
                <div class="ty-control-group ">
                    <label for="cp_nbt_login_email" class="ty-login__filed-label ty-control-group__label cm-required cm-trim cm-email cp-hide-required">
                        {$label}
                    </label>
                    <input type="text" id="cp_nbt_login_email" name="email" size="30" value="{$login_email}" class="ty-login__input cm-focus"
                           placeholder="{__("cp_new_buying_types.enter_email")}" />
                </div>
                <div class="ty-login__remember-me">
                    <div class="cm-field-container">
                        <input class="checkbox" type="checkbox" name="remember_me" id="remember_me_{$obj_id}" {if $cp_login_step.remember_me == 'Y'}checked{/if} value="Y" />
                        <label for="remember_me_{$obj_id}" class="ty-login__remember-me-label">{__("remember_me")}</label>
                    </div>
                </div>
            {elseif $cp_login_step.step == 'password'}
                <div class="ty-control-group ty-password-forgot">
                    <label for="psw_{$id}" class="ty-login__filed-label ty-control-group__label ty-password-forgot__label cm-required cp-hide-required">
                        {$label}
                    </label>
                    <input type="password" id="psw_{$id}" name="password" size="30" value="" class="ty-login__input cm-focus" maxlength="32" placeholder="{__("password")}"/>
                </div>
            {elseif $cp_login_step.step == 'phone'}
                <div class="ty-control-group ty-shipping-phone cm-phone cp-dialog cp-phone-block">
                    <label for="phone" class="ty-control-group__title cm-required cm-mask-phone-label cm-trim cp-hide-required">{$label}</label>
                    <input type="tel" id="phone" class="ty-input-text cm-focus cp-phone" maxlength="32"
                           value="{if $login_phone}{$login_phone}{/if}" data-ca-verification="phone_verification_info_{$obj_id}"
                           name="phone" autocomplete="n" {if $placeholder}placeholder="{$placeholder}"{/if}>
                </div>
            {elseif $cp_login_step.step == 'confirm_code'}
                {$digits_count = 4}
                {$submit_by_last = false}
                {if $addons.cp_otp_registration.last_num_confirm == "Y"}
                    {$submit_by_last = true}
                {/if}

                <div class="ty-control-group clearfix">
                    <label for="cp_otp_code" class="ty-control-group__title cm-required cp-hide-required">
                        {__("cp_new_buying_types.cp_otp_enter_code")}
                    </label>
                    <div class="cp-otp-code-wrap">
                        {for $i = 1 to $digits_count}
                            <input type="text" size="1" name="code[{$i}]" maxlength="1" class="cp-otp-code-item cm-autocomplete-off cm-required{if $i == 1} cm-focus{/if}" data-ca-target-id="cp_otp_code" />
                        {/for}
                        <input id="cp_otp_code" type="hidden" value="" name="cp_otp_code" data-ca-count="{$digits_count}" size="24" maxlength="24" />
                        <input id="cp_otp_code_last_num" type="hidden" value="{$submit_by_last}" name="cp_otp_code_last_num" />
                    </div>
                </div>
                <div class="cp-otp-timer-wrap">
                    {$time_left = fn_cp_nbt_get_resend_code_time($auth.user_id)}
                    {if $time_left > -1}
                        {$mins = ($time_left/60)|intval}
                        {$secs = ($time_left%60)|intval}

                        <span class="cp-otp-timer-info">{__("cp_new_buying_types.cp_new_code_in")}:
                            <span class="cp-otp-timer">{"%02d"|sprintf:$mins}:{"%02d"|sprintf:$secs}</span></span>
                        {$btn_hidden="hidden"}
                    {else}
                        {$btn_hidden=""}
                    {/if}
                    {$but_text="{__('cp_new_buying_types.resend_code')}"}

                    {include file="buttons/button.tpl"
                    but_id=$but_id
                    but_role="text"
                    but_role="text"
                    but_text=$but_text
                    but_meta="cm-ajax ty-btn__primary ty-btn__full-width ty-btn__continue cp-new-code-btn cm-skip-validation `$btn_hidden`"
                    but_name="dispatch[cp_nbt_login.resend_code]"
                    }
                </div>
            {/if}
        {elseif $cp_login_step.mode == 'register'}
            {if $cp_login_step.step == 'user_data'}
                <div class="ty-control-group__label">
                    {__("cp_new_buying_types.registration_title")}
                </div>

                <div class="ty-control-group cp-otp-auth-field cp-auth-field">
                    <div class="cm-field-container">
                        <input type="text" id="login_email_{$obj_id}" name="user_data[email]" size="30" value="{$login_email}" class="ty-login__input" placeholder=" " />
                        <label for="login_email_{$obj_id}" class="ty-login__filed-label ty-control-group__label cm-required cm-trim cm-email">
                            {__("cp_new_buying_types.registration_title")}
                        </label>
                    </div>
                </div>

                <div class="ty-control-group cp-otp-auth-field cp-auth-field">
                    <div class="cm-field-container">
                        <input type="text" id="login_firstname_{$obj_id}" name="user_data[firstname]" size="30" value="{$login_firstname}"
                               placeholder=" " class="ty-login__input cm-focus" />
                        <label for="login_firstname_{$obj_id}" class="ty-login__filed-label ty-control-group__label cm-trim cm-profile-field cm-required">
                            {__("firstname")}
                        </label>
                    </div>
                </div>

                <div class="ty-control-group cp-otp-auth-field cp-auth-field">
                    <div class="cm-field-container">
                        <input type="text" id="login_lastname_{$obj_id}" name="user_data[lastname]" size="30" value="{$login_lastname}"
                               placeholder=" " class="ty-login__input" />
                        <label for="login_lastname_{$obj_id}" class="ty-login__filed-label ty-control-group__label cm-trim cm-profile-field">
                            {__("lastname")}
                        </label>
                    </div>
                </div>

                <div class="ty-control-group__label">{__("cp_new_buying_types.enter_password")}</div>

                <div class="ty-control-group cp-otp-auth-field cp-auth-field">
                    <div class="cm-field-container">
                        <input type="password" id="password1" name="user_data[password1]" size="30" value=""
                               class="ty-input-text cm-autocomplete-off" autocomplete="off" placeholder=" "/>
                        <label for="password1" class="ty-control-group__title cm-required cm-password">
                            {__("password")}
                        </label>
                    </div>
                </div>

                <div class="ty-control-group cp-otp-auth-field cp-auth-field">
                    <div class="cm-field-container">
                        <input type="password" id="password2" name="user_data[password2]" size="30" value=""
                               class="ty-input-text cm-autocomplete-off" autocomplete="off" placeholder=" "/>
                        <label for="password2" class="ty-control-group__title cm-required cm-password">
                            {__("confirm_password")}
                        </label>
                    </div>
                </div>

                {hook name="checkout:user_register_form"}
                {/hook}
                <script>
                    (function (_, $) {
                        _.hideRecaptcha();
                    }(Tygh, Tygh.$));
                </script>
            {/if}
        {/if}
    </div>

    {include file="addons/cp_new_buying_types/components/popup_footer.tpl"}
</form>
<!--cp_nbt_auth_form_wrap--></div>
