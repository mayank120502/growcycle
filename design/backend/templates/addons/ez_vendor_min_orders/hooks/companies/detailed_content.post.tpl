{include file="common/subheader.tpl" title=__("vendor_min_orders")}

<div class="collapsed in">
	<div class="control-group">
		<label class="control-label" for="vendor_min_order_amount">{__("vendor_min_orders_min_order_amount")}:</label>
		<div class="controls">
			<input type="text" name="company_data[vendor_min_order_amount]" id="vendor_min_order_amount" size="50" value="{$company_data.vendor_min_order_amount}" class="input-medium">
		</div>
	</div>
</div>
