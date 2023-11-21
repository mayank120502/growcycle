<div title="{__("cp_otp_phone_verification")}" id="pre_verification_{$obj_id}">
    <div class="cp-otp-send-wrap" id="pre_verification_content_{$obj_id}">
        <form name="pre_verification_form cm-ajax" action="{""|fn_url}" method="post">
            <input type="hidden" name="result_ids" value="phone_verification_{$obj_id}">
            <input type="hidden" name="obj_id" value="{$obj_id}">
            <input type="hidden" name="otp_type" value="{$otp_type}">
            <input type="hidden" name="phone" value="{$phone}">
            <input type="hidden" name="redir_dispatch" value="{$redir_dispatch}">
            
            {include file="common/image_verification.tpl" option="cp_otp"}
            
            <div class="buttons-container ty-center clearfix">
                {include file="buttons/button.tpl" but_meta="ty-btn__secondary cm-ajax cm-form-dialog-closer" but_text=__("submit") but_name="dispatch[cp_otp.pre_verification]" but_role="submit"}
            </div>
        </form>
    <!--pre_verification_content_{$obj_id}--></div>
<!--pre_verification_{$obj_id}--></div>
