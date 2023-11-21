{strip}
{$wishlist_button_type = $wishlist_button_type|default:  "icon"}
{$but_id               = $wishlist_but_id|default:       $but_id}
{$but_name             = $wishlist_but_name|default:     $but_name}
{$but_title            = $wishlist_but_title|default:    __("add_to_wishlist")}
{$but_role             = $wishlist_but_role|default:     "text"}
{$but_onclick          = $wishlist_but_onclick|default:  $but_onclick}
{$but_href             = $wishlist_but_href|default:     $but_href}

{if $show_et_icon_buttons || $show_et_icon_grid}
{include file="buttons/button.tpl" 
	but_id=$but_id 
	but_name=$but_name 
	but_text=__("add_to_wishlist") 
	but_role="et_icon" 
	but_onclick=$but_onclick 
	but_href=$but_href
	et_icon="et-icon-btn-wishlist"
	but_extra_class="et-add-to-wishlist"}
{else}
{if $et_category_list || $details_page}
	{$but_text=__("et_wishlist_button_text")}
	{$but_role="et_icon_text_no_btn"}
{else}
	{$but_text=__("add_to_wishlist")}
	{$but_role="et_icon_text"}
{/if}
{include file="buttons/button.tpl" 
	but_id=$but_id 
	but_name=$but_name 
	but_text=$but_text
  but_role=$but_role
	but_onclick=$but_onclick 
	but_href=$but_href
  but_target=$but_target 
	et_icon="et-icon-btn-wishlist"
	but_extra_class="et-add-to-wishlist et-button"}
{/if}
{/strip}