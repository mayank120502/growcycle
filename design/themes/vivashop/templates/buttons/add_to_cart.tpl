{hook name="buttons:add_to_cart"}
	{assign var="c_url" value=$config.current_url|escape:url}
	{if ($settings.Checkout.allow_anonymous_shopping == "allow_shopping" || $auth.user_id) && ($show_et_icon_buttons || $show_et_icon_grid || $et_category_list)}
		{if ($product.avail_since > $smarty.const.TIME)}
			{*Product coming soon with add to cart*}
			{$avail_date=$avail_date|default:$product.avail_since}
			{assign var="date" value=$avail_date|date_format:$settings.Appearance.date_format}
			{assign var="et_coming_soon" value=__("product_coming_soon_add", ["[avail_date]" => $date])}
			{if $show_et_icon_buttons}
				{include file="buttons/button.tpl" 
					but_text=$but_text|default:$et_coming_soon
					but_id=$but_id 
					but_href=$but_href 
					but_role="et_icon"
					but_target=$but_target 
					but_name=$but_name 
					but_onclick=$but_onclick 
					et_icon="et-icon-btn-cart"
					but_extra_class="et-add-to-cart et-atc-icon-only"}
			{elseif $show_et_icon_grid || $et_category_list}
				{if $et_category_compact}
					{capture name="et-soon-text_`$obj_id_prefix`"}
			  		<div class="et-soon-txt-grid">{$et_coming_soon}</div>
			  	{/capture}
				{/if}
				{include file="buttons/button.tpl" 
					but_text=$but_text|default:__("add_to_cart") 
					but_id=$but_id 
					but_href=$but_href 
					but_role="et_icon_text"
					but_target=$but_target 
					but_name=$but_name 
					but_onclick=$but_onclick 
					et_icon="et-icon-btn-cart"
					but_extra_class="et-add-to-cart et-in-stock"}
					{if !$et_category_list}
					   <div class="et-soon-txt-grid et-grid-hide">{$et_coming_soon}</div>
					{/if}
			{/if}
		{else}
			{if $show_et_icon_buttons}
				{include file="buttons/button.tpl" 
					but_text=$but_text|default:__("add_to_cart") 
					but_id=$but_id 
					but_href=$but_href 
					but_role="et_icon"
					but_target=$but_target 
					but_name=$but_name 
					but_onclick=$but_onclick 
					et_icon="et-icon-btn-cart"
					but_extra_class="et-add-to-cart et-atc-icon-only"}
			{elseif $show_et_icon_grid || $et_category_list}
				{include file="buttons/button.tpl" 
					but_text=$but_text|default:__("add_to_cart") 
					but_id=$but_id 
					but_href=$but_href 
					but_role="et_icon_text"
					but_target=$but_target 
					but_name=$but_name 
					but_onclick=$but_onclick 
					et_icon="et-icon-btn-cart"
					but_extra_class="et-add-to-cart et-in-stock"}
			{/if}
		{/if}

	{elseif $settings.Checkout.allow_anonymous_shopping == "allow_shopping" || $auth.user_id}
		{if ($product.avail_since > $smarty.const.TIME)}
			{if $details_page || $show_et_atc}
				{include file="buttons/button.tpl" 
					but_text=$but_text|default:__("add_to_cart") 
					but_id=$but_id 
					but_href=$but_href 
					but_role="et_icon_text"
					but_target=$but_target 
					but_name=$but_name 
					but_onclick=$but_onclick 
					et_icon="et-icon-btn-cart"
					but_extra_class="et-add-to-cart et-in-stock"}
			{/if}
		{else}
			{if $details_page || $show_et_atc}
				{include file="buttons/button.tpl" 
					but_text=$but_text|default:__("add_to_cart") 
					but_id=$but_id 
					but_href=$but_href 
					but_role="et_icon_text"
					but_target=$but_target 
					but_name=$but_name 
					but_onclick=$but_onclick 
					et_icon="et-icon-btn-cart"
					but_extra_class="et-add-to-cart et-in-stock"}
				{include file="buttons/button.tpl" 
					but_id="cr_`$but_id`"
					but_text=$but_text|default:__("add_to_cart") 
					but_meta="hidden"
					but_role="submit"}
			{else}
				{if $et_show_icon_atc}
					<div class="et-product-atc">
						{include file="buttons/button.tpl" 
							but_text=$but_text|default:__("add_to_cart") 
							but_id=$but_id 
							but_href=$but_href 
							but_role="et_icon_text"
							but_target=$but_target 
							but_name=$but_name 
							but_onclick=$but_onclick 
							et_icon="et-icon-btn-cart"
							but_extra_class="et-add-to-cart et-in-stock"}
					</div>
				{else}
					{include file="buttons/button.tpl" but_id=$but_id but_text=$but_text|default:__("add_to_cart") but_name=$but_name but_onclick=$but_onclick but_href=$but_href but_target=$but_target but_role=$but_role|default:"text" but_meta="ty-btn__primary ty-btn__big ty-btn__add-to-cart cm-form-dialog-closer"}
				{/if}
			{/if}
		{/if}
	{else}
		{if $runtime.controller == "auth" && $runtime.mode == "login_form"}
			{assign var="login_url" value=$config.current_url}
		{else}
			{assign var="login_url" value="auth.login_form?return_url=`$c_url`"}
		{/if}
		
		{if $show_et_icon_buttons}
			{include file="buttons/button.tpl" 
				but_id=$but_id 
				but_text=__("sign_in_to_buy")
				but_role="et_icon"
				but_href=$login_url
				et_icon="et-icon-contact-for-price3"
				but_extra_class="et-add-to-cart et-in-stock et-atc-icon-only"}
		{else}
			{include file="buttons/button.tpl" 
				but_id=$but_id 
				but_text=__("sign_in_to_buy")
				but_name=$but_name 
				but_onclick=$but_onclick 
				but_href=$login_url
				but_target=$but_target
				but_meta="et-atc" 
				et_icon="et-icon-contact-for-price3"
				but_role="et_icon_text"
				but_extra_class="et-add-to-cart"}
		{/if}
	{/if}
{/hook}
{* Change the Buy now button behavior using a hook *}
{$show_buy_now = $show_buy_now scope = parent}