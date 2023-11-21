{$show_select_variations_button=$show_select_variations_button|default:true}

{if !$details_page && $product.has_child_variations && $show_select_variations_button}
    {hook name="products:add_to_cart"}
        {if $show_et_icon_buttons}
          {include file="buttons/button.tpl" 
            but_id="button_cart_`$obj_prefix``$obj_id`" 
            but_text=__("product_variations.select_variation") 
            but_href="{"products.view?product_id=`$product.product_id`"|fn_url}"
            but_role="et_icon"
            but_name=""
            et_icon="et-icon-btn-opt"
            but_extra_class="et-add-to-cart et-atc-icon-only"}
        {else}
          {include file="buttons/button.tpl" 
            but_text=__("product_variations.select_variation")
            but_id="button_cart_`$obj_prefix``$obj_id`" 
            but_href="{"products.view?product_id=`$product.product_id`"|fn_url}"
            but_role="et_icon_text"
            but_target=$but_target 
            but_name=""
            but_onclick=$but_onclick 
            et_icon="et-icon-btn-opt"
            but_extra_class="et-add-to-cart"}
        {/if}
    {/hook}
{/if}
