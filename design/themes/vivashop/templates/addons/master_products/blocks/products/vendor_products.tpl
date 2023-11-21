{if $items|default:[]}

  {$first_vendor_product = reset($items)}
  <div class="et-product-vendor-wrapper" id="et-master-list">
    <div class="et-vendor-block_title">
      {__('master_products.vendor_products_tab_name', [], DEFAULT_LANGUAGE)} (<strong>{$product.master_product_offers_count}</strong>)
    </div>
    <div class="ty-sellers-list1 js-sellers-list et-master-list-wrapper"
       data-ca-seller-list-request-product-id="{$smarty.request.product_id}"
       id="sellers_list_{$first_vendor_product.master_product_id}">
    {$index=0}
    {foreach $items as $vendor_product}
      {$company_id = $vendor_product.company_id}
      {$product_id = $vendor_product.product_id}
      {$obj_prefix = "`$company_id`-"}
      {if !empty($vendor_product.min_qty)}
        {$amount=$vendor_product.min_qty}
      {elseif !empty($vendor_product.qty_step)}
        {$amount=$vendor_product.qty_step}
      {else}
        {$amount="1"}
      {/if}
      {$index=$index+1}

      <div class="ty-sellers-list__item et-master-list-inner-wrapper {if $index>2}hidden{/if}">
        <form action="{""|fn_url}"
            method="post"
            name="vendor_products_form_{$company_id}"
            enctype="multipart/form-data"
            class="cm-disable-empty-files cm-ajax cm-ajax-full-render cm-ajax-status-middle"
            data-ca-master-products-element="product_form"
            data-ca-master-products-master-product-id="{$vendor_product.master_product_id}"
            data-ca-master-products-product-id="{$vendor_product.product_id}"
        >
          <input type="hidden" name="result_ids" value="cart_status*,wish_list*,checkout*,account_info*,average_rating*"/>
          <input type="hidden" name="redirect_url" value="{$redirect_url|default:$config.current_url}" />
          <input type="hidden" name="product_data[{$product_id}][product_id]" value="{$product_id}" />
          <input type="hidden" name="product_data[{$product_id}][amount]" value="{$amount}" />
          {foreach from=$product.selected_options key=option_id item=option_value}
            <input type="hidden" name="product_data[{$product.product_id}][product_options][{$option_id}]" value="{$option_value}" />
          {/foreach}

          {$show_logo = $vendor_product.company.logos}

          {include file="common/company_data.tpl"
              company=$vendor_product.company
              show_name=true
              show_links=true
              show_logo=$show_logo
              show_city=true
              show_country=true
              show_rating=true
              show_posts_count=false
              show_location=true
              logo_width=60
              logo_height=60
              et_on_vs=false
              show_empty_rating=true
            }

          <div class="ty-sellers-list__content1">

            {hook name="companies:vendor_products"}
            <div class="et-master-list-logo-name-rating-wrapper">
              <div class="et-vendor-logo">
                {$logo="logo_`$company_id`"}
                {$smarty.capture.$logo nofilter}
              </div>
              
              <div class="ty-sellers-list__title1">
                <div class="et-master-list-sold-by">{__("et_pp_sold_by")}:</div>

                <div class="et-master-list-vendor-name">
                  {$name="name_`$company_id`"}
                  {$smarty.capture.$name nofilter}
                </div>
              
                {$rating="rating_`$company_id`"}
                <div class="et-vendor-rating">
                  {$smarty.capture.$rating nofilter}
                </div>
              </div>
            </div>

            {$location="location_`$company_id`"}
            {if $smarty.capture.$location|trim || $show_vendor_location}
              <div class="ty-sellers-list__item-location1">
                <a href="{"companies.products?company_id=`$company_id`"|fn_url}" class="company-location"><bdi>
                    {$smarty.capture.$location nofilter}
                  </bdi></a>
              </div>
            {/if}
                    {hook name="vendor_products:additional_info"}
                    {/hook}

            {include file="common/product_data.tpl"
              product=$vendor_product
              obj_prefix="vendor_product"
              show_add_to_cart=true
              show_amount_label=false
              show_product_amount=true
              show_buy_now=false
              show_product_options=true
              hide_compare_list_button=true
              details_page=true
              show_add_to_wishlist=false
              show_et_grid_stock=true
            }

            <div class="ty-sellers-list__controls1">
              <div class="et-master-list-stock">
                {$product_amount = "product_amount_`$product_id`"}
                {$smarty.capture.$product_amount nofilter}
              </div>

              <div class="et-master-list-price">
 {if $settings.Checkout.allow_anonymous_shopping === "hide_price_and_add_to_cart" && !$auth.user_id}
                                <span class="ty-price">{__("sign_in_to_view_price")}</span>
                            {else}
                <a class="ty-sellers-list__price-link1"
                   href="{"products.view?product_id={$product_id}"|fn_url}"
                >
                  {include file="common/price.tpl"
                    value=$vendor_product.price
                    class="ty-price-num"
                  }
                </a>
                            {/if}

                {if $addons.reward_points.status == "A"}
                  {include file="addons/reward_points/views/products/components/product_representation.tpl"
                    product=$vendor_product
                  }
                {/if}
              </div>

              <div class="ty-sellers-list__buttons1 et-master-list-buttons">
                {hook name="vendor_products:list_buttons"}

                  <div class="et-product-atc">
                    {$add_to_cart = "add_to_cart_`$product_id`"}
                    {$smarty.capture.$add_to_cart nofilter}
                  </div>

                  {$list_buttons = "list_buttons_`$product_id`"}
                  {$smarty.capture.$list_buttons nofilter}

                  {if $addons.wishlist.status == "A" && !$hide_wishlist_button}
                    {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text"}
                  {/if}
                  
                {/hook}
              </div>

            </div>
            {/hook}
          </div>
        </form>
      </div>
    {/foreach}
    <!--sellers_list_{$first_vendor_product.master_product_id}--></div>
    {if $index>2}
      <div class="et-master-show-all">
        <span onclick="Tygh.$('.et-master-list-inner-wrapper.hidden').removeClass('hidden');Tygh.$('.et-master-show-all').addClass('hidden');tab_sizes();et_sticky_tabs(pos_rechecked=false);">+ {__("master_products.view_product_offers")}</span>
      </div>
    {/if}
  </div>

{/if}
