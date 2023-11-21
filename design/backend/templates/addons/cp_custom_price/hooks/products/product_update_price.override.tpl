{hook name="products:product_update_price"}
    {if !$runtime.company_id && $product_data && !$product_data.company_id && $product_data.master_product_offers_count}
        <div class="control-group {$no_hide_input_if_shared_product}">
            <label for="elm_price_price" class="control-label cm-required">
                {__("price")} ({$currencies.$primary_currency.symbol nofilter}):
            </label>
            <div class="controls">
                <input type="hidden" name="product_data[price]" value="{$product_data.price|default:"0.00"|fn_format_price:$primary_currency:null:false}"/>
                <p>
                    {include file="common/price.tpl" value=$product_data.price assign=price_from}
                    <a href="{"products.manage?product_type[]=`$smarty.const.PRODUCT_TYPE_VENDOR_PRODUCT_OFFER`&product_type[]=`$smarty.const.PRODUCT_TYPE_PRODUCT_OFFER_VARIATION`&master_product_id=`$product_data.product_id`"|fn_url}">
                        {__("master_products.price_from", ["[formatted_price]" =>$price_from])}
                    </a>
                </p>
            </div>
        </div>
    {else}
        {component name="configurable_page.field" entity="products" tab="detailed" section="information" field="price"}
        <div id="cp_custom_price_block">
            <div class="control-group {$no_hide_input_if_shared_product}">
                <label for="elm_price_price" class="control-label {if $product_data.cp_custom_price != "YesNo::YES"|enum} cm-required {/if}">
                    {if $product_data.cp_custom_price != "YesNo::YES"|enum}
                        {__("price")} 
                    {else}
                        {__("cp_custom_price.price_from")}
                    {/if}    
                    ({$currencies.$primary_currency.symbol nofilter}):
                </label>
                <div class="controls cp-custom-price" data-product-id="{$product_data.product_id}">
                    <input type="text" name="product_data[price]" id="elm_price_price" size="10" value="{$product_data.price|default:"0.00"|fn_format_price:$primary_currency:null:false}" class="input-long cm-numeric" data-a-sep/>
                    <div>
                        <input type="hidden" name="product_data[cp_custom_price]" value="{"YesNo::NO"|enum}" />
                        <input type="hidden" name="product_data[cp_access_custom_price]" value="{$product_data.cp_access_custom_price}" />
                        <input type="hidden" name="product_data[cp_vendor_buying_types]" value="{$product_data.cp_vendor_buying_types}" />
                        <input type="hidden" name="product_data[cp_buying_types]" value="{','|implode:$product_data.cp_buying_types}" />
                        <input type="hidden" name="product_data[master_product_id]" value="{$product_data.master_product_id}" />
                        <label class="checkbox inline" for="product_cp_custom_price">
                            <input type="checkbox" name="product_data[cp_custom_price]" id="product_cp_custom_price" value="{"YesNo::YES"|enum}" 
                                {if $product_data.cp_custom_price == "YesNo::YES"|enum}checked="checked"{/if} 
                                {if $product_data.cp_access_custom_price != "YesNo::YES"|enum}disabled="disabled"{/if}/>
                        {__("cp_custom_price.custom_price")}</label>
                        {if $product_data.cp_access_custom_price != "YesNo::YES"|enum}
                            <p class="muted description">{__("cp_custom_price.info_for_activate")}</p>
                        {/if}
                    </div>
                    {include file="buttons/update_for_all.tpl"
                        display=$show_update_for_all
                        object_id="price"
                        name="update_all_vendors[price]"
                        component="products.price"
                    }
                </div>
            </div>
            {if $product_data.cp_custom_price == "YesNo::YES"|enum}
                <div class="control-group {$no_hide_input_if_shared_product}">
                    <label for="elm_cp_price_to" class="control-label">{__("cp_custom_price.price_to")} ({$currencies.$primary_currency.symbol nofilter}):</label>
                    <div class="controls">
                        <input type="text" name="product_data[cp_price_to]" id="elm_cp_price_to" size="10" value="{$product_data.cp_price_to|default:"0.00"|fn_format_price:$primary_currency:null:false}" class="input-long cm-numeric" data-a-sep/>
                    </div>
                </div>
            {/if}
        <!--cp_custom_price_block--></div>
        {/component}
    {/if}
{/hook}