<div class="hidden" id="content_tab_cp_picker_vendor_{$id}">
    {$add_storefront_text = __("add_vendor")}
    {include file="pickers/companies/picker.tpl"
        multiple=true
        input_name="payment_data[cp_company_ids]"
        item_ids=$payment.cp_company_ids
        data_id="cp_company_ids"
        but_meta="pull-right"
        no_item_text=__("all_vendors")
        but_text=$add_storefront_text
        view_only=($is_sharing_enabled && $runtime.company_id)
    }

</div>