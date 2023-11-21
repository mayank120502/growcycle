{script src="js/addons/sd_affiliate/update_affiliate_info.js"}
{if $runtime.mode == 'update' && $user_type == 'P'}
    <div id="content_affiliate_information">
        {include file="common/subheader.tpl" title=__("affiliate_information")}
        <div class="control-group">
            <label class="control-label" for="elm_affiliate_code">{__("affiliate_code")}:</label>
            <div class="controls">
                <input type="text" id="elm_affiliate_code" size="32" value="{$partner.user_id|fn_dec2any}" class="span3" disabled="disabled"/>
            </div>
        </div>
        {if $addons.sd_affiliate.use_multiple_promotions == 'N'}
            <div class="control-group">
                <label class="control-label" for="elm_affiliate_coupon_code">{__("addons.sd_affiliate.coupon_code")}:</label>
                <div class="controls">
                    <select name="update_data[coupon_code]" id="elm_affiliate_coupon_code" class="span3" {if $partner.approved == "D" || $partner.approved == "N"}disabled="disabled"{/if}>
                        <option value="">{__("addons.sd_affiliate.select_coupon_code")}</option>
                        {foreach from=$coupon_code_list item=coupon_code}
                            <option value="{$coupon_code}" {if $partner.coupon_code == $coupon_code}selected="selected"{/if}>{$coupon_code}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
        {/if}
        <div class="control-group">
            <label class="control-label" for="elm_affiliate_plan">{__("plan")}:</label>
            <div class="controls">
                <select name="update_data[plan_id]" id="elm_affiliate_plan" {if $partner.approved == "D" || $partner.approved == "N"}disabled="disabled"{/if} class="span3">
                    <option value="0" id="affiliate_plan_0" {if !$partner.plan_id}selected="selected"{/if}> - </option>
                    {if $affiliate_plans}{html_options options=$affiliate_plans selected=$partner.plan_id}{/if}
                </select>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="elm_affiliate_status">{__("status")}:</label>
            <div class="controls">
                <select name="update_data[approved]" id="elm_affiliate_status" class="span3">
                    <option value="N" {if $partner.approved == "N"}selected="selected"{/if}>{__("awaiting_approval")}</option>
                    <option value="A" {if $partner.approved == "A"}selected="selected"{/if}>{__("approved")}</option>
                    <option value="D" {if $partner.approved == "D"}selected="selected"{/if}>{__("declined")}</option>
                </select>
            </div>
        </div>
        <div id="reason_to_decline" class="control-group hidden">
            <label class="control-label">{__("reason")}:</label>
            <div class="controls">
                <textarea name="update_data[reason_to_decline]" id="partner_reason_to_decline" cols="50" rows="4" class="span9"></textarea>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="elm_affiliate_invited_affiliate">{__("addons.sd_affiliate.invited_affiliate")}:</label>
            <div class="controls">
                <select name="update_data[referrer_partner_id]" id="elm_affiliate_invited_affiliate" class="span3">
                    <option value="0">-</option>
                    {foreach from=$all_affiliates item=affiliate key=affiliate_id}
                        <option value="{$affiliate_id}" {if $partner.referrer_partner_id == $affiliate_id}selected="selected"{/if}>{$affiliate}</option>
                    {/foreach}
                </select>
            </div>
        </div>
        {include file="common/subheader.tpl" title=__("commissions_of_last_periods")}
        <div class="well content_affiliate_information table-responsive-wrapper">
            <table cellpadding="4" cellspacing="1" border="0" class="table-responsive">
                {foreach from=$last_payouts item=period}
                    <tr class = "{if $period.range.end < $partner.timestamp}hidden{/if}">
                        <td>{if $period.amount > 0}<a href="{"aff_statistics.approve?partner_id=`$partner.user_id`&period=C&time_from=`$period.range.start`&time_to=`$period.range.end`"|fn_url}">{/if}{$period.range.start|date_format:$settings.Appearance.date_format}{if $period.amount > 0}</a>{/if}</td>
                        <td class="progress-small mobile-hide">{include file="views/sales_reports/components/graph_bar.tpl" bar_width="300px" value_width=$period.amount/$max_amount*100|round}</td>
                        <td>{include file="common/price.tpl" value=$period.amount}</td>
                    </tr>
                {/foreach}
                <tr>
                    <td></td>
                    <td><div class="pull-right">{__("total_commissions")}:</div></td>
                    <td><div class="pull-right">{include file="common/price.tpl" value=$total_commissions}</div></td>
                </tr>
                <tr>
                    <td></td>
                    <td><div class="pull-right">{__("balance_account")}:</div></td>
                    <td><div class="pull-right">{include file="common/price.tpl" value=$partner.balance}</div></td>
                </tr>
                <tr>
                    <td></td>
                    <td><div class="pull-right">{__("total_payouts")}:</div></td>
                    <td><div class="pull-right">{if $partner.total_payouts}<a href="{"payouts.manage?partner_id=`$partner.user_id`&period=A"|fn_url}">{include file="common/price.tpl" value=$partner.total_payouts}</a>{else}{include file="common/price.tpl" value=$partner.total_payouts}{/if}</div></td>
                </tr>
            </table>
        </div>
    </div>

    <div id="content_affiliate_tree">
        {include file="common/subheader.tpl" title=__("affiliate_tree")}
        <div class="items-container multi-level">
            {include file="addons/sd_affiliate/views/partners/components/partner_tree.tpl" partners=$partners header=1 level=0}
        </div>
    </div>
{/if}

{if $usergroup_for_affiliate.usergroup_id}
    <div id="content_user_affiliate_group" class="cm-hide-save-button">
        <div class="table-responsive-wrapper">
            <table width="100%" class="table table-middle table-responsive">
                <thead>
                    <tr>
                        <th width="50%">{__("usergroup")}</th>
                        <th class="right" width="10%">{__("status")}</th>
                    </tr>
                </thead>
                <tr>
                    <td data-th="{__("usergroup")}">
                        <a href="{"usergroups.manage#group$usergroup_for_affiliate.usergroup_id"|fn_url}">{$usergroup_for_affiliate.usergroup}</a>
                    </td>
                    <td class="right" data-th="{__("status")}">
                        {$hide_for_vendor = false}
                        {if !"usergroups.manage"|fn_check_view_permissions:"POST"}
                            {$hide_for_vendor=true}
                        {/if}
                        {if $user_data.usergroups[$usergroup_for_affiliate.usergroup_id]}
                            {$ug_status = $user_data.usergroups[$usergroup_for_affiliate.usergroup_id].status}
                        {else}
                            {$ug_status = "F"}
                        {/if}
                        {include file="common/select_popup.tpl"
                            id=$usergroup_for_affiliate.usergroup_id
                            status=$ug_status hidden=""
                            items_status="profiles"|fn_get_predefined_statuses extra="&user_id=`$id`"
                            update_controller="usergroups"
                            notify=true
                            hide_for_vendor=$hide_for_vendor
                        }
                    </td>
                </tr>
            </table>
        </div>
    </div>
{elseif $user_type == 'P' && $runtime.mode != 'add' && $navigation.tabs.user_affiliate_group}
    <div id="content_user_affiliate_group" class="cm-hide-save-button">
        <p class="no-items">{__("no_items")}</p>
    </div>
{/if}