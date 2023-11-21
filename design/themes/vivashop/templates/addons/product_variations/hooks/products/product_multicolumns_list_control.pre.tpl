{if $show_features && $product.variation_features_variants}
  {capture name="variation_features_variants"}
  {foreach $product.variation_features_variants as $variation_feature}
    {if $variation_feature.display_on_catalog === "YesNo::YES"|enum}
      <div class="ty-grid-list__item-features-item">
        <span class="ty-grid-list__item-features-description">
          {$variation_feature.description}:
        </span>
        {$id=$variation_feature.feature_id}

        {$et_variants = []}
        {foreach $variation_feature.variants as $variant}
            {if $variant.product_id || $addons.product_variations.variations_show_all_possible_feature_variants === "YesNo::YES"|enum}
                {$et_variants[] = $variant}
            {/if}
        {/foreach}

        <div class="et-grid-item-features-wrapper">
          {foreach $et_variants as $variant name=variants}{strip}
            {if $variant.color_hex}
              <span class="et-grid-color-variant" style="background: {$variant.color_hex};">{if $variant.variant_id==$product.variation_features.$id.variant_id}<i class="ty-icon-ok {if $variant.color_hex=="#ffffff"}black{/if}"></i>{/if}</span> 
            {else}
              <span class="ty-grid-list__item-features-variant {if $variant.variant_id==$product.variation_features.$id.variant_id}selected{/if}">
                {$variant.variant}{if !$smarty.foreach.variants.last}{/if}
          </span>
            {/if}
          {/strip}{/foreach}
        </div>
      </div>
    {/if}
  {/foreach}
  {/capture}
  {if $smarty.capture.variation_features_variants|trim}
    <div class="ty-grid-list__item-features">
      {$smarty.capture.variation_features_variants nofilter}
    </div>
  {/if}
{/if}
