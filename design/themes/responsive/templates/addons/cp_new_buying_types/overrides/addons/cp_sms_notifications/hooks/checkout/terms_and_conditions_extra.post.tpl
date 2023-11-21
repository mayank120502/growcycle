{if $smarty.request.dispatch !== 'products.cp_contact_vendor'}
<div class="cp-receive-sms-notifications">
    <div class="ty-control-group ty-profile-field__item cp-receive-sms-notifications">
        <input type="hidden" name="cp_sms_receive" value="N">
        <label class="ty-control-group__title">
            <input {if $user_data.cp_sms_receive == "Y"}checked="checked"{/if} type="checkbox" name="cp_sms_receive" value="Y">{__("cp_sn_receive_sms_notifications")}
        </label>
    </div>
</div>
{/if}
