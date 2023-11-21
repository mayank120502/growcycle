{include file="addons/sd_affiliate/common/affiliate_menu.tpl"}
<div class="affiliate">
    <div class="clearfix affiliate-plan-block">
        <div class="ty-affiliate-table-wrapper">
            {include file="common/subheader.tpl" title=__("affiliate_information")}
            <table class="ty-affiliate-summary__table">
                <tr class="ty-affiliate-summary__row">
                    <td>{__("status")}:</td>
                    <td>{if $partner.approved=="A"}{__("approved")}{elseif $partner.approved=="D"}{__("declined")}{else}{__("awaiting_approval")}{/if}</td>
                </tr>
                {if $partner.plan}
                    <tr class="ty-affiliate-summary__row">
                        <td>{__("affiliate_plan")}:</td>
                        <td><a href="{"affiliate_plans.list"|fn_url}">{$partner.plan}</a></td>
                    </tr>
                {/if}

                {if $partner.balance}
                    <tr class="ty-affiliate-summary__row">
                        <td>{__("balance_account")}:</td>
                        <td>{include file="common/price.tpl" value=$partner.balance}</td>
                    </tr>
                {/if}

                <tr class="ty-affiliate-summary__row">
                    <td>{__("total_payouts")}:</td>
                    <td>{include file="common/price.tpl" value=$partner.total_payouts}{if $partner.total_payouts} (<a href="{"payouts.list"|fn_url}">{__("view")}</a>){/if}</td>
                </tr>
            </table>
        </div>

        <div class="ty-affiliate-table-wrapper">
            {include file="common/subheader.tpl" title=__("sd.affiliate.commissions_of_last_periods")}
            {assign var="user_info" value=$auth.user_id|fn_get_user_info}
            {assign var="user_data_register" value=$user_info.timestamp}
            <table class="ty-affiliate-summary__table">
                {foreach from=$last_payouts item=period name=last_payout}
                    {if $period.range.end >= $user_data_register}
                        <tr class="ty-affiliate-summary__row">
                            <td {if $smarty.foreach.last_payout.first}class="no-border"{/if}>
                                {if !empty($period.amount)}
                                    <a href="{"aff_statistics.commissions?action=search&statistic_search[partner_id]=`$partner.user_id`&statistic_search[status][A]=A&statistic_search[status][P]=P&period=C&time_from=`$period.range.start`&time_to=`$period.range.end`"|fn_url}">{$period.range.start|date_format:$settings.Appearance.date_format}</a>
                                {else}
                                    {$period.range.start|date_format:$settings.Appearance.date_format}
                                {/if}
                            </td>
                            <td {if $smarty.foreach.last_payout.first}class="no-border"{/if}>{include file="common/price.tpl" value=$period.amount}</td>
                        </tr>
                    {/if}
                {/foreach}
                <tr class="ty-affiliate-summary__row">
                    <td>{__("total_commissions")}:</td>
                    <td><strong>{include file="common/price.tpl" value=$total_commissions}</strong></td>
                </tr>
            </table>
        </div>
    </div>
    <div class="ty-affiliate-table-wrapper" style="min-width:20%">
        {include file="addons/sd_affiliate/views/partners/components/partner_tree_root.tpl" partners=$partners}
    </div>

</div>
{capture name="mainbox_title"}
    {__(affiliates_partnership)} <span class="subtitle">/ {__("balance_account")}</span>
{/capture}
