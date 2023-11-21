{if !$smarty.session.auth.age && $product.need_age_verification == "Y"}
<div class="et-age-verification__block">
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


  <div class="ty-grid-list__image">
    <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>
      <span class="ty-no-image" style="max-height: {$image_height|default:$image_width}px; width: {$image_width|default:$image_height}px;"><img src="./design/themes/vivashop/media/images/et-empty.png" height="{$image_height|default:$image_width}" width="{$image_width|default:$image_height}" class="et-no-image" alt="{__("empty")}"/><i class="ty-no-image__icon et-icon-verify" title="{__("verify")}"></i></span>
    </a>
  </div>

  <div class="et-grid-info-wrapper et-info-wrapper-age-verif">
    {assign var="name" value="name_$obj_id"}
    <div class="et-grid-product-name">
      {if $item_number == "Y"}
        <span class="item-number">{$cur_number}.&nbsp;</span>
        {math equation="num + 1" num=$cur_number assign="cur_number"}
      {/if}
      <bdi>{$smarty.capture.$name nofilter}</bdi>
    </div>

    <div class="et-grid-hide">
      <div class="et-grid-sku">{assign var="sku" value="sku_`$obj_id`"}
        {$smarty.capture.$sku nofilter}</div>
    </div>

    <div class="ty-age-verification__txt">{__("product_need_age_verification")}</div>

    <div class="ty-grid-list__control">
      <div class="button-container">
          <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter} class="ty-btn ty-btn__secondary text-button" title="{__("verify")}">{__("verify")}</a>
      </div>
    </div>

  </div>

</div>
{/if}