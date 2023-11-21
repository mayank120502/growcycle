{if !$hide_form && $addons.call_requests.buy_now_with_one_click == "Y" && $show_add_to_cart == "Y" && ($et_show_call_req == true || $et_product_scroller == true)}
{$id = "call_request_{$obj_prefix}{$product.product_id}"}
<div class="hidden" id="content_{$id}" title="{__("call_requests.buy_now_with_one_click")}">
</div>
{/if}