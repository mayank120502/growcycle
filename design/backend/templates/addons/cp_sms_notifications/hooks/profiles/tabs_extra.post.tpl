<div class="hidden" id="content_cp_sms_send">
    <div class="control-group">
        <label class="control-label" for="cp_sms_receive">{__("cp_sn_receive_sms_notifications")}:</label>
        <div class="controls">
            <input type="hidden" name="user_data[cp_sms_receive]" value="N">
            <input {if $user_data.cp_sms_receive == "Y"}checked="checked"{/if} id="cp_sms_receive" type="checkbox" name="user_data[cp_sms_receive]" value="Y">
        </div>
    </div>
    {if $cp_sms_show_send_tab}
        {include file="addons/cp_sms_notifications/components/send_content.tpl" data=$user_data}
    {/if}
<!--content_cp_sms_send--></div>


{if $cp_sms_show_log_tab}
    {include file="addons/cp_sms_notifications/components/logs_content.tpl" search=$cp_sms_search logs=$cp_sms_logs is_tab=true}
{/if}
