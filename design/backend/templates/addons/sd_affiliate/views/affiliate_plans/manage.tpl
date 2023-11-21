{capture name="mainbox"}
{if $plan_type == 'AffiliateUserTypes::PARTNER'|enum}
    <form action="{""|fn_url}" method="post" name="manage_affiliate_plans_form">

        {include file="common/pagination.tpl"}

        {if $affiliate_plans}
        <table width="100%" class="table table-middle table-responsive">
            <thead>
            <tr>
                <th class="left mobile-hide" width="1%">
                    {include file="common/check_items.tpl"}</th>
                <th width="35%">{__("name")}</th>
                <th class="center">{__("affiliates")}</th>
                <th class="mobile-hide">&nbsp;</th>
                <th width="10%" class="right">{__("status")}</th>
            </tr>
            </thead>

            {foreach from=$affiliate_plans item="aff_plan"}
                {$allow_save = $aff_plan|fn_allow_save_object:"affiliate_plans"}
                {if !"ULTIMATE"|fn_allowed_for}
                    <tr class="cm-row-status-{$aff_plan.status|lower}">
                {/if}

                {if "ULTIMATE"|fn_allowed_for}
                    <tr
                        class="
                                cm-row-status-{$aff_plan.status|lower}
                                {if !$allow_save || ($aff_plan.user_id == $smarty.session.auth.user_id)}
                                    cm-hide-inputs
                                {/if}
                            "
                    >
                {/if}
                    <td class="left row-status mobile-hide">
                        <input type="checkbox" name="plan_ids[]" value="{$aff_plan.plan_id}" class="cm-item"/></td>
                    <td class="row-status" data-th="{__("name")}">
                        <a href="{"{$runtime.controller}.update?plan_id={$aff_plan.plan_id}&plan_type={$plan_type}"|fn_url}">
                            {$aff_plan.name}
                        </a>
                        {if $aff_plan.is_default=="Y"} ({__("default")}) {/if}
                        {include file="views/companies/components/company_name.tpl" object=$aff_plan}
                    </td>
                    <td class="center row-status" data-th="{__("affiliates")}">{$aff_plan.count_partners}</td>
                    <td class="nowrap right mobile-hide">
                        {capture name="tools_list"}
                            <li>
                                {btn
                                    type="list"
                                    text=__("edit")
                                    href="affiliate_plans.update?plan_id={$aff_plan.plan_id}"
                                }
                            </li>
                            <li>
                                {btn
                                    type="list"
                                    class="cm-confirm"
                                    text=__("sd_affiliate.set_as_default")
                                    href="affiliate_plans.set_as_default?plan_id={$aff_plan.plan_id}"
                                }
                            </li>
                            {if "ULTIMATE"|fn_allowed_for}
                                {if $allow_save}
                                    <li>
                                        {btn
                                            type="list"
                                            class="cm-confirm"
                                            text=__("delete")
                                            href="affiliate_plans.delete?plan_id={$aff_plan.plan_id}&plan_type={$plan_type}"
                                        }
                                    </li>
                                {/if}
                            {else}
                                <li>
                                    {btn
                                        type="list"
                                        class="cm-confirm"
                                        text=__("delete")
                                        href="affiliate_plans.delete?plan_id={$aff_plan.plan_id}&plan_type={$plan_type}"
                                    }
                                </li>
                            {/if}
                        {/capture}
                        <div class="hidden-tools">
                            {dropdown content=$smarty.capture.tools_list}
                        </div>
                    </td>
                    <td class="right" data-th="{__("status")}">
                        {if "ULTIMATE"|fn_allowed_for}
                            {if $allow_save}
                                {include
                                    file="common/select_popup.tpl"
                                    id=$aff_plan.plan_id
                                    status=$aff_plan.status
                                    hidden=""
                                    object_id_name="plan_id"
                                    table="affiliate_plans"
                                }
                            {/if}
                        {else}
                            {include
                                file="common/select_popup.tpl"
                                id=$aff_plan.plan_id
                                status=$aff_plan.status
                                hidden=""
                                object_id_name="plan_id"
                                table="affiliate_plans"
                            }
                        {/if}
                    </td>
                </tr>
            {/foreach}
        </table>
        {else}
            <p class="no-items">{__("no_data")}</p>
        {/if}

        {include file="common/pagination.tpl"}

        {capture name="adv_buttons"}
            {btn type="add" title=__("affiliate_add_plan") href="affiliate_plans.add"}
        {/capture}

        {capture name="buttons"}
            {capture name="tools_list"}
                {if $affiliate_plans}
                    <li>
                        {btn
                            type="delete_selected"
                            dispatch="dispatch[affiliate_plans.m_delete]"
                            form="manage_affiliate_plans_form"
                        }
                    </li>
                {/if}
            {/capture}
            {dropdown content=$smarty.capture.tools_list class="mobile-hide"}
        {/capture}

    </form>
{else}
    <form action="{""|fn_url}" method="post" name="manage_affiliate_plans_form">
        {if $affiliate_plans}
            <table width="100%" class="table table-middle table-responsive">
                <thead>
                    <tr>
                        <th width="35%">{__("name")}</th>
                        <th class="mobile-hide">&nbsp;</th>
                        <th width="10%" class="right">{__("status")}</th>
                    </tr>
                </thead>

                {foreach from=$affiliate_plans item="aff_plan"}
                    {$allow_save = $aff_plan|fn_allow_save_object:"affiliate_plans"}
                    {if !"ULTIMATE"|fn_allowed_for}
                        <tr class="cm-row-status-{$aff_plan.status|lower}">
                    {/if}

                    {if "ULTIMATE"|fn_allowed_for}
                        <tr
                            class="
                                    cm-row-status-{$aff_plan.status|lower}
                                    {if !$allow_save || ($aff_plan.user_id == $smarty.session.auth.user_id)}
                                        cm-hide-inputs
                                    {/if}
                                "
                        >
                    {/if}
                        <td class="row-status" data-th="{__("name")}">
                            <a href="{"{$runtime.controller}.update?plan_id={$aff_plan.plan_id}&plan_type={$plan_type}"|fn_url}">
                                {$aff_plan.name}
                            </a>
                            {include file="views/companies/components/company_name.tpl" object=$aff_plan}
                        </td>
                        <td class="nowrap right mobile-hide">
                            {capture name="tools_list"}
                                <li>
                                    {btn
                                        type="list"
                                        text=__("edit")
                                        href="affiliate_plans.update?plan_id={$aff_plan.plan_id}&plan_type={$plan_type}"
                                    }
                                </li>
                                {if "ULTIMATE"|fn_allowed_for}
                                    {if $allow_save}
                                        <li>
                                            {btn
                                                type="list"
                                                class="cm-confirm"
                                                text=__("delete")
                                                href="affiliate_plans.delete?plan_id={$aff_plan.plan_id}&plan_type={$plan_type}"
                                            }
                                        </li>
                                    {/if}
                                {else}
                                    <li>
                                        {btn
                                            type="list"
                                            class="cm-confirm"
                                            text=__("delete")
                                            href="affiliate_plans.delete?plan_id={$aff_plan.plan_id}&plan_type={$plan_type}"
                                        }
                                    </li>
                                {/if}
                            {/capture}
                            <div class="hidden-tools">
                                {dropdown content=$smarty.capture.tools_list}
                            </div>
                        </td>
                        <td class="right" data-th="{__("status")}">
                            {if "ULTIMATE"|fn_allowed_for}
                                {if $allow_save}
                                    {include
                                        file="common/select_popup.tpl"
                                        id=$aff_plan.plan_id
                                        status=$aff_plan.status
                                        hidden=""
                                        object_id_name="plan_id"
                                        table="affiliate_plans"
                                    }
                                {/if}
                            {else}
                                {include
                                    file="common/select_popup.tpl"
                                    id=$aff_plan.plan_id
                                    status=$aff_plan.status
                                    hidden=""
                                    object_id_name="plan_id"
                                    table="affiliate_plans"
                                }
                            {/if}
                        </td>
                    </tr>
                {/foreach}
            </table>
        {else}
            <p class="no-items">{__("no_data")}</p>
        {/if}

        {capture name="adv_buttons"}
            {if !$affiliate_plans}
                {btn type="add" title=__("affiliate_add_plan") href="affiliate_plans.add?plan_type={$plan_type}"}
            {/if}
        {/capture}
    </form>
{/if}
{/capture}
{include
    file="common/mainbox.tpl"
    title=__("plans")
    content=$smarty.capture.mainbox
    adv_buttons=$smarty.capture.adv_buttons
    buttons=$smarty.capture.buttons
}
