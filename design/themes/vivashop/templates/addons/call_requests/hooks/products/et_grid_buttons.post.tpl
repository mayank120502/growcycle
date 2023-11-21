{if !$hide_form && $addons.call_requests.buy_now_with_one_click == "Y" && $et_show_call_req == true}
	{include file="buttons/button.tpl" 
		but_text=__("call_requests.buy_now_with_one_click") 
		but_id="buy_now_with_one_click_{$obj_prefix}{$product.product_id}"
		but_href="call_requests.request?product_id={$product.product_id}&obj_prefix={$obj_prefix}"
		but_role="et_icon_popup"
		et_icon="et-icon-btn-call"
		but_extra_class="et-call-request"}
{/if}