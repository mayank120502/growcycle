{$otp_content_id = $otp_content_id|default:"phone_verification_content_`$obj_id`"}
{$digits_count = 4}
{$submit_by_last = false}
{if $addons.cp_otp_registration.last_num_confirm == "Y"}
    {$submit_by_last = true}
{/if}
{if !$no_info_text}
    <div class="cp-code-sended-text">{if $phone}{__("cp_otp_code_sended_text")}{elseif $email}{__("cp_otp_email_code_sended_text")}{/if}</div>
{/if}
<div class="ty-control-group clearfix">
    <label for="cp_otp_code" class="ty-control-group__title cm-required">{__("cp_otp_enter_code")}</label>
    <div class="cp-otp-code-wrap">
        {for $i = 1 to $digits_count}
            <input type="text" size="1" maxlength="1" class="cp-otp-code-item cm-autocomplete-off {if $i == 1}cm-required cm-focus{/if}" data-ca-target-id="cp_otp_code" />
        {/for}
        <input id="cp_otp_code" type="hidden" value="" name="cp_otp_code" data-ca-count="{$digits_count}" size="24" maxlength="24" />
        <input id="cp_otp_code_last_num" type="hidden" value="{$submit_by_last}" name="cp_otp_code_last_num" />
    </div>

    <div class="cp-otp-timer-wrap">
        {$code_valid = $addons.cp_otp_registration.code_valid_time}
        {if $code_valid}
            {$mins = $code_valid|intval}
            {$secs = 0}
            {if $mins < $code_valid}
                {$secs = ($code_valid - $mins) * 60}
            {/if}
            <span class="cp-otp-timer-info">{__("cp_otp_code_valid")}: <span class="cp-otp-timer">{"%02d"|sprintf:$mins}:{"%02d"|sprintf:$secs}</span></span>
        {/if}
        {$resend_extra = ""}
        {if $phone}
            {$resend_extra = "phone=`$phone`"}
        {elseif $email}
            {$resend_extra = "email=`$email`"}
        {/if}
        {if $return_dispatch}
            {$resend_extra = "`$resend_extra`&return_dispatch=`$return_dispatch`"}
        {/if}
        <a class="cm-post cm-ajax cm-skip-validation cp-new-code-btn hidden" href="{"profiles.cp_check_otp?resend=1&obj_id=`$obj_id`&otp_type=`$otp_type`&otp_action=`$otp_action`&`$resend_extra`"|fn_url}" data-ca-target-id="{$otp_content_id}">{__("cp_otp_get_new_code")}</a>
    </div>
</div>

