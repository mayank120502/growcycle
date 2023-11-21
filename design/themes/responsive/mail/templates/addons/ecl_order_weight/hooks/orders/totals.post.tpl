{if $addons.ecl_order_weight.display_on_invoices == 'Y' && $order_info.weight > 0}
<tr>
    <td style="text-align: right; white-space: nowrap; font-size: 12px; font-family: Arial;">{__("weight")}:&nbsp;</td>
    <td style="text-align: right; white-space: nowrap; font-size: 12px; font-family: Arial;">{$order_info.weight} {$settings.General.weight_symbol}</td>
</tr>
{/if}