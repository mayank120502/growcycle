{if !$hide_form && $addons.call_requests.buy_now_with_one_click == "Y"}
		</div>
	</div>
	{$et_icon="et-icon-btn-call"}
	{$link_meta="et-button et-call-request et-btn ty-btn"}
	{include file="common/popupbox.tpl"
		href="call_requests.request?product_id={$product.product_id}&obj_prefix={$obj_prefix}"
		link_text=__("call_requests.buy_now_with_one_click")
		text=__("call_requests.buy_now_with_one_click")
		id="buy_now_with_one_click_{$obj_prefix}{$product.product_id}"
		link_meta=$link_meta
		et_btn_content=""
		content=""
		et_icon=$et_icon}
	<div>
		<div>
{/if}