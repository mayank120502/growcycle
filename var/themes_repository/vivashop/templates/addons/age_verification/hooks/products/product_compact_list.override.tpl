{if !$smarty.session.auth.age && $product.need_age_verification == "Y"}
<div class="et-age-verification__compact">
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

  <div class="ty-compact-list__item et-compact-list__item {if $smarty.foreach.products.first}first{/if}">
    <form {if !$config.tweaks.disable_dhtml}class="cm-ajax cm-ajax-full-render"{/if} action="{""|fn_url}" method="post" name="short_list_form{$obj_prefix}">
      
      <input type="hidden" name="result_ids" value="cart_status*,wish_list*,account_info*,et-cw*" />
      <input type="hidden" name="redirect_url" value="{$config.current_url}" />
      <input type="hidden" name="product_data[{$obj_id}][product_id]" value="{$product.product_id}" />
      
      <div class="ty-compact-list__content et-compact-list__content">
        {hook name="products:product_compact_list_image"}
        <div class="ty-compact-list__image et-compact-list__image">
          <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter}>
            <span class="ty-no-image" style="max-height: {$image_height|default:$image_width}px; width: {$image_width|default:$image_height}px;"><img src="./design/themes/vivashop/media/images/et-empty.png" height="{$image_height|default:$image_width}" width="{$image_width|default:$image_height}" class="et-no-image" alt=""/><i class="ty-no-image__icon et-icon-verify" title="{__("verify")}"></i></span>
          </a>
        </div>
        {/hook}

        <div class="et-compact-list__middle">
          {* Product title *}
          <div class="et-compact-list__title">
            {assign var="name" value="name_$obj_id"}<bdi>{$smarty.capture.$name nofilter}</bdi>
          </div>
          {* /Product title *}
          <div class="ty-age-verification__txt">{__("product_need_age_verification")}</div>

        </div>

        <div class="et-compact-list__right">
          <a href="{$product_detail_view_url|fn_url}" {$et_add_blank nofilter} class="ty-btn ty-btn__secondary text-button" title="{__("verify")}">{__("verify")}</a>
        </div>
      </div>
    </form>
  </div>
</div>
{/if}