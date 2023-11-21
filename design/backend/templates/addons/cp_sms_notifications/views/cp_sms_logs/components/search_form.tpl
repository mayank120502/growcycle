<div class="sidebar-row">
    <h6>{__("search")}</h6>
    <form action="{""|fn_url}" name="cp_sms_logs_form" method="get">
        
        {capture name="simple_search"}
            {include file="common/period_selector.tpl" period=$search.period extra="" display="form" button="false"}
        {/capture}
        
        {capture name="advanced_search"}
        <div class="group form-horizontal">
            <div class="control-group">
                <label class="control-label">{__("user")}:</label>
                <div class="controls">
                    <input type="text" name="q_user" size="30" value="{$search.q_user}">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">{__("action")}:</label>
                <div class="controls">
                    <select name="action">
                        <option value=""{if !$search.action} selected="selected"{/if}>{__("all")}</option>
                        {foreach from=$all_actions key="a_key" item="a_title"}
                            <option value="{$a_key}"{if $search.action == $a_key} selected="selected"{/if}>{$a_title}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
        </div>
        {/capture}
        
        {include file="common/advanced_search.tpl" advanced_search=$smarty.capture.advanced_search simple_search=$smarty.capture.simple_search dispatch="cp_sms_logs.manage" view_type="logs"}
    </form>
</div>