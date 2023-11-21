<style>
  .et-vendor-menu .ty-menu__item a.ty-menu__item-link,
  .et-vendor-menu .ty-menu__item .ty-menu__item-toggle i,
  .et-vendor-store-menu .et-category-menu .ty-dropdown-box__title a,
  .et-vendor-store-menu .et-category-menu .ty-dropdown-box__title i{
    color: {$et_vs.color_menu|default:$et_default_colors.menu_text};
  }

  .et-phone-vendor-menu .et-category-menu .ty-menu__menu-btn{
    background: {$et_vs.bkg_menu_hover|default:$et_default_colors.menu_bkg_hover};
    color: {$et_vs.color_menu_hover|default:$et_default_colors.menu_text_hover};
  }

  .et-phone-vendor-menu .et-marketplace-menu-content .et-category-menu .ty-menu__menu-btn .ty-menu__item-link i,
  .et-phone-vendor-menu .et-marketplace-menu-content .et-category-menu .ty-menu__menu-btn .ty-menu__item-link span,
  .et-phone-vendor-menu .et-marketplace-menu-content .et-category-menu .ty-menu__menu-btn .ty-menu__item-toggle i{
    color: {$et_vs.color_menu_hover|default:$et_default_colors.menu_text_hover};
  }

</style>


{function name="store_submenu_mobile" data=$data level=$level}
{assign var=first value = $data|@key}
{if $level==1}
  <div class="ty-menu__submenu et-vendor-menu-level-1" id="et_vendor_menu{$et_vendor_info.company_id}{$page.page_id}">
    <ul class="ty-menu__submenu-items cm-responsive-menu-submenu">
      {foreach from=$data item="page" name=this}
        <li class="ty-top-mine__submenu-col">
          <a href="{"companies.page_view?page_id=`$page.page_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.page_view" && $smarty.request.page_id==$page.page_id}active{/if} et-vendor-menu-level-1_a">
            {$page.page}
          </a>
          {if $page.subpages}
            <div class="ty-menu__item-arrow hidden-phone hidden-tablet">
              <i class="ty-icon-right-open"></i>
            </div>
            {store_submenu_mobile data=$page.subpages level=2}
          {/if}
        </li>
      {/foreach}
    </ul>
  </div>
{elseif $level>1}
  <div class="ty-menu__submenu level-2">
    <ul class="ty-menu__submenu-list cm-responsive-menu-submenu">
      {foreach from=$data item="page" name=this}
        <li class="ty-menu__submenu-item ty-menu__submenu-item-active">
          <a href="{"companies.page_view?page_id=`$page.page_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.page_view" && $smarty.request.page_id==$page.page_id}active{/if} ty-menu__submenu-link et-vendor-menu-level-{$level}_a">
            {$page.page}
            {if $page.subpages}
              <span class="ty-menu__item-arrow hidden-phone hidden-tablet">
                <i class="et-icon-arrow-right"></i>
              </span>
            {/if}
          </a>
          {if $page.subpages}
            {store_submenu_mobile data=$page.subpages level=2}
          {/if}
        </li>
      {/foreach}
    </ul>
  </div>
{/if}
{/function}

{function name="et_dropdown_vendor" data=$data level=$level childs=$childs link_name=$link_name separator=$separator}

{if $level==1}
<!-- LEVEL 1 -->
  {foreach from=$data item="item" name=this}
    {$item.company_id=$et_vendor_info.company_id}
    {$item_url=$item|fn_form_dropdown_object_link:"vendor_categories"}
    {$et_menu=$item.et_menu}

    <li class="ty-menu__item cm-menu-item-responsive {if $item.$childs}dropdown-vertical__dir{/if}{if $item.active || $item|fn_check_is_active_menu_item:$block.type} ty-menu__item-active{/if} menu-level-{$level}{if $item.class} {$item.class}{/if} {if $smarty.foreach.this.first}first{/if} {if $smarty.foreach.this.index>=12}bottom{/if}" >

      {if $item.$childs}
        <div class="ty-menu__item-toggle hidden-desktop {* visible-phone *} cm-responsive-menu-toggle">
          <i class="ty-menu__icon-open et-icon-circle-plus"></i>
          <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
        </div>
      {/if}

      <div class="ty-menu__submenu-item-header">
        {* IMAGE *}
        {capture name="et_title_pre" assign="et_title_pre"}
          {if !empty($et_menu.icon) && $et_menu.icon.type=="G"}
            {if !empty($et_menu.icon.img) || !empty($et_menu.icon.img_hover)}
              <div class="et-menu-icon-wrapper">
                <div class="et-menu-icon-round">
            {/if}

              {if !empty($et_menu.icon.img_hover)}
                {include file="common/image.tpl" images=$et_menu.icon.img_hover vs_lazy_additional=false class="et-menu-icon et-menu-icon-hover " image_height=42 image_width=42}
              {/if}

              {if !empty($et_menu.icon.img)}
                {include file="common/image.tpl" images=$et_menu.icon.img vs_lazy_additional=false class="et-menu-icon" image_height=42 image_width=42}
              {/if}

            {if !empty($et_menu.icon.img) || !empty($et_menu.icon.img_hover)}
                </div>
              </div>
            {/if}
          {/if}
        {/capture}
        
        {* ICON *}
        {capture name="et_title_icon" assign="et_title_icon"}{strip}
          {if !empty($et_menu.icon) && ($et_menu.icon.type=="I" || $et_menu.icon.type=="C")}
            {if $et_menu.icon.value}<i class="{$et_menu.icon.value} et_menu_icon et_menu_icon_{$et_menu.et_menu_id}"></i>{/if}
          {/if}
        {/strip}{/capture}
        <style>
          {if !empty($et_menu.icon) && ($et_menu.icon.type=="I" || $et_menu.icon.type=="C")}
            .et-category-menu .et_menu_icon_{$et_menu.et_menu_id}{
              color: {$et_menu.icon.color};
            }
          {/if}
        </style>

        {* LABEL *}
        {$et_title_label=""}
        {capture name="et_title_label" assign="et_title_label"}
          {if isset($et_menu.text) && $et_menu.text.enabled == "Y" && $et_menu.text.label}
            <span class="et_menu_label et_menu_text_{$et_menu.et_menu_id}"  style="color: {$et_menu.text.color};
              background: {$et_menu.text.bkg};">{$et_menu.text.label}</span>
          {/if}
        {/capture}

        {* MINI DESCRIPTION *}
        {capture name="et_title_descr" assign="et_title_descr"}
          {if $et_menu.text.descr}
            <br/><span class="et-menu-text">{$et_menu.text.descr nofilter}</span>
          {/if}
        {/capture}
        <a {if $item_url} href="{$item_url}"{/if} class="ty-menu__item-link">
          {$et_title_pre nofilter}
          <div class="et-menu-link-wrapper">{$et_title_icon nofilter}<span class="et-menu-link">{$item.$link_name}</span>{$et_title_label nofilter}{$et_title_descr nofilter}
          </div>
          {if $item.$childs}
            <span class="visible-desktop et-menu-arrow">
              <i class="et-icon-arrow-right"></i>
            </span>
          {/if}
        </a>

      </div>
      
      {if $item.$childs}
        {et_dropdown_vendor data=$item.$childs childs=$childs level=2 link_name=$link_name}
      {/if}

    </li>
  {/foreach}
{elseif $level==2}
<!-- LEVEL 2 -->
  <div class="ty-menu__submenu level-2">
    <div class="ty-menu__submenu-items cm-responsive-menu-submenu  et-menu-{$level}-wrapper">
      <ul class="et-menu-{$level}">
        {foreach from=$data item="item"}
          {$item.company_id=$et_vendor_info.company_id}
          {$item_url=$item|fn_form_dropdown_object_link:"vendor_categories"}
          {$et_menu=$item.et_menu}
          {$cat_thumbnail_size=45}

          {* LABEL *}
          {$et_title_label=""}
          {capture name="et_title_label" assign="et_title_label"}
           {if isset($et_menu.text) && $et_menu.text.enabled == "Y" && $et_menu.text.label}
             <span class="et_menu_label et_menu_text_{$et_menu.et_menu_id}"  style="color: {$et_menu.text.color};
               background: {$et_menu.text.bkg};">{$et_menu.text.label}</span>
           {/if}
          {/capture}

          <li class="ty-top-mine__submenu-col">
            <a{if $item_url} href="{$item_url}"{/if} class="vs-sub-categ-img-link zzz" style="min-width: {$cat_thumbnail_size}px;">
               {include file="common/image.tpl" images=$et_menu.category_img.detailed image_width=$cat_thumbnail_size image_height=$cat_thumbnail_size vs_lazy_additional=true}
            </a>
            <div class="et-menu-lev-2-inline-wrapper">
              <div class="ty-menu__submenu-item-header {if $item.$childs}et-has-child{/if} clearfix">
                <a{if $item_url} href="{$item_url}"{/if} class="ty-menu__submenu-link">{$item.category}{$et_title_label nofilter}</a>
              </div>
              {if $item.$childs}
                {et_dropdown_vendor data=$item.$childs childs=$childs level=3 show_more=$item.show_more show_more_link=$item_url link_name=$link_name separator="/"}
              {/if}
            </div>
          </li>
        {/foreach}
      </ul>
    </div>
  </div>
{elseif $level==3}
<!-- LEVEL 3 -->
  <div class="ty-menu__submenu level-3">
    <ul class="ty-menu__submenu-list cm-responsive-menu-submenu">
      {foreach from=$data item="item" name="lev3"}
        {$item.company_id=$et_vendor_info.company_id}
        {$item_url=$item|fn_form_dropdown_object_link:"vendor_categories"}
        {$et_menu=$item.et_menu}

        {* LABEL *}
        {capture name="et_title_label" assign="et_title_label"}
          {if isset($et_menu.text) && $et_menu.text.enabled == "Y" && $et_menu.text.label}
            <span class="et_menu_label et_menu_text_{$et_menu.et_menu_id}"  style="color: {$et_menu.text.color};
              background: {$et_menu.text.bkg};">{$et_menu.text.label}</span>
          {/if}
        {/capture}
        <li class="ty-menu__submenu-item">
          {if !$smarty.foreach.lev3.first && $separator}{$separator}{/if}
          <a{if $item_url} href="{$item_url}"{/if} class="ty-menu__submenu-link"><span>{$item.$link_name}</span>{$et_title_label nofilter}</a>
        </li>
      {/foreach}
      {if $show_more}
        <li class="ty-menu__submenu-item">
          {$separator}&nbsp;<a{if $show_more_link} href="{$show_more_link}"{/if} class="ty-menu__submenu-link et-show-more-link">{__("view_more")}</a>
        </li>
      {/if}
    </ul>
  </div>
{/if}
{/function}

{function name="store_menu_mobile"}{strip}

{if $et_vendor_info.has_microstore}
<div class="et-marketplace-menu-content ty-sidebox__body visible-phone visible-tablet et-category-menu ">
  <div class="ty-menu"> 
    <ul id="vmenu_{$block.block_id}" class="ty-menu__items cm-responsive-menu{if $block.properties.right_to_left_orientation =="Y"} rtl{/if}">
      <li class="ty-menu__item ty-menu__menu-btn hidden-desktop">
        <div class="ty-menu__item-toggle hidden-desktop cm-responsive-menu-toggle ty-menu__item-toggle-active">
          <i class="ty-menu__icon-open et-icon-circle-plus"></i>
          <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
        </div>
        <a class="ty-menu__item-link">
          <i class="ty-icon-short-list"></i>
          <span>{__("categories")}</span>
        </a>
      </li>
      {foreach from=$menu_items item="item" key="key"}
        {$item.company_id=$et_vendor_info.company_id}
        {$item_url=$item|fn_form_dropdown_object_link:"vendor_categories"}
        {$et_menu=$item.et_menu}
        <li class="ty-menu__item cm-menu-item-responsive {if $item.subcategories}dropdown-vertical__dir{/if}">
          {if $item.subcategories}
            <div class="ty-menu__item-toggle hidden-desktop {* visible-phone *} cm-responsive-menu-toggle">
              <i class="ty-menu__icon-open et-icon-circle-plus"></i>
              <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
            </div>
          {/if}

          <div class="ty-menu__submenu-item-header">
            {* IMAGE *}
            {capture name="et_title_pre" assign="et_title_pre"}
              {if !empty($et_menu.icon) && $et_menu.icon.enabled=="Y" && $et_menu.icon.type=="G"}
                {if !empty($et_menu.icon.img) || !empty($et_menu.icon.img_hover)}
                  <div class="et-menu-icon-wrapper">
                    <div class="et-menu-icon-round">
                {/if}

                  {if !empty($et_menu.icon.img_hover)}
                    {include file="common/image.tpl" images=$et_menu.icon.img_hover vs_lazy_additional=false class="et-menu-icon et-menu-icon-hover " image_height=30 image_width=30}
                  {/if}

                  {if !empty($et_menu.icon.img)}
                    {include file="common/image.tpl" images=$et_menu.icon.img vs_lazy_additional=false class="et-menu-icon" image_height=30 image_width=30}
                  {/if}

                {if !empty($et_menu.icon.img) || !empty($et_menu.icon.img_hover)}
                    </div>
                  </div>
                {/if}
              {/if}
            {/capture}
            
            {* ICON *}
            {capture name="et_title_icon" assign="et_title_icon"}{strip}
              {if !empty($et_menu.icon) && $et_menu.icon.enabled=="Y" && (($et_menu.icon.type=="I" || $et_menu.icon.type=="C") || $et_menu.icon.type=="C")}
                {if $et_menu.icon.value}<i class="{$et_menu.icon.value|trim} et_menu_icon et_menu_icon_{$et_menu.et_menu_id}"></i>{/if}
              {/if}
            {/strip}{/capture}
            
            {if !empty($et_menu.icon) && $et_menu.icon.enabled=="Y" && (($et_menu.icon.type=="I" || $et_menu.icon.type=="C") || $et_menu.icon.type=="C")}
              <style>
                .et-vendor-store-menu .et-vendor-menu-pages .ty-menu__submenu-items .et_menu_icon_{$et_menu.et_menu_id}{
                  color: {$et_menu.icon.color};
                }
              </style>
            {/if}

            {$active_category=false}

            {if $item.subcategories}
              {foreach from=$item.subcategories item="item2"}
                {$categ_ids=explode("/",$item2.id_path)}
                {if in_array($smarty.request.category_id,$categ_ids)}
                  {$active_category=true}
                {/if}

                {if $item2.subcategories}
                  {foreach from=$item2.subcategories item="item3"}
                    {$categ_ids=explode("/",$item3.id_path)}
                    {if in_array($smarty.request.category_id,$categ_ids)}
                      {$active_category=true}
                    {/if}
                  {/foreach}
                {/if}
              {/foreach}
            {else}
              {$active_category=false}
            {/if}
            
            
            <a {if $item_url} href="{$item_url}"{/if} class="ty-menu__item-link {if $smarty.request.dispatch=="companies.products" && $smarty.request.category_id && ($smarty.request.category_id==$item.category_id || $active_category)}active{/if}">
              {$et_title_pre nofilter}
              <div class="et-menu-link-wrapper">{strip}
                {if $et_title_icon|trim}{$et_title_icon nofilter}{/if}
                <div class="et-menu-link-inner-wrapper"><span class="et-menu-link">{$item.category}</span></div>
              {/strip}</div>
              {if $item.subcategories}
                <span class="ty-menu__item-arrow hidden-phone hidden-tablet">
                  <i class="et-icon-arrow-right"></i>
                </span>
              {/if}
            </a>
          </div>
          <div class="ty-menu__submenu level-2">
            {if $item.subcategories}
              <div class="ty-menu__submenu-items cm-responsive-menu-submenu et-menu-2-wrapper">
                <ul class="et-menu-2">
                  {foreach from=$item.subcategories item="item2"}
                    {$item2.company_id=$et_vendor_info.company_id}
                    {$item2_url=$item2|fn_form_dropdown_object_link:"vendor_categories"}
                    <!-- level-2 -->
                    <li class="ty-top-mine__submenu-col {if $et_menu.thumbnails.enabled!="Y" || empty($item2.et_menu.category_img)}et-no-menu-icon{/if}">
                      {if $item2.subcategories}
                        <div class="ty-menu__item-toggle hidden-desktop cm-responsive-menu-toggle">
                          <i class="ty-menu__icon-open et-icon-circle-plus"></i>
                          <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
                        </div>
                      {/if}

                      {$active_category=false}

                      {if $item2.subcategories}
                        {foreach from=$item2.subcategories item="item3"}
                          {$categ_ids=explode("/",$item3.id_path)}
                          {$categ_ids.0=null}
                          {if in_array($smarty.request.category_id,$categ_ids)}
                            {$active_category=true}
                          {/if}
                        {/foreach}
                      {else}
                        {$active_category=false}
                      {/if}
                      <div class="ty-menu__submenu-item-header clearfix">
                        {$et_menu_this=$item2.et_menu}
                        {$cat_thumbnail_size=32}
                        <a{if $item2_url} href="{$item2_url}"{/if} class="et-sub-categ-img-link" style="min-width: {$cat_thumbnail_size}px;">
                          {if $et_menu.thumbnails.enabled=="Y" && !empty($et_menu_this.category_img)}
                            {include file="common/image.tpl" images=$et_menu_this.category_img.detailed image_width=$cat_thumbnail_size image_height=$cat_thumbnail_size vs_lazy_additional=true}
                          {/if}
                          {$item2.category}
                        </a>

                      </div>

                      {if $item2.subcategories}
                        <div class="ty-menu__submenu level-3">
                          <ul class="ty-menu__submenu-items cm-responsive-menu-submenu">
                            {foreach from=$item2.subcategories item="item3" name="i3"}
                              {$item3.company_id=$et_vendor_info.company_id}
                              {$item3_url=$item3|fn_form_dropdown_object_link:"vendor_categories"}
                              {$et_menu3=$item3.et_menu}
                              {$cat_thumbnail_size=32}
                              <li class="ty-top-mine__submenu-col">
                                <div class="ty-menu__submenu-item-header">
                                  <a{if $item3_url} href="{$item3_url}"{/if} class="et-categ-link et-sub-categ-img-link " style="min-width: {$cat_thumbnail_size}px;">
                                    {if $et_menu.thumbnails.enabled=="Y" && !empty($et_menu3.category_img)}
                                      {include file="common/image.tpl" images=$et_menu3.category_img.detailed image_width=$cat_thumbnail_size image_height=$cat_thumbnail_size vs_lazy_additional=true}
                                    {/if}
                                    {$item3.category}
                                  </a>
                                </div>
                              </li>
                            {/foreach}
                          </ul>
                        </div>
                      {/if}
                    </li>
                  {/foreach}
                </ul>
              </div>
            {/if}
          </div>
        </li>
      {/foreach}
    </ul>
  </div>
</div>
{/if}

<div class="et-main-menu">

<style>
  .et-vendor-store-menu-mobile .et-main-menu .ty-menu__items .ty-menu__item .ty-menu__item-link,
  .et-vendor-store-menu-mobile .et-main-menu .ty-menu__items .ty-menu__item .ty-menu__submenu-link,
  .et-vendor-store-menu-mobile .et-main-menu .cm-responsive-menu-toggle.ty-menu__item-toggle-active i{
    color: {$et_vs.color_menu|default:$et_default_colors.menu_text};
  }
</style>

<ul class="ty-menu__items cm-responsive-menu et-vendor-menu" style="background: {$et_vs.bkg_menu|default:$et_default_colors.menu_bkg};">

  {if $et_vendor_info.has_microstore}
      
    {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_new|default:"Y"=="Y"}
      <li class="ty-menu__item cm-menu-item-responsive">
        <a href="{"companies.newest?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.newest"}active{/if} ty-menu__item-link">
          <i class="et-icon-vendor-menu-new"></i>
          <span>{__("new_items")}</span>
        </a></li>
    {/if}

    {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_sale|default:"Y"=="Y"}
      <li class="ty-menu__item cm-menu-item-responsive">
        <a href="{"companies.on_sale?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.on_sale"}active{/if} ty-menu__item-link">
          <i class="et-icon-vendor-menu-sale"></i>
          <span>{__("on_sale")}</span>
        </a></li>
    {/if}

    {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_best|default:"Y"=="Y"}
      <li class="ty-menu__item cm-menu-item-responsive">
        <a href="{"companies.bestsellers?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.bestsellers"}active{/if} ty-menu__item-link">
          <i class="et-icon-vendor-menu-bestsellers"></i>
          <span>{__("bestsellers")}</span>
        </a></li>
    {/if}
  {/if}

  {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_about|default:"Y"=="Y"}
    <li class="ty-menu__item cm-menu-item-responsive">
      <a href="{"companies.description?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.description"}active{/if} ty-menu__item-link">
        <i class="et-icon-vendor-menu-about"></i>
        <span>{__("about_us")}</span>
    </a></li>
  {/if}
    
    {* Vendor pages *}
    {if $et_vendor_pages && $addons.et_vivashop_mv_functionality.et_mv_menu_setting_pages|default:"Y"=="Y"}
      <li class="ty-menu__item cm-menu-item-responsive dropdown-vertical__dir">
        <div class="ty-menu__item-toggle hidden-desktop cm-responsive-menu-toggle">
          <i class="ty-menu__icon-open et-icon-circle-plus"></i>
          <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
        </div>
        <a class="{if $smarty.request.dispatch=="companies.page_view"}active{/if} et-vendor-menu-item-vendor-pages ty-menu__item-link">
          <i class="et-icon-vendor-menu-pages2"></i>
          <span>{__("vendor_pages")}</span>
        </a>

        <div class="ty-menu__submenu level-2" id="et_vendor_menu{$et_vendor_info.company_id}{$page.page_id}">
            <ul class="ty-menu__submenu-items cm-responsive-menu-submenu">
              {foreach from=$et_vendor_pages item="page" key="key"}
                {if $page.subpages}
                  {$subpage_ids=array_keys($page.subpages)}
                  {if in_array($smarty.request.page_id,$subpage_ids)}
                    {$subpage_active=true}
                  {/if}
                {else}
                  {$subpage_active=false}
                {/if}
                <li class="ty-top-mine__submenu-col">

                  {if $page.subpages}
                    <div class="ty-menu__item-toggle hidden-desktop cm-responsive-menu-toggle">
                      <i class="ty-menu__icon-open et-icon-circle-plus"></i>
                      <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
                    </div>
                  {/if}

                  <div class="ty-menu__submenu-item-header">
                    <a href="{"companies.page_view?page_id=`$page.page_id`"|fn_url}" class="et-vendor-menu-level-1_a ty-menu__submenu-link {if $smarty.request.dispatch=="companies.page_view" && ($smarty.request.page_id==$page.page_id || $subpage_active)}active{/if}">
                      {$page.page}
                      {if $page.subpages}
                        <span class="ty-menu__item-arrow hidden-phone hidden-tablet">
                          <i class="et-icon-arrow-right"></i>
                        </span>
                      {/if}
                    </a>
                  </div>
                  
                  {if $page.subpages}
                    {store_submenu_mobile data=$page.subpages level=2}
                  {/if}
                </li>
              {/foreach}
            </ul>
        </div>
      </li>
    {/if}
    {* /Vendor pages *}

    {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_contact|default:"Y"=="Y"}
      <li class="ty-menu__item cm-menu-item-responsive">
        <a href="{"companies.contact?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.contact"}active{/if} ty-menu__item-link">
          <i class="et-icon-vendor-menu-contact"></i>
          <span>{__("contact")}</span>
        </a></li>
    {/if}
    
    {if $et_vendor_review.thread_id}
      <li class="ty-menu__item cm-menu-item-responsive">
        <a href="{"companies.discussion&thread_id=`$et_vendor_review.thread_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.discussion"}active{/if} ty-menu__item-link">
          <i class="et-icon-vendor-menu-reviews"></i>
          <span>{__('discussion_title_company')}</span>
        </a></li>
    {/if}
</ul>
</div>
{/strip}{/function}


{$obj_id="`$block.grid_id``$block.block_id`"}
<script>
(function(_, $) {

  var triggers=$('#et-menu-{$obj_id} .et-left-menu__trigger, #et-menu-{$obj_id} .et-menu__close-left, #et-menu-{$obj_id} .et-dim-content');
  var whichEvent = ('ontouch' in document.documentElement ? "touch" : "click");

  if(_.isTouch && window.navigator.msPointerEnabled) {
      whichEvent = 'click';
  }

  triggers.on(whichEvent, function(e) {
    var wrapper='.et-left-menu';

    $('body').toggleClass('noscroll-fixed');
    if ($('body').hasClass('et-left-menu-visible')){
      $('body').hasClass('et-left-menu-visible')
      setTimeout(function(){ 
        $('body').removeClass('et-left-menu-visible'); 
        if (isiPhone()) {
          iNoBounce.disable();
        }
      },300);
    }else{
      $('body').addClass('et-left-menu-visible');
      if (isiPhone()) {
        iNoBounce.enable();
      }

    }

    var content=$(this).parents(wrapper).find('.et-left-menu__content');
    content.toggleClass('et-left-menu-showing');
    if (content.hasClass('et-menu__showing')){
        setTimeout(function(){ 
          content.removeClass('et-menu__showing'); 
        },300);
      }else{
        content.addClass('et-menu__showing');
      }
    
    $(this).parents(wrapper).find('.et-dim-content').toggleClass('visible');

    return false;
  });
}(Tygh, Tygh.$));

</script>


<div class="et-marketplace-menu-content et-left-menu" id="et-menu-{$obj_id}">
  <a href="#" class="et-left-menu__trigger hidden-desktop mobile-sticky-menu-link" >
    <i class="ty-icon-short-list"></i>
  </a>

  <div class="et-left-menu__content {if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">

    <div class="et-menu__controls et-primary-bkg">
      <div class="et-menu__title">
        {__("et_vendor_menu")}
      </div>
      <div class="">
        <a href="#" class="et-menu__btn et-menu__close-left">
          <i class="et-icon-menu-close"></i>
        </a>
      </div>
    </div>
    
    <div class="et-marketplace-menu-content ty-sidebox__body visible-phone visible-tablet" id="1sidebox_{$block.block_id}">
      <div class="et-vendor-store-menu-wrapper">
        <div class="et-vendor-store-menu-mobile" >
          <div class="et-container">
            {store_menu_mobile}
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="et-dim-content"></div>
</div>
