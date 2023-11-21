{if $products}

  {script src="js/tygh/exceptions.js"}

  {if !$no_pagination}
    {include file="common/pagination.tpl"}
  {/if}

  {if !$no_sorting}
    {include file="views/products/components/sorting.tpl"}
  {/if}

  {if !$show_empty}
    {split data=$products size=$columns|default:"2" assign="splitted_products"}
  {else}
    {split data=$products size=$columns|default:"2" assign="splitted_products" skip_complete=true}
  {/if}

  {math equation="100 / x" x=$columns|default:"2" assign="cell_width"}
  {if $item_number == "Y"}
    {assign var="cur_number" value=1}
  {/if}

  {script src="design/themes/vivashop/js/et_product_image_gallery.js"}

  {if $settings.Appearance.enable_quick_view == 'Y'}
    {$quick_nav_ids = $products|fn_fields_from_multi_level:"product_id":"product_id"}
  {/if}

  {function name="et_adv_btns" product_id=$product_id obj_prefix=$obj_prefix}{strip}
    <div class="et-grid-btns clearfix">
      {if $settings.Appearance.enable_quick_view == 'Y'}
        {include file="views/products/components/quick_view_link.tpl" quick_nav_ids=$quick_nav_ids show_et_icon_grid=true}
      {/if}

      {if $settings.General.enable_compare_products == "Y" && !$hide_compare_list_button}
        {include file="buttons/add_to_compare_list.tpl" product_id=$product_id show_et_icon_grid=true}
      {/if}
      {if $addons.wishlist.status == "A" && !$hide_wishlist_button}
        {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product_id`" but_name="dispatch[wishlist.add..`$product_id`]" but_role="text" show_et_icon_grid=true}
      {/if}
    </div>
  {/strip}{/function}

  <div class="grid-list et-grid-list et-vendor-block-grid">
    {strip}
      {foreach from=$splitted_products item="sproducts" name="sprod"}
        {foreach from=$sproducts item="product" name="sproducts"}
          {if $product}
            <div class="et-column{$columns} et-grid-item-wrapper">
            {assign var="obj_id" value=$product.product_id}
            {assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}
            {if $settings.Appearance.enable_quick_view == 'Y'}{$show_et_qv=true}{/if}

            {include file="common/product_data.tpl" 
              product=$product show_et_icon_grid=true 
              show_et_qv=$show_et_qv 
              show_sku=true 
              show_product_amount=true 
              show_et_grid_stock=true 
              show_et_rating=true 
              show_discount_label=true
              show_shipping_label=true
              show_product_labels=true
              hide_label_text=$_hide_label_text}
        
            <div class="ty-grid-list__item ty-quick-view-button__wrapper et-grid-item">
              {assign var="form_open" value="form_open_`$obj_id`"}
              {$smarty.capture.$form_open nofilter}
              {hook name="products:product_multicolumns_list"}
                <div class="ty-grid-list__image">
                  {assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
                  {$smarty.capture.$product_labels nofilter}
                  {include file="views/products/components/product_icon.tpl" product=$product show_gallery=true image_width="300" image_height="300"}

                  {* Buttons: Call request/Compare/Wishlist*}
                  {et_adv_btns product_id=$product.product_id obj_prefix=$obj_prefix}
                  {* /Buttons: Call request/Compare/Wishlist*}
                </div>
                <div class="et-grid-info-wrapper">
                  {assign var="name" value="name_$obj_id"}
                  <div class="et-grid-product-name">
                    {if $item_number == "Y"}
                      <span class="item-number">{$cur_number}.&nbsp;</span>
                      {math equation="num + 1" num=$cur_number assign="cur_number"}
                    {/if}
                    <bdi>{$smarty.capture.$name nofilter}</bdi>
                  </div>
                  <div class="et-grid-hide">
                    <div class="et-grid-sku">{assign var="sku" value="sku_`$obj_id`"}
                      {$smarty.capture.$sku nofilter}</div>
                  </div>

                  {assign var="old_price" value="old_price_`$obj_id`"}
                  {assign var="price" value="price_`$obj_id`"}
                  {assign var="clean_price" value="clean_price_`$obj_id`"}
                  {assign var="list_discount" value="list_discount_`$obj_id`"}

                  <div class="et-price {if $product.price == 0}ty-grid-list__no-price{/if}">
                    {$smarty.capture.$price nofilter}
                    {$smarty.capture.$clean_price nofilter}
                    {$smarty.capture.$list_discount nofilter}
                    {if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}{/if}
                  </div>
                
                  <div class="et-grid-stock-rating clearfix">
                    {assign var="stock" value="product_amount_`$obj_id`"}
                    {if $smarty.capture.$stock}
                      <div class="et-grid-stock ty-float-left">
                          {$smarty.capture.$stock nofilter}
                      </div>
                    {/if}

                    {assign var="rating" value="rating_$obj_id"}
                    {if $smarty.capture.$rating}
                      <div class="grid-list__rating ty-float-right">
                          {$smarty.capture.$rating nofilter}
                      </div>
                    {/if}
                  </div>
                </div>
              {/hook}
              {assign var="form_close" value="form_close_`$obj_id`"}
              {$smarty.capture.$form_close nofilter}
            </div>
          </div>
        {/if}
      {/foreach}
      {if $show_empty && $smarty.foreach.sprod.last}
        {assign var="iteration" value=$smarty.foreach.sproducts.iteration}
        {capture name="iteration"}{$iteration}{/capture}
        {hook name="products:products_multicolumns_extra"}
        {/hook}
        {assign var="iteration" value=$smarty.capture.iteration}
        {if $iteration % $columns != 0}
          {math assign="empty_count" equation="c - it%c" it=$iteration c=$columns}
          {section loop=$empty_count name="empty_rows"}
            <div class="ty-column{$columns}">
              <div class="ty-product-empty">
                <span class="ty-product-empty__text">{__("empty")}</span>
              </div>
            </div>
          {/section}
        {/if}
      {/if}
    {/foreach}
    {/strip}
  </div>

  {if !$no_pagination}
    {include file="common/pagination.tpl"}
  {/if}

{/if}

{capture name="mainbox_title"}{$title}{/capture}