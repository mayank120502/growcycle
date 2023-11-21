{hook name="products:product_data_content"}
{$out_of_stock_text = __("text_out_of_stock")}
{$allow_negative_amount = $allow_negative_amount|default:$settings.General.allow_negative_amount}

{if ($product.price|floatval || $product.zero_price_action == "P" || $product.zero_price_action == "A" || (!$product.price|floatval && $product.zero_price_action == "R")) && !($settings.Checkout.allow_anonymous_shopping == "hide_price_and_add_to_cart" && !$auth.user_id)}
  {assign var="show_price_values" value=true}
{else}
  {assign var="show_price_values" value=false}
{/if}
{capture name="show_price_values"}{$show_price_values}{/capture}

{assign var="cart_button_exists" value=false}
{assign var="show_qty" value=$show_qty|default:true}
{assign var="obj_id" value=$obj_id|default:$product.product_id}
{assign var="product_amount" value=$product.inventory_amount|default:$product.amount}
{assign var="show_sku_label" value=$show_sku_label|default:true}
{assign var="show_amount_label" value=$show_amount_label|default:true}
{if !$config.tweaks.disable_dhtml && !$no_ajax}
  {assign var="is_ajax" value=true}
{/if}

{capture name="form_open_`$obj_id`"}
{if !$hide_form}
<form action="{""|fn_url}" method="post" name="product_form_{$obj_prefix}{$obj_id}" enctype="multipart/form-data" class="cm-disable-empty-files {if $is_ajax} cm-ajax cm-ajax-full-render cm-ajax-status-middle{/if} {if $form_meta}{$form_meta}{/if}">

<input type="hidden" name="result_ids" value="cart_status*,wish_list*,checkout*,account_info*,et-cw*" />
{if !$stay_in_cart}
<input type="hidden" name="redirect_url" value="{$redirect_url|default:$config.current_url}" />
{/if}
<input type="hidden" name="product_data[{$obj_id}][product_id]" value="{$product.product_id}" />
{/if}
{/capture}

{if $addons.et_vivashop_mv_functionality.et_product_link=="vendor"}
  {if $product.company_id && $product.company_has_store}
    {$product_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
    {if !$smarty.request.company_id}
      {$et_add_blank='target="_blank"'}
    {else}
      {$et_add_blank=''}
    {/if}
  {else}
    {$product_url="products.view&product_id=`$product.product_id`"}
    {$et_add_blank=''}
  {/if}
{else}
  {$et_add_blank=''}
  {if $use_vendor_url}
      {$product_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
  {else}
    {$product_url="products.view&product_id=`$product.product_id`"}
  {/if}
{/if}

{if $no_capture}
  {assign var="capture_name" value="form_open_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="name_`$obj_id`"}
{hook name="products:product_name"}
  {if $show_name}
    {if $hide_links}<strong>{else}<a href="{$product_url|fn_url}" {$et_add_blank nofilter} class="product-title" title="{$product.product|strip_tags}" {live_edit name="product:product:{$product.product_id}" phrase=$product.product}>{/if}{$product.product nofilter}{if $hide_links}</strong>{else}</a>{/if}
  {elseif $show_trunc_name}
    {if $hide_links}<strong>{else}<a href="{$product_url|fn_url}" {$et_add_blank nofilter} class="product-title" title="{$product.product|strip_tags}" {live_edit name="product:product:{$product.product_id}" phrase=$product.product}>{/if}{$product.product|truncate:44:"...":true nofilter}{if $hide_links}</strong>{else}</a>{/if}
  {/if}
{/hook}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="name_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="sku_`$obj_id`"}
{if $show_sku}
  <div class="ty-control-group ty-sku-item cm-hidden-wrapper{if !$product.product_code} hidden{/if}" id="sku_update_{$obj_prefix}{$obj_id}">
    <input type="hidden" name="appearance[show_sku]" value="{$show_sku}" />
    {strip}
      {if $show_sku_label}
        <label class="ty-control-group__label" id="sku_{$obj_prefix}{$obj_id}">{__("sku")}:</label>
      {/if}
      <span class="ty-control-group__item cm-reload-{$obj_prefix}{$obj_id}" id="product_code_{$obj_prefix}{$obj_id}">{$product.product_code}<!--product_code_{$obj_prefix}{$obj_id}--></span>
    {/strip}
  </div>
{/if}
{/capture}

{if $no_capture}
  {assign var="capture_name" value="sku_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="rating_`$obj_id`"}
  {hook name="products:data_block"}
  {/hook}
{/capture}

{if $no_capture}
  {assign var="capture_name" value="rating_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="add_to_cart_`$obj_id`"}
{if $show_add_to_cart}
<div class="cm-reload-{$obj_prefix}{$obj_id} {$add_to_cart_class}" id="add_to_cart_update_{$obj_prefix}{$obj_id}">
<input type="hidden" name="appearance[show_add_to_cart]" value="{$show_add_to_cart}" />
<input type="hidden" name="appearance[show_list_buttons]" value="{$show_list_buttons}" />
<input type="hidden" name="appearance[but_role]" value="{$but_role}" />
<input type="hidden" name="appearance[quick_view]" value="{$quick_view}" />

{strip}
{capture name="buttons_product"}
  {hook name="products:add_to_cart"}
  {if $product.has_options && !$show_product_options && !$details_page}
    {if $show_et_icon_buttons}
      {include file="buttons/button.tpl" 
        but_id="button_cart_`$obj_prefix``$obj_id`" 
        but_text=__("select_options") 
        but_href=$product_url 
        but_role="et_icon"
        but_name=""
        et_icon="et-icon-btn-opt"
        but_extra_class="et-add-to-cart et-atc-icon-only"}
    {else}
      {if $but_role == "text"}
        {$opt_but_role="text"}
      {else}
        {$opt_but_role="action"}
      {/if}
      {include file="buttons/button.tpl" 
        but_text=__("select_options")
        but_id="button_cart_`$obj_prefix``$obj_id`" 
        but_href=$product_url
        but_role="et_icon_text"
        but_target=$but_target 
        but_name=""
        but_onclick=$but_onclick 
        et_icon="et-icon-btn-opt"
        but_extra_class="et-add-to-cart"}
    {/if}
  {elseif $show_et_icon_buttons}
    {include file="buttons/add_to_cart.tpl" 
      but_id="button_cart_`$obj_prefix``$obj_id`" 
      but_name="dispatch[checkout.add..`$obj_id`]" 
      but_role=$but_role 
      block_width=$block_width 
      obj_id=$obj_id 
      product=$product 
      but_meta=$add_to_cart_meta}
    {assign var="cart_button_exists" value=true}
  {else}
		{hook name="products:add_to_cart_but_id"}
		    {$_but_id="button_cart_`$obj_prefix``$obj_id`"}
		{/hook}
    {if $extra_button}{$extra_button nofilter}&nbsp;{/if}
    {include file="buttons/add_to_cart.tpl" but_id=$_but_id but_name="dispatch[checkout.add..`$obj_id`]" but_role=$but_role block_width=$block_width obj_id=$obj_id product=$product but_meta=$add_to_cart_meta}
    {assign var="cart_button_exists" value=true}
  {/if}
  {/hook}
{/capture}
{hook name="products:buttons_block"}
  {if (
      $product.zero_price_action != "R"
      || $product.price != 0
    )
    && (
            $settings.General.inventory_tracking == "YesNo::NO"|enum
      || $allow_negative_amount === "YesNo::YES"|enum
      || (
        $product_amount > 0
        && $product_amount >= $product.min_qty
      )
      || $product.tracking == "ProductTracking::DO_NOT_TRACK"|enum
      || $product.is_edp == "Y"
      || $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
    )
    || (
      $product.has_options
      && !$show_product_options
    )}
    {if $smarty.capture.buttons_product|trim != '&nbsp;'}
      {if $product.avail_since <= $smarty.const.TIME || (
        $product.avail_since > $smarty.const.TIME && $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
      )}
        {if $show_et_icon_grid}
          {$et_show_add_to_cart=true}
        {else}
          {$smarty.capture.buttons_product nofilter}
          {if $et_category_list}
            {hook name="products:et_list_buttons"}
            {/hook}
          {/if}
        {/if}
      {/if}
    {/if}
    
  {elseif ($settings.General.inventory_tracking !== "YesNo::NO"|enum && $allow_negative_amount !== "YesNo::YES"|enum && (($product_amount <= 0 || $product_amount < $product.min_qty) && $product.tracking != "ProductTracking::DO_NOT_TRACK"|enum) && $product.is_edp != "Y")}
    {hook name="products:out_of_stock_block"}
    {assign var="show_qty" value=false}
    {if !$details_page}
      {if (!$product.hide_stock_info && !(($product_amount <= 0 || $product_amount < $product.min_qty) && ($product.avail_since > $smarty.const.TIME)))}
        {if $et_scroller_buttons}
          {if !($product.price==0 && $product.zero_price_action == "R")}
          	{include file="buttons/button.tpl" 
              but_id="out_of_stock_info_{$obj_prefix}{$obj_id}" 
              but_text=$out_of_stock_text
              but_role="et_icon"
              et_icon="et-icon-btn-oos"
              but_extra_class="et-add-to-cart et-atc-icon-only et-out-of-stock"}
          {/if}
        {else}
          {capture name="et_oos_btn"}
            {include file="buttons/button.tpl" 
            but_text=__("text_out_of_stock")
            but_role="et_icon_text"
            et_icon="et-icon-btn-oos"
            but_extra_class="et-add-to-cart et-out-of-stock"}
          {/capture}
          {if $show_et_icon_grid || $et_category_list || $et_variation_list}
            {$et_oos_btn=true}
          {else}
            {$smarty.capture.buttons_product nofilter}
          {/if}
        {/if}
      {/if}
    {elseif ($product.out_of_stock_actions == "OutOfStockActions::SUBSCRIBE"|enum)}
      {if ($details_page || $quick_view) && !($product.avail_since > $smarty.const.TIME)}
          {include file="buttons/button.tpl" 
          but_text=__("text_out_of_stock")
          but_role="et_icon_text"
          et_icon="et-icon-btn-oos"
          but_extra_class="et-add-to-cart et-out-of-stock"}
      {/if}

    <div id="subscribe_form_wrapper"><!--subscribe_form_wrapper--></div>

     <script>
         (function(_, $) {
             $.ceAjax('request', fn_url('products.subscription_form?product_id={$product.product_id}'), {
                 hidden: true,
                 result_ids: 'subscribe_form_wrapper'
             });
         }(Tygh, Tygh.$));
     </script>

      {include file="common/image_verification.tpl" option="track_product_in_stock"}
    {elseif ($details_page || $quick_view) && !($product.avail_since > $smarty.const.TIME)}
        {include file="buttons/button.tpl" 
        but_text=__("text_out_of_stock")
        but_role="et_icon_text"
        et_icon="et-icon-btn-oos"
        but_extra_class="et-add-to-cart et-out-of-stock"}
    {/if}
    {/hook}
  {/if}
  {if $product.price==0 && $product.zero_price_action == "R" && !$details_page}
    {if $et_scroller_buttons}

      {include file="buttons/button.tpl" 
      but_text=__("contact_us_for_price")
      but_role="et_icon"
      et_icon="et-icon-contact-for-price3"
      but_href=$product_url
      but_extra_class="et-add-to-cart et-atc-icon-only et-out-of-stock1 et-contact-for-price"}
    {else}
    {include file="buttons/button.tpl" 
    but_text=__("contact_us_for_price")
    but_role="et_icon_text"
    but_href=$product_url
    et_icon="et-icon-contact-for-price3"
    but_extra_class="et-add-to-cart et-out-of-stock1 et-contact-for-price"}
    {/if}
  {/if}
  {if $show_list_buttons}
    {capture name="product_buy_now_`$obj_id`"}
      {$compare_product_id = $product.product_id}
      {if $et_scroller_buttons}
        {hook name="products:et_scroller_buttons"}
        {/hook} 

        <div class="et-scroller-btns">{strip}
          {if $show_et_qv}
            {include file="views/products/components/quick_view_link.tpl" quick_nav_ids=$quick_nav_ids show_et_icon_buttons=true}
          {/if}
          {if $settings.General.enable_compare_products == "Y" && !$et_hide_compare_btn}
            {include file="buttons/add_to_compare_list.tpl" product_id=$compare_product_id}
          {/if}
          {hook name="products:buy_now"}
          {/hook}
          {strip}
        </div>
      {elseif $et_category_list}
        <div class="et-list-buttons-wrapper clearfix">{strip}
          {hook name="products:buy_now"}
            {if $settings.General.enable_compare_products == "Y"}
              {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id}
            {/if}
          {/hook}
          {if $show_et_qv}
            {include file="views/products/components/quick_view_link.tpl" quick_nav_ids=$quick_nav_ids}
          {/if}
        {/strip}</div>
      {elseif $details_page}
        {hook name="products:buy_now"}
        {/hook}
      {elseif $show_et_icon_grid}
        <div class="et-scroller-btns clearfix">{strip}
          {if $show_et_qv}
            {include file="views/products/components/quick_view_link.tpl" quick_nav_ids=$quick_nav_ids}
          {/if}
          {if $settings.General.enable_compare_products == "Y"}
            {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id}
          {/if}
          {hook name="products:buy_now"}
          {/hook}
        {/strip}</div>
      {else}
        {if $show_et_qv}
          {include file="views/products/components/quick_view_link.tpl" quick_nav_ids=$quick_nav_ids show_et_icon_buttons=true}
        {/if}
        {hook name="products:buy_now"}
        {if $settings.General.enable_compare_products == "Y"}
          {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id}
        {/if}
        {/hook}
      {/if}
    {/capture}
    {assign var="capture_buy_now" value="product_buy_now_`$obj_id`"}

    {if $smarty.capture.$capture_buy_now|trim && !$show_et_icon_grid && !$et_category_list}
      {$smarty.capture.$capture_buy_now nofilter}
    {/if}
  {/if}

  {if !$details_page && !$et_category_list && !$et_category_compact && ($product.avail_since > $smarty.const.TIME)}
    {include file="common/coming_soon_notice.tpl" avail_date=$product.avail_since add_to_cart=$product.out_of_stock_actions}
  {/if}


  {if $et_show_add_to_cart}
    {if $show_et_icon_grid && !$et_category_list}
      {hook name="products:et_grid_buttons"}
      {/hook} 
    {/if}
    {$smarty.capture.buttons_product nofilter}
  {elseif $et_oos_btn}
    {$smarty.capture.et_oos_btn nofilter}
  {/if}




  {* Uncomment these lines in the overrides hooks for back-passing $cart_button_exists variable to the product_data template *}
  {*if $cart_button_exists}
    {capture name="cart_button_exists"}Y{/capture}
  {/if*}
{/hook}
{/strip}
{if $details_page && $addons.call_requests.status !== "A"}<!--add_to_cart_update_{$obj_prefix}{$obj_id}-->{/if}</div>
{/if}
{/capture}

{if $smarty.capture.cart_button_exists}
  {assign var="cart_button_exists" value=true}
{/if}

{if $no_capture}
  {assign var="capture_name" value="add_to_cart_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="product_features_`$obj_id`"}
{hook name="products:product_features"}
  {if $show_features}
        <div class="cm-reload-{$obj_prefix}{$obj_id}" id="product_data_features_update_{$obj_prefix}{$obj_id}">
    <input type="hidden" name="appearance[show_features]" value="{$show_features}" />
    {include file="views/products/components/product_features_short_list.tpl" features=$product|fn_get_product_features_list no_container=true}
        <!--product_data_features_update_{$obj_prefix}{$obj_id}--></div>
  {/if}
{/hook}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="product_features_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="prod_descr_`$obj_id`"}
  {if $show_descr}
  {if $product.short_description}
    <div {live_edit name="product:short_description:{$product.product_id}"}>{$product.short_description nofilter}</div>
  {elseif $quick_view}
    <div {live_edit name="product:full_description:{$product.product_id}" phrase=$product.full_description}>{$product.full_description|strip_tags|truncate:160 nofilter}</div>
  {else}
    <div {live_edit name="product:full_description:{$product.product_id}" phrase=$product.full_description}>{$product.full_description|strip_tags|truncate:650 nofilter}</div>
  {/if}
  {/if}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="prod_descr_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{********************** Old Price *****************}
{capture name="old_price_`$obj_id`"}
  {if $show_price_values && $show_old_price}
  <span class="cm-reload-{$obj_prefix}{$obj_id}" id="old_price_update_{$obj_prefix}{$obj_id}">
    {hook name="products:old_price"}
    {if $product.discount}

      {if !$product.included_tax}
        <span class="ty-list-price ty-nowrap" id="line_old_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.original_price|default:$product.base_price - $product.tax_value span_id="old_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
      {else}
        <span class="ty-list-price ty-nowrap" id="line_old_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.original_price|default:$product.base_price span_id="old_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
      {/if}
    {elseif $product.list_discount}
      {if !$product.included_tax}
        <span class="ty-list-price ty-nowrap" id="line_list_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.list_price - $product.tax_value span_id="list_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
      {else}
        <span class="ty-list-price ty-nowrap" id="line_list_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.list_price span_id="list_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
      {/if}
    {/if}
    {/hook}
  <!--old_price_update_{$obj_prefix}{$obj_id}--></span>
  {/if}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="old_price_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{********************** Price *********************}
{capture name="price_`$obj_id`"}
    <span class="{if $product.zero_price_action !== "A"}cm-reload-{$obj_prefix}{$obj_id}{/if} ty-price-update" id="price_update_{$obj_prefix}{$obj_id}">
  <input type="hidden" name="appearance[show_price_values]" value="{$show_price_values}" />
  <input type="hidden" name="appearance[show_price]" value="{$show_price}" />
  {if $show_price_values}
    {if $show_price}
    {hook name="products:prices_block"}
      {if $auth.tax_exempt === "{"YesNo::NO"|enum}" || !$product.clean_price}
        {$price = $product.price}
      {else}
        {$price = $product.clean_price}
      {/if}

      {if $price|floatval || $product.zero_price_action == "P" || ($hide_add_to_cart_button == "Y" && $product.zero_price_action == "A")}
        <span class="ty-price{if !$price|floatval && !$product.zero_price_action} hidden{/if}" id="line_discounted_price_{$obj_prefix}{$obj_id}">{include file="common/price.tpl" value=$price span_id="discounted_price_`$obj_prefix``$obj_id`" class="ty-price-num" live_editor_name="product:price:{$product.product_id}" live_editor_phrase=$product.base_price}</span>
      {elseif $product.zero_price_action == "A" && $show_add_to_cart}
        {assign var="base_currency" value=$currencies[$smarty.const.CART_PRIMARY_CURRENCY]}
        <span class="ty-price-curency"><span class="ty-price-curency__title">{__("enter_your_price")}:</span>
        <div class="ty-price-curency-input">
          <input type="text" name="product_data[{$obj_id}][price]" class="ty-price-curency__input cm-numeric" data-a-sign="{$base_currency.symbol nofilter}"  data-a-dec="{if $base_currency.decimal_separator}{$base_currency.decimal_separator nofilter}{else}.{/if}"  data-a-sep="{if $base_currency.thousands_separator}{$base_currency.thousands_separator nofilter}{else},{/if}" data-p-sign="{if $base_currency.after === "YesNo::YES"|enum}s{else}p{/if}" data-m-dec="{$base_currency.decimals}" size="3" value="" />
        </div>
        </span>

      {elseif $product.zero_price_action == "R"}
        <span class="ty-no-price">{__("contact_us_for_price")}</span>
        {assign var="show_qty" value=false}
      {/if}
    {/hook}
    {/if}
  {elseif $settings.Checkout.allow_anonymous_shopping == "hide_price_and_add_to_cart" && !$auth.user_id}
    <span class="ty-price">{__("sign_in_to_view_price")}</span>
  {/if}
  <!--price_update_{$obj_prefix}{$obj_id}--></span>
{/capture}
{if $no_capture}
  {assign var="capture_name" value="price_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{******************* Clean Price ******************}
{capture name="clean_price_`$obj_id`"}
  {if $show_price_values
    && $show_clean_price
    && $settings.Appearance.show_prices_taxed_clean === "YesNo::YES"|enum
    && $auth.tax_exempt !== "YesNo::YES"|enum
    && $product.taxed_price
  }
    <span class="cm-reload-{$obj_prefix}{$obj_id} et-clean-price" id="clean_price_update_{$obj_prefix}{$obj_id}">
    <input type="hidden" name="appearance[show_price_values]" value="{$show_price_values}" />
    <input type="hidden" name="appearance[show_clean_price]" value="{$show_clean_price}" />
    {if $product.clean_price != $product.taxed_price && $product.included_tax}
    <span class="ty-list-price ty-nowrap" id="line_product_price_{$obj_prefix}{$obj_id}">({include file="common/price.tpl" value=$product.taxed_price span_id="product_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"} {__("inc_tax")})</span>
    {elseif $product.clean_price != $product.taxed_price && !$product.included_tax}
    <span class="ty-list-price ty-nowrap ty-tax-include">({__("including_tax")})</span>
    {/if}
  <!--clean_price_update_{$obj_prefix}{$obj_id}--></span>
  {/if}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="clean_price_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{********************** You Save ******************}
{capture name="list_discount_`$obj_id`"}
  {if ($show_price_values && $show_list_discount && $details_page) || $et_show_discount_text}
  <span class="cm-reload-{$obj_prefix}{$obj_id}" id="line_discount_update_{$obj_prefix}{$obj_id}">
    <input type="hidden" name="appearance[show_price_values]" value="{$show_price_values}" />
    <input type="hidden" name="appearance[show_list_discount]" value="{$show_list_discount}" />
    {if $product.discount}
    <span class="ty-list-price ty-save-price ty-nowrap" id="line_discount_value_{$obj_prefix}{$obj_id}">{__("you_save")}: {include file="common/price.tpl" value=$product.discount span_id="discount_value_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}{if $et_show_discount_prc}<span class="ty-save-price__percent">&nbsp;(<span id="prc_discount_value_{$obj_prefix}{$obj_id}" class="ty-list-price ty-nowrap">{$product.discount_prc}</span>%)</span>{/if}</span>
    {elseif $product.list_discount}
    <span class="ty-list-price ty-save-price ty-nowrap" id="line_discount_value_{$obj_prefix}{$obj_id}">{__("you_save")}: {include file="common/price.tpl" value=$product.list_discount span_id="discount_value_`$obj_prefix``$obj_id`"}{if $et_show_discount_prc}<span class="ty-save-price__percent">&nbsp;(<span id="prc_discount_value_{$obj_prefix}{$obj_id}">{$product.list_discount_prc}</span>%)</span>{/if}</span>
    {/if}
  <!--line_discount_update_{$obj_prefix}{$obj_id}--></span>
  {/if}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="list_discount_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{************************************ Discount label ****************************}
{capture name="discount_label_`$obj_prefix``$obj_id`"}
  {if $show_discount_label && ($product.discount_prc || $product.list_discount_prc) && $show_price_values}
    <span class="ty-discount-label cm-reload-{$obj_prefix}{$obj_id}" id="discount_label_update_{$obj_prefix}{$obj_id}">
      <span class="ty-discount-label__item" id="line_prc_discount_value_{$obj_prefix}{$obj_id}"><span class="ty-discount-label__value" id="prc_discount_value_label_{$obj_prefix}{$obj_id}">-{if $product.discount}{$product.discount_prc}{else}{$product.list_discount_prc}{/if}%</span></span>
    <!--discount_label_update_{$obj_prefix}{$obj_id}--></span>
  {/if}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="discount_label_`$obj_prefix``$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{************************************ Product labels ****************************}
{$product_labels_position = $product_labels_position|default:"top-left"}

{capture name="product_labels_`$obj_prefix``$obj_id`"}
    {if $show_product_labels}
        {capture name="capture_product_labels_`$obj_prefix``$obj_id`"}
            {hook name="products:product_labels"}
            {if $show_shipping_label && $product.free_shipping == "Y"}
                {include
                    file="views/products/components/product_label.tpl"
                    label_meta="ty-product-labels__item--shipping"
                    label_text=__("free_shipping")
                    label_mini=$product_labels_mini
                    label_static=$product_labels_static
                    label_rounded=$product_labels_rounded
                    label_icon="et-icon-free-shipping"
                }
            {/if}
            {/hook}
        {/capture}
        {$capture_product_labels = "capture_product_labels_`$obj_prefix``$obj_id`"}

        {if $smarty.capture.$capture_product_labels|trim}
            <div class="ty-product-labels ty-product-labels--{$product_labels_position} {if $product_labels_mini}ty-product-labels--mini{/if} {if $product_labels_static}ty-product-labels--static{/if} cm-reload-{$obj_prefix}{$obj_id}" id="product_labels_update_{$obj_prefix}{$obj_id}">
                {$smarty.capture.$capture_product_labels nofilter}
            <!--product_labels_update_{$obj_prefix}{$obj_id}--></div>
        {/if}
        {if $show_discount_label && ($product.discount_prc || $product.list_discount_prc) && $show_price_values}
            <span class="ty-discount-label cm-reload-{$obj_prefix}{$obj_id}" id="discount_label_update_{$obj_prefix}{$obj_id}">
              <span class="ty-discount-label__item" id="line_prc_discount_value_{$obj_prefix}{$obj_id}"><span class="ty-discount-label__value" id="prc_discount_value_label_{$obj_prefix}{$obj_id}">-{if $product.discount}{$product.discount_prc}{else}{$product.list_discount_prc}{/if}%</span></span>
            <!--discount_label_update_{$obj_prefix}{$obj_id}--></span>
        {/if}
    {/if}
{/capture}
{if $no_capture}
    {$capture_name = "product_labels_`$obj_prefix``$obj_id`"}
    {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="product_amount_`$obj_id`"}
{hook name="products:product_amount"}
{if $show_product_amount && $product.is_edp != "Y" && $settings.General.inventory_tracking !== "YesNo::NO"|enum}
  <div class="cm-reload-{$obj_prefix}{$obj_id} stock-wrap" id="product_amount_update_{$obj_prefix}{$obj_id}">
  <input type="hidden" name="appearance[show_product_amount]" value="{$show_product_amount}" />
  {if !$product.hide_stock_info}
    {if $settings.Appearance.in_stock_field == "Y"}
      {if $product.tracking != "ProductTracking::DO_NOT_TRACK"|enum}
        {if ($product_amount > 0 && $product_amount >= $product.min_qty) && $settings.General.inventory_tracking !== "YesNo::NO"|enum || $details_page || $show_et_grid_stock}
          {if (
            $product_amount > 0
            && $product_amount >= $product.min_qty
            || $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
            )
            && $settings.General.inventory_tracking !== "YesNo::NO"|enum
          }
            <div class="ty-control-group product-list-field">
              {if $show_et_grid_stock}
                {if $product_amount > 0}
                  {if $show_amount_label && $settings.General.inventory_tracking}
                    {capture name="et_stock_text"}{$product_amount}&nbsp;{__("items")}{/capture}
                  {else}
                    {capture name="et_stock_text"}{__('in_stock')}{/capture}
                  {/if}
                  <div class="et-grid-stock et-in-stock"><i class="far fa-check-circle"></i> <span>{$smarty.capture.et_stock_text nofilter}</span></div>
                {else}
                  <div class="et-grid-stock et-backorder"><i class="far fa-check-circle"></i> <span>{__("on_backorder")}</span></div>
                {/if}
              {else}
                {if $show_amount_label}
                  <label class="ty-control-group__label">{__("availability")}:</label>
                {/if}
                <span id="qty_in_stock_{$obj_prefix}{$obj_id}" class="ty-qty-in-stock ty-control-group__item">
                  {if $product_amount > 0}
                    {$product_amount}&nbsp;{__("items")}
                  {else}
                      {__("on_backorder")}
                  {/if}
                </span>
              {/if}
            </div>
          {elseif $settings.General.inventory_tracking !== "YesNo::NO"|enum && $allow_negative_amount !== "YesNo::YES"|enum}
            <div class="ty-control-group product-list-field">
              {if $show_et_grid_stock}
                <div class="et-grid-stock et-out-of-stock"><i class="et-icon-btn-oos"></i> <span>{$out_of_stock_text}</span></div>
              {else}
                {if $show_amount_label}
                  <label class="ty-control-group__label">{__("in_stock")}:</label>
                {/if}
                <span class="ty-qty-out-of-stock ty-control-group__item">{$out_of_stock_text}</span>
              {/if}
            </div>
          {/if}
        {/if}
      {/if}
    {else}
      {if (
        $product_amount > 0
        && $product_amount >= $product.min_qty
        || $product.tracking == "ProductTracking::DO_NOT_TRACK"|enum
        )
        && $settings.General.inventory_tracking !== "YesNo::NO"|enum
        && $allow_negative_amount !== "YesNo::YES"|enum
        || $settings.General.inventory_tracking !== "YesNo::NO"|enum
        && (
          $allow_negative_amount === "YesNo::YES"|enum
          || $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
        )
      }
        {if $show_et_grid_stock}
          {if $product_amount > 0}
            <div class="et-grid-stock et-in-stock"><i class="far fa-check-circle"></i> <span>{__('in_stock')}</span></div>
          {else}
            <div class="et-grid-stock et-backorder"><i class="far fa-check-circle"></i> <span>{__("on_backorder")}</span></div>
          {/if}
        {else}
          <div class="ty-control-group product-list-field">
            {if $show_amount_label}
              <label class="ty-control-group__label">{__("availability")}:</label>
            {/if}
            <span class="ty-qty-in-stock ty-control-group__item" id="in_stock_info_{$obj_prefix}{$obj_id}">
              {if $product_amount > 0}
                <i class="far fa-check-circle"></i> {__("in_stock")}
              {else}
                {__("on_backorder")}
              {/if}
            </span>
          </div>
        {/if}
      {elseif (
          $product_amount <= 0
          || $product_amount < $product.min_qty
        )
        && $settings.General.inventory_tracking !== "YesNo::NO"|enum
        && $allow_negative_amount !== "YesNo::YES"|enum
      }

        <div class="ty-control-group product-list-field">
          {if $show_et_grid_stock}
            <div class="et-grid-stock et-out-of-stock"><i class="et-icon-btn-oos"></i> <span>{$out_of_stock_text}</span></div>
          {else}
            {if $show_amount_label}
              <label class="ty-control-group__label">{__("availability")}:</label>
            {/if}
              <span class="ty-qty-out-of-stock ty-control-group__item" id="out_of_stock_info_{$obj_prefix}{$obj_id}"><i class="et-icon-btn-oos"></i> {$out_of_stock_text}</span>
          {/if}
        </div>
      {/if}
    {/if}
  {/if}
  <!--product_amount_update_{$obj_prefix}{$obj_id}--></div>
{/if}
{/hook}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="product_amount_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="product_options_`$obj_id`"}
  {if $show_product_options}
    <div class="cm-reload-{$obj_prefix}{$obj_id} js-product-options-{$obj_prefix}{$obj_id}" id="product_options_update_{$obj_prefix}{$obj_id}">
    <input type="hidden" name="appearance[show_product_options]" value="{$show_product_options}" />
    {hook name="products:product_option_content"}
    {if $disable_ids}
      {assign var="_disable_ids" value="`$disable_ids``$obj_id`"}
    {else}
      {assign var="_disable_ids" value=""}
    {/if}
    {include file="views/products/components/product_options.tpl" id=$obj_id product_options=$product.product_options name="product_data" capture_options_vs_qty=$capture_options_vs_qty disable_ids=$_disable_ids}
    {/hook}
  <!--product_options_update_{$obj_prefix}{$obj_id}--></div>
  {/if}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="product_options_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="advanced_options_`$obj_id`"}
  {if $show_product_options}
  <div class="cm-reload-{$obj_prefix}{$obj_id}" id="advanced_options_update_{$obj_prefix}{$obj_id}">
      {if !$details_page}
        {include file="views/companies/components/product_company_data.tpl" company_name=$product.company_name company_id=$product.company_id}
      {/if}
    {hook name="products:options_advanced"}
    {/hook}
  <!--advanced_options_update_{$obj_prefix}{$obj_id}--></div>
  {/if}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="advanced_options_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="qty_`$obj_id`"}
  {hook name="products:qty"}
  <div class="cm-reload-{$obj_prefix}{$obj_id}" id="qty_update_{$obj_prefix}{$obj_id}">
    <input type="hidden" name="appearance[show_qty]" value="{$show_qty}" />
    <input type="hidden" name="appearance[capture_options_vs_qty]" value="{$capture_options_vs_qty}" />
    {if !empty($product.selected_amount)}
    {assign var="default_amount" value=$product.selected_amount}
    {elseif !empty($product.min_qty)}
    {assign var="default_amount" value=$product.min_qty}
    {elseif !empty($product.qty_step)}
    {assign var="default_amount" value=$product.qty_step}
    {else}
    {assign var="default_amount" value="1"}
    {/if}

    {if $show_qty && $product.is_edp !== "Y" && $cart_button_exists == true && ($settings.Checkout.allow_anonymous_shopping == "allow_shopping" || $auth.user_id) && $product.avail_since <= $smarty.const.TIME || ($product.avail_since > $smarty.const.TIME && $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum)}
    <div class="ty-qty clearfix{if $settings.Appearance.quantity_changer == "Y"} changer{/if}" id="qty_{$obj_prefix}{$obj_id}">
      {if !$hide_qty_label}<label class="ty-control-group__label" for="qty_count_{$obj_prefix}{$obj_id}">{$quantity_text|default:__("quantity")}:</label>{/if}
        {if $product.qty_content}
        <select name="product_data[{$obj_id}][amount]" id="qty_count_{$obj_prefix}{$obj_id}">
        {assign var="a_name" value="product_amount_`$obj_prefix``$obj_id`"}
        {assign var="selected_amount" value=false}
        {foreach $product.qty_content as $var}
          <option value="{$var}" {if $product.selected_amount && ($product.selected_amount == $var || ($var@last && !$selected_amount))}{assign var="selected_amount" value=true}selected="selected"{/if}>{$var}</option>
        {/foreach}
        </select>
        {else}
      <div class="ty-center ty-value-changer cm-value-changer">
      {if $settings.Appearance.quantity_changer == "Y"}
            <a class="cm-increase ty-value-changer__increase">&#43;</a>
      {/if}
          <input {if $product.qty_step > 1}readonly="readonly"{/if} type="text" size="5" class="ty-value-changer__input cm-amount" id="qty_count_{$obj_prefix}{$obj_id}" name="product_data[{$obj_id}][amount]" value="{$default_amount}"{if $product.qty_step > 1} data-ca-step="{$product.qty_step}"{/if} data-ca-min-qty="{if $product.min_qty > 1}{$product.min_qty}{else}1{/if}" />
      {if $settings.Appearance.quantity_changer == "Y"}
            <a class="cm-decrease ty-value-changer__decrease">&minus;</a>
      {/if}
      </div>
        {/if}
    </div>
      {if $product.prices && !$details_page}
        {include file="views/products/components/products_qty_discounts.tpl"}
      {/if}
    {elseif !$bulk_add}
    <input type="hidden" name="product_data[{$obj_id}][amount]" value="{$default_amount}" />
    {/if}
  <!--qty_update_{$obj_prefix}{$obj_id}--></div>
  {/hook}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="qty_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="qty_`$obj_id`_no_id"}
  {hook name="products:qty"}
  <div>
    <input type="hidden" name="appearance[show_qty]" value="{$show_qty}" />
    <input type="hidden" name="appearance[capture_options_vs_qty]" value="{$capture_options_vs_qty}" />
    {if !empty($product.selected_amount)}
    {assign var="default_amount" value=$product.selected_amount}
    {elseif !empty($product.min_qty)}
    {assign var="default_amount" value=$product.min_qty}
    {elseif !empty($product.qty_step)}
    {assign var="default_amount" value=$product.qty_step}
    {else}
    {assign var="default_amount" value="1"}
    {/if}

    {if $show_qty && $product.is_edp !== "Y" && $cart_button_exists == true && ($settings.Checkout.allow_anonymous_shopping == "allow_shopping" || $auth.user_id) && $product.avail_since <= $smarty.const.TIME || ($product.avail_since > $smarty.const.TIME && $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum)}
    <div class="ty-qty clearfix{if $settings.Appearance.quantity_changer == "Y"} changer{/if}" >
      {if !$hide_qty_label}<label class="ty-control-group__label" for="qty_count_{$obj_prefix}{$obj_id}">{$quantity_text|default:__("quantity")}:</label>{/if}
        {if $product.qty_content}
        <select name="product_data[{$obj_id}][amount]" >
        {assign var="a_name" value="product_amount_`$obj_prefix``$obj_id`"}
        {assign var="selected_amount" value=false}
        {foreach $product.qty_content as $var}
          <option value="{$var}" {if $product.selected_amount && ($product.selected_amount == $var || ($var@last && !$selected_amount))}{assign var="selected_amount" value=true}selected="selected"{/if}>{$var}</option>
        {/foreach}
        </select>
        {else}
      <div class="ty-center ty-value-changer cm-value-changer">
      {if $settings.Appearance.quantity_changer == "Y"}
            <a class="cm-increase ty-value-changer__increase">&#43;</a>
      {/if}
          <input {if $product.qty_step > 1}readonly="readonly"{/if} type="text" size="5" class="ty-value-changer__input cm-amount" name="product_data[{$obj_id}][amount]" value="{$default_amount}"{if $product.qty_step > 1} data-ca-step="{$product.qty_step}"{/if} data-ca-min-qty="{if $product.min_qty > 1}{$product.min_qty}{else}1{/if}" />
      {if $settings.Appearance.quantity_changer == "Y"}
            <a class="cm-decrease ty-value-changer__decrease">&minus;</a>
      {/if}
      </div>
        {/if}
    </div>
      {if $product.prices && !$details_page}
        {include file="views/products/components/products_qty_discounts.tpl"}
      {/if}
    {elseif !$bulk_add}
    <input type="hidden" name="product_data[{$obj_id}][amount]" value="{$default_amount}" />
    {/if}
  <!--qty_update_{$obj_prefix}{$obj_id}--></div>
  {/hook}
{/capture}

{capture name="min_qty_`$obj_id`"}
  {hook name="products:qty_description"}
  {if $min_qty && $product.min_qty}
  <p class="ty-min-qty-description">{__("text_cart_min_qty", ["[product]" => $product.product, "[quantity]" => $product.min_qty]) nofilter}.</p>
  {/if}
  {/hook}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="min_qty_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="product_edp_`$obj_id`"}
  {if $show_edp && $product.is_edp == "Y"}
    <p class="ty-edp-description">{__("text_edp_product")}.</p>
  <input type="hidden" name="product_data[{$obj_id}][is_edp]" value="Y" />
  {/if}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="product_edp_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{capture name="form_close_`$obj_id`"}
{if !$hide_form}
</form>
{/if}
{/capture}
{if $no_capture}
  {assign var="capture_name" value="form_close_`$obj_id`"}
  {$smarty.capture.$capture_name nofilter}
{/if}

{foreach from=$images key="object_id" item="image"}
{assign var="product_link" value=$image.link}
{hook name="products:list_images_block"}
  <div class="cm-reload-{$image.obj_id}" id="{$object_id}">
        {if $product_link}
            <a href="{$product_link}">
    <input type="hidden" value="{$image.link}" name="image[{$object_id}][link]" />
  {/if}
  <input type="hidden" value="{$image.obj_id},{$image.width},{$image.height},{$image.type}" name="image[{$object_id}][data]" />
  {include file="common/image.tpl" image_width=$image.width image_height=$image.height obj_id=$object_id images=$product.main_pair}
  {if $image.link}
    </a>
  {/if}
  <!--{$object_id}--></div>
{/hook}
{/foreach}
{/hook}

{hook name="products:product_data"}{/hook}
