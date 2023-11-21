{if !$hide_form 
	&& $addons.call_requests.buy_now_with_one_click == "YesNo::YES"|enum 
	&& ($auth.user_id || $settings.Checkout.allow_anonymous_shopping == "allow_shopping") 
	&& !$show_et_icon_grid 
	&& !$et_category_list  
	&& !$et_product_scroller 
	&& $show_buy_now|default:true}

	{$is_not_required_option = true}

	{foreach $product.product_options as $option}
	    {if $option.required === "YesNo::YES"|enum}
	        {$is_not_required_option = false}
	        {break}
	    {/if}
	{/foreach}
	{if (
	    $settings.General.inventory_tracking == "YesNo::NO"|enum
	    || $settings.General.allow_negative_amount == "YesNo::YES"|enum
	    || (
	        $product_amount > 0
	        && $product_amount >= $product.min_qty
	    )
	    || $product.tracking == "ProductTracking::DO_NOT_TRACK"|enum
	    || $product.is_edp == "YesNo::YES"|enum
	    || $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
	)}

		{$link_meta="ty-btn ty-btn__text ty-cr-product-button et-buy-now cm-dialog-destroy-on-close"}
	 	

		{hook name="call_requests:call_request_button"}
		{if $details_page && ($show_product_options || $is_not_required_option)}
		 		<!--add_to_cart_update_{$obj_prefix}|{$obj_id}--></div>
			</div>
			<div class="et_product_call-req">
		 		{$et_icon="et-icon-btn-call"}
		 		{$link_meta="et-button et-call-request et-btn ty-btn cm-dialog-destroy-on-close"}
		 		{include file="common/popupbox.tpl"
		 			href="call_requests.request?product_id={$product.product_id}&obj_prefix={$obj_prefix}"
		 			link_text=__("call_requests.buy_now_with_one_click")
		 			text=__("call_requests.buy_now_with_one_click")
		 			id="buy_now_with_one_click_{$obj_prefix}{$product.product_id}"
		 			link_meta=$link_meta
		 			et_btn_content=""
		 			content=""
		 			dialog_additional_attrs=["data-ca-product-id" => $product.product_id, "data-ca-dialog-purpose" => "call_request"]
		 			et_icon=$et_icon}
			</div>
	 	 	<div>
	 			<div>
	 	{else}
	 		{$link_icon="et-icon-btn-call"}
	 		{$link_meta="ty-btn ty-cr-product-button et-buy-now cm-dialog-destroy-on-close"}
	 		{$text=__("call_requests.buy_now_with_one_click")}
		 	{include file="common/popupbox.tpl"
			 href="call_requests.request?product_id={$product.product_id}&obj_prefix={$obj_prefix}"
			 link_text=$link_text
			 text=$text
			 id="buy_now_with_one_click_{$obj_prefix}{$product.product_id}"
			 link_meta=$link_meta
			 content=""
			 dialog_additional_attrs=["data-ca-product-id" => $product.product_id, "data-ca-dialog-purpose" => "call_request"]
			 link_icon=$link_icon}
		{/if}
		{/hook}
	{/if}
{/if}
