{include file="addons/sd_affiliate/common/affiliate_menu.tpl"}
{include file="addons/sd_affiliate/views/aff_statistics/components/stat_search_form.tpl"}

<div id="general_statistics" class="general-statistics">
    <table class="ty-table">
        <thead>
            <tr>
                <th style="width: 40%">{__("action")}</th>
                <th style="width: 20%">{__("count")}</th>
                <th style="width: 20%">{__("sum")}</th>
                <th style="width: 20%">{__("avg")}</th>
            </tr>
        </thead>
        {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum}
            <tbody>
                {if $general_stats}
                    {foreach from=$payout_types key="payout_id" item="a"}
                        {assign var="payout" value=$general_stats.$payout_id}
                        {assign var="payout_var" value=$a.title}
                        {if $payout.count}
                            <tr>
                                <td><strong>{__($payout_var)}</strong></td>
                                <td>{$payout.count|default:"0"}</td>
                                <td>{include file="common/price.tpl" value=$payout.sum|round:2}</td>
                                <td>{include file="common/price.tpl" value=$payout.avg|round:2}</td>
                            </tr>
                        {/if}
                    {/foreach}

                    {if $general_stats.total}
                        {assign var="payout" value=$general_stats.total}
                        <tr>
                            <td><strong>{__("total")}</strong></td>
                            <td><strong>{$payout.count|default:"0"}</strong></td>
                            <td><strong>{include file="common/price.tpl" value=$payout.sum|round:2}</strong></td>
                            <td><strong>{include file="common/price.tpl" value=$payout.avg|round:2}</strong></td>
                        </tr>
                    {/if}
                {else}
                    <tr class="ty-table__no-items">
                        <td colspan="4"><p class="ty-no-items">{__("no_data_found")}</p></td>
                    </tr>
                {/if}
            </tbody>
        {else}
            <tbody>
                {if $general_stats}
                    {foreach from=$payout_types key="payout_id" item="a"}
                        {assign var="payout" value=$general_stats.$payout_id}
                        {assign var="payout_var" value=$a.title}
                        {if $payout.count}
                            <tr>
                                <td><strong>{__($payout_var)}</strong></td>
                                <td>{$payout.count|default:"0"}</td>
                                <td>{$payout.sum|round}</td>
                                <td>{$payout.avg|round}</td>
                            </tr>
                        {/if}
                    {/foreach}

                    {if $general_stats.total}
                        {assign var="payout" value=$general_stats.total}
                        <tr>
                            <td><strong>{__("total")}</strong></td>
                            <td><strong>{$payout.count|default:"0"}</strong></td>
                            <td><strong>{$payout.sum|round}</strong></td>
                            <td><strong>{$payout.avg|round}</strong></td>
                        </tr>
                    {/if}
                {else}
                    <tr class="ty-table__no-items">
                        <td colspan="4"><p class="ty-no-items">{__("no_data_found")}</p></td>
                    </tr>
                {/if}
            </tbody>
        {/if}
    </table>
    {if $additional_stats && $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum}
        <div class="clearfix affiliate-plan-block">
            <table class="affiliate-plan__table">
                {foreach from=$additional_stats key="a_stats_name" item="a_stats_value" name="additional_stat"}
                    <tr class="affiliate-plan__row">
                        <td>{__($a_stats_name)}:</td>
                        <td style="width: 57%">{$a_stats_value}</td>
                    </tr>
                {/foreach}
            </table>
        </div>
    {elseif $auth.user_type == 'AffiliateUserTypes::CUSTOMER'|enum}
        <h1 class="ty-mt-s">{__("addons.sd_affiliate.commissions_details")}</h1>
    {/if}
</div>

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

{if $addons.sd_affiliate.show_attracted_users_ip === 'Y'}
    {$show_customer_ip = true}
{/if}

<table class="ty-table commissions-table">
    <thead>
        <tr>
            <th width="30%">
                <a class="{$ajax_class}"
                    href="{fn_url("{$c_url}&sort_by=action&sort_order={$search.sort_order_rev}")}"
                    data-ca-target-id="pagination_contents"
                >
                    {__("action")}
                </a>

                {if $search.sort_by == "action"}
                    {$sort_sign nofilter}
                {/if}
            </th>

            {if fn_allowed_for("MULTIVENDOR") && $addons.sd_affiliate.show_vendor_to_affiliate == "Y"}
                <th width="15%">
                    {__("vendor")}
                </th>
            {/if}

            <th width="16%">
                <a class="{$ajax_class}"
                    href="{fn_url("{$c_url}&sort_by=date&sort_order={$search.sort_order_rev}")}"
                    data-ca-target-id="pagination_contents"
                >
                    {__("date")}
                </a>

                {if $search.sort_by == "date"}
                    {$sort_sign nofilter}
                {/if}

            </th>
            <th width="11%">
                <a class="{$ajax_class}"
                    href="{fn_url("{$c_url}&sort_by=cost&sort_order={$search.sort_order_rev}")}"
                    data-ca-target-id="pagination_contents"
                >
                    {__("cost")}
                </a>

                {if $search.sort_by == "cost"}
                    {$sort_sign nofilter}
                {/if}
            </th>
            <th width="12%">
                {if fn_allowed_for("MULTIVENDOR")}
                    {__("customer")}/{__("vendor")}
                {else}
                    <a class="{$ajax_class}"
                        href="{fn_url("{$c_url}&sort_by=customer&sort_order={$search.sort_order_rev}")}"
                        data-ca-target-id="pagination_contents"
                    >
                        {__("customer")}
                    </a>

                    {if $search.sort_by == "customer"}
                        {$sort_sign nofilter}
                    {/if}
                {/if}

            </th>
            {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum}
                <th width="10%">
                    <a class="{$ajax_class}"
                        href="{fn_url("{$c_url}&sort_by=banner&sort_order={$search.sort_order_rev}")}"
                        data-ca-target-id="pagination_contents"
                    >
                        {__("affiliate_banner")}
                    </a>

                    {if $search.sort_by == "banner"}
                        {$sort_sign nofilter}
                    {/if}
                </th>
            {/if}

            <th width="9%">
                <a class="{$ajax_class}"
                    href="{fn_url("{$c_url}&sort_by=status&sort_order={$search.sort_order_rev}")}"
                    data-ca-target-id="pagination_contents"
                >
                    {__("status")}
                </a>

                {if $search.sort_by == "status"}
                    {$sort_sign nofilter}
                {/if}
            </th>

            <th width="12%" class="center">
                <i id="on_st"
                    class="icon-right-dir dir-list cm-combinations-commissions"
                    title="{__("expand_collapse_list")}"
                ></i>
                <i id="off_st"
                    class="icon-down-dir dir-list hidden cm-combinations-commissions"
                    title="{__("expand_collapse_list")}"
                ></i>
                {__("extra")}

            </th>
        </tr>
    </thead>

    {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum}
        <tbody>
            {foreach $list_stats as $row_stats}
                {include "addons/sd_affiliate/views/aff_statistics/components/additional_data.tpl"
                    data=$row_stats.data
                    assign="additional_data"
                }

                <tr {if $smarty.foreach.commissions.iteration is even}class="alt-row"{/if}>
                    <td>
                        <strong>{$row_stats.title}{$action_title}</strong>
                    </td>
                    {if fn_allowed_for("MULTIVENDOR") && $addons.sd_affiliate.show_vendor_to_affiliate == "Y"}
                        <td>
                            {if $row_stats.vendor_data.company && $row_stats.vendor_data.company_id}
                                <a href="{fn_url("companies.products?company_id={$row_stats.vendor_data.company_id}")}">
                                    {$row_stats.vendor_data.company}
                                </a>
                            {else}
                                -
                            {/if}
                        </td>
                    {/if}

                    <td>
                        {$row_stats.date|date_format:"{$settings.Appearance.date_format}, {$settings.Appearance.time_format}"}
                    </td>
                    <td class="ty-right">
                        {include "common/price.tpl" value=$row_stats.amount|round:2}
                        {$action_amount}
                    </td>
                    <td>
                        {if $row_stats.action == 'new_vendor'}
                            {fn_get_company_name($row_stats.customer_id)}
                        {else}
                            {$row_stats.customer_lastname} {$row_stats.customer_firstname}
                        {/if}

                        {if $row_stats.ip && $show_customer_ip}
                            <p><em>({$row_stats.ip})</em></p>
                        {/if}
                    </td>
                    <td>
                        {if $row_stats.banner}
                            <a href="{fn_url("banners_manager.update?banner_type={$row_stats.banner_type}&banner_id={$row_stats.banner_id}")}">
                                {$row_stats.banner}
                            </a>
                        {else}
                            &nbsp;&nbsp;---&nbsp;
                        {/if}
                    </td>
                    <td>
                        {if $row_stats.payout_id}
                            {__("paidup")}
                        {elseif $row_stats.approved=="Y"}
                            {__("approved")}
                        {elseif $row_stats.amount > 0}
                            {__("awaiting_approval")}
                        {else}
                            &nbsp;&nbsp;---&nbsp;
                        {/if}
                    </td>
                    <td class="ty-center nowrap">
                        {if $row_stats.extra_data || $additional_data|strip_tags|trim}
                            <a id="sw_commission_{$smarty.foreach.commissions.iteration}" class="cm-combination-commissions">
                                <i id="on_commission_{$smarty.foreach.commissions.iteration}"
                                    class="icon-right-dir dir-list cm-combination-commissions"
                                    title="{__("expand_collapse_list")}"
                                ></i>
                                <i id="off_commission_{$smarty.foreach.commissions.iteration}"
                                    class="icon-down-dir dir-list hidden cm-combination-commissions"
                                    title="{__("expand_collapse_list")}"
                                ></i>
                                {__("extra")}
                            </a>
                        {else}
                            &nbsp;
                        {/if}
                    </td>
                </tr>

                {if $row_stats.extra_data || $additional_data|trim}
                    <tr id="commission_{$smarty.foreach.commissions.iteration}" class="{$row_class_name} extra-row hidden">
                        <td colspan="10">
                            {if $row_stats.extra_data}
                                <table class="ty-table sortable table-width commissions-table-extra">
                                    <thead>
                                        <tr>
                                            <th style="width: 25%">
                                                {__("action")}
                                            </th>

                                            <th style="width: 10%">
                                                {__("cost")}
                                            </th>
                                            <th>
                                                {__("affiliate")}
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $row_stats.extra_data as $r_action}
                                            <tr>
                                                <td>
                                                    {if $r_action.action_id == $row_stats.action_id}<strong>{/if}

                                                    {$r_action.title}

                                                    {if $r_action.tier}
                                                        ({$r_action.tier} {__("tier_account")})
                                                    {/if}

                                                    {if $r_action.action_id == $row_stats.action_id}</strong>{/if}
                                                </td>
                                                <td>
                                                    {include "common/price.tpl" value=$r_action.amount|round:2}
                                                </td>
                                                <td>
                                                    {$r_action.affiliate}
                                                </td>
                                            <tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            {/if}

                            {if $additional_data|strip_tags|trim}
                                <div class="commissions-additional">
                                    <p>{__("additional_data")}:</p>
                                    {$additional_data nofilter}
                                </div>
                            {/if}
                        </td>
                    </tr>
                {/if}
            {foreachelse}
                <tr class="ty-table__no-items">
                    <td colspan="10">
                        <p class="ty-no-items">
                            {__("no_data_found")}
                        </p>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    {else}
        <tbody>
            {foreach $list_stats as $row_stats}
                {include "addons/sd_affiliate/views/aff_statistics/components/additional_data.tpl"
                    data=$row_stats.data
                    assign="additional_data"
                }

                <tr {if $smarty.foreach.commissions.iteration is even}class="alt-row"{/if}>
                    <td>
                        <strong>{$row_stats.title}{$action_title}</strong>
                    </td>
                    <td>
                        {$row_stats.date|date_format:"{$settings.Appearance.date_format}, {$settings.Appearance.time_format}"}
                    </td>
                    <td class="ty-right">
                        {$row_stats.amount|round}{$action_amount}
                    </td>
                    <td>
                        {if $row_stats.action == "new_vendor"}
                            {fn_get_company_name($row_stats.customer_id)}
                        {else}
                            {$row_stats.customer_lastname} {$row_stats.customer_firstname}
                        {/if}

                        {if $row_stats.ip && $show_customer_ip}
                            <p><em>({$row_stats.ip})</em></p>
                        {/if}
                    </td>
                    <td>
                        {if $row_stats.approved == "Y" && $row_stats.payout_id}
                            {__("paidup")}
                        {elseif $row_stats.amount > 0}
                            {__("awaiting_approval")}
                        {else}
                            &nbsp;&nbsp;---&nbsp;
                        {/if}
                    </td>
                    <td class="ty-center nowrap">
                        {if $row_stats.extra_data || $additional_data|strip_tags|trim}
                            <a id="sw_commission_{$smarty.foreach.commissions.iteration}" class="cm-combination-commissions">
                                <i id="on_commission_{$smarty.foreach.commissions.iteration}"
                                    class="icon-right-dir dir-list cm-combination-commissions"
                                    title="{__("expand_collapse_list")}"
                                ></i>
                                <i id="off_commission_{$smarty.foreach.commissions.iteration}"
                                    class="icon-down-dir dir-list hidden cm-combination-commissions"
                                    title="{__("expand_collapse_list")}"
                                ></i>
                                {__("extra")}
                            </a>
                        {else}
                            &nbsp;
                        {/if}
                    </td>
                </tr>

                {if $row_stats.extra_data || $additional_data|trim}
                    <tr id="commission_{$smarty.foreach.commissions.iteration}" class="{$row_class_name} extra-row hidden">
                        <td colspan="10">
                            {if $row_stats.extra_data}
                                <table class="ty-table sortable table-width commissions-table-extra">
                                    <thead>
                                        <tr>
                                            <th style="width: 25%">{__("action")}</th>
                                            <th style="width: 10%">{__("cost")}</th>
                                            <th>{__("affiliate")}</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $row_stats.extra_data as $r_action}
                                            <tr>
                                                <td>
                                                    {if $r_action.action_id == $row_stats.action_id}<strong>{/if}

                                                    {$r_action.title}

                                                    {if $r_action.tier}
                                                        ({$r_action.tier} {__("tier_account")})
                                                    {/if}

                                                    {if $r_action.action_id == $row_stats.action_id}</strong>{/if}
                                                </td>
                                                <td>
                                                    {$r_action.amount|round}
                                                </td>
                                                <td>
                                                    {$r_action.affiliate}
                                                </td>
                                            <tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            {/if}

                            {if $additional_data|strip_tags|trim}
                                <div class="commissions-additional">
                                    <p>{__("additional_data")}:</p>
                                    {$additional_data nofilter}
                                </div>
                            {/if}
                        </td>
                    </tr>
                {/if}
            {foreachelse}
                <tr class="ty-table__no-items">
                    <td colspan="10"><p class="ty-no-items">{__("no_data_found")}</p></td>
                </tr>
            {/foreach}
        </tbody>
    {/if}
</table>

{include "common/pagination.tpl"}

{capture "mainbox_title"}
    {__(affiliates_partnership)} <span class="subtitle">/ {__("sd_affiliate.commissions")}</span>
{/capture}
