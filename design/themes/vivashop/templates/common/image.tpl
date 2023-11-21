{strip}

{if $capture_image}
  {capture name="image"}
{/if}


{$image_data = $images|fn_image_to_display:$image_width:$image_height}
{$generate_image = $image_data.generate_image && !$external}
{$show_no_image = $show_no_image|default:true}
{$image_additional_attrs = $image_additional_attrs|default:[]}
{$image_link_additional_attrs = $image_link_additional_attrs|default:[]}

{if $image_data}
  {$image_additional_attrs["alt"] = $image_data.alt}
  {$image_additional_attrs["title"] = $image_data.alt}
  {$image_link_additional_attrs["title"] = $images.detailed.alt}
{/if}

{if !$obj_id}
    {if $image_data.image_path}
        {$obj_id = $image_data.image_path|crc32}
    {elseif $image_id}
        {$obj_id = $image_id|crc32}
    {else}
        {$obj_id = uniqid()}
    {/if}
{/if}

{hook name="common:image"}
{if $show_detailed_link}
  <a id="det_img_link_{$obj_id}" {if $image_data.detailed_image_path && $image_id}data-ca-image-id="{$image_id}"{/if} class="{$link_class} {if $image_data.detailed_image_path}cm-previewer ty-previewer{/if}" data-ca-image-width="{$images.detailed.image_x}" data-ca-image-height="{$images.detailed.image_y}" {if $image_data.detailed_image_path}href="{$image_data.detailed_image_path}" {$image_link_additional_attrs|render_tag_attrs nofilter}{/if}>
{/if}

{if $image_data.image_path}
  {** products:product_image_object is deprecated **}
  {hook name="products:product_image_object"}


    {$image_attributes = $image_additional_attrs|default:[]}
    {if $obj_id && !$no_ids}
        {$image_attributes.id = "det_img_{$obj_id}"}
    {/if}
    {if $image_data.width && !$image_attributes.width}
        {$image_attributes.width = $image_data.width}
    {/if}
    {if $image_data.height && !$image_attributes.height}
        {$image_attributes.height = $image_data.height}
    {/if}
    {if $generate_image}
        {$image_attributes["data-ca-image-path"] = $image_data.image_path}
    {/if}

    {if $image_onclick}
        {$image_attributes.onclick = $image_onclick}
    {/if}


    {if $et_lazy==true || $et_lazy_menu==true || $et_lazy_banner==true || $et_lazy_mobile==true || !empty($et_custom_lazy) || $et_lazy_owl==true}
      {$image_attributes.src ="./design/themes/vivashop/media/images/et-empty.png"}
      {if $generate_image}
        {$image_attributes["data-src"]="`$images_dir`/icons/spacer.gif"}
      {else}
        {$image_attributes["data-src"]=$image_data.image_path}
      {/if}
      {if $et_lazy_mobile==true||$et_lazy==true||$et_lazy_banner==true}
        {$placeholder_size=$image_data.height/$image_data.width*100}
        {$style="padding: 0 0 `$placeholder_size`%; width: `$image_data.width`px; height: 0 !important; opacity: 1;"}
        {$style=""}
      {/if}
    {else}
      {if $generate_image}
          {$image_initial_src = "{$images_dir}/icons/spacer.gif"}
      {else}
          {$image_initial_src = $image_data.image_path}
      {/if}

      {if $lazy_load}
          {$image_attributes["data-src"] = $image_initial_src}
      {else}
          {$image_attributes.src = $image_initial_src}
      {/if}
    {/if}

     <img class="ty-pict {$valign} {$class} {if $generate_image}ty-spinner{/if} {if $et_lazy_owl==true}lazyOwl{/if} {if !empty($et_custom_lazy)}{$et_custom_lazy}{/if} {if $et_lazy==true}etLazy{/if} {if $et_lazy_banner==true}etLazyBanner{/if} {if $et_lazy_menu==true}et_lazy_menu{/if} {if $et_lazy_mobile==true} et_lazy_mobile{/if} cm-image" {$image_attributes|render_tag_attrs nofilter}/>

    {if $et_lazy_menu==true || $et_lazy==true || $et_lazy_banner==true}
      <noscript>
        <img class="{$valign} {$class} {if $generate_image}spinner cm-generate-image{/if} cm-image" {if $et_style}style="{$et_style}"{/if} {if $generate_image}data-ca-image-path="{$image_data.image_path}"{/if} src="{if $generate_image}{$images_dir}/icons/spacer.gif{else}{$image_data.image_path}{/if}" width="{$image_data.width}" height="{$image_data.height}" {if $image_onclick}onclick="{$image_onclick}"{/if} {$image_additional_attrs|render_tag_attrs nofilter}/>
      </noscript>
    {/if}

    {if $show_detailed_link}
      <svg class="ty-pict__container" aria-hidden="true" width="{$image_data.width}" height="{$image_data.height}" viewBox="0 0 {$image_data.width} {$image_data.height}" style="max-height: 100%; max-width: 100%; position: absolute; top: 0; left: 50%; transform: translateX(-50%); z-index: -1;">
        <rect fill="transparent" width="{$image_data.width}" height="{$image_data.height}"></rect>
      </svg>
    {/if}
  {/hook}

{elseif $show_no_image}
    <span class="ty-no-image" style="max-height: {$image_height|default:$image_width}px; width: {$image_width|default:$image_height}px;"><img src="./design/themes/vivashop/media/images/et-empty.png" height="{$image_height|default:$image_width}" width="{$image_width|default:$image_height}" class="et-no-image" alt=""/>{include_ext file="common/icon.tpl" class="ty-icon-image ty-no-image__icon" title=__("no_image")}</span>
{/if}

{if $show_detailed_link}
  {if $images.detailed_id}
    <span class="ty-previewer__icon hidden-phone"></span>
  {/if}
</a>
{/if}
{/hook}

{if $capture_image}
  {/capture}
  {capture name="icon_image_path"}
    {$image_data.image_path}
  {/capture}
  {capture name="detailed_image_path"}
    {$image_data.detailed_image_path}
  {/capture}
{/if}

{/strip}