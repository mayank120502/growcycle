<div id="phone_verification_{$obj_id}">
    <div class="cp-otp-send-wrap" id="phone_verification_content_{$obj_id}">
        <form name="phone_verification_form" action="{""|fn_url}" method="post">
            <input type="hidden" name="result_ids" value="phone_verification_info_{$obj_id}">
            <input type="hidden" name="obj_id" value="{$obj_id}">
            <input type="hidden" name="otp_type" value="{$otp_type}">
            <input type="hidden" name="phone" value="{$phone}">

            {include file="addons/cp_otp_registration/components/otp_code.tpl"}

            {include file="addons/cp_otp_registration/components/otp_fail_message.tpl"}

            <div class="buttons-container ty-center clearfix">
                {include file="buttons/button.tpl" but_meta="ty-btn__secondary cm-ajax " but_text=__("cp_otp_confirm") but_name="{$but_name}" but_role="submit"}
            </div>
        </form>
    <!--phone_verification_content_{$obj_id}--></div>
<!--phone_verification_{$obj_id}--></div>
