{hook name="products:notification_product"}
{if isset($product.cp_custom_price)}
    {$cp_custom_price = $product.cp_custom_price}
{else}
    {$cp_custom_price = $product.extra.cp_custom_price}
{/if}
{if isset($product.cp_price_to)}
    {$cp_price_to = $product.cp_price_to}
{else}
    {$cp_price_to = $product.extra.cp_price_to}
{/if}
{if isset($product.master_product_id)}
    {$master_product_id = $product.master_product_id}
{else}
    {$master_product_id = $product.extra.master_product_id}
{/if}
    <div class="ty-product-notification__item clearfix">
        <div class="et-product-notification__item-wrapper">
            <div class="et-product-notification__image">{include file="common/image.tpl" image_width="50" image_height="50" images=$product.main_pair no_ids=true class="ty-product-notification__image"}</div>
            
            <div class="ty-product-notification__content clearfix">
                <a href="{"products.view?product_id=`$product.product_id`"|fn_url}" class="ty-product-notification__product-name">{$product.product_id|fn_get_product_name nofilter}</a>
                {if !($settings.Checkout.allow_anonymous_shopping == "hide_price_and_add_to_cart" && !$auth.user_id)}
                    <div class="ty-product-notification__price">
                        {if !$hide_amount}
                            {if ($cp_custom_price == "YesNo::YES"|enum && $cp_price_to == 0 && $product.display_price == 0)
                                || ($cp_custom_price == "YesNo::YES"|enum && $product.display_price == 0 && $master_product_id == 0)}
                                <span>{__('cp_custom_price.contact_us')}</span>
                            {else}
                                {if $cp_custom_price == "YesNo::YES"|enum}
                                    <span>{__('cp_custom_price.from')}</span><span dir="{$language_direction}">&nbsp;x&nbsp;</span>{include file="common/price.tpl" value=$product.display_price span_id="price_`$key`" class="none"}
                                    {if $cp_price_to > 0}
                                        <span>{__('cp_custom_price.to')}</span><span dir="{$language_direction}">&nbsp;x&nbsp;</span>{include file="common/price.tpl" value=$cp_price_to span_id="price_to_`$key`" class="none"}
                                    {/if}
                                {else}
                                <span class="none">{$product.amount}</span><span dir="{$language_direction}">&nbsp;x&nbsp;</span>{include file="common/price.tpl" value=$product.display_price span_id="price_`$key`" class="none"}
                                {/if}
                            {/if}
                        {/if}
                    </div>
                {/if}
            </div>
        </div>
        {if $product.product_option_data}
            {include file="common/options_info.tpl" product_options=$product.product_option_data}
        {/if}
    </div>
{/hook}