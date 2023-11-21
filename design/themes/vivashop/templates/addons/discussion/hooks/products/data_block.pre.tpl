{if $show_rating && $addons.product_reviews.status !== "ObjectStatuses::ACTIVE"|enum}

	{if $product.discussion_type && $product.discussion_type == "R" || $product.discussion_type == "B"}
		{if $product.average_rating}
			{$average_rating = $product.average_rating}
		{elseif $product.discussion.average_rating}
			{$average_rating = $product.discussion.average_rating}
		{/if}
		{if !(isset($average_rating))}
			{$et_disc=fn_get_discussion($product.product_id, "P",true)}
			{$average_rating=$et_disc.average_rating}
		{/if}
		{if $average_rating >= 0}
			{if $addons.et_vivashop_mv_functionality.et_product_link=="vendor"}
			  {if $product.company_id && $product.company_has_store}
			    {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
			    {if !$smarty.request.company_id}
			      {$et_add_blank='target="_blank"'}
			    {else}
			      {$et_add_blank=''}
			    {/if}
			  {else}
			    {$product_detail_view_url="products.view&product_id=`$product.product_id`"}
			    {$et_add_blank=''}
			  {/if}
			{else}
			  {$et_add_blank=''}
			  {if $use_vendor_url}
			      {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
			  {else}
			    {$product_detail_view_url="products.view&product_id=`$product.product_id`"}
			  {/if}
			{/if}

			{if $average_rating>0}
				{$_et_no_rating=false}
			{else}
				{$_et_no_rating=true}
			{/if}
			{include file="addons/discussion/views/discussion/components/stars.tpl"
				stars=$average_rating|fn_get_discussion_rating
				link="`$product_detail_view_url`&selected_section=discussion#et-tab-product_reviews" et_on_vs=true et_no_rating=$_et_no_rating}
		{/if}
	{/if}
{/if}
