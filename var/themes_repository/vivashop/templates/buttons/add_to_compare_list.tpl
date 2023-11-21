{strip}
{if !$config.tweaks.disable_dhtml}
    {$ajax_class = "cm-ajax cm-ajax-full-render"}
{/if}
{$c_url = $redirect_url|default:$config.current_url|escape:url}

{if  !$hide_compare_list_button && ($show_et_icon_buttons || $show_et_icon_grid)}
	{include file="buttons/button.tpl" 
		but_text=__("add_to_comparison_list") 
		but_href="product_features.add_product?product_id=$product_id&sl=`$smarty.const.CART_LANGUAGE`&redirect_url=$c_url" 
		but_role="et_icon" 
		but_target_id="comparison_list,account_info*,et-cw*" 
		but_meta="ty-add-to-compare $ajax_class" 
		but_rel="nofollow" 
		et_icon="et-icon-btn-compare"
		but_extra_class="et-add-to-compare"}
{elseif !$hide_compare_list_button}
	{if $et_category_list || $details_page}
		{$but_text=__("compare")}
		{$but_role="et_icon_text_no_btn"}
	{else}
		{$but_text=__("add_to_comparison_list")}
		{$but_role="et_icon_text"}
	{/if}
	{include file="buttons/button.tpl" 
		but_text=$but_text
		but_href="product_features.add_product?product_id=$product_id&redirect_url=$c_url" 
	  but_role=$but_role
		but_target_id="comparison_list,account_info*,et-cw*" 
		but_meta="ty-add-to-compare $ajax_class"
		but_rel="nofollow" 
		et_icon="et-icon-btn-compare"
		but_extra_class="et-add-to-compare et-button"}
{/if}
{/strip}