<div class="ty-thumbnail-list et-link-thumb {if $et_column>6 || ($position=="T" || $position=="B")}et-horiz-scroll1{/if}"  {if $et_menu.size.height}style="max-height: {$et_menu.size.height-90}px;"{/if}>
  {if ($position=="T" || $position=="B") && $et_column>6}
    <div class="et-scroller et_menu_product-scroller">
      <div class="owl-theme ty-owl-controls" id="owl_outside_nav_{$obj_prefix}">
        <div class="owl-controls clickable owl-controls-outside"  >
          <div class="owl-buttons">
            <div id="owl_next_{$obj_prefix}" class="owl-next">
              {if $language_direction == 'rtl'}
                <i class="et-icon-arrow-left"></i>
              {else}
                <i class="et-icon-arrow-right"></i>
              {/if}
            </div>
            <div id="owl_prev_{$obj_prefix}" class="owl-prev">
              {if $language_direction == 'rtl'}
                <i class="et-icon-arrow-right"></i>
              {else}
                <i class="et-icon-arrow-left"></i>
              {/if}
            </div>
          </div>
        </div>
      </div>

      <div id="scroll_list_{$obj_prefix}" class="owl-carousel ty-scroller-list">
  {/if}
  {foreach from=$products item="product" name="products"}{strip}
    <div class="et-home-categ-block et-menu-product-wrapper {if $et_column>6}{elseif $et_column>1}ty-column{$et_column}{elseif $et_column=1}{else}ty-column6{/if}">
      {assign var="obj_id" value=$product.product_id}
      {assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}
      {include file="common/product_data.tpl" product=$product show_et_icon_grid=true et_mcb=true}

      {hook name="products:product_thumbnail_list"}
        <div class="ty-thumbnail-list__item">
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
          
          <div class="et-links_thumb_img_wrapper">
            <a class="ty-thumbnail-list__img-block" href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>
              {assign var="discount_label" value="discount_label_`$obj_prefix``$obj_id`"}
              {$smarty.capture.$discount_label nofilter}
              {include file="common/image.tpl" image_width="150" image_height="150" images=$product.main_pair obj_id=$obj_id_prefix no_ids=true class="ty-thumbnail-list__img" et_lazy=true}
            </a>

            {assign var="rating" value="rating_`$obj_id`"}
            {if $smarty.capture.$rating|trim}
              <div class="rating-wrapper">
                {$smarty.capture.$rating nofilter}
              </div>
            {/if}
          </div>
          {if $show_name=="Y"}
            <div class="ty-thumbnail-list__name">{if $block.properties.item_number == "Y"}{$smarty.foreach.products.iteration}.&nbsp;{/if}
            {assign var="name" value="name_$obj_id"}{$smarty.capture.$name nofilter}</div>
          {/if}

          <div class="et-price">
              {assign var="price" value="price_`$obj_id`"}
              {if $show_price=="Y"}
                {$smarty.capture.$price nofilter}
              {/if}

              {assign var="old_price" value="old_price_`$obj_id`"}
              {if $smarty.capture.$old_price|trim && $show_old_price=="Y"}&nbsp;{$smarty.capture.$old_price nofilter}{/if}
          </div>
          {if !$et_hide_vendor}
            <div class="et-scrl-vendor">
              <span>{__("et_pp_sold_by")}:</span> <a href="{"companies.view?company_id=`$product.company_id`"|fn_url}">{$product.company_name}</a>
            </div>
          {/if}

          {if $show_add_to_cart}
            <div class="ty-thumbnail-list__butons">
              {assign var="add_to_cart" value="add_to_cart_`$obj_id`"}
              {$smarty.capture.$add_to_cart nofilter}
            </div>
          {/if}

          {assign var="form_close" value="form_close_`$obj_id`"}
          {$smarty.capture.$form_close nofilter}
        </div>
      {/hook}
    </div>
  {/strip}{/foreach}
  {if $position=="T" || $position=="B"}
      </div>
    </div>

    {$block.properties.not_scroll_automatically = "Y"}
    {$block.properties.outside_navigation = "Y"}
    {$block.properties.scroll_per_page = "Y"}
    {$block.properties.item_quantity = 6}

    {$custom_nav_id = "owl_outside_nav_`$obj_prefix`"}
    {$next_button = "owl_next_`$obj_prefix`"}
    {$prev_button = "owl_prev_`$obj_prefix`"}
    {$scroll_list_id = "scroll_list_`$obj_prefix`"}

    {include file="common/scroller_init.tpl" 
      prev_selector="#`$prev_button`" 
      next_selector="#`$next_button`" 
      custom_nav_id=$custom_nav_id 
      scroll_list_id=$scroll_list_id
      et_no_rewind=true
    }
  {/if}
</div>