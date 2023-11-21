{$obj_prefix="`$block.grid_id`_`$block.block_id`_`$item.tab_id`_000"}

{$block.properties.not_scroll_automatically = "Y"}
{$block.properties.outside_navigation = "Y"}
{$block.properties.scroll_per_page = "Y"}
{$block.properties.item_quantity = $et_column}

{$custom_nav_id = "owl_outside_nav_`$obj_prefix`"}
{$next_button = "owl_next_`$obj_prefix`"}
{$prev_button = "owl_prev_`$obj_prefix`"}
{$scroll_list_id = "scroll_list_`$obj_prefix`"}

<div class="et-scroller">
  {* Arrow navigation *}
  <div class="owl-theme ty-owl-controls" id="{$custom_nav_id}">
    <div class="owl-controls clickable owl-controls-outside"  >
      <div class="owl-buttons">
          <div id="{$prev_button}" class="owl-prev et-disabled">{strip}
            {if $language_direction == 'rtl'}
              <i class="et-icon-arrow-right"></i>
            {else}
              <i class="et-icon-arrow-left"></i>
            {/if}
          {/strip}</div>
          <div id="{$next_button}" class="owl-next et-disabled">{strip}
            {if $language_direction == 'rtl'}
              <i class="et-icon-arrow-left"></i>
            {else}
              <i class="et-icon-arrow-right"></i>
            {/if}
          {/strip}</div>
      </div>
    </div>
  </div>

  {* Content *}
  <div id="{$scroll_list_id}" class="owl-carousel">
    {foreach from=$products item="product" name="products"}{strip}
      <div class="ty-thumbnail-list et-link-thumb et-link-thumb__wrapper">
        <div class="et-link-thumb__inner-wrapper">
          {$obj_id = $product.product_id}
          {$obj_id_prefix = "`$obj_prefix``$obj_id`"}

          {if $et_column>8}
            {$_hide_label_text=true}
          {else}
            {$_hide_label_text=false}
          {/if}

          {include file="common/product_data.tpl" 
            product=$product 
            show_et_icon_grid=true 
            et_categ_block=true 
            show_old_price=true 
            show_et_atc=true 
            show_et_icon_buttons=false
            et_separate_buttons=false
            show_list_buttons=false
            show_discount_label=true
            show_shipping_label=true
            show_product_labels=true
            hide_label_text=$_hide_label_text
            show_et_rating=true}

          <div class="et-link-thumb__item ty-thumbnail-list__item">
            {assign var="form_open" value="form_open_`$obj_id`"}
            {$smarty.capture.$form_open nofilter}

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
            
            {* Image *}
            <div class="et-link-thumb__img_wrapper">
              {assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
              {$smarty.capture.$product_labels nofilter}
              <a class="et-link-thumb__img_a" href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>{include file="common/image.tpl" image_width=$et_image_width image_height=$et_image_height images=$product.main_pair obj_id=$obj_id_prefix no_ids=true et_lazy=true}</a>
            </div>

            {* Title *}
            <div class="et-title-hover">
              <div class="et-title-hover-inner ">
                {assign var="name" value="name_$obj_id"}<bdi>{$smarty.capture.$name nofilter}</bdi>
              </div>
            </div>
            
            {* Price *}
            <div class="et-price">
              {assign var="price" value="price_`$obj_id`"}
              {$smarty.capture.$price nofilter}

              {assign var="old_price" value="old_price_`$obj_id`"}
              {if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}{/if}
            </div>

            {* Rating *}
            {assign var="rating" value="rating_`$obj_id`"}
            <div class="et-link-thumb__rating-wrapper">
              {$smarty.capture.$rating nofilter}
            </div>

            {assign var="form_close" value="form_close_`$obj_id`"}
            {$smarty.capture.$form_close nofilter}
          </div>
        </div>
      </div>
    {/strip}{/foreach}
  </div>
</div>

{include file="common/scroller_init.tpl" 
  prev_selector="#`$prev_button`" 
  next_selector="#`$next_button`" 
  custom_nav_id=$custom_nav_id 
  scroll_list_id=$scroll_list_id
  et_mobile_items=3 
  et_no_rewind=true
}