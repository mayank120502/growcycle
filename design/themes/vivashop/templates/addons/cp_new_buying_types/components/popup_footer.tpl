<div id="cp_nbt_footer">
    {$cp_login_step = $smarty.session.cp_login_step}

    {capture name="continue_btn"}
        <div class="ty-float-left">
            <a href="#" class="cm-dialog-closer ty-btn ty-btn__primary" rel="nofollow">{__("continue")}</a>
        </div>
    {/capture}



    {if $cp_login_step.step == 'email'}
        {hook name="index:cp_login_buttons"}
        {/hook}
    {/if}
    {if $cp_login_step.mode =='login'}
        {if $cp_login_step.step == 'phone'}
            {$but_id="cp-get-code"}
            {$but_text="{__('cp_new_buying_types.get_code')}"}
            {$step_class="ty-btn__step-phone"}
        {elseif $cp_login_step.step=='confirm_code'}
            {$but_id="cp-verify-phone-vendor"}
            {$but_text="{__('confirm')}"}
        {else}
            {$but_id="cp-nbt-continue"}
            {$but_text="{__('continue')}"}
        {/if}
        {if $cp_login_step.step == 'phone'}
            {$code_resend_time = fn_cp_nbt_get_resend_code_time($auth.user_id)}
        {/if}
        <div class="buttons-container clearfix buttons-container-picker">
            <div class="ty-center">
                {if $cp_login_step.step == 'phone'}
                    <div class="cp-otp-timer-wrap">
                        {$time_left = $auth.user_id|fn_cp_nbt_get_resend_code_time}
                        {if $time_left > -1}
                            {$mins = ($time_left/60)|intval}
                            {$secs = ($time_left%60)|intval}

                            <span class="cp-otp-timer-info cp-otp-timer-info_step-phone">{__("cp_new_buying_types.cp_new_code_in")}:
                            <span class="cp-otp-timer">{"%02d"|sprintf:$mins}:{"%02d"|sprintf:$secs}</span></span>
                            {$hide_class='hidden'}
                        {else}
                            {$hide_class=''}
                        {/if}
                {/if}
                {include file="buttons/button.tpl"
                    but_id=$but_id
                    but_role="text"
                    but_role="text"
                    but_text=$but_text
                    but_meta="cm-ajax ty-btn__primary ty-btn__full-width ty-btn__continue cp-new-code-btn `$hide_class` `$step_class`"
                    but_name="dispatch[cp_nbt_login.continue]"
                }


                {if $cp_login_step.step == 'phone'}
                    </div>
                {/if}
                {if $cp_login_step.step == 'password'}
                    <a href="{"auth.recover_password"|fn_url}" class="ty-password-forgot__a"  tabindex="5">{__("forgot_password_question")}</a>
                {/if}
            </div>

        </div>
    {elseif $cp_login_step.mode=='register'}

        {if $cp_login_step.step='user_data'}
            {$but_id="cp-continue"}
            {$but_text="{__('continue')}"}
            {include file="common/image_verification.tpl" option="login" align="center"}
        {/if}
        <div class="buttons-container clearfix buttons-container-picker">
            <div class="ty-center">
                {include file="buttons/button.tpl"
                but_id=$but_id
                but_role="text"
                but_text=$but_text
                but_meta="cm-ajax ty-btn__primary ty-btn__full-width ty-btn__continue"
                but_name="dispatch[cp_nbt_login.continue]"}
            </div>
        </div>
    {/if}
</div>
