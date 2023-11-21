{$product_detail_view_url = "products.view?product_id=`$product.product_id`" scope=parent}
{if $product.combination}
    {$product_detail_view_url = "products.view?product_id=`$product.product_id`&combination=`$product.combination`" scope=parent}
{/if}
{if $use_vendor_url}
	{$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`" scope=parent}
{/if}