{if !($addons.master_products.status == "A" && !$product.company_id)}
<div class="et-qv-vendor-info">
	<div class="ty-column2 ty-center et-qv-vendor-name-wrapper">
		<a href="{"companies.view?company_id=`$company_id`"|fn_url}" class="et-vendor-name" target="_blank">
			<i class="et-icon-fib-premium"></i>
			<span>{$product.company_name}</span>
		</a>
	</div>
	<div class="ty-column2 ty-center">
		<div class="et-vendor-contact et-vendor_detail-wrapper">
			{if $addons.vendor_communication.status == "A"}
				{if "MULTIVENDOR"|fn_allowed_for && $addons.vendor_communication.show_on_product == "Y" && ($details_page || $quick_view)}
			    {include file="addons/vendor_communication/views/vendor_communication/components/new_thread_button.tpl" object_id=$product.product_id show_form=false}
			  {/if}
			{/if}
		</div>
	</div>
</div>
{/if}