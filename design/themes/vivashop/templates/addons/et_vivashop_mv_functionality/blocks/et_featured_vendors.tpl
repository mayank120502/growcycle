{** block-description:vendor_logos_and_product_count **}

{$show_location = $block.properties.show_location|default:"N" == "Y"}
{$show_rating = $block.properties.show_rating|default:"N" == "Y"}
{$show_vendor_rating = $block.properties.show_vendor_rating|default:"N" == "Y"}
{$show_products_count = $block.properties.show_products_count|default:"N" == "Y"}

{$columns=$block.properties.number_of_columns}
{$obj_prefix="`$block.block_id`000"}
{$et_on_vs=false}

{if $items}
  <div class="clear-both et-featured-vendors et-scroller">
   
    {foreach from=$items item=company}{strip}
      {if $company}
        <div class="et-featured-vendor-wrapper ty-column{$columns}">
        {if $company.logos}
          {$show_logo = true}
        {else}
          {$show_logo = false}
        {/if}
        {$obj_id=$company.company_id}
        {$obj_id_prefix="`$obj_prefix``$company.company_id`"}
        {include file="common/company_data.tpl" company=$company show_links=true show_logo=$show_logo show_location=$show_location et_featured_vendor_block=true et_on_vs=$et_on_vs}
          <div class="et-featured-vendor ty-center">
            <div class="ty-center et-featured-vendor-image">
              {$logo="logo_`$obj_id`"}
              {$smarty.capture.$logo nofilter}

              {$vendor_rating="vendor_rating_`$obj_id`"}
              <a href="{"companies.view?company_id=`$company.company_id`"|fn_url}" class="ty-block et-vendor-name" {if !$et_on_vs}target="_blank"{/if}>
                {if $smarty.capture.$vendor_rating && $show_vendor_rating}
                  {$smarty.capture.$vendor_rating nofilter}
                {/if}
                {$company.company}
              </a>
            </div>

            {$location="location_`$obj_id`"}
            {if $show_location && $smarty.capture.$location|trim}
                {if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_contact|default:"Y"=="Y"}
                  {$et_contact_url="companies.contact?company_id=`$company.company_id`"|fn_url}
                {else}
                  {$et_contact_url="companies.view?company_id=`$company.company_id`"|fn_url}
                {/if}
                <div class="ty-grid-list__item-location et-vendor-location">
                  <span class="et-vendor-location-label">{__("location")} :</span>
                  <i class="et-icon-footer-location hidden"></i>
                  <a href="{$et_contact_url}" class="company-location" {if !$et_on_vs}target="_blank"{/if}><bdi>
                    {$smarty.capture.$location nofilter}
                  </bdi></a>
                </div>
            {/if}

            {$rating="rating_`$obj_id`"}
            {if $smarty.capture.$rating && $show_rating}
              <div class="grid-list__rating">
                {$smarty.capture.$rating nofilter}
              </div>
            {/if}

            <div class="ty-grid-list__total-products">
              {$products_count="products_count_`$obj_id`"}
              {if $smarty.capture.$products_count && $show_products_count}
                <i class="et-icon-vendor-products hidden"></i>
                {$smarty.capture.$products_count nofilter}
              {/if}
            </div>
          </div>
        </div>
      {/if}
    {/strip}{/foreach}
  </div>
{/if}