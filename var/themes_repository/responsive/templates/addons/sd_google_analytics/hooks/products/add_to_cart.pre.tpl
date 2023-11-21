{* send product_data to call_request js ceEvent *}

<input type="hidden" name="product_data[{$obj_id}][name]" value="{$product.product}" />
<input type="hidden" name="product_data[{$obj_id}][product_code]" value="{$product.product_code}" />
<input type="hidden" name="product_data[{$obj_id}][category]" value="{$product|fn_sd_ga_get_main_category}"/>
<input type="hidden" name="product_data[{$obj_id}][brand]" value="{$product.product_id|fn_sd_ga_get_brand:$product}"/>
<input type="hidden" name="product_data[{$obj_id}][variant]" value="{$product.product_id|fn_sd_ga_get_product_options:$product.selected_options}"/>
{if fn_allowed_for("MULTIVENDOR") && $vendor_tracking_codes}
    <input type="hidden" name="product_data[{$obj_id}][ga_code]" value="{$vendor_tracking_codes[$product.company_id]}"/>
    <input type="hidden" name="product_data[{$obj_id}][tracker]" value="{$product.company_id}"/>
{/if}
