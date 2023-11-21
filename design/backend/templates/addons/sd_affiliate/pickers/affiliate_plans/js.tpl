<tr {if !$clone}id="{$root_id}_{$delete_id}" {/if}class="cm-js-item{if $clone} cm-clone hidden{/if}">
    {if $type == 'save'}
        <td>{$plan|fn_get_affiliate_plan_name}</td>
    {else}
        <td>{$plan nofilter}</td>
    {/if}
    <td>&nbsp;</td>
    <td class="nowrap">
        {capture name="tools_list"}
            <li>{btn type="list" text=__("edit") href="affiliate_plans.update?plan_id=`$delete_id`"}</li>
            <li>{btn type="list" text=__("remove") onclick="Tygh.$.cePicker('delete_js_item', '{$root_id}', '{$delete_id}', 'p'); return false;"}</li>
        {/capture}
        <div class="hidden-tools">
            {dropdown content=$smarty.capture.tools_list}
        </div>
    </td>
</tr>
