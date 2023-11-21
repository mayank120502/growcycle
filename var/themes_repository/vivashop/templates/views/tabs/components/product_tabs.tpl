{assign var="product_details_in_tab" value=$product_details_in_tab|default:$settings.Appearance.product_details_in_tab}

{capture name="tabsbox"}
{if $product_details_in_tab == "N"}
  <div class="et-sticky-tabs-wrapper">
    <div class="et-sticky-content">
      {if $addons.product_bundles.status == "A" && $et_has_bundles}
        <a class="et-sticky-tab cm-external-click et-sticky-product_bundles" data-et-tab="product_bundles">{__("product_bundles.product_bundles")}</a>
      {/if}
      {foreach from=$tabs item="tab" key="tab_id"}
        {if $tab.show_in_popup != "Y" && $tab.status=='A'}
          {assign var="et_tab_content_capture" value="et_tab_content_capture_`$tab_id`"}
          {capture name=$et_tab_content_capture}
            {if $tab.tab_type == 'B'}
              {if $tab.addon!='master_products'}
                {render_block block_id=$tab.block_id dispatch="products.view" use_cache=false parse_js=false}
              {/if}
            {elseif $tab.tab_type == 'T'}
              {include file=$tab.template product_tab_id=$tab.html_id et_tab_type=$tab.et_tab_type}
            {/if}
          {/capture}

          {if $smarty.capture.$et_tab_content_capture|trim}
            {if $product_details_in_tab == "N"}
              {if empty($tab.html_id)}
                {* {print_r($tab,true)} *}
              {/if}
              <a class="et-sticky-tab cm-external-click et-sticky-{$tab.html_id}" data-et-tab="{$tab.html_id}">{$tab.name}</a>
            {/if}
          {/if}
        {/if}
      {/foreach}

    </div>
  </div>

  <div class="et-product-tabs">
    {foreach from=$tabs item="tab" key="tab_id"}
      {if $tab.show_in_popup != "Y" && $tab.status == "A"}
        {assign var="tab_content_capture" value="tab_content_capture_`$tab_id`"}
        {capture name=$tab_content_capture}
          {if $tab.addon=='buy_together' && $product_details_in_tab == "Y"}
            {$et_buy_together=['template'=>$tab.template,'product_tab_id'=>$tab.html_id,'name'=>$tab.name]}
          {else}
            {if $tab.tab_type == 'B'}
              {if $tab.addon!='master_products'}
                {render_block block_id=$tab.block_id dispatch="products.view" use_cache=false parse_js=false}
              {/if}                
            {elseif $tab.tab_type == 'T'}
              {include file=$tab.template product_tab_id=$tab.html_id et_tab_type=$tab.et_tab_type}
            {/if}
          {/if}
        {/capture}

        {if $smarty.capture.$tab_content_capture|trim}
          <div id="et-tab-{$tab.html_id}" class="et-product-page-tab-wrapper clearfix">
            {if $product_details_in_tab == "N"}{strip}
              <h3 class="tab-list-title" id="{$tab.html_id}">
                <span id="{$tab.html_id}_offset" class="et_tab_offset"></span>
                <span id="external_{$tab.html_id}_offset" class="et_tab_external_offset"></span>
                {$tab.name}
              </h3>
            {/strip}{/if}
            <div id="content_{$tab.html_id}" class="ty-wysiwyg-content content-{$tab.html_id} et-tab-content">
              {$smarty.capture.$tab_content_capture nofilter}
            </div>
          </div>
        {/if}

      {/if}
    {/foreach}
  </div>

{else}
  {foreach from=$tabs item="tab" key="tab_id"}
      {if $tab.show_in_popup != "Y" && $tab.status == "A"}
          {assign var="tab_content_capture" value="tab_content_capture_`$tab_id`"}

          {capture name=$tab_content_capture}
              {if $tab.tab_type == 'B'}
                  {render_block block_id=$tab.block_id dispatch="products.view" use_cache=false parse_js=false}
              {elseif $tab.tab_type == 'T'}
                  {include file=$tab.template product_tab_id=$tab.html_id}
              {/if}
          {/capture}

          {if $smarty.capture.$tab_content_capture|trim}
              {if $product_details_in_tab == "N"}
                  <h3 class="tab-list-title" id="{$tab.html_id}">{$tab.name}</h3>
              {/if}
          {/if}

          <div id="content_{$tab.html_id}" class="ty-wysiwyg-content content-{$tab.html_id} {if $smarty.capture.$tab_content_capture|trim}et-tab-content{/if}">
              {$smarty.capture.$tab_content_capture nofilter}
          </div>
      {/if}
  {/foreach}

{/if}
{/capture}

{capture name="tabsbox_content"}
{if $product_details_in_tab == "Y"}
  {include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox et_wrapper="et-product-tabs"}
  {if $et_buy_together}
    {capture name="et_buy_together_content"}
      {include file=$et_buy_together.template product_tab_id=$et_buy_together.product_tab_id}
    {/capture}

    {if $smarty.capture.et_buy_together_content|trim}
      <div class="ty-mainbox-simple-container clearfix et_mainbox_simple">
        <div class="ty-mainbox-simple-title et-block-title-wrapper">
          <span class="et-block-title-border">{$et_buy_together.name}</span>
        </div>
      </div>
      <div class="ty-mainbox-simple-body">
        <div class="ty-wysiwyg-content content-buy_together">
          {include file=$et_buy_together.template product_tab_id=$et_buy_together.product_tab_id}
        </div>
      </div>
    {/if}
  {/if}
{else}
  {$smarty.capture.tabsbox nofilter}
{/if}
{/capture}
