{assign var="th_size" value=$thumbnails_size|default:120}
{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}

{if $product.main_pair.icon || $product.main_pair.detailed}
  {assign var="image_pair_var" value=$product.main_pair}
{elseif $product.option_image_pairs}
  {assign var="image_pair_var" value=$product.option_image_pairs|reset}
{/if}

{if $image_pair_var.image_id}
  {assign var="image_id" value=$image_pair_var.image_id}
{else}
  {assign var="image_id" value=$image_pair_var.detailed_id}    
{/if}

{if !$preview_id}
    {$preview_id = $product.product_id}
{/if}

{if !$et_columns}
  {$et_columns=1}
{/if}


{function name="et_gallery_horizontal"}

{$image_counter=0}
<div class="cm-image-gallery-wrapper et-product-thumbnails__gallery-horizontal">
  <div class="ty-product-thumbnails owl-carousel cm-image-gallery clearfix {if $language_direction == 'rtl'}is-rtl{/if}" id="images_preview_{$preview_id}" data-ca-items-count="3" data-ca-items-responsive="1">{strip}
    {if $image_pair_var}
      <div class="cm-item-gallery ty-float-left 1">
        <a data-ca-gallery-large-id="det_img_link_{$preview_id}_{$image_id}" class="cm-gallery-item cm-thumbnails-mini active ty-product-thumbnails__item" data-ca-image-order="{$image_counter}" data-ca-parent="#product_images_{$preview_id}"
        >
          {include file="common/image.tpl" images=$image_pair_var image_width=$th_size image_height=$th_size show_detailed_link=false obj_id="`$preview_id`_`$image_id`_mini"}
        </a>
      </div>
    {/if}
    {if $product.image_pairs}
      {foreach from=$product.image_pairs item="image_pair"}{strip}
        {$image_counter = $image_counter + 1}
        {if $image_pair}
          <div class="cm-item-gallery ty-float-left 2">
            {if $image_pair.image_id}
              {assign var="img_id" value=$image_pair.image_id}
            {else}
              {assign var="img_id" value=$image_pair.detailed_id}
            {/if}
            <a data-ca-gallery-large-id="det_img_link_{$preview_id}_{$img_id}" class="cm-gallery-item cm-thumbnails-mini ty-product-thumbnails__item" data-ca-image-order="{$image_counter}" data-ca-parent="#product_images_{$preview_id}"
            >
              {include file="common/image.tpl" images=$image_pair image_width=$th_size image_height=$th_size show_detailed_link=false obj_id="`$preview_id`_`$img_id`_mini"}
            </a>
          </div>
        {/if}
      {/strip}{/foreach}
    {/if}
  {/strip}</div>
</div>
{/function}

{function name="et_gallery_vertical" image_nr=$image_nr columns=$columns}

{$border=2}
{$spacing=10}
{$et_show_gallery=false}
{if $et_is_big_picture && $image_nr>=5}
  {$et_show_gallery=true}
{else if !$et_is_big_picture && $image_nr>=4}
  {$et_show_gallery=true}
{/if}

{if $et_show_gallery}
  <style>
    ul.jcarousel-skin{
      max-height: {$image_height}px;
    }
  </style>
  
  {if $smarty.const.ET_DEVICE == "D" || $et_traditional_resp}
    <div class="et-product-thumbnails-wrapper et-vertical 10 hidden-phone hidden-tablet" style="width: {$th_size+2+$spacing}px;">
      <ul class="product-thumbnails center jcarousel-skin cm-image-gallery ty-float-left clearfix et-product-thumbnails__gallery-vertical" id="images_preview_{$preview_id}" data-ca-items-count="{$columns}" data-et-items-width="{$th_size+$border}" data-et-items-height="{$th_size+$border}" data-et-items-margin-right="{$spacing}" data-et-items-margin-bottom="{$spacing}" data-et-items-show="{if $columns==1}{$et_thumb_nr}{else}8{/if}">
        {if $image_pair_var}
          <li class="cm-item-gallery">
            <a data-ca-gallery-large-id="det_img_link_{$preview_id}_{$image_id}" class="cm-gallery-item cm-thumbnails-mini active ty-product-thumbnails__item" style="width: {$th_size}px" data-ca-image-order="{$image_counter}" data-ca-parent="#product_images_{$preview_id}"
            >
              {include file="common/image.tpl" images=$image_pair_var image_width=$th_size image_height=$th_size show_detailed_link=false obj_id="`$preview_id`_`$image_id`_mini"}
            </a>
          </li>
          {if $product.image_pairs}
            {foreach from=$product.image_pairs item="image_pair" name=image}{strip}
              {$image_counter = $image_counter + 1}
              {if $image_pair}
                {if $image_pair.image_id}
                  {assign var="img_id" value=$image_pair.image_id}
                {else}
                  {assign var="img_id" value=$image_pair.detailed_id}
                {/if}
                
                <li class="cm-item-gallery clearfix">
                  <a data-ca-gallery-large-id="det_img_link_{$preview_id}_{$img_id}" class="cm-gallery-item cm-thumbnails-mini ty-product-thumbnails__item" data-ca-image-order="{$image_counter}" data-ca-parent="#product_images_{$preview_id}"
                  >
                  {include file="common/image.tpl" images=$image_pair image_width=$th_size image_height=$th_size show_detailed_link=false obj_id="`$preview_id`_`$img_id`_mini"}
                  </a>
                </li>
              {/if}
            {/strip}{/foreach}
          {/if}
        {/if}
      </ul>
    </div>
  {/if}
{else}
  <div class="cm-image-gallery-wrapper et-vertical clearfix hidden-phone hidden-tablet 4" style="width: {$th_size+2+$spacing}px">
    <div class="ty-product-thumbnails cm-image-gallery clearfix 6" id="images_preview_{$preview_id}" data-ca-items-count="6" data-ca-items-responsive="1">
      {if $image_pair_var}
        <div class="cm-item-gallery ty-float-left 5">
          <a data-ca-gallery-large-id="det_img_link_{$preview_id}_{$image_id}" class="cm-gallery-item cm-thumbnails-mini active ty-product-thumbnails__item" style="width: {$th_size}px" data-ca-image-order="{$image_counter}" data-ca-parent="#product_images_{$preview_id}"
          >
            {include file="common/image.tpl" images=$image_pair_var image_width=$th_size image_height=$th_size show_detailed_link=false obj_id="`$preview_id`_`$image_id`_mini"}
          </a>
        </div>
        {if $product.image_pairs}
          {foreach from=$product.image_pairs item="image_pair"}{strip}
            {$image_counter = $image_counter + 1}
            {if $image_pair}
              {if $image_pair.image_id}
                {assign var="img_id" value=$image_pair.image_id}
              {else}
                {assign var="img_id" value=$image_pair.detailed_id}
              {/if}
              <div class="cm-item-gallery ty-float-left 6">
                <a data-ca-gallery-large-id="det_img_link_{$preview_id}_{$img_id}" class="cm-gallery-item cm-thumbnails-mini ty-product-thumbnails__item" data-ca-image-order="{$image_counter}" data-ca-parent="#product_images_{$preview_id}"
                >
                {include file="common/image.tpl" images=$image_pair image_width=$th_size image_height=$th_size show_detailed_link=false obj_id="`$preview_id`_`$img_id`_mini"}
                </a>
              </div>
            {/if}
          {/strip}{/foreach}
        {/if}
      {/if}
    </div>
  </div>
{/if}
<div class="clearfix"></div>

{/function}

{$et_thumb_nr=$et_thumb_nr|default:4}
{if $settings.Appearance.thumbnails_gallery == "Y"}
  {$image_counter = 0}
  {if $et_vertical}
    {et_gallery_vertical image_nr=$product.image_pairs|count columns=$et_columns}
  {else}
    {et_gallery_horizontal}
  {/if}
{else}
  {$image_counter = 0}
  {et_gallery_vertical image_nr=$product.image_pairs|count columns=$et_columns}
{/if}
<style>
  .et-product-img-wrapper{
    max-width: {$image_width}px;
  }
</style>

<div class="et-product-img-wrapper">
  {if $et_show_product_labels}
    {assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
    {$smarty.capture.$product_labels nofilter}
  {/if}
  <div class="ty-product-img cm-preview-wrapper et-product-img" id="product_images_{$preview_id}">
    {include file="common/image.tpl" obj_id="`$preview_id`_`$image_id`" images=$image_pair_var link_class="cm-image-previewer" image_width=$image_width image_height=$image_height image_id="preview[product_images_`$preview_id`]"}
    {foreach from=$product.image_pairs item="image_pair"}
      {$image_counter = $image_counter + 1}
      {if $image_pair}
        {if $image_pair.image_id}
          {assign var="img_id" value=$image_pair.image_id}
        {else}
          {assign var="img_id" value=$image_pair.detailed_id}            
        {/if}
        {include file="common/image.tpl" images=$image_pair link_class="cm-image-previewer hidden" obj_id="`$preview_id`_`$img_id`" image_width=$image_width image_height=$image_height image_id="preview[product_images_`$preview_id`]"}
      {/if}
    {/foreach}
  </div>
</div>
<div class="hidden-desktop">
  {et_gallery_horizontal}
</div>

{include file="common/previewer.tpl"}
{if $et_vertical}
  {script src="design/themes/vivashop/js/et_product_image_gallery_vertical.js"}
{else}
  {script src="design/themes/vivashop/js/et_product_image_gallery.js"}
{/if}
{hook name="products:product_images"}{/hook}