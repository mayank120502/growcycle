{if $view_tools}
	<div class="ty-product-switcher clearfix">
	  <a class="ty-product-switcher__a ty-product-switcher__a-left {if !$view_tools.prev_id}disabled{elseif $quick_view}cm-dialog-opener cm-dialog-auto-size{/if}" {if $view_tools.prev_id}href="{$view_tools.prev_url}" title="{if $view_tools.links_label}{$view_tools.links_label}{if $view_tools.show_item_id} #{$view_tools.prev_id}{/if}{else}{__("prev_page")}{/if}" {if $quick_view}data-ca-view-id="{$view_tools.prev_id}" data-ca-target-id="product_quick_view" data-ca-dialog-title="{__("quick_product_viewer")}" rel="nofollow"{/if}{/if}>{if $language_direction == 'rtl'}<i class="et-icon-bc-right"></i>{else}<i class="et-icon-bc-left"></i>{/if}</a>
			<span class="switcher-selected-product">{$view_tools.current}</span>
			<span>{__("of")}</span>
			<span class="switcher-total">{$view_tools.total}</span>
	  <a class="ty-product-switcher__a ty-product-switcher__a-right {if !$view_tools.next_id}disabled{elseif $quick_view}cm-dialog-opener cm-dialog-auto-size{/if}" {if $view_tools.next_id}href="{$view_tools.next_url}" title="{if $view_tools.links_label}{$view_tools.links_label}{if $view_tools.show_item_id} #{$view_tools.next_id}{/if}{else}{__("next")}{/if}" {if $quick_view}data-ca-view-id="{$view_tools.next_id}" data-ca-target-id="product_quick_view" data-ca-dialog-title="{__("quick_product_viewer")}" rel="nofollow"{/if}{/if}>{if $language_direction == 'rtl'}<i class="et-icon-bc-left"></i>{else}<i class="et-icon-bc-right"></i>{/if}</a>
	</div>
{/if}
