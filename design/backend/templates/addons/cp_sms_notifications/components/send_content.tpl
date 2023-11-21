<div class="cm-hide-save-button">
    <input type="hidden" name="cp_return_url" value="{$config.current_url}">
    <input type="hidden" name="result_ids" value="content_cp_sms_send">

    <h4 class="subheader">{__("cp_sms_send")}</h4>
    <input type="hidden" name="cp_sms_data[user_id]" value="{$data.user_id}">
    <input type="hidden" name="cp_sms_data[order_id]" value="{$data.order_id}">
    <input type="hidden" name="cp_sms_data[company_id]" value="{$data.company_id}">
    <div class="control-group">
        <label class="control-label cm-mask-phone-label" for="elm_cp_sms_phone">{__("phone")}: </label>
        <div class="controls">
            <input type="hidden" name="cp_sms_data[phone]" value="{$data.phone}">
            <input type="text" class="input cm-mask-phone" disabled="disabled" name="cp_sms_data[phone]" value="{$data.phone}">
        </div>
    </div>
    <div class="control-group">
        <label class="control-label" for="elm_cp_sms_content">{__("cp_sms_message")}: </label>
        <div class="controls">
            <textarea class="input-large" id="elm_cp_sms_content" rows="3" cols="32" name="cp_sms_data[content]"></textarea>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label" for="elm_button_send_sms"></label>
        <div class="controls">
            <input  type="submit" name="dispatch[cp_sms_notifications.send]" id="cp_sms_notifications_button" class="btn cm-submit cm-ajax" data-ca-target-id="content_cp_sms_send" value="{__("send")}" />
        </div>
    </div>
</div>
