{assign var="obj_prefix" value="bt_`$chain.chain_id`"}
<div class="et-buy-together-wrapper">
  <form {if $is_ajax}class="cm-ajax cm-ajax-full-render"{/if} action="{""|fn_url}" method="post" name="chain_form_{$chain.chain_id}" enctype="multipart/form-data">
  <input type="hidden" name="redirect_url" value="{$config.current_url}" />
  <input type="hidden" name="result_ids" value="cart_status*,wish_list*" />
  {if !$stay_in_cart || $is_ajax}
    <input type="hidden" name="redirect_url" value="{$config.current_url}" />
  {/if}
  <input type="hidden" name="product_data[{$chain.product_id}_{$chain.chain_id}][chain]" value="{$chain.chain_id}" />
  <input type="hidden" name="product_data[{$chain.product_id}_{$chain.chain_id}][product_id]" value="{$chain.product_id}" />
  
  {include file="common/subheader.tpl" title=$chain.name class="et-buy-together__title"}
  {if $chain.description}
    <div class="et-buy-together__description">
      {$chain.description nofilter}
    </div>
  {/if}
  
  {assign var="buy_together_options_class" value="cm-reload-{$obj_prefix}{$chain.product_id}_{$chain.chain_id}"}
  
  {if $chain.products}
    {foreach from=$chain.products key="_id" item="_product"}
      {assign var="buy_together_options_class" value="{$buy_together_options_class} cm-reload-{$obj_prefix}{$_product.product_id}"}
    {/foreach}
  {/if}
  
  <div class="ty-buy-together et-buy-together">
      <div class="et-buy-together__left">
        <div class="ty-buy-together__products ty-scroll-x clearfix">
        {if $chain.products}
          <div class="ty-buy-together__product">
            <div class="ty-buy-together__product-image cm-reload-{$obj_prefix}{$chain.product_id}_{$chain.chain_id}" id="bt_product_image_{$obj_prefix}{$chain.product_id}_{$chain.chain_id}_main">
              <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>{include file="common/image.tpl" image_width=$settings.Thumbnails.product_lists_thumbnail_width image_height=$settings.Thumbnails.product_lists_thumbnail_height obj_id="`$chain.chain_id`_`$chain.product_id`" images=$chain.main_pair class="ty-buy-together__product-image"}</a>
            <!--bt_product_image_{$obj_prefix}{$chain.product_id}_{$chain.chain_id}_main--></div>
        
            <div class="ty-buy-together__product-name">
               <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter} class="product-title">{$chain.product_name}</a>
            </div>
        
            {if $chain.product_options}
              {capture name="buy_together_product_options"}
                <div id="buy_together_options_{$chain.chain_id}_{$key}_main" class="ty-buy-together-box">
                  <div class="{$buy_together_options_class}" id="buy_together_options_update_{$chain.chain_id}_{$chain.product_id}_main">
                    <input type="hidden" name="appearance[show_product_options]" value="1" />
                    <input type="hidden" name="appearance[bt_chain]" value="{$chain.chain_id}" />
                    <input type="hidden" name="appearance[bt_id]" value="{$key}" />
                    
                    {include file="views/products/components/product_options.tpl" product=$chain id="`$chain.product_id`_`$chain.chain_id`" product_options=$chain.product_options name="product_data" no_script=true extra_id="`$chain.product_id`_`$chain.chain_id`_main"}
                  <!--buy_together_options_update_{$chain.chain_id}_{$chain.product_id}_main--></div>
                  <div class="buttons-container ty-center">
                    {include file="buttons/button.tpl" but_id="add_item_close" but_name="" but_text=__("save_and_close") but_role="action" but_meta="ty-btn__primary cm-dialog-closer"}
                  </div>
                </div>
              {/capture}
              <div class="ty-buy-together__product-options">
                {include file="common/popupbox.tpl" id="buy_together_options_`$chain.chain_id`_`$chain.product_id`_main" link_meta="ty-btn ty-btn__primary" text=__("specify_options") content=$smarty.capture.buy_together_product_options link_text=__("specify_options") act="general"}
              </div>
            {/if}
            <div class="ty-buy-together__product-price cm-reload-{$obj_prefix}{$chain.product_id}_{$chain.chain_id}" id="bt_product_price_{$obj_prefix}{$chain.product_id}_{$chain.chain_id}_main">
              {$chain.min_qty}&nbsp;x
              {if !(!$auth.user_id && $settings.Checkout.allow_anonymous_shopping == "hide_price_and_add_to_cart")}
                {include file="common/price.tpl" value=$chain.discounted_price class="ty-price-num"}
                {if $chain.price != $chain.discounted_price}
                  <span class="ty-strike">{include file="common/price.tpl" value=$chain.price}</span>
                {/if}
              {/if}
            <!--bt_product_price_{$obj_prefix}{$chain.product_id}_{$chain.chain_id}_main--></div>
          </div>
        {/if}
        
        {foreach from=$chain.products key="_id" item="_product"}
          <span class="ty-buy-together__plus chain-plus">+</span>
          
          <div class="ty-buy-together__product">
            <input type="hidden" name="product_data[{$_product.product_id}][product_id]" value="{$_product.product_id}" />
        
            <div class="ty-buy-together__product-image cm-reload-{$obj_prefix}{$_product.product_id}" id="bt_product_image_{$chain.chain_id}_{$_product.product_id}">
              <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>{include file="common/image.tpl" image_width=$settings.Thumbnails.product_lists_thumbnail_width image_height=$settings.Thumbnails.product_lists_thumbnail_height obj_id="`$chain.chain_id`_`$_product.product_id`" images=$_product.main_pair class="ty-buy-together__product-image"}</a>
            <!--bt_product_image_{$chain.chain_id}_{$_product.product_id}--></div>
        
            <div class="ty-buy-together__product-name">
              <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter} class="product-title">{$_product.product_name}</a>
            </div>
        
            {if $_product.product_options}
              {foreach from=$_product.product_options item="option"}
                <div class="ty-buy-together-option"><span class="ty-buy-together-option__name">{$option.option_name}</span>: {$option.variant_name}</div>
              {/foreach}
            {elseif $_product.aoc}
              {capture name="buy_together_product_options"}
                <div id="buy_together_options_{$chain.chain_id}_{$_product.product_id}" class="ty-buy-together-box">
                  <div class="{$buy_together_options_class}" id="buy_together_options_update_{$chain.chain_id}_{$_product.product_id}">
                    <input type="hidden" name="appearance[show_product_options]" value="1" />
                    <input type="hidden" name="appearance[bt_chain]" value="{$chain.chain_id}" />
                    <input type="hidden" name="appearance[bt_id]" value="{$_id}" />
                    {include file="views/products/components/product_options.tpl" product=$_product id=$_product.product_id  product_options=$_product.options name="product_data" no_script=true extra_id="`$_product.product_id`_`$chain.chain_id`"}
                    <!--buy_together_options_update_{$chain.chain_id}_{$_product.product_id}--></div>
        
                  <div class="buttons-container">
                    {include file="buttons/button.tpl" but_id="add_item_close" but_name="" but_text=__("save_and_close") but_role="action" but_meta="ty-btn__secondary cm-dialog-closer"}
                  </div>
                </div>
              {/capture}
              <div class="ty-buy-together__product-options">
                {include file="common/popupbox.tpl" id="buy_together_options_`$chain.chain_id`_`$_product.product_id`" link_meta="ty-btn ty-btn__primary" text=__("specify_options") content=$smarty.capture.buy_together_product_options link_text=__("specify_options") act="general"}
              </div>
            {/if}
            <div class="ty-buy-together__product-price cm-reload-{$obj_prefix}{$_product.product_id}" id="bt_product_price_{$chain.chain_id}_{$_product.product_id}">
              {$_product.amount}&nbsp;x
              {if !(!$auth.user_id && $settings.Checkout.allow_anonymous_shopping == "hide_price_and_add_to_cart")}
                {include file="common/price.tpl" value=$_product.discounted_price class="ty-price-num"}
                {if $_product.price != $_product.discounted_price}
                  <span class="ty-strike">{include file="common/price.tpl" value=$_product.price}</span>
                {/if}
              {/if}
            <!--bt_product_price_{$chain.chain_id}_{$_product.product_id}--></div>
          </div>
        {/foreach}
        </div>
      </div>
      <div class="et-buy-together__right">
        {if !(!$auth.user_id && $settings.Checkout.allow_anonymous_shopping == "hide_price_and_add_to_cart")}
          <div class="ty-buy-together__plus chain-plus">=</div>
          <div class="et-buy-together__price-buttons">
            <div class="et-buy-together__price {$buy_together_options_class}" id="bt_total_price_{$obj_prefix}{$chain.product_id}_{$chain.chain_id}">
              <div class="et-buy-together__price-old">
                <span class="et-buy-together__price-title">{__("total_list_price")}</span>
                <span class="chain-old-line ty-strike">{include file="common/price.tpl" value=$chain.total_price}</span>
              </div>
              <div class="et-buy-together__price-new">
                <span class="et-buy-together__price-title">{__("price_for_all")}</span>
                <span class="et-buy-together__price-value">{include file="common/price.tpl" value=$chain.chain_price}</span>
              </div>
            <!--bt_total_price_{$obj_prefix}{$chain.product_id}_{$chain.chain_id}--></div>
            {if !(!$auth.user_id && $settings.Checkout.allow_anonymous_shopping == "hide_add_to_cart_button")}
              <div width="100%" class="et-buy-together__buttons-container cm-ty-buy-together-submit" id="wrap_chain_button_{$chain.chain_id}">
                  {include file="buttons/button.tpl" but_text=__("add_all_to_cart") but_id="chain_button_`$chain.chain_id`" but_meta="ty-btn__secondary" but_name="dispatch[checkout.add]" but_role="et_icon_text" obj_id=$obj_id et_icon="et-icon-btn-cart" but_extra_class="et-add-to-cart"}
              </div>
            {/if}
          </div>
        {else}
        <p>{__("sign_in_to_view_price")}</p>
        {/if}
    </div>
  </div>
  </form>
</div>
