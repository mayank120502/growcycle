{** banners section **}

{capture name="mainbox"}

<form action="{""|fn_url}" method="post" id="inx_rules_form" name="inx_rules_form" enctype="multipart/form-data">
<input type="hidden" name="fake" value="1" />
{*
{include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id="pagination_contents_rules"}
*}
{$c_url=$config.current_url|fn_query_remove:"sort_by":"sort_order"}

{$rev=$smarty.request.content_id|default:"pagination_contents_rules"}
{$c_icon="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
{$c_dummy="<i class=\"icon-dummy\"></i>"}

{$has_permission = fn_check_permissions("cp_seo_optimization", "m_update_rules", "admin", "POST")}

{if $exist_rules}
    <div class="table-responsive-wrapper longtap-selection">
        <table class="table table-middle table--relative table-responsive">
        <thead>
        <tr>
            <th width="1%" class="left mobile-hide">
                {include file="common/check_items.tpl" class="cm-no-hide-input"}
            </th>
            <th><a class="cm-ajax" href="{"`$c_url`&sort_by=dispatch&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("dispatch")}{if $search.sort_by == "dispatch"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
            <th class="mobile-hide">
                <a class="cm-ajax" href="{"`$c_url`&sort_by=rule&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("cp_seo_indexing_management")}{if $search.sort_by == "rule"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a>
            </th>
            <th width="6%" class="mobile-hide">&nbsp;</th>
        </tr>
        </thead>
        {foreach from=$exist_rules item="rule"}
            <tr class="cm-longtap-target">
                {$allow_save=$rule|fn_allow_save_object:"cp_seo_optimization"}

                {if $allow_save}
                    {$no_hide_input="cm-no-hide-input"}
                {else}
                    {$no_hide_input=""}
                {/if}

                <td width="6%" class="left mobile-hide">
                    {if $schema_rules.{$rule.dispatch}}
                        -
                    {else}
                        <input type="checkbox" name="rule_ids[]" value="{$rule.rule_id}" class="cm-item {$no_hide_input}" />
                    {/if}
                </td>
                <td width="45%" data-th="{__("dispatch")}">
                    {$rule.dispatch}
                    {if "ULTIMATE"|fn_allowed_for}
                        <div class="shift-left">
                            {include file="views/companies/components/company_name.tpl" object=$rule}
                        </div>
                    {/if}
                </td>
                <td width="45%" data-th="{__("cp_seo_indexing_management")}">
                    <select name="rules[{$rule.rule_id}][rule]">
                        <option value="F" {if $rule.rule == "F"}selected="selectd"{/if}>{__("cp_seo_indexing_management_f")}</option>
                        <option value="Y" {if $rule.rule == "Y"}selected="selectd"{/if}>{__("cp_seo_indexing_management_y")}</option>
                        <option value="I" {if $rule.rule == "I"}selected="selectd"{/if}>{__("cp_seo_indexing_management_i")}</option>
                    </select>
                </td>
                <td width="6%" class="mobile-hide">
                    {capture name="tools_list"}
                    {if $allow_save && !$schema_rules.{$rule.dispatch}}
                        <li>{btn type="list" class="cm-confirm" text=__("delete") href="cp_seo_optimization.delete_rule?rule_id=`$rule.rule_id`" method="POST"}</li>
                    {/if}
                    {/capture}
                    <div class="hidden-tools">
                        {dropdown content=$smarty.capture.tools_list}
                    </div>
                </td>
            </tr>
        {/foreach}
        </table>
    </div>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}
{*
{include file="common/pagination.tpl" div_id="pagination_contents_rules"}
*}
{capture name="buttons"}
    {capture name="tools_list"}
        {if $exist_rules}
            <li>{btn type="delete_selected" dispatch="dispatch[cp_seo_optimization.m_delete_rules]" form="inx_rules_form"}</li>
        {/if}
    {/capture}
    {dropdown content=$smarty.capture.tools_list class="mobile-hide"}
    {if $exist_rules}
        {include file="buttons/save.tpl" but_name="dispatch[cp_seo_optimization.m_update_rules]" but_role="submit-link" but_target_form="inx_rules_form"}
    {/if}
{/capture}
{capture name="adv_buttons"}
    {if "cp_seo_optimization.add_rule"|fn_check_view_permissions}
        <div class="btn-group">
            <a class="btn cm-dialog-opener cm-dialog-auto-size"href="{"cp_seo_optimization.add_rule"|fn_url}" title="{__("cp_seo_add_rule")}" data-ca-target-id="cp_add_rule">
                <i class="cs-icon icon-plus"></i>
            </a>
        </div>
    {/if}
{/capture}

</form>

{/capture}

{$page_title = __("cp_seo_index_rules")}

{include file="common/mainbox.tpl" title=$page_title content=$smarty.capture.mainbox buttons=$smarty.capture.buttons select_languages=false sidebar=$smarty.capture.sidebar adv_buttons=$smarty.capture.adv_buttons}

