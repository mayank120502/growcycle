<div class="et-link-thumb__wrapper">
{foreach from=$products item="product" name="products"}{strip}
  <div class="et-link-thumb__inner-wrapper ty-column2">
    {assign var="obj_id" value=$product.product_id}
    {assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}
    {include file="common/product_data.tpl" 
      product=$product 
      show_et_icon_grid=true 
      show_old_price=true 
      show_et_atc=true 
      show_et_icon_buttons=false
      et_separate_buttons=false
      show_list_buttons=false
      show_product_labels=true 
      show_discount_label=true 
      show_shipping_label=true
      hide_label_text=true
      show_rating=true
      show_et_rating=true}

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

    {hook name="products:product_thumbnail_list"}
      <div class="et-link-thumb__item">
        {assign var="form_open" value="form_open_`$obj_id`"}
        {$smarty.capture.$form_open nofilter}
        <div class="et-link-thumb__img_wrapper">
          {assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
          {$smarty.capture.$product_labels nofilter}


          <a class="et-link-thumb__img_a" href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>{include file="common/image.tpl" image_width="100" image_height="100" images=$product.main_pair obj_id=$obj_id_prefix no_ids=true class="ty-thumbnail-list__img" et_lazy=true}</a>
        </div>

        <div class="et-title">
          {assign var="name" value="name_$obj_id"}<bdi>{$smarty.capture.$name nofilter}</bdi>
        </div>

        <div class="et-price">
          {assign var="price" value="price_`$obj_id`"}
          {$smarty.capture.$price nofilter}

          {assign var="old_price" value="old_price_`$obj_id`"}
          {if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}{/if}
        </div>

        {assign var="rating" value="rating_`$obj_id`"}
        <div class="et-link-thumb__rating-wrapper">
          {$smarty.capture.$rating nofilter}
        </div>

        {assign var="form_close" value="form_close_`$obj_id`"}
        {$smarty.capture.$form_close nofilter}
      </div>
  {/hook}
</div>{strip}{/foreach}
</div>