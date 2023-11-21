{$cond_key = $condition_data.condition}
{$item_ids = $condition_data.value}
{$condition = $conditions[$cond_key]}

<div class="conditions-tree-node clearfix">
    <div class="pull-right">
        <a class="icon-trash cm-tooltip cm-delete-row" name="remove" id="{$item_id}" title="{__("remove")}"></a>
    </div>
    <input type="hidden" name="{$prefix}[condition]" value="{$cond_key}"/>

    {if $condition.title}
        <label>{$condition.title}</label>
    {/if}

    {assign var="p_md" value=$prefix|md5}
    {if $condition.type == "input"}
        <input type="text" name="{$prefix}[value]" value="{$condition_data.value}" class="input-medium"/>
    {elseif $condition.type == "select"}
        <select name="{$prefix}[value]">
            {foreach from=$condition.variants|default:$condition.variants_function|fn_get_promotion_variants key="_k" item="v"}
                <option value="{$_k}"
                    {if $_k == $condition_data.value}selected="selected"{/if}>{if $condition.variants_function}{$v}{else}{__($v)}{/if}
                </option>
            {/foreach}
        </select>
    {elseif $condition.type == "picker"}
        <select name="{$prefix}[operator]" id="condition_operator_{$p_md}">
            {foreach from=$condition.operators item="op"}
                {assign var="l" value="promotion_op_`$op`"}
                <option value="{$op}" {if $op == $condition_data.operator}selected="selected"{/if}>{__($l)}</option>
            {/foreach}
        </select>

        {$params=$condition.picker_props.params}
        {if $condition.use_company}
            {$company_id = $template.company_id}
        {/if}
        {include_ext file=$condition.picker_props.picker company_id=$company_id company_ids=$picker_selected_companies data_id="objects_`$elm_id`" input_name="`$prefix`[value]" item_ids=$item_ids params_array=$params owner_company_id=$template.company_id but_meta="btn"}
    
    {elseif $condition.type == "list"}
        <input type="hidden" name="{$prefix}[operator]" value="in"/>
        <input type="hidden" name="{$prefix}[value]" value="{$condition_data.value}"/>
        {$condition_data.value|default:__("no_data")}

    {elseif $condition.type == "statement"}
        <input type="hidden" name="{$prefix}[operator]" value="eq"/>
        <input type="hidden" name="{$prefix}[value]" value="Y"/>
        {__("yes")}
    {/if}
</div>
