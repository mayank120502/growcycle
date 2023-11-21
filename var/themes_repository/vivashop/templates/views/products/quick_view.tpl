<div class="ty-quick-view__wrapper">
  {assign var="quick_view" value="true"}
  {capture name="val_hide_form"}{/capture}
  {capture name="val_capture_options_vs_qty"}{/capture}
  {capture name="val_capture_buttons"}{/capture}
  {capture name="val_no_ajax"}{/capture}
  {script src="js/tygh/exceptions.js"}
  {$obj_prefix=$obj_prefix|default:"ajax"}
  <div class="ty-product-block" id="product_main_info_{$obj_prefix}">
    <div id="et-quick-view">
      <div class="ty-product-block__wrapper clearfix">
        {hook name="products:view_main_info"}
          {if $product}
            {$obj_id=$product.product_id}

            {if $smarty.request.use_vendor_url}
              {$use_vendor_url=true}
            {/if}
            {include file="common/product_data.tpl"
              obj_prefix=$obj_prefix
              obj_id=$obj_id
              product=$product
              but_role="big"
              but_text=__("add_to_cart")
              add_to_cart_meta="cm-form-dialog-closer"
              show_sku=true
              show_et_grid_stock=true
              show_rating=true
              show_old_price=true
              show_price=true
              show_clean_price=true
              et_show_discount_text=true
              details_page=true
              show_product_labels=true
              show_discount_label=true
              show_shipping_label=true
              show_product_amount=true
              show_product_options=true
              hide_form=$smarty.capture.val_hide_form
              min_qty=true
              show_edp=true
              show_add_to_cart=true
              show_list_buttons=true
              capture_buttons=$smarty.capture.val_capture_buttons
              capture_options_vs_qty=$smarty.capture.val_capture_options_vs_qty
              separate_buttons=true
              block_width=true
              no_ajax=$smarty.capture.val_no_ajax
              show_descr=true
              quick_view=true
              et_hide_wishlist=true}

            <div class="ty-quick-view-tools">
              {include file="common/view_tools.tpl" quick_view=true}
            </div>

            {assign var="form_open" value="form_open_`$obj_id`"}
            {assign var="product_detail_view_url" value="products.view?product_id=`$product.product_id`"}

            {if $smarty.request.use_vendor_url}
              {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
              {$use_vendor_url=true}
            {/if}
                
            {$thumbnail_width = $settings.Thumbnails.product_quick_view_thumbnail_width}
            {$thumbnail_height = $settings.Thumbnails.product_quick_view_thumbnail_height}
            {$thumbnails_size = 85}

            {$et_image_container_width=$thumbnail_width+$thumbnails_size+12}
            {$et_image_container_height=$thumbnail_height}

            <div id="product_main_info_form_{$obj_prefix}">
              {$smarty.capture.$form_open nofilter}
        
              {capture name="product_detail_view_url"}
                {hook name="products:product_detail_view_url"}
                  {$product_detail_view_url}
                {/hook}
              {/capture}

              {$product_detail_view_url = $smarty.capture.product_detail_view_url|trim}

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

              <div class="et-product-block__inner-wrapper">
                {* Images *}
                {hook name="products:quick_view_image_wrap"}
                  {if !$no_images}
                    <div class="ty-product-block__img-wrapper et-product-image-wrapper" style="width: {$et_image_container_width}px;">
                      
                      <div class="ty-product-block__img cm-reload-{$obj_prefix}{$obj_id}" style="width:{$et_image_container_width}px; max-width:{$et_image_container_width}px; height: {$et_image_container_width}px;" id="product_images_{$obj_prefix}{$obj_id}_update"
                      >

                        {include file="views/products/components/product_images.tpl" product=$product 
                          show_detailed_link=true 
                          image_width=$settings.Thumbnails.product_quick_view_thumbnail_width 
                          image_height=$settings.Thumbnails.product_quick_view_thumbnail_height 
                          thumbnails_size=$thumbnails_size
                          et_vertical=true
                          et_show_product_labels=true
                        }
                      <!--product_images_{$obj_prefix}{$obj_id}_update--></div>
                    </div>
                  {/if}
                {/hook}
                {* /Images *}

                <div class="et-pp-info">
                  {hook name="products:quick_view_title"}
                    {if !$hide_title}
                      <h1 class="ty-product-block-title" id="et_prod_title">
                        <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter} class="ty-quick-view__title" {live_edit name="product:product:{$product.product_id}"}><bdi>{$product.product nofilter}</bdi></a>
                      </h1>
                    {/if}
                  {/hook}

                  <div class="et-product-left">
                    <div class="et-stock-rating">
                      {strip}
                        {* Stock *}
                        {assign var="product_amount" value="product_amount_`$obj_id`"}
                        {if $smarty.capture.$product_amount|trim}
                          <div class="ty-product-block__field-group et-stock">
                            {$smarty.capture.$product_amount nofilter}
                          </div>
                        {/if}
                        {* /Stock *}
                        {hook name="products:et_qv_rating"}{/hook}
                      {/strip}
                    </div>

                    {capture name="et_product_sku_opt_brand"}
                      {* SKU *}
                      {assign var="sku" value="sku_`$obj_id`"}
                      {if $smarty.capture.$sku|trim}
                        <div class="et-product-page__sku">
                          {$smarty.capture.$sku nofilter}
                        </div>
                      {/if}    
                      {* /SKU *}
                    
                      {* Advanced Options: price in points *}
                      {assign var="advanced_options" value="advanced_options_`$obj_id`"}
                      {if $smarty.capture.$advanced_options|trim}
                        <div class="et-adv-options ty-product-block__advanced-option clearfix">
                          {if $capture_options_vs_qty}{capture name="product_options"}{$smarty.capture.product_options nofilter}{/if}
                          {$smarty.capture.$advanced_options nofilter}
                          {if $capture_options_vs_qty}{/capture}{/if}
                        </div>
                      {/if}
                      {* /Options: price in points *}
                    
                      {* Brand *}
                      {hook name="products:brand"}
                        <div class="et-brand">
                          {include file="views/products/components/product_features_short_list.tpl" features=$product.header_features et_title_span=true}
                        </div>
                      {/hook}
                      {* /Brand *}
                    {/capture}

                    {if $smarty.capture.et_product_sku_opt_brand|trim}
                      <div class="et_product_sku_opt_brand">
                        {$smarty.capture.et_product_sku_opt_brand nofilter}
                      </div>
                    {/if}

                    {* Price *}
                    <div class="et-price-wrapper clearfix">
                      {assign var="old_price" value="old_price_`$obj_id`"}
                      {assign var="price" value="price_`$obj_id`"}
                      {assign var="clean_price" value="clean_price_`$obj_id`"}
                      {assign var="list_discount" value="list_discount_`$obj_id`"}
                      {assign var="discount_label" value="discount_label_`$obj_id`"}
                      {assign var="product_labels" value="product_labels_`$obj_id`"}

                      <div class="{if $old_price && $smarty.capture.$old_price|trim || $clean_price && $smarty.capture.$clean_price|trim || $list_discount && $smarty.capture.$list_discount|trim}prices-container {/if} price-wrap">
                        {hook name="products:main_price"}
                        {if $smarty.capture.$price|trim}
                          <div class="ty-product-block__price-actual">
                            {$smarty.capture.$price nofilter}
                          </div>
                        {/if}
                        {/hook}
                        {if $smarty.capture.$old_price|trim || $smarty.capture.$clean_price|trim || $smarty.capture.$list_discount|trim}
                          <div class="et-old-price">
                            {if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}{/if}
                          </div>
                        {/if}
                        <div class="et-discount-text">
                          {$smarty.capture.$list_discount nofilter}
                        </div>
                        {if $smarty.capture.$clean_price|trim}
                          <div class="et-clean-price">
                            {$smarty.capture.$clean_price nofilter}
                          </div>
                        {/if}
                      </div>
                    </div>
                    {* /Price *}
                    {assign var="prod_descr" value="prod_descr_`$obj_id`"}
                    {if $smarty.capture.$prod_descr|trim}
                        <div class="ty-product-block__description">{$smarty.capture.$prod_descr nofilter}</div>
                    {/if}

                    {* Promo text *}
                    {hook name="products:promo_text"}
                      {if $product.promo_text}
                        <div class="et-promo-text">
                          {$product.promo_text nofilter}
                        </div>
                      {/if}
                    {/hook}
                    {* /Promo text *}

                    {* Options: dorpdown/radio/etc.. *}
                    {if $capture_options_vs_qty}{capture name="product_options"}{$smarty.capture.product_options nofilter}{/if}
                      <div class="ty-product-block__option et-product-options">
                        {assign var="product_options" value="product_options_`$obj_id`"}
                        {$smarty.capture.$product_options nofilter}
                      </div>
                    {if $capture_options_vs_qty}{/capture}{/if}
                    {* /Options: dorpdown/radio/etc.. *}

                    {* Qty discount *}
                    {capture name="et_qty_discount_min_qty"}
                      {if $capture_options_vs_qty}{capture name="product_options"}{$smarty.capture.product_options nofilter}{/if}
                      {if $product.prices}
                        <div class="et-qty-discount">
                          {include file="views/products/components/products_qty_discounts.tpl"}
                        </div>
                      {/if}
                      {assign var="min_qty" value="min_qty_`$obj_id`"}
                      {$smarty.capture.$min_qty nofilter}
                      {if $capture_options_vs_qty}{/capture}{/if}
                    {/capture}
                    {if $smarty.capture.et_qty_discount_min_qty|trim}
                      <div class="ty-product-block__field-group">
                        {$smarty.capture.et_qty_discount_min_qty nofilter}
                      </div>
                    {/if}
                    {* /Qty discount *}

                    {* EDP *}
                    {assign var="product_edp" value="product_edp_`$obj_id`"}
                    {$smarty.capture.$product_edp nofilter}
                    {* /EDP *}

                    {* Buttons *}
                    <div>
                      {* View details (unused) *}
                      {if $show_details_button}
                        {include file="buttons/button.tpl" but_href=$product_detail_view_url but_text=__("view_details") but_role="submit"}
                      {/if}
                      {* /View details (unused) *}

                      {if ($product.avail_since > $smarty.const.TIME)}
                        {include file="common/coming_soon_notice.tpl" avail_date=$product.avail_since add_to_cart=$product.out_of_stock_actions details_page=true}
                      {/if}

                      <div class="clearfix">
                        {* QTY changer *}
                        <div class="et-value-changer et-main-qty-changer">
                          {assign var="qty" value="qty_`$obj_id`"}
                          {$smarty.capture.$qty nofilter}
                        </div>
                        {* /QTY changer *}

                        {* Buttons: Add to cart/Buy now*}
                        <div class="et-product-atc">
                          {assign var="add_to_cart" value="add_to_cart_`$obj_id`"}
                          {$smarty.capture.$add_to_cart nofilter}
                        </div>
                        {* /Buttons: Add to cart/Buy now*}
                      </div>

                      {* Buttons: Compare/Wishlist*}
                      {if !($addons.master_products.status == "A" && !$product.company_id)}
                        {capture name="et_pp_compare"}
                          {if $settings.General.enable_compare_products == "Y" && !$hide_compare_list_button || $product.feature_comparison == "Y"}
                            {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id}
                          {/if}
                        {/capture}
                        {capture name="et_pp_wishlist"}
                          {if $addons.wishlist.status == "A" && !$hide_wishlist_button}
                            {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text"}
                          {/if}
                        {/capture}
                        <div class="et-list-buttons-wrapper clearfix">
                          {if $smarty.capture.et_pp_compare|trim && $smarty.capture.et_pp_wishlist|trim}
                            <div class="ty-column2">
                              {$smarty.capture.et_pp_compare nofilter}
                            </div>
                            <div class="ty-column2">
                              {$smarty.capture.et_pp_wishlist nofilter}
                            </div>
                          {else}
                            {$smarty.capture.et_pp_compare nofilter}
                            {$smarty.capture.et_pp_wishlist nofilter}
                          {/if}
                        </div>
                      {/if}
                    </div>
                    {* /Buttons *}
                    {hook name="products:qv_product_vendor"}
                    {/hook}

                  </div> {* /.et-product-left *}
                </div> {* /.et-pp-info *}
              </div>{* /et-product-block__inner-wrapper *}

              {assign var="form_close" value="form_close_`$obj_id`"}
              {$smarty.capture.$form_close nofilter}
            <!--product_main_info_form_{$obj_prefix}--></div>
          {/if}
        {/hook}
      </div> {* /.ty-product-block__wrapper *}
    </div>  {* /#et-quick-view *}

    {if $smarty.capture.hide_form_changed == "Y"}
      {assign var="hide_form" value=$smarty.capture.orig_val_hide_form}
    {/if}
  <!--product_main_info_{$obj_prefix}--></div>
</div>