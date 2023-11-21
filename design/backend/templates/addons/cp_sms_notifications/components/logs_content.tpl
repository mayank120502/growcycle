<div id="content_cp_sms_logs">
    {assign var="c_icon" value="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
    {assign var="c_dummy" value="<i class=\"icon-dummy\"></i>"}
    {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
    {assign var="rev" value=$smarty.request.content_id|default:"cp_logs_pagination_contents"}

    {include file="common/pagination.tpl" div_id=$rev}

    {if $logs}
        {if !$is_tab}<form action="{""|fn_url}" method="post" name="cp_sms_logs_list_form">{/if}
        <div class="table-responsive-wrapper">
            <table class="table table--relative table-responsive">
                <thead>
                    <tr>
                        <th width="1%" class="center">{include file="common/check_items.tpl"}</th>
                        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=user&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("sender")}{if $search.sort_by == "user"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="8%"><a class="cm-ajax" href="{"`$c_url`&sort_by=timestamp&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("time")}{if $search.sort_by == "timestamp"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="12%"><a class="cm-ajax" href="{"`$c_url`&sort_by=action&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("action")}{if $search.sort_by == "action"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=phone&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("phone")}{if $search.sort_by == "phone"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="40%">{__("content")}</th>
                    </tr>
                </thead>
                <tbody>
                {foreach from=$logs item="log"}
                <tr>
                    <td width="1%" class="center">
                        <input type="checkbox" name="log_ids[]" value="{$log.log_id}" class="cm-item" />
                    </td>
                    <td data-th="{__("sender")}">
                        {if $log.user_id}
                            <a target="_blank" href="{"profiles.update?user_id=`$log.user_id`"|fn_url}">{$log.lastname}{if $log.firstname}&nbsp;{/if}{$log.firstname}</a>
                        {else}
                            &mdash;
                        {/if}
                    </td>
                    <td data-th="{__("time")}">
                        <span class="nowrap">{$log.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</span>
                    </td>
                    <td data-th="{__("action")}">
                        {if $log.action && $all_actions[$log.action]}
                            {$all_actions[$log.action]}
                        {else}
                            &mdash;
                        {/if}
                    </td>
                    <td data-th="{__("phone")}">
                        {$log.phone}
                    </td>
                    <td data-th="{__("content")}">
                        {$log.content}
                    </td>
                </tr>
                {/foreach}
                </tbody>
            </table>
        </div>
        {if !$is_tab}</form>{/if}
    {else}
        <p class="no-items">{__("no_data")}</p>
    {/if}

    {include file="common/pagination.tpl" div_id=$rev}
<!--content_cp_sms_logs--></div>