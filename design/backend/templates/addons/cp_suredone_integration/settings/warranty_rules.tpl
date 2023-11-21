<div>
    <div class="table-responsive-wrapper">
        <table class="table table-middle table--relative table-responsive" width="100%">
        <thead class="cm-first-sibling">
        <tr>
            <th width="20%">{__("cp_auction.price")}</th>
            <th width="20%">{__("value")}</th>
            <th width="25%">{__("type")}{include file="common/tooltip.tpl" tooltip=__("cp_auction.warranty_tooltip")}</th>
            <th width="15%">&nbsp;</th>
        </tr>
        </thead>
        <tbody>
        {foreach from=$warranty_rules item="rule" key="_key"}
        <tr class="cm-row-item">
            <td width="20%" data-th="{__("cp_auction.price")}">
                <input type="text" name="warranty_data[rules][{$_key}][price]" value="{$rule.price|default:"0.00"|fn_format_price:$primary_currency:null:false}" class="input-medium cm-numeric" />
            </td>
            <td width="20%"  data-th="{__("value")}">
                <input type="text" name="warranty_data[rules][{$_key}][value]" value="{$rule.value}" size="10" class="input-medium"/>
            </td>
            <td width="25%" data-th="{__("type")}">
                <select class="span3" name="warranty_data[rules][{$_key}][type]">
                    <option value="A" {if $rule.type == 'A'}selected="selected"{/if}>{__("absolute")} ({$currencies.$primary_currency.symbol nofilter})</option>
                    <option value="P" {if $rule.type == 'P'}selected="selected"{/if}>{__("percent")} (%)</option>
                </select>
            </td>
            <td width="15%" class="nowrap right">   
                {include file="buttons/clone_delete.tpl" dummy_href=true microformats="cm-delete-row" no_confirm=true}
            </td>
        </tr>
        {/foreach}
        {math equation="x+1" x=$_key|default:0 assign="new_key"}
        <tr class="{cycle values="table-row , " reset=1}" id="box_add_warranty_rules">
            <td width="20%" data-th="{__("quantity")}">
                <input type="text" name="warranty_data[rules][{$new_key}][price]" value="0.00" class="input-medium cm-numeric" /></td>
            <td width="20%" data-th="{__("value")}">
                <input type="text" name="warranty_data[rules][{$new_key}][value]" value="" size="10" class="input-medium "/></td>
            <td width="25%" data-th="{__("type")}">
            <select class="span3" name="warranty_data[rules][{$new_key}][type]">
                <option value="A" selected="selected">{__("absolute")} ({$currencies.$primary_currency.symbol nofilter})</option>
                <option value="P">{__("percent")} (%)</option>
            </select></td>
            <td width="15%" class="right">
                {include file="buttons/multiple_buttons.tpl" item_id="add_warranty_rules"}
            </td>
        </tr>
        </tbody>
        </table>
    </div>

</div>