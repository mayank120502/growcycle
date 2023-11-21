{capture name="mainbox"}
    {include file="addons/cp_sms_notifications/components/logs_content.tpl"}
{/capture}

{capture name="sidebar"}
    {include file="addons/cp_sms_notifications/views/cp_sms_logs/components/search_form.tpl"}
{/capture}

{capture name="buttons"}
    {capture name="tools_list"}
        <li>{btn type="delete_selected" dispatch="dispatch[cp_sms_logs.m_delete]" form="cp_sms_logs_list_form"}</li>
        <li>{btn type="list" text=__("clean_logs") href="cp_sms_logs.clean" class="cm-confirm" method="POST"}</li>
    {/capture}
    {dropdown content=$smarty.capture.tools_list}
{/capture}

{include file="common/mainbox.tpl" title=__("cp_sms_logs") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons sidebar=$smarty.capture.sidebar}