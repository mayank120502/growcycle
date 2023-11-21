{capture "mainbox"}
    {if $runtime.mode == "add"}
        {literal}
            <script data-no-defer type="text/javascript">
                //<![CDATA[
                var payout_amounts = new Array();
                var _payout_amounts = new Array();
                var action_amounts = new Array();
                var currencies_symbol = '';

                function fn_replace_payment_amount(partner_id, action_id, check_status)
                {
                    if (typeof(payout_amounts[partner_id]) != 'undefined' && typeof(action_amounts[action_id]) != 'undefined') {
                        payout_amounts[partner_id] += (check_status) ? action_amounts[action_id] : -action_amounts[action_id];
                        Tygh.$('#id_td_amount_'+partner_id).html(currencies_symbol + Tygh.$.formatNum(payout_amounts[partner_id] / Tygh.currencies.secondary.coefficient, 2, false));
                    }
                }
                //]]>
            </script>
        {/literal}
    {/if}

    {if $payouts}
        {foreach $payouts as $user_id => $payout}
            {if $runtime.mode == "add"}
                <script data-no-defer>
                    //<![CDATA[
                    payout_amounts[{$user_id}] = {$payout.amount};
                    _payout_amounts[{$user_id}] = {$payout.amount};
                    currencies_symbol = "{$currencies.$secondary_currency.symbol nofilter}";
                    //]]>
                </script>
                <form action="{""|fn_url}" method="POST" name="payout_{$user_id}_form">
            {/if}

            {include "common/pagination.tpl"}

            {$c_url = $config.current_url|fn_query_remove:"sort_by":"sort_order"}
            {$c_icon = "<i class=\"exicon-{$search.sort_order_rev}\"></i>"}
            {$c_dummy = "<i class=\"exicon-dummy\"></i>"}

            <table class="table table-middle table-responsive sd-affiliates-payout-table">
                <thead>
                    <tr>
                        {if $runtime.mode == "add"}
                            <th width="5%" class="center mobile-hide">
                                {include "common/check_items.tpl" check_onclick="payout_amounts[{$user_id}] = (this.checked) ? _payout_amounts[{$user_id}] : 0.00; Tygh.$('#id_td_amount_{$user_id}').html(currencies_symbol + Tygh.$.formatNum(payout_amounts[{$user_id}], 2, true))"}
                            </th>
                        {/if}

                        <th width="15%">
                            <a class="cm-ajax"
                                href="{"{$c_url}&sort_by=action&sort_order={$search.sort_order_rev}"|fn_url}"
                                data-ca-target-id="pagination_contents"
                            >
                                {__("action")}

                                {if $search.sort_by == "action"}
                                    {$c_icon nofilter}
                                {else}
                                    {$c_dummy nofilter}
                                {/if}
                            </a>
                        </th>
                        <th width="10%">
                            <a class="cm-ajax"
                                href="{"{$c_url}&sort_by=date&sort_order={$search.sort_order_rev}"|fn_url}"
                                data-ca-target-id="pagination_contents"
                            >
                                {__("date")}

                                {if $search.sort_by == "date"}
                                    {$c_icon nofilter}
                                {else}
                                    {$c_dummy nofilter}
                                {/if}
                            </a>
                        </th>
                        <th width="10%" class="nowrap">
                            <a class="cm-ajax"
                                href="{"{$c_url}&sort_by=cost&sort_order={$search.sort_order_rev}"|fn_url}"
                                data-ca-target-id="pagination_contents"
                            >
                                {__("cost")}

                                {if $search.sort_by == "cost"}
                                    {$c_icon nofilter}
                                {else}
                                    {$c_dummy nofilter}
                                {/if}
                            </a>
                        </th>
                        <th width="15%">
                            {__("customer")}

                            {if "MULTIVENDOR"|fn_allowed_for}
                                / {__("vendor")}
                            {else}
                                ({__("ip_address")})
                            {/if}
                        </th>
                        <th width="10%">
                            <a class="cm-ajax{if $search.sort_by == "banner"} sort-link-{$search.sort_order_rev}{/if}"
                                href="{"{$c_url}&sort_by=banner&sort_order={$search.sort_order_rev}"|fn_url}"
                                data-ca-target-id="pagination_contents"
                            >
                                {__("affiliate_banner")}
                            </a>
                        </th>
                        <th width="25%">
                            {__("additional_data")}
                        </th>
                        <th width="15%" class="right">
                            {__("status")}
                        </th>
                    </tr>
                </thead>

                {if $payout.actions}
                    {foreach $payout.actions as $action_id => $action}
                        <tr>
                            {if $runtime.mode == "add"}
                                <td class="mobile-hide">
                                    <script data-no-defer type="text/javascript">
                                        //<![CDATA[
                                        action_amounts[{$action_id}]={$action.amount};
                                        //]]>
                                    </script>

                                    <input type="checkbox"
                                        name="action_ids[{$user_id}][{$action_id}]"
                                        value="Y"
                                        onclick="fn_replace_payment_amount({$user_id}, {$action_id}, this.checked);"
                                        checked="checked"
                                        class="checkbox cm-item" 
                                    />
                                </td>
                           {/if}

                            <td data-th="{__("action")}">
                                &nbsp;<span>{$action.title}</span>
                            </td>
                            <td data-th="{__("date")}">
                                {$action.date|date_format:"{$settings.Appearance.date_format}, {$settings.Appearance.time_format}"}
                            </td>

                            {if !empty($user_type) && $user_type == 'AffiliateUserTypes::PARTNER'|enum}
                                <td data-th="{__("cost")}">
                                    {include "common/price.tpl" value=$action.amount|round:2}
                                </td>
                            {else}
                                <td data-th="{__("cost")}">
                                    {$action.amount|round}
                                </td>
                            {/if}

                            <td data-th="{__("ip_address")}">
                                <ul class="unstyled">
                                    {if $action.action == "new_vendor"}
                                         <a href="{"companies.update&company_id={$action.customer_id}"|fn_url}">
                                            {$action.customer_id|fn_get_company_name}
                                        </a>
                                    {else}
                                        {if $action.customer_firstname || $action.customer_lastname}
                                            <li>
                                                <a href="{"profiles.update?user_id={$action.customer_id}"|fn_url}">
                                                    {$action.customer_firstname} {$action.customer_lastname}
                                                </a>
                                            </li>
                                        {/if}
                                    {/if}

                                    {if $action.ip}
                                        <li>
                                            <em>
                                                ({$action.ip})
                                            </em>
                                        </li>
                                    {/if}
                                </ul>
                            </td>
                            <td data-th="{__("affiliate_banner")}">
                                {if $action.banner}
                                    <a href={"banners_manager.update?banner_id={$action.banner_id}"|fn_url}>
                                        {$action.banner}
                                    </a>
                                {else}
                                    &nbsp;&nbsp;---&nbsp;
                                {/if}
                            </td>
                            <td data-th="{__("additional_data")}">
                                {include "addons/sd_affiliate/views/payouts/components/additional_data.tpl"
                                    data=$action.data
                                    assign="additional_data"
                                }

                                {if $additional_data|trim}
                                    {$additional_data nofilter}
                                {else}
                                    &nbsp;&nbsp;---&nbsp;
                                {/if}
                            </td>
                            <td class="right" data-th="{__("status")}">
                                {if $action.payout_id}
                                    {__("paidup")}
                                {elseif $action.approved == "Y"}
                                    {__("approved")}
                                {else}
                                    &nbsp;&nbsp;---&nbsp;
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                {else}
                    <tr class="no-items" data-th="{__("count")}">
                        <td colspan="{if $runtime.mode == "add"}8{else}7{/if}">
                            <p>
                                {__("no_items")}
                            </p>
                        </td>
                    </tr>
                {/if}
            </table>

            {include "common/pagination.tpl"}

            {capture "buttons"}
                {if $runtime.mode == "add"}
                    {include "buttons/save_cancel.tpl"
                        but_text=__("affiliate_add_payout")
                        hide_second_button=true
                        but_name="dispatch[payouts.m_add_payouts]"
                        but_role="submit-link"
                        but_target_form="payout_{$user_id}_form"
                    }
                {else}
                    {include "common/view_tools.tpl" url="payouts.update?payout_id="}
                {/if}
            {/capture}

            {capture "sidebar"}
                <div class="sidebar-row">
                    <h6>
                        {__("information")}
                    </h6>
                    <dl>
                        <dt>
                            {__("affiliate")}
                        </dt>
                        <dd>
                            {if $payout.partner.partner_exists}
                                <a href="{"profiles.update?user_id={$user_id}&user_type={$payout.partner.user_type}"|fn_url}">
                                    {$payout.partner.affiliate}
                                </a>
                            {else}
                                {$payout.partner.affiliate}
                            {/if}
                        </dd>
                        <dt>
                            {__("email")}
                        </dt>
                        <dd>
                            {$payout.partner.email}
                        </dd>
                        <dt>
                            {__("plan")}
                        </dt>
                        <dd>
                            <a href="{"affiliate_plans.update?plan_id={$payout.plan.plan_id}&plan_type={$user_type}"|fn_url}">
                                {$payout.plan.name}
                            </a>
                        </dd>

                        {if $payout.plan && $runtime.mode == "add"}
                            <dt>
                                {__("minimum_commission_payment")}
                            </dt>
                            <dd>
                                {include "common/price.tpl" value=$payout.plan.min_payment}
                            </dd>
                        {/if}

                        <dt>
                            {__("chart_period")}
                        </dt>
                        <dd>
                            {$payout.date_range.min|date_format:$settings.Appearance.date_format}
                            &nbsp;-&nbsp;{$payout.date_range.max|date_format:$settings.Appearance.date_format}
                        </dd>
                        <dt>
                            {__("amount")}
                        </dt>

                        {if !empty($user_type) && $user_type == 'AffiliateUserTypes::PARTNER'|enum}
                            <dd>
                                <span id="id_td_amount_{$user_id}">
                                    {include "common/price.tpl" value=$payout.amount}
                                </span>
                            </dd>
                        {else}
                            <dd>
                                <span id="id_td_amount_{$user_id}">
                                    {$payout.amount|round}
                                </span>
                            </dd>
                        {/if}
                    </dl>
                </div>
                <hr>
            {/capture}
            </form>

            {if !$payout@last}<hr />{/if}
        {/foreach}
    {/if}
{/capture}

{include "common/mainbox.tpl"
    title=__("payout")
    content=$smarty.capture.mainbox
    sidebar=$smarty.capture.sidebar
    buttons=$smarty.capture.buttons
}
