{include file="views/profiles/components/profiles_scripts.tpl"}
{capture name="mainbox"}
<form action="{""|fn_url}" method="post" enctype="multipart/form-data" name="partnerlist_form">
<input type="hidden" name="fake" value="1" />

{include file="common/pagination.tpl" save_current_page=true save_current_url=true}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}

{if $partners}
<div class="sd-affiliates-container">
    <table width="100%" class="table table-middle table-responsive">
    <thead>
    <tr>
        <th class="left mobile-hide" width="1%">
            {include file="common/check_items.tpl"}</th>
        <th width="7%"><a class="cm-ajax" href="{"`$c_url`&sort_by=id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("id")}{if $search.sort_by == "id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th width="20%"><a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("name")}{if $search.sort_by == "name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=email&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("email")}{if $search.sort_by == "email"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th width="15%" class="nowrap"><a class="cm-ajax" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("registered")}{if $search.sort_by == "date"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th width="10%">{__("plan")}</th>
        <th class="mobile-hide">&nbsp;</th>
        <th width="12%" class="left"><a class="cm-ajax" href="{"`$c_url`&sort_by=partner_status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("partner_status")}{if $search.sort_by == "partner_status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th width="10%" class="left"><a class="cm-ajax" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("user_status")}{if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    </tr>
    </thead>
    {foreach from=$partners item=user}
    {assign var="allow_save" value=$user|fn_allow_save_object:"users"}
    {if !$allow_save && !"RESTRICTED_ADMIN"|defined && $auth.is_root != 'Y'}
        {assign var="link_text" value=__("view")}
        {assign var="popup_additional_class" value=""}
    {elseif $allow_save || "RESTRICTED_ADMIN"|defined || $auth.is_root == 'Y'}
        {assign var="link_text" value=""}
        {assign var="popup_additional_class" value="cm-no-hide-input"}
    {else}
        {assign var="popup_additional_class" value=""}
        {assign var="link_text" value=""}
    {/if}
    {if !"ULTIMATE"|fn_allowed_for}
        <tr class="cm-row-status-{$user.status|lower}">
    {/if}

    {if "ULTIMATE"|fn_allowed_for}
        <tr class="cm-row-status-{$user.status|lower}{if !$allow_save || ($user.user_id == $smarty.session.auth.user_id)} cm-hide-inputs{/if}">
    {/if}
        <td class="left"><input type="checkbox" name="user_ids[]" value="{$user.user_id}" class="cm-item mobile-hide"/></td>
        <td data-th="{__("id")}"><a class="row-status" href="{"profiles.update?user_id=`$user.user_id`&user_type=`$user.user_type`"|fn_url}">{$user.user_id}</a></td>
        {strip}
            <td class="row-status" data-th="{__("name")}">
                {if $user.firstname || $user.lastname}
                    {$user_name_value = "{$user.lastname} {$user.firstname}"}
                    {if $user_name_value|count_characters > 35}
                        {$user_name_value = $user_name_value|truncate:27:"...":true}
                    {/if}

                    <a href="{"profiles.update?user_id=`$user.user_id`&user_type=`$user.user_type`"|fn_url}">
                        {$user_name_value}
                    </a>
                {else}
                    -
                {/if}
            </td>
        {/strip}
        <td data-th="{__("email")}"><a class="row-status" href="mailto:{$user.email|escape:url}">{$user.email}</a></td>
        <td class="row-status" data-th="{__("registered")}">{$user.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
        {if $user.approved == 'A' || ($user.approved == 'D' && $user.plan_id)}
        <td width="10%" class="row-status" data-th="{__("plan")}">
            {$user_id = $user.user_id}
            {if $affiliate_plans.$user_id}{$plans = $affiliate_plans.$user_id}{else}{$plans = $general_affiliate_plans}{/if}
            <select name="update_data[{$user.user_id}][plan_id]" id="id_select_plan_{$user.user_id}" {if $user.approved == "D"}disabled="disabled"{/if} class="span2">
                <option value="0" {if !$user.plan_id}selected="selected"{/if}> - </option>
                {if $plans}{html_options options=$plans selected=$user.plan_id}{/if}
            </select>
        </td>
        {else}
        <td width="10%" class="nowrap row-status" data-th="{__("plan")}">-</td>
        {/if}
        <td class="nowrap mobile-hide">
            <div class="hidden-tools">
                {capture name="tools_list"}
                    {$list_extra_links = false}
                    {hook name="profiles:list_extra_links"}
                        {if $user.user_type|fn_user_need_login && (!$runtime.company_id || $runtime.company_id == $auth.company_id && fn_check_permission_act_as_user()) && $user.user_id != $auth.user_id && !($user.user_type == $auth.user_type && $user.is_root == 'Y' && (!$user.company_id || $user.company_id == $auth.company_id))}
                            <li>{btn type="list" target="_blank" text=__("sd_affiliate.log_in_as_user") href="profiles.act_as_user?user_id=`$user.user_id`"}</li>
                            {$list_extra_links = true}
                        {/if}
                        <li>{btn type="list" text=__("view_all_orders") href="orders.manage?user_id=`$user.user_id`"}</li>
                        {$list_extra_links = true}
                        {assign var="return_current_url" value=$config.current_url|escape:url}
                    {/hook}
                    {if $list_extra_links}
                        <li class="divider"></li>
                    {/if}
                    <li>{btn type="list" text=__("edit") href="profiles.update?user_id=`$user.user_id`"}</li>
                    {if $user.approved != 'A'}
                        <li>{btn type="list" class="cm-confirm cm-post" text=__("to_approve") href="partners.approve?user_id=`$user.user_id`"}</li>
                    {/if}
                    {if $user.approved != 'D'}
                        <li>{btn type="dialog" class="cm-post" text=__("decline") target_id="content_decline_`$user.user_id`" form="partnerlist_form"}</li>
                    {/if}
                    {if !$runtime.company_id && !($user.user_type == "A" && $user.is_root == "Y")}
                        <li>{btn type="list" text=__("delete") class="cm-confirm" href="profiles.delete?user_id=`$user.user_id`&redirect_url=`$return_current_url`" method="POST"}</li>
                    {/if}
                {/capture}
                {dropdown content=$smarty.capture.tools_list}
            </div>
        </td>
        <td class="row-status" data-th="{__("partner_status")}">
            {if $user.approved == "A"}
                <span class="text-success">{__("approved")}</span>
            {elseif $user.approved == "D"}
                <span class="text-error">{__("declined")}</span>
            {else}
                <span class="required-field-mark">{__("awaiting_approval")}</span>
            {/if}
        </td>
        <td class="right" data-th="{__("user_status")}">
            <input type="hidden" name="user_types[{$user.user_id}]" value="{$user.user_type}" />
            {if $user.is_root == "Y" && ($user.user_type == "A" || $user.user_type == "V" && $runtime.company_id && $runtime.company_id == $user.company_id)}
                {assign var="u_id" value=""}
            {else}
                {assign var="u_id" value=$user.user_id}
            {/if}

            {assign var="non_editable" value=false}

            {if $user.is_root == "Y" && $user.user_type == $auth.user_type && (!$user.company_id || $user.company_id == $auth.company_id) || $user.user_id == $auth.user_id || ("MULTIVENDOR"|fn_allowed_for && $runtime.company_id && ($user.user_type == 'C' || $user.company_id && $user.company_id != $runtime.company_id))}
                {assign var="non_editable" value=true}
            {/if}

            {include file="common/select_popup.tpl" id=$u_id status=$user.status hidden="" update_controller="profiles" notify=true notify_text=__("notify_user") popup_additional_class="`$popup_additional_class` dropleft" non_editable=$non_editable}
        </td>
    </tr>
    {/foreach}
    </table>
</div>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{foreach from=$partners item=user}
    {capture name="decline"}
        {include file="addons/sd_affiliate/views/partners/components/reason_container.tpl" name="action_reason_declined_`$user.user_id`"}
        <div class="buttons-container">
            {include file="buttons/save_cancel.tpl" but_text=__("proceed") but_name="dispatch[partners.decline.`$user.user_id`]" cancel_action="close"}
        </div>
    {/capture}
    {include file="common/popupbox.tpl" id="decline_`$user.user_id`" text=__("decline") content=$smarty.capture.decline}
{/foreach}

{include file="common/pagination.tpl"}

{if $partners}
    {capture name="decline_selected"}
        {include file="addons/sd_affiliate/views/partners/components/reason_container.tpl" name="action_reason_declined"}
        <div class="buttons-container">
            {include file="buttons/save_cancel.tpl" but_text=__("proceed") but_name="dispatch[partners.m_decline]" cancel_action="close" but_meta="cm-process-items"}
        </div>
    {/capture}
    {include file="common/popupbox.tpl" id="decline_selected" text=__("decline_selected") content=$smarty.capture.decline_selected}
{/if}
</form>

{/capture}

{capture name="sidebar"}
    {include file="common/saved_search.tpl" view_type="affiliates" dispatch="partners.manage"}
    {include file="addons/sd_affiliate/views/partners/components/partner_search.tpl" dispatch="partners.manage"}
{/capture}

{capture name="buttons"}
    {capture name="tools_list"}
        <li>{btn type="list" text=__("approve_selected") dispatch="dispatch[partners.m_approve]" form="partnerlist_form"}</li>
        <li>{btn type="dialog" text=__("decline_selected") target_id="content_decline_selected" form="partnerlist_form"}</li>
        <li class="divider"></li>
        {if "ULTIMATE"|fn_allowed_for || !$runtime.company_id}
            <li>{btn type="list" text=__("export_selected") dispatch="dispatch[profiles.export_range]" form="partnerlist_form"}</li>
        {/if}
        <li>{btn type="delete_selected" dispatch="dispatch[profiles.m_delete]" form="partnerlist_form"}</li>
    {/capture}
    {if $partners}
        {dropdown content=$smarty.capture.tools_list class="mobile-hide"}
        {include file="buttons/save.tpl" but_name="dispatch[partners.m_update]" but_role="submit-link" but_target_form="partnerlist_form"}
    {/if}
{/capture}

{capture name="partners_adv_buttons"}
    {if !($runtime.company_id && "MULTIVENDOR"|fn_allowed_for && ($smarty.request.user_type == 'C' || $auth.is_root != 'Y'))}
        <a class="btn cm-tooltip" href="{"profiles.add?user_type=`$user_type`"|fn_url}" title="{__("add_user")}"><i class="cs-icon icon-plus"></i></a>
    {/if}
{/capture}

{include file="common/mainbox.tpl" title=__("affiliates") content=$smarty.capture.mainbox sidebar=$smarty.capture.sidebar buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.partners_adv_buttons}
