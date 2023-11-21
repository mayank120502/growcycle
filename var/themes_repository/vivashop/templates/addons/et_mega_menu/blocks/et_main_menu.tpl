{** block-description:et_category_menu_vertical **}
{if empty($smarty.const.ET_DEVICE)}
  {et_get_device()}
{/if}
{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}

{function name="et_dropdown" data=$data level=$level childs=$childs link_name=$link_name separator=$separator}

{if $level==1}
<!-- LEVEL 1 -->
  {foreach from=$data item="item" name=this}
    {assign var="item_url" value=$item|fn_form_dropdown_object_link:"categories"}
    <li class="ty-menu__item cm-menu-item-responsive {if $item.$childs}dropdown-vertical__dir{/if}{if $item.active || $item|fn_check_is_active_menu_item:$block.type} 1ty-menu__item-active{/if} menu-level-{$level}{if $item.class} {$item.class}{/if} {if $smarty.foreach.this.first}first{/if} {if $smarty.foreach.this.index>=12}bottom{/if}" >
      {if $item.$childs}
        <div class="ty-menu__item-toggle hidden-desktop cm-responsive-menu-toggle">
          <i class="ty-menu__icon-open et-icon-circle-plus"></i>
          <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
        </div>
      {/if}

      <div class="ty-menu__submenu-item-header">
        {$et_menu_icon=$item.et_menu}
        {$et_menu=$item.et_menu}

        {* IMAGE *}
        {capture name="et_title_pre" assign="et_title_pre"}
          {if !empty($et_menu.icon) && $et_menu.icon.enabled=="Y" && $et_menu.icon.type=="G"}
            {if !empty($et_menu.icon.img) || !empty($et_menu.icon.img_hover)}
              <div class="et-menu-icon-wrapper">
                <div class="et-menu-icon-round">
            {/if}

              {if !empty($et_menu.icon.img_hover)}
                {include file="common/image.tpl" images=$et_menu.icon.img_hover  class="et-menu-icon et-menu-icon-hover " image_height=32 et_lazy_menu=true image_width=32}
              {/if}

              {if !empty($et_menu.icon.img)}
                {include file="common/image.tpl" images=$et_menu.icon.img et_lazy_menu=true class="et-menu-icon" image_height=32 image_width=32}
              {/if}

            {if !empty($et_menu.icon.img) || !empty($et_menu.icon.img_hover)}
                </div>
              </div>
            {/if}
          {/if}
        {/capture}
        
        {* ICON *}
        {capture name="et_title_icon" assign="et_title_icon"}{strip}
          {if !empty($et_menu.icon) && $et_menu.icon.enabled=="Y" && ($et_menu.icon.type=="I" || $et_menu.icon.type=="C")}
            {if $et_menu.icon.value}<i class="{$et_menu.icon.value} et_menu_icon et_menu_icon_{$et_menu.et_menu_id}"></i>{/if}
          {/if}
        {/strip}{/capture}
        
        {if !empty($et_menu.icon) && $et_menu.icon.enabled=="Y" && ($et_menu.icon.type=="I" || $et_menu.icon.type=="C") && $et_menu.icon.color_type|default:"S"=="C"} 
          <style>
            .et-category-menu .ty-menu>.ty-menu__items>li .et-menu-link-wrapper .et_menu_icon_{$et_menu.et_menu_id}{
              color: {$et_menu.icon.color};
            }
          </style>
        {/if}

        {* LABEL *}
        {capture name="et_title_label" assign="et_title_label"}{strip}
          {if isset($et_menu.text) && $et_menu.text.enabled=="Y" && $et_menu.text.enabled == "Y" && $et_menu.text.label}
            &nbsp;<span class="et_menu_label et_menu_text_{$et_menu.et_menu_id}"  {if $et_menu.text.color_type|default:"S" == "C"}style="color: {$et_menu.text.color};
              background: {$et_menu.text.bkg};"{/if}>{$et_menu.text.label}</span>
          {/if}
        {strip}{/capture}

        {* MINI DESCRIPTION *}
        {capture name="et_title_descr" assign="et_title_descr"}
          {if $et_menu.text.descr && ($smarty.const.ET_DEVICE == "D" || $et_traditional_resp)}
            <br/><span class="et-menu-text">{$et_menu.text.descr nofilter}</span>
          {/if}
        {/capture}

        <a {if $item_url}href="{$item_url}"{/if} class="ty-menu__item-link">
          {$et_title_pre nofilter}
          <div class="et-menu-link-wrapper">{strip}
            {if $et_title_icon|trim}{$et_title_icon nofilter}{/if}
            <div class="et-menu-link-inner-wrapper">
              <span class="et-menu-link">{$item.$link_name}</span>
              {if $et_title_label|trim}{$et_title_label nofilter}{/if}{$et_title_descr nofilter}
            </div>
          {/strip}</div>
          {if $item.$childs || $et_menu.products.enabled=="Y"}
            <span class="visible-desktop et-menu-arrow">
              {if $language_direction == 'rtl'}
                <i class="et-icon-arrow-left"></i>
              {else}
                <i class="et-icon-arrow-right"></i>
              {/if}
            </span>
          {/if}
        </a>

      </div>
      
      {if $item.$childs || $et_menu.products.enabled=="Y"}
        {et_dropdown data=$item.$childs childs=$childs level=2 link_name=$link_name}
      {/if}

    </li>
  {/foreach}
{elseif $level==2}
<!-- LEVEL 2 -->
  <div class="ty-menu__submenu level-2">
    {hook name="et_menu:side"}
    <ul class="ty-menu__submenu-items cm-responsive-menu-submenu">
      {foreach from=$data item="item"}
        {$item_url=$item|fn_form_dropdown_object_link:"categories"}
        {$et_menu=$item.et_menu}
        {$cat_thumbnail_size=45}

        {* LABEL *}
        {capture name="et_title_label" assign="et_title_label"}{strip}
          {if isset($et_menu.text) && $et_menu.text.enabled == "Y" && $et_menu.text.label}
            &nbsp;<span class="et_menu_label et_menu_text_{$et_menu.et_menu_id}"  style="color: {$et_menu.text.color};
              background: {$et_menu.text.bkg};">{$et_menu.text.label}</span>
          {/if}
        {/strip}{/capture}
        <li class="ty-top-mine__submenu-col">
          <a{if $item_url} href="{$item_url}"{/if} class="vs-sub-categ-img-link zzz" style="min-width: {$cat_thumbnail_size}px;">
             {include file="common/image.tpl" images=$et_menu.category_img.detailed image_width=$cat_thumbnail_size image_height=$cat_thumbnail_size et_lazy_menu=true}
          </a>
          <div class="et-menu-lev-2-inline-wrapper">
            <div class="ty-menu__submenu-item-header {if $item.$childs}et-has-child{/if} clearfix">
              <a{if $item_url} href="{$item_url}"{/if} class="ty-menu__submenu-link">{$item.category}{$et_title_label nofilter}</a>
            </div>
            {if $item.$childs}
              {et_dropdown data=$item.$childs childs=$childs level=3 show_more=$item.show_more show_more_link=$item_url link_name=$link_name separator="&nbsp;/&nbsp;"}123
            {/if}
          </div>
        </li>
      {/foreach}
    </ul>
    {/hook}

   </div>
{elseif $level==3}
<!-- LEVEL 3 -->
  <div class="ty-menu__submenu level-3">
    <ul class="ty-menu__submenu-list cm-responsive-menu-submenu">
      {foreach from=$data item="item" name="lev3"}
        {$item_url=$item|fn_form_dropdown_object_link:"categories"}
        {$et_menu=$item.et_menu}

        {* LABEL *}
        {capture name="et_title_label" assign="et_title_label"}{strip}
          {if isset($et_menu.text) && $et_menu.text.enabled == "Y" && $et_menu.text.label}
            &nbsp;<span class="et_menu_label et_menu_text_{$et_menu.et_menu_id}"  style="color: {$et_menu.text.color};
              background: {$et_menu.text.bkg};">{$et_menu.text.label}</span>
          {/if}
        {/strip}{/capture}
        {if !$smarty.foreach.lev3.first && $separator}
          <li class="ty-menu__submenu-item">
            {$separator nofilter}
          </li>
        {/if}

        <li class="ty-menu__submenu-item">
          <a{if $item_url} href="{$item_url}"{/if} class="ty-menu__submenu-link"><span>{$item.$link_name}</span>{$et_title_label nofilter}</a>
        </li>
      {/foreach}
      {if $show_more}
        <li class="ty-menu__submenu-item">
          {$separator nofilter}
        </li>
        <li class="ty-menu__submenu-item">
          <a{if $show_more_link} href="{$show_more_link}"{/if} class="ty-menu__submenu-link et-show-more-link">{__("view_more")}</a>
        </li>
      {/if}
    </ul>
  </div>
{/if}
{/function}

{if $et_traditional_resp==true}

  {$et_menu_capture="et_menu_`$block.block_id`"}
  {capture name="et_menu_`$block.block_id`"}
    <li class="ty-menu__item ty-menu__menu-btn visible-phone visible-tablet">
      <div class="ty-menu__item-toggle hidden-desktop cm-responsive-menu-toggle ty-menu__item-toggle-active">
        <i class="ty-menu__icon-open et-icon-circle-plus"></i>
        <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
      </div>
      <a class="ty-menu__item-link">
        <i class="ty-icon-short-list"></i>
        <span>{__("all_categories")}</span>
      </a>
    </li>
    {et_dropdown data=$items childs="subcategories" level=1 link_name="category"}
  {/capture}

  <div class="ty-menu visible-desktop">
    <ul id="vmenu_{$block.block_id}_desktop" class="ty-menu__items cm-responsive-menu{if $block.properties.right_to_left_orientation =="Y"} rtl{/if}">

      {$smarty.capture.$et_menu_capture nofilter}

    </ul>
  </div>
  <div class="et-category-menu hidden-desktop">
    <div class="ty-menu">
      <ul id="vmenu_{$block.block_id}_mobile" class="ty-menu__items cm-responsive-menu{if $block.properties.right_to_left_orientation =="Y"} rtl{/if}">


        {$smarty.capture.$et_menu_capture nofilter}

      </ul>
    </div>
  </div>

{else}
{if $smarty.const.ET_DEVICE != "D"}
{* NOT DESKTOP *}
<div class="et-category-menu">
{/if}
<div class="ty-menu">
  <ul id="vmenu_{$block.block_id}" class="ty-menu__items cm-responsive-menu{if $block.properties.right_to_left_orientation =="Y"} rtl{/if}">
    <li class="ty-menu__item ty-menu__menu-btn visible-phone visible-tablet">
      <div class="ty-menu__item-toggle hidden-desktop cm-responsive-menu-toggle ty-menu__item-toggle-active">
        <i class="ty-menu__icon-open et-icon-circle-plus"></i>
        <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
      </div>
      <a class="ty-menu__item-link">
        <i class="ty-icon-short-list"></i>
        <span>{__("all_categories")}</span>
      </a>
    </li>
    {et_dropdown data=$items childs="subcategories" level=1 link_name="category"}

  </ul>
</div>
{if $smarty.const.ET_DEVICE != "D"}
{* NOT DESKTOP *}
</div>
  {/if}
{/if}