{assign var="prefix_md5" value=$prefix|md5}

<input type="hidden" name="{$prefix}[fake]" value="" disabled="disabled" />

{capture name="set"}
    {if !$group.set || $group.set == "any"}
        {assign var="selected_name" value=__("promotions.cond_any")}
    {else}
        {assign var="selected_name" value=__("promotions.cond_all")}
    {/if}
    {include file="common/select_object.tpl" style="field" items=["all" => __("promotions.cond_all"), "any" => __("promotions.cond_any")] select_container_name="`$prefix`[set]" selected_key=$group.set selected_name=$selected_name}
{/capture}

<ul class="conditions-tree-group cm-row-item">
    <li class="no-node{if $root}-root{/if}">
        {if !$root}
        <div class="pull-right">
            <a class="icon-trash cm-delete-row cm-tooltip conditions-tree-remove" name="remove" id="{$item_id}" title="{__("remove_this_item")}"></a>
        </div>
        {/if}
        <div id="add_condition_{$prefix_md5}" class="btn-toolbar pull-right">
            {if !$hide_add_buttons}
                {include file="common/tools.tpl" hide_tools=true tool_onclick="fn_cp_condition_add(Tygh.$(this).parents('div[id^=add_condition_]').prop('id'), false, '`$prefix`');" prefix="simple" link_text=__("add_condition")}
            {/if}
        </div>
        {__("text_promotions_group_condition", ["[set]" => $smarty.capture.set, "[set_value]" => __("promotions.cond_true")])}
    </li>

    <li class="no-node no-items {if $group.conditions}hidden{/if}">
        <p class="no-items">{__("no_items")}</p>
    </li>

    {foreach from=$group.conditions key="k" item="condition_data" name="conditions"}
    <li id="container_condition_{$prefix_md5}_{$k}" class="cm-row-item{if $smarty.foreach.conditions.last} cm-last-item{/if}">
        {include file="addons/cp_seo_templates/views/cp_seo_templates/components/condition.tpl" condition_data=$condition_data prefix="`$prefix`[conditions][`$k`]" elm_id="condition_`$prefix_md5`_`$k`"}
    </li>
    {/foreach}

    <li id="container_add_condition_{$prefix_md5}" class="hidden cm-row-item">
        <div class="conditions-tree-node">
        <select onchange="Tygh.$.ceAjax('request', '{"cp_seo_templates.dynamic?template_id=`$smarty.request.template_id`"|fn_url nofilter}&prefix=' + encodeURIComponent(this.name) + '&condition=' + this.value + '&elm_id=' + this.id, {$ldelim}result_ids: 'container_' + this.id{$rdelim})">
            <option value=""> -- </option>
            {foreach from=$conditions key="c_key" item="c_value"}
                <option value="{$c_key}">{$c_value.title}</option>
            {/foreach}
        </select>
        </div>
    </li>
</ul>
