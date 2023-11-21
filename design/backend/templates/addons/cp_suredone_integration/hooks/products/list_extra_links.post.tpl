<li><a onclick="fn_cp_update_amount_one_product(id)" id="cp_btn_amount_{$product.product_id}">{__("cp_suredone_integration.cp_update_amount")}</a>
<input class="cp_product_code" type="hidden" id="cp_product_code_{$product.product_id}" value="{$product.product_code}" />
<input class="cp_product_id_sd" type="hidden" id="cp_product_id_{$product.product_id}" value="{$product.product_id}" />
<input class="cp_product_request_items_per_page" type="hidden" value="{$_REQUEST.items_per_page}" />
</li>

<script>
    function fn_cp_update_amount_one_product(id) {
        
        let cp_btn_amount = $('#' + id);
        let cp_product_code = cp_btn_amount.next('.cp_product_code')[0].value;
        let cp_product_id = cp_btn_amount.next('.cp_product_code').next('.cp_product_id_sd')[0].value;
        let cp_items_per_page = cp_btn_amount.next('.cp_product_code').next('.cp_product_id_sd').next('.cp_product_request_items_per_page')[0].value;
        
        $.ceAjax('request', fn_url("suredone.process.get_amount_one_product"), {
            data: {
                cp_product_code, cp_product_id, cp_items_per_page,
                result_ids: 'cp_amount_suredone',
            }
        });
    }
</script>
