{style src="addons/csc_live_search/styles.less"}
{style src="addons/csc_live_search/synonyms.less"}
{if $runtime.controller == "csc_live_search" && $runtime.mode == "styles"}
{assign var="one_of_ten" value=['#595154', '#50AFD6', '#47ADA5', '#5A59C4', '#b9032f', '#fd5461', '#d81f83', '#7C94C0', '#8DE0C6', '#FC918B']}
{assign var="one_of_ten_key" value=0|rand:9}
	<style>
        @cls_base: {$options.base_text_color};
        @cls_background: {$options.active_elements_background};
        @cls_link: {$options.link_color};
        @cls_tabs: {$options.active_elements_color};
        @cls_radius: {$options.border_radius}px;
		{if $options.color_type == "M"}@cls_category_color: {$one_of_ten.$one_of_ten_key};
		{else if $options.color_type == "A"}@cls_category_color: #{1|rand:200|md5|substr:0:6};
		{else if $options.category_e && $options.color_type == "E"}@cls_category_color: {$options.category_e};{/if}
    </style>
    
    
    <style>
        {if $smarty.request.elm_base_text_color}@cls_base: #{$smarty.request.elm_base_text_color};{/if}
        {if $smarty.request.elm_active_elements_background}@cls_background: #{$smarty.request.elm_active_elements_background};{/if}
        {if $smarty.request.elm_link_color}@cls_link: #{$smarty.request.elm_link_color};{/if}
        {if $smarty.request.elm_active_elements_color}@cls_tabs: #{$smarty.request.elm_active_elements_color};{/if}
        {if $smarty.request.elm_border_radius}@cls_radius: {$smarty.request.elm_border_radius}px;{/if}
		{if $smarty.request.elm_color_type == "M"}@cls_category_color: {$one_of_ten.$one_of_ten_key};
		{else if $smarty.request.elm_color_type == "A"}@cls_category_color: #{1|rand:200|md5|substr:0:6};
		{else if $smarty.request.elm_color_type == "E" && $smarty.request.elm_category_e}@cls_category_color: #{$smarty.request.elm_category_e};
		{else if $smarty.request.elm_color_type == "E"}@cls_category_color: #50AFD6;{/if}
		{if $smarty.request.elm_show_category_gradient == "Y" || ($options.show_category_gradient == "Y" && !$smarty.request.elm_show_category_gradient)}@cls_category: linear-gradient(to top, @cls_category_color, #fff 200%);
		{else}
			@cls_category: linear-gradient(@cls_category_color, @cls_category_color);
		{/if}
		
		{if $smarty.request.elm_show_category == "Y"}.clsLabel{ display: flex !important;}{/if}
		{if $smarty.request.elm_show_category == "N"}.clsLabel{ display: none !important;}{/if}		
		
		{if $smarty.request.elm_show_price == "D"}.clsPrices{ display: none !important;}{/if}
		{if  $smarty.request.elm_show_price && $smarty.request.elm_show_price != "D"}.clsPrices{ display: block !important;}{/if}
		
		{if $smarty.request.elm_show_cart == "D"}a[type="cartAdd"]{ display: none !important;}{/if}
		{if  $smarty.request.elm_show_cart && $smarty.request.elm_show_cart != "D"}a[type="cartAdd"]{ display: inline !important;}{/if}
		
		{if $smarty.request.elm_show_product_code == "Y"}.clsArt{ display: block !important;}{/if}
		{if $smarty.request.elm_show_product_code == "N"}.clsArt{ display: none !important;}{/if}
		
		{if $smarty.request.elm_show_wish == "Y"}a[type="wishAdd"]{ display: inline !important;}{/if}
		{if $smarty.request.elm_show_wish == "N"}a[type="wishAdd"]{ display: none !important;}{/if}
		
		{if $smarty.request.elm_show_compare == "Y"}a[type="compAdd"]{ display: inline !important;}{/if}
		{if $smarty.request.elm_show_compare == "N"}a[type="compAdd"]{ display: none !important;}{/if}	
		
		{if $smarty.request.elm_show_quick_view == "Y"}a[type="viewAdd"]{ display: inline !important;}{/if}
		{if $smarty.request.elm_show_quick_view == "N"}a[type="viewAdd"]{ display: none !important;}{/if}	
		
					
		
		
		
		
		
    </style>
    {style src="../../themes/responsive/css/addons/csc_live_search/styles.less"}
    {if $smarty.request.elm_theme}
    	{style src="../../themes/responsive/css/addons/`$smarty.request.elm_theme`"}
    {else}
    	{style src="../../themes/responsive/css/addons/`$options.theme`"}
    {/if}
	{style src="addons/csc_live_search/styles_front_changes.less"}
{/if}
