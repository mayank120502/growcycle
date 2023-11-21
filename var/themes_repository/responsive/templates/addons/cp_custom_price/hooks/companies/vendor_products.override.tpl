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
            {if $vendor_product.cp_custom_price == "YesNo::YES"|enum && $vendor_product.cp_price_to == 0 && $vendor_product.price == 0}
                <span>{__('cp_custom_price.contact_us')}</span>
            {elseif $settings.Checkout.allow_anonymous_shopping === "hide_price_and_add_to_cart" && !$auth.user_id}
                <span class="ty-price">{__("sign_in_to_view_price")}</span>
            {else}
                {if $vendor_product.cp_custom_price == "YesNo::YES"|enum}
                    <span>{__('cp_custom_price.from')}</span>
                {/if}
                <a class="ty-sellers-list__price-link1" href="{"products.view?product_id={$product_id}"|fn_url}">
                    {include file="common/price.tpl"
                    value=$vendor_product.price
                    class="ty-price-num"
                    }
                </a>
                {if $vendor_product.cp_custom_price == "YesNo::YES"|enum && $vendor_product.cp_price_to > 0}
                    <span>{__('cp_custom_price.to')}</span>
                    <a class="ty-sellers-list__price-link1" href="{"products.view?product_id={$product_id}"|fn_url}">
                        {include file="common/price.tpl"
                        value=$vendor_product.cp_price_to
                        class="ty-price-num"
                        }
                    </a>
                {/if}
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