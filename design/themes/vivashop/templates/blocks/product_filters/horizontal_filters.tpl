{** block-description:horizontal_filters **}
{$show=false}
{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
{function name="current_filter"}{strip}
  {if $items}
    {if $block.type == "product_filters"}
      {$ajax_div_ids = "product_filters_*,selected_filters_*,products_search_*,category_products_*,currencies_*,languages_*,et_mobile_filters_count"}
      {$curl = $config.current_url}
    {else}
      {$curl = "products.search"|fn_url}
      {$ajax_div_ids = ""}
    {/if}
    {$filter_base_url = $curl|fn_query_remove:"result_ids":"full_render":"filter_id":"view_all":"req_range_id":"features_hash":"page":"total"}
    {$current_filters_count=0}
    {foreach from=$items item="filter" name="filters"}
      {if $filter.selected_variants}
        {$c=0}
        {if is_array($filter.selected_variants)}
          {$c=count($filter.selected_variants)}
        {/if}
        {$current_filters_count=$current_filters_count+$c}

        {$c=0}
        {if is_array($current_filters)}
          {$c=count($current_filters)}
        {/if}

        {$current_filters_key=$c}
        {$current_filters.$current_filters_key.filter_name=$filter.filter}
        {$current_filters.$current_filters_key.filter_id=$filter.filter_id}
        {$current_filters.$current_filters_key.selected_variants=$filter.selected_variants}
      {/if}

      {$active_tab=false}
      {if $smarty.request.feature_tab}
        {if $smarty.request.feature_tab==$filter.filter_id}
          {$active_tab=true}
        {/if}
      {elseif $smarty.foreach.filters.first}
        {$active_tab=true}
      {/if}

      {if $filter.selected_range}
        {$et_price_filter=true}
        {$et_price_info=$filter}
        {$current_filters_count=$current_filters_count+1}
      {/if}
     {/foreach}
  {/if}
  <div class="et-selected-product-filters ty-horizontal-product-filters cm-product-filters cm-horizontal-filters" data-ca-target-id="{$ajax_div_ids}" data-ca-tooltip-class="ty-product-filters__tooltip" data-ca-tooltip-right-class="ty-product-filters__tooltip--right" data-ca-tooltip-mobile-class="ty-tooltip--mobile" data-ca-tooltip-layout-selector="[data-ca-tooltip-layout='true']" data-ce-tooltip-events-tooltip="mouseenter" data-ca-base-url="{$filter_base_url|fn_url}" id="product_filters_{$block.block_id}_selected">
    {if $current_filters_count>0}
      <div class="ty-product-filters__wrapper et-product-filters__wrapper">
        <div class="et-hf-selected__wrapper clearfix">
          <div class="et-hf-selected clearfix">
            <div class="et_horiz_filter_buttons">
              <span class="et-hf-selected__title hidden">
                <i class="et-icon-selected-filters"></i>
                <span class="hidden-phone">{__("et_horziontal_filters_selected")}<span class="et-hf-selected__count">({$current_filters_count})</span>:</span>
              </span>
            
              <div class="et-hf-selected__filter-outer-wrapper">
                {* Price selected *}
                {if $et_price_filter}
                  {$reset_url = ""}
                  {if $et_price_info.selected_variants || $et_price_info.selected_range}
              
                    {$reset_url = $filter_base_url}
                    {$fh = $smarty.request.features_hash|fn_delete_filter_from_hash:$et_price_info.filter_id}
              
                    {if $fh}
                      {$reset_url = $filter_base_url|fn_link_attach:"features_hash=$fh"}
                    {/if}
                  {/if}
                  <div class="et-hf-selected__filter_wrapper">
                    <a class="et_horiz_checkbox ty-btn ty-btn__primary cm-ajax cm-ajax-full-render cm-history" 
                      href="{$reset_url|fn_url}" 
                      data-ca-event="ce.filtersinit" 
                      data-ca-target-id="{$ajax_div_ids}"><i class="far fa-times-circle hidden"></i>{$et_price_info.filter|fn_text_placeholders} {if $et_price_info.et_item_count}<span class="et-hf-variant__count">({$et_price_info.et_item_count})</span>{/if}</a><a href="{$reset_url|fn_url}" 
                      data-ca-event="ce.filtersinit" 
                      data-ca-target-id="{$ajax_div_ids}" class="et-hf-variant__clear-wrapper cm-ajax cm-ajax-full-render cm-history" ><i class="et-icon-menu-close"></i></a>
                  </div>
                {/if}
                {* /Price selected *}
              
                <script>
                  function et_clear_filter(id){
                    var click_id=id;
                    sidebox_filter=$(".et-sidebar-filter-id");
                    sidebox_id=sidebox_filter.data('etSideboxId');
                    click_id="#elm_checkbox_"+sidebox_id+"_"+click_id;
                    $(click_id).click();

                  };
                </script>

                {foreach from=$current_filters item=filter key=key name=name}{strip}
                      {foreach from=$filter.selected_variants item=variant key=key name=name}
                        <div class="et-hf-selected__filter_wrapper">
                          <span class="et_horiz_checkbox ty-btn ty-btn__primary" onclick="et_clear_filter('{$filter.filter_id}_{$variant.variant_id}');"><i class="far fa-times-circle hidden"></i><strong>{$filter.filter_name}</strong>:&nbsp;{$filter.prefix}{$variant.variant|fn_text_placeholders}{$filter.suffix} {if $variant.et_item_count}<span class="et-hf-variant__count">({$variant.et_item_count})</span>{/if}</span><span class="et-hf-variant__clear-wrapper" onclick="et_clear_filter('{$filter.filter_id}_{$variant.variant_id}');"><i class="et-icon-menu-close"></i></span>
                        </div>
                    {/foreach}
                {/strip}{/foreach}
                <div class="et-hf-selected__filter-clear">
                  {$et_base_url=$filter_base_url|fn_query_remove:"feature_tab"}
                  <a href="{$filter_base_url}" 
                    id="et_clear_horizontal_filters"
                    class="cm-ajax cm-ajax-full-render cm-history ty-btn ty-btn__tertiary" 
                    onclick="$(this).attr('href','{$et_base_url}');"
                    data-ca-event="ce.filtersinit" 
                    data-ca-target-id="product_filters_*,products_search_*,category_products_*,product_features_*,breadcrumbs_*,currencies_*,languages_*,selected_filters_*,et_mobile_filters_count">{__("et_horziontal_filters_clear")}</a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    {/if}
  <!--product_filters_{$block.block_id}_selected--></div>
  <div data-ca-tooltip-layout="true" class="hidden">
      <button type="button" class="cm-scroll ty-tooltip--link ty-tooltip--filter"><span class="tooltip-arrow"></span></button>
  </div>
{strip}{/function}

{if $smarty.request.dispatch=="companies.products"}
  {if $et_vs.data.filters}
    {if $et_vs.data.filters!="vertical"}
      {$show=true}
    {/if}
  {elseif $addons.et_vivashop_mv_functionality.et_vendor_filters!="vertical"}
    {$show=true}
  {/if}
{elseif $addons.et_vivashop_settings.et_viva_filters!="vertical"}
  {$show=true}
{/if}

{if $show}
  {script src="design/themes/vivashop/js/et_product_filters.js"}
  {script src="js/tygh/tabs.js"}

  {if $block.type == "product_filters"}
    {$ajax_div_ids = "product_filters_*,selected_filters_*,products_search_*,category_products_*,currencies_*,languages_*,et_mobile_filters_count,product_features_*"}
    {$curl = $config.current_url}
  {else}
    {$curl = "products.search"|fn_url}
    {$ajax_div_ids = ""}
  {/if}

  {$filter_base_url = $curl|fn_query_remove:"result_ids":"full_render":"filter_id":"view_all":"req_range_id":"features_hash":"page":"total"}
  <div class="et-horizontal-product-filters ty-horizontal-product-filters cm-product-filters cm-horizontal-filters clearfix" data-ca-target-id="{$ajax_div_ids}"  data-ca-tooltip-class="ty-product-filters__tooltip" data-ca-tooltip-right-class="ty-product-filters__tooltip--right" data-ca-tooltip-mobile-class="ty-tooltip--mobile" data-ca-tooltip-layout-selector="[data-ca-tooltip-layout='true']" data-ce-tooltip-events-tooltip="mouseenter" data-ca-base-url="{$filter_base_url|fn_url}" id="product_filters_{$block.block_id}">
    <div class="ty-product-filters__wrapper et-product-filters__wrapper">
      {if $items}

        {capture name="tabs_title" assign="tabs_title"}
          {$current_filters_count=0}

          {foreach from=$items item="filter" name="filters"}
            {$id="et-filters-tab-`$smarty.foreach.filters.index`"}

            {if $filter.selected_variants}
              {$c=0}
              {if is_array($filter.selected_variants)}
                {$c=count($filter.selected_variants)}
              {/if}
              {$current_filters_count=$current_filters_count+$c}

              {$c=0}
              {if is_array($current_filters)}
                {$c=count($current_filters)}
              {/if}

              {$current_filters_key=$c}
              {$current_filters.$current_filters_key.filter_name=$filter.filter}
              {$current_filters.$current_filters_key.filter_id=$filter.filter_id}
              {$current_filters.$current_filters_key.selected_variants=$filter.selected_variants}
            {/if}

            {$active_tab=false}
            {if $smarty.request.feature_tab}
              {if $smarty.request.feature_tab==$filter.filter_id}
                {$active_tab=true}
              {/if}
            {elseif $smarty.foreach.filters.first}
              {$active_tab=true}
            {/if}

            {if $filter.selected_range}
              {$et_price_filter=true}
              {$et_price_info=$filter}
              {$current_filters_count=$current_filters_count+1}
            {/if}

            <li id="{$id}" class="cm-js ty-tabs__item et-filter-tab {if $active_tab}active{/if}{if $tab.hidden == "Y"} hidden{/if}{if $tab.js} cm-js{elseif $tab.ajax} cm-js cm-ajax{if $tab.ajax_onclick} cm-ajax-onclick{/if}{/if}{if $tab.properties} extra-tab{/if}" data-et-id="{$filter.filter_id}">
                <div class="ty-tabs__a"><bdi>{$filter.filter}{if $filter.selected_variants} ({$filter.selected_variants|sizeof}){/if}
                </bdi></div>
            </li>
          {/foreach}
        {/capture}

        {capture name="tabs_content" assign="tabs_content"}
          <div class="et-hf-tabs__content">
            {foreach from=$items item="filter" name="filters"}
              {$id="content_et-filters-tab-`$smarty.foreach.filters.index`"}
              {$filter_uid = "`$block.block_id`_`$filter.filter_id`"}

              {$reset_url = ""}
              {if $filter.selected_variants || $filter.selected_range}
                {$reset_url = $filter_base_url}
                {$fh = $smarty.request.features_hash|fn_delete_filter_from_hash:$filter.filter_id}
                {if $fh}
                  {$reset_url = $filter_base_url|fn_link_attach:"features_hash=$fh"}
                {/if}
                {$reset_url = $reset_url|fn_link_attach:"feature_tab=`$filter.filter_id`"}
              {/if}

              {$active_tab=false}
              {if $smarty.request.feature_tab}
                {if $smarty.request.feature_tab==$filter.filter_id}
                  {$active_tab=true}
                {/if}
              {elseif $smarty.foreach.filters.first}
                {$active_tab=true}
              {/if}
                

              <div id="{$id}" class="{$id} et-tab-content {if !$active_tab}hidden{/if}">
                {hook name="blocks:product_filters_variants_element"}
                  {if $filter.slider}
                    {if $filter.feature_type == "ProductFeatures::DATE"|enum}
                      {include file="blocks/product_filters/components/product_filter_datepicker.tpl" filter_uid=$filter_uid filter=$filter}
                    {else}
                      {include file="blocks/product_filters/components/product_filter_slider.tpl" filter_uid=$filter_uid filter=$filter}
                    {/if}
                  {else}
                    {include file="blocks/product_filters/components/product_filter_variants.tpl" filter_uid=$filter_uid filter=$filter  et_horiz_filters=true}
                  {/if}
                {/hook}
              </div>
            {/foreach}
          </div>
        {/capture}

        <div class="et-hf-tabs__outer-wrapper">
          <div class="et-hf-tabs__wrapper ty-tabs cm-j-tabs cm-j-tabs-disable-convertation {if $track} cm-track{/if}">
            <div class="et-horizontal-filter__title">
              <i class="et-icon-mobile-filter"></i>
              <span class="hidden-phone">{__('filters')}</span>
            </div>
            <ul class="ty-tabs__list clearfix">
              {$tabs_title nofilter}
            </ul>
          </div>
        </div>

        <div class="et-hf-tabs__content-wrapper cm-tabs-content ty-tabs__content clearfix" id="tabs_content">
          {$tabs_content nofilter}
        </div>

        {if $current_filters_count}
          <div class="et-hf-selected__wrapper clearfix">
            <div class="et-hf-selected clearfix">
              <div class="et_horiz_filter_buttons">
                <span class="et-hf-selected__title hidden">
                  <i class="et-icon-selected-filters"></i>
                  
                  <span class="hidden-phone">{__("et_horziontal_filters_selected")} <span class="et-hf-selected__count">({$current_filters_count})</span>:</span>
                </span>
              
                <div class="et-hf-selected__filter-outer-wrapper">
                  {* Price selected *}
                  {if $et_price_filter}
                    {$reset_url = ""}
                    {if $et_price_info.selected_variants || $et_price_info.selected_range}
                
                      {$reset_url = $filter_base_url}
                      {$fh = $smarty.request.features_hash|fn_delete_filter_from_hash:$et_price_info.filter_id}
                
                      {if $fh}
                        {$reset_url = $filter_base_url|fn_link_attach:"features_hash=$fh"}
                      {/if}
                    {/if}
                    <div class="et-hf-selected__filter_wrapper">
                      <a class="et_horiz_checkbox ty-btn ty-btn__primary cm-ajax cm-ajax-full-render cm-history" 
                        href="{$reset_url|fn_url}" 
                        data-ca-event="ce.filtersinit" 
                        data-ca-target-id="{$ajax_div_ids}"><i class="far fa-times-circle hidden"></i>{$et_price_info.filter|fn_text_placeholders} {if $et_price_info.et_item_count}<span class="et-hf-variant__count">({$et_price_info.et_item_count})</span>{/if}</a><a href="{$reset_url|fn_url}" 
                        data-ca-event="ce.filtersinit" 
                        data-ca-target-id="{$ajax_div_ids}" class="et-hf-variant__clear-wrapper cm-ajax cm-ajax-full-render cm-history" ><i class="et-icon-menu-close"></i></a>
                    </div>
                  {/if}
                  {* /Price selected *}
                
                  {foreach from=$current_filters item=filter key=key name=name}{strip}
                        {foreach from=$filter.selected_variants item=variant key=key name=name}
                          <div class="et-hf-selected__filter_wrapper">
                            <span class="et_horiz_checkbox ty-btn ty-btn__primary" onclick="$('#elm_checkbox_{$block.block_id}_{$filter.filter_id}_{$variant.variant_id}').click(); return false"><i class="far fa-times-circle hidden"></i><strong>{$filter.filter_name}</strong>:&nbsp;{$filter.prefix}{$variant.variant|fn_text_placeholders}{$filter.suffix} {if $variant.et_item_count}<span class="et-hf-variant__count">({$variant.et_item_count})</span>{/if}</span><span class="et-hf-variant__clear-wrapper" onclick="$('#elm_checkbox_{$block.block_id}_{$filter.filter_id}_{$variant.variant_id}').click(); return false"><i class="et-icon-menu-close"></i></span>
                          </div>
                      {/foreach}
                  {/strip}{/foreach}
                  <div class="et-hf-selected__filter-clear">
                    {$et_base_url=$filter_base_url|fn_query_remove:"feature_tab"}
                    <a href="{$filter_base_url}" 
                      id="et_clear_horizontal_filters"
                      class="cm-ajax cm-ajax-full-render cm-history ty-btn ty-btn__tertiary" 
                      onclick="$(this).attr('href','{$et_base_url}&feature_tab='+$('.et-filter-tab.active').data('etId'));"
                      data-ca-event="ce.filtersinit" 
                      data-ca-target-id="product_filters_*,products_search_*,category_products_*,product_features_*,breadcrumbs_*,currencies_*,languages_*,selected_filters_*,et_mobile_filters_count">{__("et_horziontal_filters_clear")}</a>
                  </div>
                </div>
              </div>

            </div>
          </div>
        {/if}
      {/if}
    </div>
  <!--product_filters_{$block.block_id}--></div>
  <div data-ca-tooltip-layout="true" class="hidden">
      <button type="button" class="cm-scroll ty-tooltip--link ty-tooltip--filter"><span class="tooltip-arrow"></span></button>
  </div>

  <script>
    (function(_, $) {
      var windowWidth = window.innerWidth || document.documentElement.clientWidth;
      {if $et_traditional_resp}
        $(window).resize(function(){
          var windowWidth = window.innerWidth || document.documentElement.clientWidth;
          if (windowWidth<1025){
            var et_footer=$(".et-mobile-footer-wrapper");
            if (et_footer.length>=1){
              footer_offset=et_footer.offset().top-$(window).height()+46;
            }else{
              footer_offset=$(".tygh-footer").offset().top-$(window).height()+46;
            }

            category_content_offset=$(".et-category-content").offset().top-60;
            $(window).scroll(function(){
              if ( $(window).scrollTop() > category_content_offset && $(window).scrollTop() <= footer_offset ){
                $(".et-mobile-filter-button").show();
              }else if ( $(window).scrollTop() <= category_content_offset || $(window).scrollTop() >= footer_offset ){
                $(".et-mobile-filter-button").hide();
              }else{
                $(".et-mobile-filter-button").show();
              }
            });

            $(".et-mobile-filter-button").click(function(e){
              $('html, body').animate({
                scrollTop: $('.et-horizontal-product-filters').offset().top-50
              },500)
              e.preventDefault();
            });
          }
        });
      {else}
        if (windowWidth<1025){
          var et_footer=$(".et-mobile-footer-wrapper");
          if (et_footer.length>=1){
            footer_offset=et_footer.offset().top-$(window).height()+46;
          }else{
            footer_offset=$(".tygh-footer").offset().top-$(window).height()+46;
          }

          category_content_offset=$(".et-category-content").offset().top-60;
          $(window).scroll(function(){
            if ( $(window).scrollTop() > category_content_offset && $(window).scrollTop() <= footer_offset ){
              $(".et-mobile-filter-button").show();
            }else if ( $(window).scrollTop() <= category_content_offset || $(window).scrollTop() >= footer_offset ){
              $(".et-mobile-filter-button").hide();
            }else{
              $(".et-mobile-filter-button").show();
            }
          });

          $(".et-mobile-filter-button").click(function(e){
            $('html, body').animate({
              scrollTop: $('.et-horizontal-product-filters').offset().top-50
            },500)
            e.preventDefault();
          });
        }
      {/if}
    }(Tygh, Tygh.$));
  </script>
  <div class="et-mobile-filter-button" id="et_mobile_filters_count">
    <a href="#" class="et-right-menu__trigger hidden-desktop mobile-sticky-menu-link" >
      <i class="et-icon-mobile-filter"></i>
      {if $current_filters_count>0}
      <span class="et-mobile-filters-count hidden1">{$current_filters_count}</span>
      {/if}
    </a>
  <!--et_mobile_filters_count--></div>
{else}
  <div class="">
    {current_filter}
  </div>
{/if}