{if $smarty.const.ACCOUNT_TYPE == "admin"
 && fn_check_view_permissions("logs.manage")}
    <li>
        {$search_shard = "ti={$order_info.order_id}& {$smarty.const.MEASUREMENT_GA_URI}"|escape:"url"}

        {btn type="list"
            text=__("sd_google_analytics.view_ga_logs")
            href="logs.manage?q_type=requests&q_content={$search_shard}"
            class="cm-new-window"
        }
    </li>

    <li>
        {$search_shard = "# {$order_info.order_id}"|escape:"url"}

        {btn type="list"
            text=__("sd_google_analytics.view_order_logs")
            href="logs.manage?q_type=orders&q_content={$search_shard}"
            class="cm-new-window"
        }
    </li>
{/if}