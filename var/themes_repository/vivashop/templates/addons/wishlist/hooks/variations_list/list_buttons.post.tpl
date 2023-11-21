{if $show_add_to_wishlist}
  	{$but_role="et_icon_text_no_btn"}
  	{$but_id="button_wishlist_`$obj_prefix``$product.product_id`"}
  	{$but_name="dispatch[wishlist.add..`$product.product_id`]"}

		{include file="buttons/button.tpl" 
			but_text=$but_text
			but_href=$but_href
		  but_role=$but_role
			but_id=$but_id 
		  but_target=$but_target 
			but_name=$but_name 
			but_onclick=$but_onclick 
			et_icon="et-icon-btn-wishlist"
			but_extra_class="et-add-to-wishlist"}
{/if}