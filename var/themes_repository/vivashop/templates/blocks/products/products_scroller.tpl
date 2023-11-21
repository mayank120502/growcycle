{** block-description:tmpl_scroller **}

{if $settings.Appearance.enable_quick_view == "Y" && $block.properties.enable_quick_view == "Y"}
  {$quick_nav_ids = $items|fn_fields_from_multi_level:"product_id":"product_id"}
{/if}

{if $block.properties.hide_add_to_cart_button == "Y"}
  {$_show_add_to_cart=false}
{else}
  {$_show_add_to_cart=true}
{/if}
{if $block.properties.show_price == "Y"}
  {$_hide_price=false}
{else}
  {$_hide_price=true}
{/if}

{$show_old_price = true}

{$obj_prefix="`$block.block_id`000"}
{$block.block_id = "{$block.block_id}_{uniqid()}"}

<div class="et-scroller">
  {if $block.properties.outside_navigation == "Y"}
    <div class="owl-theme ty-owl-controls" id="owl_outside_nav_{$block.block_id}">
      <div class="owl-controls clickable owl-controls-outside"  >
        <div class="owl-buttons">
            <div id="owl_prev_{$obj_prefix}" class="owl-prev">{strip}
              {if $language_direction == 'rtl'}
                <i class="et-icon-arrow-right"></i>
              {else}
                <i class="et-icon-arrow-left"></i>
              {/if}
            {/strip}</div>
            <div id="owl_next_{$obj_prefix}" class="owl-next">{strip}
              {if $language_direction == 'rtl'}
                <i class="et-icon-arrow-left"></i>
              {else}
                <i class="et-icon-arrow-right"></i>
              {/if}
            {/strip}</div>
        </div>
      </div>
    </div>
  {/if}

  <div id="scroll_list_{$block.block_id}" class="owl-carousel ty-scroller-list">
    {foreach from=$items item="product" name="for_products"}
      {if $settings.Appearance.enable_quick_view == "Y" && $block.properties.enable_quick_view == "Y"}
          {$show_et_qv=true}
      {/if}
      {$obj_id="scr_`$block.block_id`000`$product.product_id`"}
      {hook name="products:product_scroller_list"}
        {include file="blocks/list_templates/et_simple_list.tpl" 
          product=$product 
          show_name=true 
          show_price=true 
          show_add_to_cart=$_show_add_to_cart 
          but_role="action" 
          hide_price=$_hide_price 
          hide_qty=true 
          show_rating=true
          show_et_icon_buttons=true
          show_old_price=true
          show_clean_price=true
          show_list_buttons=true
          show_et_qv=$show_et_qv
          et_scroller_buttons=true
          show_product_labels=true 
          show_discount_label=true 
          show_shipping_label=true
        }
      {/hook}
    {/foreach}
  </div>
</div>


{include file="common/scroller_init.tpl" prev_selector="#owl_prev_`$obj_prefix`" next_selector="#owl_next_`$obj_prefix`" et_mobile_items=2 et_no_rewind=true}