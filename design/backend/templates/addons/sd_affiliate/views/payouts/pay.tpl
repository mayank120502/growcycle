{capture name="mainbox"}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}

{capture name="sidebar"}
<div class="sidebar-row">
    <h6>{__("search")}</h6>
    <form action="{""|fn_url}" method="get" name="filter_form">
        <div class="sidebar-field">
            <label for="elm_amount_from">{__("payment_amount")} ({$currencies.$primary_currency.symbol nofilter}):</label>
            <input type="text" name="amount_from" id="elm_amount_from" value="{$search.amount_from}" size="8" class="input-small" /> &ndash; <input type="text" name="amount_to" value="{$search.amount_to}" size="8" class="input-small" />
        </div>
        <div class="sidebar-field">
            <label for="elm_min_payment" class="checkbox">
                <input type="checkbox" name="min_payment" id="elm_min_payment" value="Y" {if $search.min_payment == "Y"}checked="checked"{/if} />
                {__("checking_min_payment")}
            </label>
        </div>
        <div class="sidebar-field">
            <label for="elm_last_payout" class="checkbox">
            <input type="checkbox" name="last_payout" id="elm_last_payout" value="Y" {if $search.last_payout == "Y"}checked="checked"{/if} />
            {__("checking_payment_period")} ({$period_name})</label>
        </div>
        <div class="sidebar-field">
            {include file="buttons/search.tpl" but_name="dispatch[payouts.pay]"}
        </div>
    </form>
</div>
{/capture}

<form action="{""|fn_url}" method="post" name="pay_affiliates_form">

    {include file="common/pagination.tpl"}

    {if $partner_balances}
        <table width="100%" class="table table-middle table-responsive">
            <thead>
                <tr>
                    <th class="left mobile-hide">
                        {include file="common/check_items.tpl"}</th>
                    <th><a class="cm-ajax" href="{"`$c_url`&sort_by=user_id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("id")}{if $search.sort_by == "user_id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                    <th><a class="cm-ajax" href="{"`$c_url`&sort_by=partner&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("affiliate")}{if $search.sort_by == "partner"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                    <th><a class="cm-ajax" href="{"`$c_url`&sort_by=amount&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("amount_of_approved_actions")}{if $search.sort_by == "amount"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                    <th>{__("amount_of_awaiting_approval_actions")}</th>
                    <th><a class="cm-ajax" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("date_of_last_payment")}{if $search.sort_by == "date"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                </tr>
            </thead>
            {foreach from=$partner_balances key="user_id" item="partner"}
                <tr>
                    <td class="left"><input type="checkbox" name="partner_ids[]" value="{$user_id}" class="cm-item mobile-hide" /></td>
                    <td data-th="{__("id")}">
                        {if $partner.partner_exists}
                            <a href="{"profiles.update?user_id=`$partner.partner_id`&user_type=`$partner.user_type`"|fn_url}">{$partner.partner_id}</a>
                        {else}
                            {$partner.partner_id}
                        {/if}
                    </td>
                    <td data-th="{__("affiliate")}">{if $partner.partner_exists}
                            <a href="{"profiles.update?user_id=`$partner.partner_id`&user_type=`$partner.user_type`"|fn_url}">{$partner.affiliate}</a>
                        {else}
                            {$partner.affiliate}
                        {/if}
                    </td>
                    <td data-th="{__("amount_of_approved_actions")}">{include file="common/price.tpl" value=$partner.amount} (<a href="{"aff_statistics.approve?partner_id=`$partner.partner_id`&status[]=A"|fn_url}">{__("details")}</a>)</td>
                    <td data-th="{__("amount_of_awaiting_approval_actions")}">{include file="common/price.tpl" value=$partner.awaiting_amount}{if $partner.awaiting_amount} (<a href="{"aff_statistics.approve?partner_id=`$partner.partner_id`&status[]=N"|fn_url}">{__("details")}</a>){/if}</td>
                    <td data-th="{__("date_of_last_payment")}">{if $partner.last_payout_date}{$partner.last_payout_date|date_format:$settings.Appearance.date_format}{else}&nbsp;---{/if}</td>
                    <td class="nowrap" data-th="{__("action")}">
                        <div class="hidden-tools">
                            {capture name="tools_list"}
                                <li>{btn type="list" text=__("addons.sd_affiliate.pay_affiliate") href="payouts.pay_affiliate?partner_id={$partner.partner_id}&company_id={$partner.company_id}" method="POST"}</li>
                            {/capture}
                            {dropdown content=$smarty.capture.tools_list}
                        </div>
                    </td>
                    <td class="right">
                        {include file="buttons/button.tpl" but_role="edit" but_text=__("details") but_href="payouts.add?partner_ids[]=$user_id"}
                    </td>
                </tr>
            {/foreach}
        </table>
    {else}
        <p class="no-items">{__("no_data")}</p>
    {/if}

    {include file="common/pagination.tpl"}

    {capture name="buttons"}
        {if $partner_balances && $runtime.company_id}
            {include file="buttons/button.tpl" but_text=__("pay_affiliates") but_name="dispatch[payouts.do_m_pay_affiliates]" but_meta="btn-primary cm-process-items" but_role="submit-link" but_target_form="pay_affiliates_form"}
        {/if}
    {/capture}

</form>
{/capture}
{include file="common/mainbox.tpl" title=__("pay_affiliates") content=$smarty.capture.mainbox sidebar=$smarty.capture.sidebar buttons=$smarty.capture.buttons}
