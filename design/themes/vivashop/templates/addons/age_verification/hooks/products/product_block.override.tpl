{if !$smarty.session.auth.age && $product.need_age_verification == "Y"}
<div class="et-age-verification__list">
  {assign var="obj_id" value=$product.product_id}
  {assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}

  {$et_category_list=true}
  {include file="common/product_data.tpl" product=$product min_qty=true et_category_list=$et_category_list show_et_rating=true show_et_grid_stock=true show_sku=true show_et_atc=true}
  {if !$image_width}
    {$image_width=$settings.Thumbnails.product_lists_thumbnail_width}
  {/if}

  {if !$image_height}
    {$image_height=$settings.Thumbnails.product_lists_thumbnail_height}
  {/if}

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

  <div class="ty-product-list clearfix et-list__item {if $smarty.foreach.products.first}first{elseif $smarty.foreach.products.last}last{/if} {if $use_vendor_url}et-vendor-list{/if}">
    <div class="et-list__form-wrapper">
      {assign var="form_open" value="form_open_`$obj_id`"}
      {$smarty.capture.$form_open nofilter}
      <div class="et-list__inner-wrapper">
        {* Product Images *}
        <div class="ty-product-list__image ">
          <div class="et-relative">
            <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>
              <span class="ty-no-image" style="max-height: {$image_height|default:$image_width}px; width: {$image_width|default:$image_height}px;"><img src="./design/themes/vivashop/media/images/et-empty.png" height="{$image_height|default:$image_width}" width="{$image_width|default:$image_height}" class="et-no-image" alt="{__("empty")}"/><i class="ty-no-image__icon et-icon-verify" title="{__("verify")}"></i></span>
            </a>
          </div>
        </div>
        {* /Product Images *}

        <div class="ty-product-list__content et-list__content clearfix">
        {hook name="products:product_block_content"}
          {* Product title *}
          <div class="ty-product-list__item-name">
            {assign var="name" value="name_$obj_id"}
            <bdi>{$smarty.capture.$name nofilter}</bdi>
          </div>
          {* /Product title *}

          <div class="ty-product-list__info et-product-list__info">
            {* Description *}
            <div class="ty-product-list__description et-product-list__description">
              {__("product_need_age_verification")}
            </div>
            {* /Description *}
          </div>
        </div>
        <div class="et-product-list__right">
          <div class="et-list-buttons-vendor-wrapper">
            <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter} class="ty-btn ty-btn__secondary text-button" title="{__("verify")}">{__("verify")}</a>
          </div>
        {/hook}
        </div>
      </div>
      {assign var="form_close" value="form_close_`$obj_id`"}
      {$smarty.capture.$form_close nofilter}
    </div>
  </div>
</div>
{/if}