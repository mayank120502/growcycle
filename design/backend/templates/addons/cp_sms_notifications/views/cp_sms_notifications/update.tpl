{script src="js/tygh/template_editor.js"}
{script src="js/tygh/email_templates.js"}

{capture name="mainbox"}
<form action="{""|fn_url}" method="post" class="form-horizontal form-edit" name="cp_sms_notifications_form">
    {$active_action = $smarty.request.selected_section|default:"order_status"}
    <input type="hidden" name="company_id" value="{$runtime.company_id}"/>
    <input type="hidden" name="active_action" value="{$active_action}"/>
    {capture name="tabsbox"}
        {foreach from=$actions key="action_key" item="action"}
            <div id="content_{$action_key}">
                {if $active_action == $action_key}
                    {if $action.multiple}
                        <input type="hidden" name="multiple" value="{$action.multiple}">
                        {include file=$action.multiple_template}
                    {else}
                        <div class="control-group">
                            <label class="control-label" for="cp_sms_notifications_orders_content">{__("cp_sms_message")}:</label>
                            <div class="controls">
                                <textarea name="data[content]" class="cm-focus input-large cm-emltpl-set-active" id="cp_sms_notifications_orders_content" cols="35" rows="4">{$notification.content|default:$action.default_content}</textarea>
                            </div>
                        </div>

                        {include file="common/select_status.tpl" input_name="data[status]" id="elm_seo_filter_status_{$id}" obj=$notification}

                        {if $action.extra_fields}
                            {foreach from=$action.extra_fields item="extra_field"}
                                {if $extra_field.file}
                                    {include file=$extra_field.file input_name="data[`$action_key`][extra]" data=$notification.extra}
                                {/if}
                            {/foreach}
                        {/if}
                    {/if}
                {else}
                    <span class="hidden"></span>
                {/if}
            <!--content_{$action_key}--></div>
        {/foreach}
    {/capture}
    {include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$active_action track=true}
</form>
{/capture}

{capture name="sidebar"}
    <div class="sidebar-row" id="sidebar_variables">
        <h6>{__("cp_sn_placeholders_title")}</h6>
        <ul class="nav nav-list variables-list variables-list--variables" id="sidebar_variables">
            {foreach $variables as $var_key => $var}
                {if $var.is_group}
                    {if !$var.variables}
                        {continue}
                    {/if}
                    <span class="strong micro-note hand cm-external-click" data-ca-external-click-id="cp_var_list_{$var_key}">{$var.title}</span>
                    <span id="cp_var_list_{$var_key}" class="icon-plus hand nav-opener"></span>
                    <ul class="hidden nav nav-list">
                        {foreach $var.variables as $subvar_key => $subvar}
                            <li class="variables-list__item">
                                <span class="cm-emltpl-insert-variable label hand" data-ca-template-value="{$subvar_key}">{$subvar_key}</span>
                                <span class="micro-note">- {$subvar.title}</span>
                            </li>
                        {/foreach}
                    </ul>
                {else}
                    <li class="variables-list__item">
                        <span class="cm-emltpl-insert-variable label hand" data-ca-template-value="{$var_key}">{$var_key}</span>
                        <span class="micro-note">- {$var.title}</span>
                    </li>
                {/if}
            {/foreach}
        </ul>
    </div>
{/capture}

{capture name="buttons"}
    {include file="buttons/save.tpl" but_name="dispatch[cp_sms_notifications.update]" but_role="submit-link" but_target_form="cp_sms_notifications_form"}
{/capture}

{include file="common/mainbox.tpl" title=__("cp_sms_notifications") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons select_languages=true sidebar=$smarty.capture.sidebar sidebar_position="right"}

