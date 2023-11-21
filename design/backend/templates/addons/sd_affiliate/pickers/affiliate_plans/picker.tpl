{math equation="rand()" assign="rnd"}
{assign var="data_id" value="`$data_id`_`$rnd`"}
{assign var="view_mode" value=$view_mode|default:"mixed"}
{assign var="start_pos" value=$start_pos|default:0}
{script src="js/tygh/picker.js"}

{if $item_ids && !$item_ids|is_array && $type != "table"}
        {assign var="item_ids" value=","|explode:$item_ids}
{/if}

{if $view_mode != "list"}
    {if $placement == 'right'}
        <div class="clearfix">
            <div class="pull-right">
    {/if}

    {if $type != "single"}
    <a data-ca-external-click-id="opener_picker_{$data_id}" class="cm-external-click btn {$meta}"><i class="icon-plus"></i> {__("addons.sd_affiliate.add_plan")}</a>
    {/if}

    {if $placement == 'right'}
            </div>
        </div>
    {/if}
{/if}

<input type="hidden" id="p{$data_id}_ids" name="{$input_name}" value="{if $item_ids}{","|implode:$item_ids}{/if}" />
<table class="table table-middle">
    <thead>
        <tr>
            <th width="100%">{__("name")}</th>
            <th>&nbsp;</th>
            <th>&nbsp;</th>
        </tr>
    </thead>
    <tbody id="{$data_id}" class="{if !$item_ids}hidden{/if} cm-picker-product">
        {include file="addons/sd_affiliate/pickers/affiliate_plans/js.tpl" clone=true plan="`$ldelim`plan`$rdelim`" root_id=$data_id delete_id="`$ldelim`plan_id`$rdelim`" type="update" position_field=$positions position="0"}
        {if $item_ids}
            {foreach from=$item_ids item="plan" name="items"}
                {include file="addons/sd_affiliate/pickers/affiliate_plans/js.tpl" plan_id=$plan delete_id=$plan plan_name=$plan root_id=$data_id type="save" first_item=$smarty.foreach.items.first position_field=$positions position=$smarty.foreach.items.iteration+$start_pos}
            {/foreach}
        {/if}
    </tbody>
    <tbody id="{$data_id}_no_item"{if $item_ids} class="hidden"{/if}>
        <tr class="no-items">
            <td colspan="3"><p>{$no_item_text|default:__("no_items") nofilter}</p></td>
        </tr>
    </tbody>
</table>

{if $view_mode != "list"}
    <div class="hidden">
        {if $extra_var}
            {assign var="extra_var" value=$extra_var|escape:url}
        {/if}
        {if !$no_container}<div class="buttons-container">{/if}{if $picker_view}[{/if}
            {include file="buttons/button.tpl" but_id="opener_picker_`$data_id`" but_href="affiliate_plans.picker?display=`$display`&picker_for=`$picker_for`&extra=`$extra_var`&checkbox_name=`$checkbox_name`&aoc=`$aoc`&data_id=`$data_id`"|fn_url but_text=$but_text|default:__("addons.sd_affiliate.add_plans") but_role="add" but_target_id="content_`$data_id`" but_meta="cm-dialog-opener"}
        {if $picker_view}]{/if}{if !$no_container}</div>{/if}
        <div class="hidden" id="content_{$data_id}" title="{$but_text|default:__("addons.sd_affiliate.add_plans")}">
        </div>
    </div>
{/if}