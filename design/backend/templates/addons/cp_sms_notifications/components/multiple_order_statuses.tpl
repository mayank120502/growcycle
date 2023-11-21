{$order_statuses = $smarty.const.STATUSES_ORDER|fn_get_statuses}                     
<div class="table-responsive-wrapper">
    <table class="table table--relative table-responsive">
        <thead>
            <tr>
                <th width="15%">{__("order_status")}</th>
                <th width="60%">{__("cp_sms_message")}</th>
                <th width="10%" class="right">{__("status")}</th>
            </tr>
        </thead>
        <tbody>
        {foreach from=$order_statuses key="o_status_key" item="o_status"}
            {$notification = $notifications.$o_status_key}
            {$notification_status = $notification.status|default:"A"}
            <tr class="cm-row-status-{$notification_status|lower}">
                <td data-th="{__("order_status")}">
                    <input type="hidden" name="data[{$o_status_key}][object_key]" value="{$o_status_key}">
                    <div class="btn-info o-status-{$o_status_key|lower} btn dropdown-toggle">{$o_status.description}</div>
                </td>
                <td class="row-status" data-th="{__("cp_sms_message")}">
                    <textarea name="data[{$o_status_key}][content]" class="cm-focus input-large cm-emltpl-set-active" id="cp_sms_notifications_orders_content" cols="35" rows="2">{$notification.content|default:$action.default_content}</textarea>
                </td>
                <td class="right" data-th="{__("status")}">
                    {include file="common/select_status.tpl" input_name="data[{$o_status_key}][status]" display="popup" obj=$notification meta="input-small"}
                </td>
            </tr>
        {/foreach}
        </tbody>
    </table>
</div>