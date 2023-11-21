{capture name="mainbox"}
    {include file="common/pagination.tpl"}
    {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
    {assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
    {assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}
    <form action="{""|fn_url}" method="post" name="payouts_previous_form">
        <input id="selected_section" type="hidden" name="selected_section" value="" />
        {if $payouts}
            <table width="100%" class="table table-middle table-responsive">
                <thead>
                    <tr>
                        <th width="10%"><a class="cm-ajax" href="{"`$c_url`&sort_by=user_id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("id")}{if $search.sort_by == "user_id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("affiliate")}{if $search.sort_by == "name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        {if $user_type == 'AffiliateUserTypes::PARTNER'|enum}
                            <th width="20%"><a class="cm-ajax" href="{"`$c_url`&sort_by=balance&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("balance_account")}{if $search.sort_by == "balance"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        {/if}
                        <th width="15%">{__("last_payout")}</th>
                        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=avg&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("avg_payout")}{if $search.sort_by == "avg"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="15%" colspan="2"><a class="cm-ajax" href="{"`$c_url`&sort_by=total&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("total_payouts")}{if $search.sort_by == "total"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="10%">&nbsp;</th>
                    </tr>
                </thead>
                {foreach from=$payouts key="user_id" item="payouts_data"}
                    <tr>
                        <td data-th="{__("id")}">
                            {if $payouts_data.partner_exists}
                                <a href="{"profiles.update?user_id=`$payouts_data.partner_id`&user_type=`$payouts_data.user_type`"|fn_url}">{$payouts_data.partner_id}</a>
                            {else}
                                {$payouts_data.partner_id}
                            {/if}
                        </td>
                        <td data-th="{__("affiliate")}">
                            {if $payouts_data.partner_exists}
                                <a href="{"profiles.update?user_id=`$payouts_data.partner_id`&user_type=`$payouts_data.user_type`"|fn_url}">{$payouts_data.affiliate}</a>
                            {else}
                                {$payouts_data.affiliate}
                            {/if}
                        </td>
                        {if $user_type == 'AffiliateUserTypes::PARTNER'|enum}
                            <td data-th="{__("balance_account")}">{include file="common/price.tpl" value=$payouts_data.balance}</td>
                            <td data-th="{__("last_payout")}">{include file="common/price.tpl" value=$payouts_data.last_amount}</td>
                            <td data-th="{__("avg_payout")}">{include file="common/price.tpl" value=$payouts_data.avg_amount}</td>
                            <td width="10%" data-th="{__("total_payouts")}">{include file="common/price.tpl" value=$payouts_data.total_amount}</td>
                        {else}
                            <td data-th="{__("last_payout")}">{$payouts_data.last_amount|round}</td>
                            <td data-th="{__("avg_payout")}">{$payouts_data.avg_amount|round}</td>
                            <td width="10%" data-th="{__("total_payouts")}">{$payouts_data.total_amount|round}</td>
                        {/if}
                        <td class="progress-small">
                            {math equation="amount/max*width_perc" width_perc=100 max=$max_amount amount=$payouts_data.total_amount assign="w" format="%d"}
                            {include file="views/sales_reports/components/graph_bar.tpl" bar_width="70px" value_width=$w}
                        </td>
                        <td class="right nowrap">
                            {include file="buttons/button.tpl" but_role="tool" but_text=__("view_history") but_href="payouts.manage?partner_id=`$payouts_data.partner_id`&user_type=`$user_type`"}
                        </td>
                    </tr>
                {/foreach}
            </table>
        {else}
            <p class="no-items">{__("no_data")}</p>
        {/if}
    </form>
    {include file="common/pagination.tpl"}
{/capture}
{include file="common/mainbox.tpl" title=__("accounting_history") content=$smarty.capture.mainbox}
