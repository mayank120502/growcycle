{capture name="mainbox"}
    {capture name="tabsbox"}
        {$c_url = $config.current_url|fn_query_remove:"sort_by":"sort_order"}
        {$c_icon = "<i class=\"exicon-{$search.sort_order_rev}\"></i>"}
        {$c_dummy = "<i class=\"exicon-dummy\"></i>"}

        <form action="{""|fn_url}" method="post" name="commissions_approve_form">
            <div id="content_general" class="table-responsive-wrapper">
                <div id="aff_stats_list">
                    <input id="selected_section" type="hidden" name="selected_section" value="" />
                    {include file="common/pagination.tpl"}

                    {if $affiliate_commissions}
                        <div class="sd-affiliates-container">
                            <table class="table table-middle table-responsive">
                                <thead>
                                    <tr>
                                        <th class="left approve_commissions-check-items mobile-hide">
                                            {include file="common/check_items.tpl"}
                                        </th>
                                        {if $row_stats.extra_data || $additional_data|trim}
                                            <th class="approve_commissions-check-items">
                                                <span name="plus_minus" id="on_st" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand cm-combinations-commissions"> <span class="exicon-expand"></span> </span><span name="minus_plus" id="off_st" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand hidden cm-combinations-commissions"> <span class="exicon-collapse"></span> </span>
                                            </th>
                                        {/if}
                                        <th class="approve_commissions-columns"><a class="cm-ajax" href="{"{$c_url}&sort_by=action&sort_order={$search.sort_order_rev}"|fn_url}" data-ca-target-id="pagination_contents">{__("action")}{if $search.sort_by == "action"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                                        <th class="approve_commissions-columns"><a class="cm-ajax" href="{"{$c_url}&sort_by=date&sort_order={$search.sort_order_rev}"|fn_url}" data-ca-target-id="pagination_contents">{__("date")}{if $search.sort_by == "date"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                                        <th class="approve_commissions-columns"><a class="cm-ajax" href="{"{$c_url}&sort_by=cost&sort_order={$search.sort_order_rev}"|fn_url}" data-ca-target-id="pagination_contents">{__("cost")}{if $search.sort_by == "cost"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                                        <th class="approve_commissions-columns">{if "MULTIVENDOR"|fn_allowed_for}{__("customer")}/{__("vendor")}{else}<a class="cm-ajax" href="{"$c_url&sort_by=customer&sort_order={$search.sort_order_rev}"|fn_url}" data-ca-target-id="pagination_contents">{__("customer")}{if $search.sort_by == "customer"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a>{/if}</th>
                                        <th class="approve_commissions-columns"><a class="cm-ajax" href="{"{$c_url}&sort_by=partner&sort_order={$search.sort_order_rev}"|fn_url}" data-ca-target-id="pagination_contents">{__("affiliate")}{if $search.sort_by == "partner"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                                        <th class="approve_commissions-columns"><a class="cm-ajax" href="{"{$c_url}&sort_by=banner&sort_order={$search.sort_order_rev}"|fn_url}" data-ca-target-id="pagination_contents">{__("affiliate_banner")}{if $search.sort_by == "banner"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                                        <th>&nbsp;</th>
                                        <th class="approve_commissions-columns" class="right"><a class="cm-ajax" href="{"{$c_url}&sort_by=status&sort_order={$search.sort_order_rev}"|fn_url}" data-ca-target-id="pagination_contents">{if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}{__("status")}</a></th>
                                    </tr>
                                </thead>

                                {foreach $affiliate_commissions as $row_stats name="commissions"}
                                    <tbody class="hover">
                                        {include file="addons/sd_affiliate/views/payouts/components/additional_data.tpl" data=$row_stats.data assign="additional_data"}
                                        <tr>
                                            <td class="mobile-hide">
                                                <input type="checkbox" name="action_ids[]" value="{$row_stats.action_id}" {if $row_stats.amount <= 0 || $row_stats.payout_id || (!empty($row_stats.allow_approve) && $row_stats.allow_approve == "N")}disabled="disabled"{/if} class="checkbox cm-item" /></td>
                                            <td data-th="{__("action")}">
                                                {if $row_stats.extra_data || $additional_data|trim}
                                                    <div class="pull-left">
                                                        <span name="plus_minus" id="on_commission_{$smarty.foreach.commissions.iteration}" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand cm-combination-commissions"><span class="exicon-expand"></span></span><span name="minus_plus" id="off_commission_{$smarty.foreach.commissions.iteration}" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand hidden cm-combination-commissions"><span class="exicon-collapse"></span></span><a id="sw_commission_{$smarty.foreach.commissions.iteration}" class="cm-combination-commissions"></a>
                                                    </div>
                                                {/if}
                                                <span>{$row_stats.title}{$action_title}</span>

                                                {if $row_stats.related_actions}
                                                    <p>{__("related_actions")}:</p>
                                                    {foreach $row_stats.related_actions as $r_action}
                                                        <p>{$r_action.title}, {include file="common/price.tpl" value=$r_action.amount|round:2}, {if $r_action.payout_id}{__("paidup")}{elseif $r_action.approved == "Y"}{__("approved")}{else}&nbsp;&nbsp;---&nbsp;{/if}</p>
                                                    {/foreach}
                                                {/if}
                                            </td>
                                            <td data-th="{__("date")}">{$row_stats.date|date_format:"{$settings.Appearance.date_format}, {$settings.Appearance.time_format}"}</td>
                                            <td data-th="{__("cost")}">{include file="common/price.tpl" value=$row_stats.amount|round:2}{$action_amount}</td>
                                            <td data-th="{__("customer")}">{if $row_stats.action == "new_vendor"}
                                                     <a href="{"companies.update&company_id={$row_stats.customer_id}"|fn_url}">{$row_stats.customer_id|fn_get_company_name}</a>
                                                {else}
                                                    {if $row_stats.customer_firstname || $row_stats.customer_lastname}
                                                        {if $row_stats.customer_exists}
                                                            <a href="{"profiles.update?user_id={$row_stats.customer_id}"|fn_url}">{$row_stats.customer_firstname} {$row_stats.customer_lastname}</a>
                                                        {else}
                                                            {$row_stats.customer_firstname} {$row_stats.customer_lastname}
                                                        {/if}
                                                    {elseif $row_stats.customer_id != 0}
                                                        {if $row_stats.customer_exists}
                                                            <a href="{"profiles.update?user_id={$row_stats.customer_id}"|fn_url}">{if $row_stats.type_of_customer == "P"}{__("affiliate")}_{$row_stats.customer_id}{else}{__("customer")}_{$row_stats.customer_id}{/if}</a>
                                                        {else}
                                                            {if $row_stats.type_of_customer == "P"}
                                                                {__("affiliate")}_{$row_stats.customer_id}
                                                            {else}
                                                                {__("customer")}_{$row_stats.customer_id}
                                                            {/if}
                                                        {/if}
                                                    {/if}
                                                {/if}
                                                &nbsp;{if $row_stats.ip}<em>({$row_stats.ip})</em>{/if}
                                            </td>
                                            <td data-th="{__("affiliate")}">
                                                {if $row_stats.partner_exists}
                                                    <a href="{"profiles.update?user_id={$row_stats.partner_id}&user_type={$row_stats.user_type}"|fn_url}">{$row_stats.affiliate}</a>
                                                {else}
                                                    {$row_stats.affiliate}
                                                {/if}
                                                {if $row_stats.plan}<em>(<a href="{"affiliate_plans.update?plan_id={$row_stats.plan_id}"|fn_url}">{$row_stats.plan}</a>)</em>{/if}
                                                {$action_partner}
                                            </td>
                                            <td data-th="{__("affiliate_banner")}">
                                                {if $row_stats.banner}
                                                    <a href="{"banners_manager.update?banner_id={$row_stats.banner_id}"|fn_url}">{$row_stats.banner}</a>
                                                {else}&nbsp;&nbsp;---&nbsp;{/if}
                                            </td>
                                            <td class="nowrap" data-th="{__("action")}">
                                                {capture name="tools_list"}
                                                {if !$row_stats.payout_id}
                                                    <li>{btn type="list" class="cm-confirm" text=__("delete") href="aff_statistics.delete?action_id={$row_stats.action_id}"}</li>
                                                    {if !empty($row_stats.allow_approve) && $row_stats.allow_approve == "Y" && $row_stats.approved != "Y" && $row_stats.amount > 0}
                                                        <li>{btn type="list" class="cm-confirm" text=__("to_approve") href="aff_statistics.each_approve?action_id={$row_stats.action_id}"}</li>
                                                    {/if}
                                                    {if !empty($row_stats.allow_approve) && $row_stats.allow_approve == "Y" && $row_stats.approved != "N" && $row_stats.amount > 0}
                                                        <li>{btn type="list" class="cm-confirm" text=__("addons.sd_affiliate.to_disapprove") href="aff_statistics.disapprove?action_id={$row_stats.action_id}"}</li>
                                                    {/if}
                                                {/if}
                                                {/capture}
                                                <div class="hidden-tools">
                                                    {dropdown content=$smarty.capture.tools_list}
                                                </div>
                                            </td>
                                            <td class="right" data-th="{__("status")}">
                                                {if $row_stats.payout_id}{__("paidup")}{elseif $row_stats.approved == "Y"}{__("approved")}{elseif $row_stats.amount > 0}{__("awaiting_approval")}{else}&nbsp;&nbsp;---&nbsp;{/if}
                                            </td>
                                        </tr>
                                        {if $row_stats.extra_data || $additional_data|trim}
                                            <tr id="commission_{$smarty.foreach.commissions.iteration}" class="hidden">
                                                <td colspan="9">
                                                    {if $row_stats.extra_data}
                                                        <table width="100%" class="table table-middle table-responsive">
                                                            <thead>
                                                                <tr>
                                                                    <th width="25%">{__("action")}</th>
                                                                    <th width="10%">{__("cost")}</th>
                                                                    <th>{__("affiliate")}</th>
                                                                </tr>
                                                            </thead>
                                                            {foreach $row_stats.extra_data as $r_action name="related_action"}
                                                                <tr>
                                                                    <td data-th="{__("action")}">{if $r_action.action_id == $row_stats.action_id}<span>{/if}{$r_action.title}{if $r_action.tier} ({$r_action.tier} {__("tier_account")}){/if}{if $r_action.action_id == $row_stats.action_id}</span>{/if}</td>
                                                                    <td data-th="{__("cost")}">{include file="common/price.tpl" value=$r_action.amount|round:2}</td>
                                                                    <td data-th="{__("affiliate")}">{if $row_stats.partner_exists}<a href="{"profiles.update?user_id={$r_action.partner_id}"|fn_url}">{$r_action.affiliate}</a>{else}{$r_action.affiliate}{/if}</td>
                                                                <tr>
                                                            {/foreach}
                                                        </table>
                                                    {/if}
                                                    {if $additional_data|trim}
                                                        {__("additional_data")}: {$additional_data nofilter}
                                                    {/if}
                                                </td>
                                            </tr>
                                        {/if}
                                    </tbody>
                                {/foreach}
                            </table>
                        </div>
                        {hook name="aff_statistics:approve"}{/hook}
                    {else}
                        <p class="no-items">{__("no_data")}</p>
                    {/if}
                    {include file="common/pagination.tpl"}
                <!--aff_stats_list--></div>
            </div>
            <div id="content_statistics">
                {include file="addons/sd_affiliate/views/aff_statistics/components/general_statistics.tpl"}
            </div>

            {capture name="buttons"}
                {if $affiliate_commissions}
                    {capture name="tools_list"}
                        <li>{btn type="list" text=__("disapprove_commissions") dispatch="dispatch[aff_statistics.m_disapprove]" form="commissions_approve_form"}</li>
                        <li>{btn type="list" text=__("delete_commissions") dispatch="dispatch[aff_statistics.m_delete]" class="cm-confirm" form="commissions_approve_form"}</li>
                    {/capture}
                    {dropdown content=$smarty.capture.tools_list class="mobile-hide"}
                    {include file="buttons/button.tpl" but_meta="cm-process-items mobile-hide" but_text=__("approve_commissions") but_name="dispatch[aff_statistics.m_approve]" but_role="submit-link" but_target_form="commissions_approve_form"}
                {/if}
            {/capture}
            {capture name="sidebar"}
                {include file="common/saved_search.tpl" dispatch="aff_statistics.approve" view_type="aff_stats"}
                {include file="addons/sd_affiliate/views/aff_statistics/components/stat_search_form.tpl" dispatch="aff_statistics.approve" }
            {/capture}
        </form>
    {/capture}

    {include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section track=true}

{/capture}

{include file="common/mainbox.tpl" title=__("approve_commissions") content=$smarty.capture.mainbox sidebar=$smarty.capture.sidebar buttons=$smarty.capture.buttons}
