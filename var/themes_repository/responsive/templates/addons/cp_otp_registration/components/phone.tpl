<div class="cp-phone-verified-wrap" id="phone_verification_info_{$obj_id}">
    {if !$inp_name}
        {$inp_name="user_data"}
    {/if}
    {$placeholder = $placeholder|default:$addons.cp_otp_registration.no_mask_placeholder}
    {$phone = ""}
    {if $user_data.phone}
        {$phone = $user_data.phone}
        {if $user_data.cp_phone_verified == "Y"}
            {$phone_verified = true}
        {/if}
    {/if}
    {if !$phone_verified && $smarty.session.cp_otp.register}
        {$otp_data = $smarty.session.cp_otp.register}
        {$phone = $otp_data.to}
        {$phone_verified = $otp_data.verified}
    {/if}

    <div class="ty-control-group ty-shipping-phone cm-phone">
        <label for="phone" class="ty-control-group__title cm-mask-phone-label cm-trim">{__("phone")}</label>
        <input type="text" id="phone" class="ty-input-text cm-focus cp-phone" maxlength="25"
               value="{if $phone}{$phone}{/if}" data-ca-verification="phone_verification_info_{$obj_id}" name="{$inp_name}[phone]" autocomplete="n" {if $placeholder}placeholder="{$placeholder}"{/if}>

        {if "cp_otp"|fn_needs_image_verification == true}
            {$cp_btn_href="cp_otp.pre_verification?otp_type=register&obj_id=`$obj_id`&phone=`$phone`"|fn_url}
        {else}
            {$cp_btn_href="profiles.cp_phone_verification?otp_type=register&obj_id=`$obj_id`&phone=`$phone`"|fn_url}
        {/if}

        <div class="cp-verification-wrap">
             <a class="ty-btn ty-btn__primary cp-verification-link cm-dialog-auto-size cm-dialog-opener cm-ajax"
                style="{if $phone_verified}display: none;{/if}" id="otp_verification_link_{$obj_id}"
                href="{$cp_btn_href}"
                data-ca-dialog-title="{__("cp_otp_phone_verification")}"
                data-ca-target-id="phone_verification_{$obj_id}">
                     {__("cp_otp_phone_confirm")}
                </a>

             <label for="cp_otp_verified" class="hidden cm-regexp" data-ca-regexp="Y" data-ca-message="{__("cp_otp_phone_need_confirm")}">
                     {__("cp_otp_phone_verification")}
                 </label>
             <input type="hidden" id="cp_otp_verified" value="{if $phone_verified}Y{/if}" />
         </div>
    </div>
    
    {if $phone_verified}
        <input type="hidden" name="verified_phone" value="{$phone}">
        <div class="cp-phone-confirmed" data-ca-phone="{$phone}">
            <span class="cp-phone-status cp-confirmed"><i class="ty-icon-ok"></i>&nbsp;{__("cp_phone_confirmed")}</span>
        </div>
    {/if}
<!--phone_verification_info_{$obj_id}--></div>
