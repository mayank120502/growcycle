{if $addons.ecl_order_weight.display_on_order == 'Y' && $order_info.weight > 0}
<tr>
    <td>{__("weight")}:&nbsp;</td>
    <td>{$order_info.weight} {$settings.General.weight_symbol}</td>
</tr>
{/if}