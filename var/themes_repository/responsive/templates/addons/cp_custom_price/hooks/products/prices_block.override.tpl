{hook name="products:prices_block"}
    {if $auth.tax_exempt === "{"YesNo::NO"|enum}" || !$product.clean_price}
        {$price = $product.price}
    {else}
        {$price = $product.clean_price}
    {/if}

    {if $product.cp_custom_price == "YesNo::YES"|enum && $product.cp_price_to == 0 && $product.price == 0}
        <span>{__('cp_custom_price.contact_us')}</span>
    {elseif $price|floatval || $product.zero_price_action == "P" || ($hide_add_to_cart_button == "Y" && $product.zero_price_action == "A")}
        <span class="ty-price{if !$price|floatval && !$product.zero_price_action} hidden{/if}" id="line_discounted_price_{$obj_prefix}{$obj_id}">
            {if $product.cp_custom_price == "YesNo::YES"|enum}
                <span>{__('cp_custom_price.from')}</span>
            {/if}
            {include file="common/price.tpl" value=$price span_id="discounted_price_`$obj_prefix``$obj_id`" class="ty-price-num" live_editor_name="product:price:{$product.product_id}" live_editor_phrase=$product.base_price}
            {if $product.cp_custom_price == "YesNo::YES"|enum && $product.cp_price_to > 0}
                <span>{__('cp_custom_price.to')}</span>
                {include file="common/price.tpl" value=$product.cp_price_to span_id="discounted_price_to_`$obj_prefix``$obj_id`" class="ty-price-num"}
            {/if}
        </span>
    {elseif $product.zero_price_action == "A" && $show_add_to_cart}
        {assign var="base_currency" value=$currencies[$smarty.const.CART_PRIMARY_CURRENCY]}
        <span class="ty-price-curency"><span class="ty-price-curency__title">{__("enter_your_price")}:</span>
            <div class="ty-price-curency-input">
                <input type="text" name="product_data[{$obj_id}][price]" class="ty-price-curency__input cm-numeric" data-a-sign="{$base_currency.symbol nofilter}"  data-a-dec="{if $base_currency.decimal_separator}{$base_currency.decimal_separator nofilter}{else}.{/if}"  data-a-sep="{if $base_currency.thousands_separator}{$base_currency.thousands_separator nofilter}{else},{/if}" data-p-sign="{if $base_currency.after === "YesNo::YES"|enum}s{else}p{/if}" data-m-dec="{$base_currency.decimals}" size="3" value="" />
            </div>
        </span>
    {elseif $product.zero_price_action == "R"}
        <span class="ty-no-price">{__("contact_us_for_price")}</span>
    {/if}
{/hook}