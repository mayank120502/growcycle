{$buying_types = $product.cp_buying_types|default:[]}
{$contact_vendor_type = "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::CONTACT_VENDOR"|enum}

{if [$contact_vendor_type] === $buying_types}
    {$show_qty = false scope="parent"}
{/if}
