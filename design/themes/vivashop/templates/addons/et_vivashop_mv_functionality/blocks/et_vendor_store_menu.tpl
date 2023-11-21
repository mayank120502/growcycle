<style>

    .et-vendor-store-menu .et-vendor-menu-item a, 
    .et-vendor-store-menu .et-category-menu .ty-dropdown-box__title a,
    .et-vendor-store-menu .et-category-menu .ty-dropdown-box__title i{
      color: {$et_vs.color_menu|default:$et_default_colors.menu_text};
    }

    .et-vendor-store-menu .et-vendor-menu-item:hover>a, 
    .et-vendor-store-menu .et-vendor-menu-item a.active, 
    .et-vendor-store-menu .et-vendor-menu-item i.active,
    .et-vendor-store-menu .et-vendor-menu-item i.active,
    .et-vendor-store-menu .et-menu-show-more:hover{
      background: {$et_vs.bkg_menu_hover|default:$et_default_colors.menu_bkg_hover};
      color: {$et_vs.color_menu_hover|default:$et_default_colors.menu_text_hover};
    }
    .et-vendor-store-menu .et-vendor-menu-pages .ty-menu__submenu-items .ty-top-mine__submenu-col:hover .et_menu_icon,
    .et-vendor-store-menu .et-vendor-menu-pages .ty-menu__submenu-items .ty-top-mine__submenu-col:hover .et-menu-link{
      color: #000;
    }

</style>


{function name="store_submenu" data=$data level=$level height_class=$height_class}
{assign var=first value = $data|@key}
{if $level==1}
  <div class="ty-menu__submenu et-vendor-menu-level-1" id="et_vendor_menu{$et_vendor_info.company_id}{$page.page_id}">
    <ul class="ty-menu__submenu-items cm-responsive-menu-submenu {$height_class}">
      {foreach from=$data item="page" name=this}
        <li class="ty-top-mine__submenu-col">
          <a href="{"companies.page_view?page_id=`$page.page_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.page_view" && $smarty.request.page_id==$page.page_id}active{/if} et-vendor-menu-level-1_a">
            {$page.page}
          </a>
          {if $page.subpages}
            <div class="ty-menu__item-arrow hidden-phone hidden-tablet">
              <i class="ty-icon-right-open"></i>
            </div>
            {store_submenu data=$page.subpages level=2}
          {/if}
        </li>
      {/foreach}
    </ul>
  </div>
{elseif $level>1}
  <div class="ty-menu__submenu et-vendor-menu-level-{$level}" id="et_vendor_menu{$et_vendor_info.company_id}{$page.page_id}">
    <ul class="ty-menu__submenu-items cm-responsive-menu-submenu {$height_class} et-vendor-menu-level-{$level}__ul">
      {foreach from=$data item="page" name=this}
        <li class="ty-top-mine__submenu-col">
          <a href="{"companies.page_view?page_id=`$page.page_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.page_view" && $smarty.request.page_id==$page.page_id}active{/if} et-vendor-menu-level-{$level}_a">
            {$page.page}
            {if $page.subpages}
              <span class="ty-menu__item-arrow hidden-phone hidden-tablet">
                {if $language_direction == 'rtl'}
                  <i class="et-icon-arrow-left"></i>
                {else}
                  <i class="et-icon-arrow-right"></i>
                {/if}
              </span>
            {/if}
          </a>
          {if $page.subpages}
            {store_submenu data=$page.subpages level=2 height_class=$height_class}
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
        <div class="ty-menu__item-toggle hidden-desktop cm-responsive-menu-toggle">
          <i class="ty-menu__icon-open ty-icon-down-open"></i>
          <i class="ty-menu__icon-hide ty-icon-up-open"></i>
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
              {if $language_direction == 'rtl'}
                <i class="et-icon-arrow-left"></i>
              {else}
                <i class="et-icon-arrow-right"></i>
              {/if}
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

{function name="store_menu"}{strip}
<ul class="ty-menu__items cm-responsive-menu et-vendor-menu">

  {*Store Home *}
  {if !$et_vendor_info.hide_home}
    <li class="et-vendor-menu-item ty-menu__items cm-menu-item-responsive">
      <a href="{"companies.view?company_id=`$et_vendor_info.company_id`"|fn_url}" class="et-vendor-menu-top-link {if $smarty.request.dispatch=="companies.view"}active{/if}">
        <i class="et-icon-vendor-menu-home"></i>
        <span>{__("home")}</span>
      </a></li>
  {/if}
  {* /Store Home *}

  {* Categories *}
  {if $et_vendor_info.has_microstore}
    <li class="et-vendor-menu-item ty-menu__items cm-menu-item-responsive et-vendor-menu-pages">
      <a class="ty-menu__item-toggle visible-phone cm-responsive-menu-toggle">
        <i class="ty-menu__icon-open ty-icon-down-open"></i>
        <i class="ty-menu__icon-hide ty-icon-up-open"></i>
      </a>
      <a href="{"companies.products?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.products" || $smarty.request.dispatch=="companies.product_view"}active{/if} et-vendor-menu-top-link">
        <i class="et-icon-vendor-menu-categories"></i>
        <span>{__("categories")}</span>
      </a>

      <div class="ty-menu__submenu et-vendor-menu-level-1" id="et_vendor_menu{$et_vendor_info.company_id}">
        {* count max items *}
        {$max_items=count($menu_items)}
        {foreach from=$menu_items item="item"}
          {if $item.subcategories}
            {if count($item.subcategories) > $max_items}
              {$max_items=count($item.subcategories)}
            {/if}

            {foreach from=$item.subcategories item="item2"}
              {if $item2.subcategories}
                {if count($item2.subcategories) > $max_items}
                  {$max_items=count($item2.subcategories)}
                {/if}
              {/if}
            {/foreach}
          {/if}
        {/foreach}

        {if $max_items>10}
          {$max_items=10}
        {/if}
        {* /count max items *}

        <ul class="ty-menu__submenu-items cm-responsive-menu-submenu et-vendor-menu-level-1__ul et_vendor_menu_height_{$max_items}">

          {foreach from=$menu_items item="item" key="key"}
            {$item.company_id=$et_vendor_info.company_id}
            {$item_url=$item|fn_form_dropdown_object_link:"vendor_categories"}
            {$et_menu=$item.et_menu}
            <li class="ty-top-mine__submenu-col">

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
                {if !empty($et_menu.icon) && $et_menu.icon.enabled=="Y" && ($et_menu.icon.type=="I" || $et_menu.icon.type=="C")}
                  {if $et_menu.icon.value}<i class="{$et_menu.icon.value|trim} et_menu_icon et_menu_icon_{$et_menu.et_menu_id}"></i>{/if}
                {/if}
              {/strip}{/capture}
              
              {if !empty($et_menu.icon) && $et_menu.icon.enabled=="Y" && ($et_menu.icon.type=="I" || $et_menu.icon.type=="C")}
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

              <a {if $item_url} href="{$item_url}"{/if} class="et-vendor-menu-level-1_a {if $smarty.request.dispatch=="companies.products" && $smarty.request.category_id && ($smarty.request.category_id==$item.category_id || $active_category)}active{/if}">
                {$et_title_pre nofilter}
                <div class="et-menu-link-wrapper">{strip}
                  {if $et_title_icon|trim}{$et_title_icon nofilter}{/if}
                  <div class="et-menu-link-inner-wrapper"><span class="et-menu-link">{$item.category}</span></div>
                {/strip}</div>
                {if $item.subcategories}
                  <span class="ty-menu__item-arrow hidden-phone hidden-tablet">
                    {if $language_direction == 'rtl'}
                      <i class="et-icon-arrow-left"></i>
                    {else}
                      <i class="et-icon-arrow-right"></i>
                    {/if}
                  </span>
                {/if}
              </a>

              {if $item.subcategories}
                <div class="ty-menu__submenu et-vendor-menu-level-2">
                  <ul class="ty-menu__submenu-items et-vendor-menu-level-2__ul cm-responsive-menu-submenu et_vendor_menu_height_{$max_items}">
                    {foreach from=$item.subcategories item="item2"}
                      {$item2.company_id=$et_vendor_info.company_id}
                      {$item2_url=$item2|fn_form_dropdown_object_link:"vendor_categories"}
                      <li class="ty-top-mine__submenu-col ">

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

                        <a {if $item2_url} href="{$item2_url}"{/if} class=" et-vendor-menu-level-2_a {if $smarty.request.dispatch=="companies.products" && $smarty.request.category_id && ($smarty.request.category_id==$item2.category_id || $active_category)}active{/if}">{strip}
                          {$item2.category}
                          {if $item2.subcategories}
                            <span class="ty-menu__item-arrow hidden-phone hidden-tablet">
                              {if $language_direction == 'rtl'}
                                <i class="et-icon-arrow-left"></i>
                              {else}
                                <i class="et-icon-arrow-right"></i>
                              {/if}
                            </span>
                          {/if}
                        {/strip}</a>

                        {if $item2.subcategories}
                          <div class="ty-menu__submenu et-vendor-menu-level-3">
                            <ul class="ty-menu__submenu-items cm-responsive-menu-submenu et_vendor_menu_height_{$max_items}">
                              {$show_more_3=false}
                              {foreach from=$item2.subcategories item="item3" name="i3"}
                                {if $smarty.foreach.i3.index <= 8}
                                  {$item3.company_id=$et_vendor_info.company_id}
                                  {$item3_url=$item3|fn_form_dropdown_object_link:"vendor_categories"}
                                  <li class="ty-top-mine__submenu-col">
                                    <a {if $item3_url} href="{$item3_url}"{/if} class="et-vendor-menu-level-3_a {if $smarty.request.dispatch=="companies.products" && $smarty.request.category_id && ($smarty.request.category_id==$item3.category_id)}active{/if}">
                                      {$item3.category}
                                    </a>
                                  </li>
                                {else}
                                  {$show_more_3=true}
                                {/if}
                              {/foreach}
                              {if $show_more_3}
                                <li class="ty-top-mine__submenu-col et-show-more-link">
                                  <a {if $item2_url} href="{$item2_url}"{/if} class=" et-vendor-menu-level-3_a">
                                    {__('view_more')}...
                                  </a>
                                </li>

                              {/if}
                            </ul>
                          </div>
                        {/if}
                      </li>
                    {/foreach}
                  </ul>
                </div>
              {/if}
            </li>
          {/foreach}
        </ul>
      </div>
    </li>
    
    {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_new|default:"Y"=="Y"}
      <li class="et-vendor-menu-item ty-menu__items cm-menu-item-responsive">
        <a href="{"companies.newest?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.newest"}active{/if} et-vendor-menu-top-link">
          <i class="et-icon-vendor-menu-new"></i>
          <span>{__("new_items")}</span>
        </a></li>
    {/if}

    {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_sale|default:"Y"=="Y"}
      <li class="et-vendor-menu-item ty-menu__items cm-menu-item-responsive">
        <a href="{"companies.on_sale?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.on_sale"}active{/if} et-vendor-menu-top-link">
          <i class="et-icon-vendor-menu-sale"></i>
          <span>{__("on_sale")}</span>
        </a></li>
    {/if}

    {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_best|default:"Y"=="Y"}
      <li class="et-vendor-menu-item ty-menu__items cm-menu-item-responsive">
        <a href="{"companies.bestsellers?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.bestsellers"}active{/if} et-vendor-menu-top-link">
          <i class="et-icon-vendor-menu-bestsellers"></i>
          <span>{__("bestsellers")}</span>
        </a></li>
    {/if}
  {/if}

  {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_about|default:"Y"=="Y"}
    <li class="et-vendor-menu-item ty-menu__items cm-menu-item-responsive">
      <a href="{"companies.description?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.description"}active{/if} et-vendor-menu-top-link">
        <i class="et-icon-vendor-menu-about"></i>
        <span>{__("about_us")}</span>
    </a></li>
  {/if}
    
  {* Vendor pages *}
  {if $et_vendor_pages && $addons.et_vivashop_mv_functionality.et_mv_menu_setting_pages|default:"Y"=="Y"}
    <li class="et-vendor-menu-item ty-menu__items cm-menu-item-responsive et-vendor-menu-pages">
      <a class="ty-menu__item-toggle visible-phone cm-responsive-menu-toggle">
        <i class="ty-menu__icon-open ty-icon-down-open"></i>
        <i class="ty-menu__icon-hide ty-icon-up-open"></i>
      </a>
      <a class="{if $smarty.request.dispatch=="companies.page_view"}active{/if} et-vendor-menu-item-vendor-pages et-vendor-menu-top-link">
        <i class="et-icon-vendor-menu-pages2"></i>
        <span>{__("vendor_pages")}</span>
      </a>

      <div class="ty-menu__submenu et-vendor-menu-level-1" id="et_vendor_menu{$et_vendor_info.company_id}{$page.page_id}">
        {* count max items *}
        {$max_items=count($et_vendor_pages)}
        {foreach from=$et_vendor_pages item="item"}
          {if $item.subpages}
            {if count($item.subpages) > $max_items}
              {$max_items=count($item.subpages)}
            {/if}

            {foreach from=$item.subpages item="item2"}
              {if $item2.subpages}
                {if count($item2.subpages) > $max_items}
                  {$max_items=count($item2.subpages)}
                {/if}
              {/if}
            {/foreach}
          {/if}
        {/foreach}

        {if $max_items>10}
          {$max_items=10}
        {/if}
        {$height_class="et_vendor_menu_height_`$max_items`"}
        {* /count max items *}

        <ul class="ty-menu__submenu-items cm-responsive-menu-submenu et-vendor-menu-level-1__ul {$height_class}">
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
              <a href="{"companies.page_view?page_id=`$page.page_id`"|fn_url}" class="et-vendor-menu-level-1_a {if $smarty.request.dispatch=="companies.page_view" && ($smarty.request.page_id==$page.page_id || $subpage_active)}active{/if}">
                {$page.page}
                {if $page.subpages}
                  <span class="ty-menu__item-arrow hidden-phone hidden-tablet">
                    {if $language_direction == 'rtl'}
                      <i class="et-icon-arrow-left"></i>
                    {else}
                      <i class="et-icon-arrow-right"></i>
                    {/if}
                  </span>
                {/if}
              </a>
              {if $page.subpages}
                {store_submenu data=$page.subpages level=2 height_class=$height_class}
              {/if}
            </li>
          {/foreach}
        </ul>
      </div>
    </li>
  {/if}
  {* /Vendor pages *}

  {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_contact|default:"Y"=="Y"}
    <li class="et-vendor-menu-item ty-menu__items cm-menu-item-responsive">
      <a href="{"companies.contact?company_id=`$et_vendor_info.company_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.contact"}active{/if} et-vendor-menu-top-link">
        <i class="et-icon-vendor-menu-contact"></i>
        <span>{__("contact")}</span>
      </a></li>
  {/if}

  {if $et_vendor_review.thread_id}
    <li class="et-vendor-menu-item ty-menu__items cm-menu-item-responsive">
      <a href="{"companies.discussion&thread_id=`$et_vendor_review.thread_id`"|fn_url}" class="{if $smarty.request.dispatch=="companies.discussion"}active{/if} et-vendor-menu-top-link">
        <i class="et-icon-vendor-menu-reviews"></i>
        <span>{__('discussion_title_company')}</span>
      </a></li>
  {/if}
</ul>
{/strip}{/function}


<div class="et-vendor-store-menu-wrapper">
  <div class="et-vendor-store-menu" style="background: {$et_vs.bkg_menu|default:$et_default_colors.menu_bkg};">
    <div class="et-container et-vendor-store-menu-inner overflow-hidden">
      {store_menu}
    </div>
  </div>
</div>


<script>
$(document).ready(function(){

  //vendor description cutoff
  var descr_wrapper=$('.et-vendor-description').outerHeight(true);
  var vendor_descr=$('.et-vendor-description > div');
  var vendor_descr_h=vendor_descr.outerHeight(true);
    
  if (descr_wrapper<vendor_descr_h){
    $(".et-vendor-description-btn,.et-vendor-description-fade").removeClass('hidden');
  }

  // sticky vendor menu
  var store_menu=$(".et-vendor-store-menu");
  var details_page=$("#companies_product_view");

  if (store_menu.length && details_page.length!=1){
    var store_menu_start=store_menu.offset().top;
    var store_menu_height=store_menu.outerHeight(true);
    var window_top = $(window).scrollTop();
    $('.et-vendor-store-menu-wrapper').css('height',store_menu_height);
    if (window_top > store_menu_start ) {
      store_menu.addClass('et_sticky et-sticky-visible');
    }

    $(window).resize(function(){
      setTimeout(function(){
        store_menu_start=$('.hidden-phone .et-vendor-store-menu-wrapper').offset().top;
        store_menu_height=store_menu.outerHeight(true);

        $('.et-vendor-store-menu-wrapper').css('height','auto');

        if (window_top <= store_menu_start ) {
          store_menu.removeClass('et_sticky et-sticky-visible');
        }
      },0);

    })

    $(window).scroll(function(){
      window_top = $(window).scrollTop();

      if (
        window_top >= store_menu_start && 
        !(store_menu.hasClass("et-sticky-visible"))
      ){
        store_menu.addClass('et_sticky et-sticky-visible');
        et_menu_resize($('.et-vendor-store-menu-inner'));
      
        /*css animation*/
        store_menu.addClass('et-animating');
        setTimeout(function(){
          store_menu.removeClass('et-animating');
        },500);
        /*end css animation*/
      }else if (
          window_top < store_menu_start && 
          store_menu.hasClass("et-sticky-visible")
        ){
        store_menu.removeClass('et_sticky et-sticky-visible');
        et_menu_resize($('.et-vendor-store-menu-inner'));
      }
    });
  }
});

</script>