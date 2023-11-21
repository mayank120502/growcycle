<dl class="flex flex-wrap">
    {foreach $product_features as $feature}
        {if $feature.feature_type != "ProductFeatures::GROUP"|enum}
            {if $feature.feature_type == "ProductFeatures::MULTIPLE_CHECKBOX"|enum}
                {$hide_affix = true}
            {else}
                {$hide_affix = false}
            {/if}

            <dt class="h7 col-5 pb1">
                <span>{$feature.description nofilter}</span>
            </dt>
            <dd class="m0 col-7 pb1 pl2">
                {if $feature.prefix && !$hide_affix}{$feature.prefix}{/if}

                {if $feature.feature_type == "ProductFeatures::SINGLE_CHECKBOX"|enum}
                    <span class="ty-compare-checkbox" title="{$feature.value}">
                        {if $feature.value == "Y"}
                            <i class="far active fa-check-circle"></i>
                        {else}
                            <i class="far inactive fa-times-circle"></i>
                        {/if}
                    </span>
                {elseif $feature.feature_type == "ProductFeatures::DATE"|enum}
                        {$feature.value_int|date_format:"`$settings.Appearance.date_format`"}
                {elseif $feature.feature_type == "ProductFeatures::MULTIPLE_CHECKBOX"|enum && $feature.variants}
                        <div class="amp-product-feature">
                        {foreach $feature.variants as $var}
                            {assign var="hide_variant_affix" value=!$hide_affix}
                            {if $var.selected}
                                <div class="amp-product-feature__multiple">
                                    <span class="amp-product-feature__multiple-item pr1" title="{$var.variant}">
                                        <i class="far active fa-check-circle"></i>
                                    </span>
                                    {if !$hide_variant_affix}
                                        <span class="amp-product-feature__prefix pr1">{$feature.prefix}</span>
                                    {/if}
                                    {$var.variant}
                                    {if !$hide_variant_affix}
                                        <span class="amp-product-feature__suffix pl1">{$feature.suffix}</span>
                                    {/if}
                                </div>
                            {/if}
                        {/foreach}
                        </div>
                {elseif in_array($feature.feature_type, ["ProductFeatures::TEXT_SELECTBOX"|enum, "ProductFeatures::EXTENDED"|enum, "ProductFeatures::NUMBER_SELECTBOX"|enum])}
                    {foreach $feature.variants as $var}
                        {if $var.selected}{$var.variant}{/if}
                    {/foreach}
                {elseif $feature.feature_type == "ProductFeatures::NUMBER_FIELD"|enum}
                    {$feature.value_int|floatval|default:"-"}
                {else}
                    {$feature.value|default:"-"}
                {/if}
                {if $feature.suffix && !$hide_affix}{$feature.suffix}{/if}
            </dd>
        {/if}
    {/foreach}
</dl>
{foreach $product_features as $feature}
    {if $feature.feature_type == "ProductFeatures::GROUP"|enum && $feature.subfeatures}
        <div class="amp-product-feature-group">
            <h5 class="h6">{$feature.description}</h5>

            {include file="components/product_features.tpl" product_features=$feature.subfeatures}
        </div>
    {/if}
{/foreach}
