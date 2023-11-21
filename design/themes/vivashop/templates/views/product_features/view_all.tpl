{if $variants}
{$size = 4}
{split data=$variants size=$size assign="splitted_filter" preverse_keys=true}
<div class="ty-features-all et-all-brands-wrapper">
{foreach from=$splitted_filter item="group"}
  {foreach from=$group item="ranges" key="index"}
  {strip}
  <div class="ty-features-all__group ty-column6">
      {if $ranges}
        {include file="common/subheader.tpl" title=$index}
        <ul class="ty-features-all__list">
        {foreach from=$ranges item="range"}
          <li class="ty-features-all__list-item">
            {$img=$range.variant_id|fn_get_image_pairs:'feature_variant':'V':true:true}
            <a href="{"product_features.view?variant_id=`$range.variant_id`"|fn_url}" class="ty-features-all__list-a">
              {if $img}
                  {include file="common/image.tpl"
                    show_detailed_link=false
                    images=$img
                    no_ids=true
                    image_id="category_image"
                    image_width="115"
                    image_height="80"
                    class="ty-block et-brand-page-img"}
              {/if}
              <span class="et-brand-page-name">{$range.variant|fn_text_placeholders}</span>
            </a></li>
        {/foreach}
      </ul>
      {else}&nbsp;{/if}
  </div>
  {strip}
  {/foreach}
{/foreach}
</div>
{/if}