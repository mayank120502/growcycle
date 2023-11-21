{if $addons.ecl_order_weight.display_on_shipments == 'Y' && $shipment}

{$shipment.weight = 0}

{foreach from=$order_info.products item="oi"}
    {if $oi.amount > 0}
        {$shipment.weight = $shipment.weight + ($oi.extra.weight * $oi.amount)}
    {/if}
{/foreach}

{if $shipment.weight > 0}
<table width="100%" cellpadding="0" cellspacing="1" style="direction: {$language_direction}; margin-top: 20px;">
<tr>
    <td style="text-align: right">
        <b>{__("weight")}:</b>&nbsp;{$shipment.weight} {$settings.General.weight_symbol}
    </td>
</tr>
</table>
{/if}
{/if}