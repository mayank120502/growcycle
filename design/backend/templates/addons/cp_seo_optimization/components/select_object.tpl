{$item_ids = $object_id|default:$condition_data.value}
<div id="{$target_id}">
<div class="control-group">
    {if $condition.title}
        <label class="control-label" for="elm_condition_`$type`_`$object_id`">{$condition.title}</label>
    {/if}
    <input type="text" name="{$prefix}[type]" value="{$type}">

    {assign var="p_md" value=$prefix|md5}
    {if $condition.type == "input"}
        <input type="text" name="{$prefix}[value]" value="{$condition_data.value}" class="input-medium"/>
    {elseif $condition.type == "select"}
        <select name="{$prefix}[value]">
            {foreach from=$condition.items key="_k" item="v"}
                <option value="{$_k}">
                    {if $_k == $condition_data.value}selected="selected"{/if}>{if $condition.variants_function}{$v}{else}{__($v)}{/if}
                </option>
            {/foreach}
        </select>
    {elseif $condition.type == "picker"}
        <select name="{$prefix}[operator]" id="condition_operator_{$p_md}">
            {foreach from=$condition.variants item="op"}
                <option value="{$op}" {if $op == $condition_data.operator}selected="selected"{/if}>{__($l)}</option>
            {/foreach}
        </select>

        {assign var="params" value=$condition.picker_props.params}

        {include_ext file=$condition.picker_props.picker company_ids=$picker_selected_companies data_id="objects_`$elm_id`" input_name="`$prefix`[value]" item_ids=$item_ids params_array=$params owner_company_id=$company_id but_meta="btn"}
    {/if}
</div>
<!--{$target_id}--></div>