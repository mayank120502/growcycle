{capture name="popupsbox"}
{hook name="et_tabs:product_tabs"}
{/hook}
  {foreach from=$tabs item="tab" key="tab_id"}
    {if $tab.show_in_popup == "Y" && $tab.status == "A"}
      {assign var="product_tab_id" value="product_tab_`$tab.tab_id`"}
      {assign var="tab_content_capture" value="tab_content_capture_`$tab_id`"}

      {capture name=$tab_content_capture}
        {if $tab.tab_type == 'B'}
          {render_block block_id=$tab.block_id dispatch="products.view" use_cache=false parse_js=false}

        {elseif $tab.tab_type == 'T'}
          {include file=$tab.template product_tab_id=$product_tab_id force_ajax=true et_tab_type=$tab.et_tab_type}
          
        {/if}
      {/capture}

      {if $smarty.capture.$tab_content_capture|trim}
        <li class="{if $details_page} et-popup-tabs__item {else}ty-popup-tabs__item{/if} {if $et_class}{$et_class}{/if}">
          <a id="{$tab.html_id}" class="cm-dialog-opener" data-ca-target-id="content_block_popup_{$tab_id}" rel="nofollow">

            <div class="et-popup-tabs__item-inner-wrapper">
              <div class="et-popup-tabs__icon">
                <i class="et-icon-product-popup-tab2"></i>
              </div>
              <div class="et-popup-tabs__title">
                {$tab.name}
              </div>
            </div>
          </a>
          <div id="content_block_popup_{$tab_id}" class="hidden" title="{$tab.name}" data-ca-keep-in-place="true">
            {$smarty.capture.$tab_content_capture nofilter}
          </div>
        </li>
      {/if}
    {/if}
  {/foreach}
{/capture}

{capture name="popupsbox_content"}
{if $smarty.capture.popupsbox|trim}
<ul class="ty-popup-tabs">
{$smarty.capture.popupsbox nofilter}
</ul>
{/if}
{/capture}