{if $block.properties.hide_add_to_cart_button == "Y"}
    {assign var="_show_add_to_cart" value=false}
{else}
    {assign var="_show_add_to_cart" value=true}
{/if}

<div class="et-home-grid">
{include file="blocks/list_templates/grid_list.tpl" 
products=$items 
columns=$block.properties.number_of_columns 
form_prefix="block_manager" 
no_sorting="Y" 
no_pagination="Y" 
no_ids="Y" 
obj_prefix="`$block.block_id`000" 
item_number=$block.properties.item_number 
show_name=true
show_old_price=true 
show_price=true
show_rating=true
show_clean_price=true 
show_list_discount=true 
show_add_to_cart=$_show_add_to_cart
but_role="action"
show_features=true
show_product_labels=true
show_discount_label=true
show_shipping_label=true
show_vs_icon_buttons=true
vs_separate_buttons=true
et_show_call_req=true
image_width="300" 
image_height="300"}
</div>