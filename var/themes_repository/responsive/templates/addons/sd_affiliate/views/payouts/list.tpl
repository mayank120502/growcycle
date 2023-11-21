{include file="addons/sd_affiliate/common/affiliate_menu.tpl"}
{include file="addons/sd_affiliate/views/payouts/components/payout_search.tpl"}

{include file="common/pagination.tpl"}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{if $search.sort_order_rev == "asc"}
{assign var="sort_sign" value="<i class=\"ty-icon-down-dir\"></i>"}
{else}
{assign var="sort_sign" value="<i class=\"ty-icon-up-dir\"></i>"}
{/if}
{if !$config.tweaks.disable_dhtml}
    {assign var="ajax_class" value="cm-ajax"}
{/if}

<table class="ty-table ty-table-width">
    <thead>
        <tr>
            <th>{__("id")}</th>
            <th width="20%">{__("affiliate")}</th>
            <th width="15%"><a class="{$ajax_class}" href="{"`$c_url`&sort_by=amount&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("amount")}</a>{if $search.sort_by == "amount"}{$sort_sign nofilter}{/if}</th>
            <th width="15%"><a class="{$ajax_class}" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("date")}</a>{if $search.sort_by == "date"}{$sort_sign nofilter}{/if}</th>
            <th width="20%"><a class="{$ajax_class}" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("status")}</a>{if $search.sort_by == "status"}{$sort_sign nofilter}{/if}</th>
            <th width="10%">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$payouts key="payout_id" item="payout"}
        <tr {cycle values=",class=\"table-row\""}>
            <td>{$payout.partner_id}</td>
            <td>{if !empty($payout.lastname) || !empty($payout.firstname)}{$payout.firstname} {$payout.lastname}{else} - {/if}</td>
            <td class="right">{include file="common/price.tpl" value=$payout.amount}</td>
            <td class="center">{$payout.date|date_format:"`$settings.Appearance.date_format` `$settings.Appearance.time_format`"}</td>
            <td class="center">
                    {if $payout.status=="O"}{__("open")}{else}{__("successful")}{/if}
            </td>
            <td class="right">
                {include file="buttons/button.tpl" but_text=__("details") but_href="`$runtime.controller`.update?payout_id=`$payout_id`" but_role="text"}
            </td>
        </tr>
        {foreachelse}
        <tr>
            <td colspan="{if $settings.General.use_email_as_login != "Y"}6{else}6{/if}"><p class="ty-no-items">{__("no_payouts_found")}</p></td>
        </tr>
        {/foreach}
    </tbody>
</table>

{include file="common/pagination.tpl"}

{capture name="mainbox_title"}
    {__(affiliates_partnership)} <span class="subtitle">/ {__("payouts")}</span>
{/capture}
