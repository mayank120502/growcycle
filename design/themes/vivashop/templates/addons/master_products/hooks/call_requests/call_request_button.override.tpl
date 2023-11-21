{if $product.master_product_id || !$product.company_id}
    {if $show_product_options || ($is_not_required_option || $details_page)}
            <!--add_to_cart_update_{$obj_prefix}|{$obj_id}--></div>
        </div>
        <div class="et_product_call-req">
            {$et_icon="et-icon-btn-call"}
            {$link_meta="et-button et-call-request et-btn ty-btn cm-dialog-destroy-on-close"}
            {include file="common/popupbox.tpl"
                href="call_requests.request?product_id={$product.best_product_offer_id}&obj_prefix={$obj_prefix}"
                link_text=__("call_requests.buy_now_with_one_click")
                text=__("call_requests.buy_now_with_one_click")
                id="buy_now_with_one_click_{$obj_prefix}{$product.best_product_offer_id}"
                link_meta=$link_meta
                et_btn_content=""
                content=""
                dialog_additional_attrs=["data-ca-product-id" => $product.best_product_offer_id, "data-ca-dialog-purpose" => "call_request"]
                et_icon=$et_icon}
        </div>
        <div>
            <div>
    {else}
        {$link_icon="et-icon-btn-call"}
        {$link_meta="ty-btn ty-cr-product-button et-buy-now cm-dialog-destroy-on-close"}
        {$text=__("call_requests.buy_now_with_one_click")}
        {include file="common/popupbox.tpl"
         href="call_requests.request?product_id={$product.best_product_offer_id}&obj_prefix={$obj_prefix}"
         link_text=$link_text
         text=$text
         id="buy_now_with_one_click_{$obj_prefix}{$product.best_product_offer_id}"
         link_meta=$link_meta
         content=""
         dialog_additional_attrs=["data-ca-product-id" => $product.best_product_offer_id, "data-ca-dialog-purpose" => "call_request"]
         link_icon=$link_icon}
    {/if}
{/if}