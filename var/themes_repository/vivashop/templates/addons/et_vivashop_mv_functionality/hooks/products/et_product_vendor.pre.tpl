{if $addons.master_products.status == "A" && !$product.company_id}

	{foreach from=$tabs item="tab" key="tab_id"}
	  {if $tab.show_in_popup != "Y" && $tab.status == "A" && $tab.addon=='master_products'}
	    {render_block block_id=$tab.block_id dispatch="products.view" use_cache=false parse_js=false}
	  {/if}
	{/foreach}
	
{elseif ($product.company_id>0)}
	{$et_count=fn_et_get_company_product_count($company_id)|default:"0"}
	<div class="et-product-vendor-wrapper">
		<div class="et-vendor-block_title">
			{__("et_pp_this_item_sold_by")}
		</div>
		<div class="et-list-vendor clearfix">
			<div class="et-vendor-logo-link-wrapper clearfix">
				
				<div class="et-vendor-logo-wrapper">
					{$logo=fn_et_get_company_logo($company_id)}
					<div class="et-vendor-logo">
						<a href="{"companies.view?company_id=`$company_id`"|fn_url}" target="_blank">
							{include file="common/image.tpl" images=$logo.theme.image image_width="111" image_height="111"}
						</a>
					</div>
				</div>

				<div class="et-vendor-store-link-wrapper">
					{capture assign="et_vendor_rating"}
						{$show_vendor_rating=true}
						{$company.relative_vendor_rating=$vendor.relative_vendor_rating}
				    {hook name="companies:vendor_rating"}
				    {/hook}
					{/capture}

					<a href="{"companies.view?company_id=`$company_id`"|fn_url}" class="et-vendor-name" target="_blank"><span>{if $et_vendor_rating}{$et_vendor_rating nofilter}{/if}{$product.company_name}</span></a>

					<a href="{"companies.view?company_id=`$company_id`"|fn_url}" class="et-vendor-store-link ty-btn" target="_blank">
						{__("view_store")}
					</a>

					<span class="et-vendor-products"><a href="{"companies.products?company_id=`$company_id`"|fn_url}" target="_blank">{$et_count} {__('products')}</a></span>
				</div>
			</div>

			{capture assign="et_store_rating"}
				{$show_rating=true}
				{hook name="companies:data_block"}
				{/hook}
			{/capture}
			{if $et_store_rating|trim}
				<div class="et-vendor-rating et-vendor_detail-wrapper clearfix">
					<div class="et-vendor_detail-title">
						{__('store_rating')}:
					</div>
					<div class="et-vendor_detail-content">
						<div class="et-rating-graph__trigger">
							{$et_store_rating nofilter}
						</div>
					</div>
				</div>
			{/if}

			{capture assign="et_store_location"}
				{if $vendor.city || $vendor.country}{$vendor.city nofilter}{if $vendor.city && $vendor.country}, {/if}{$vendor.country nofilter}{/if}
			{/capture}
			
			{if $et_store_location|trim}
				{if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_contact|default:"Y"=="Y"}
				  {$et_contact_url="companies.contact?company_id=`$company_id`"|fn_url}
				{else}
				  {$et_contact_url="companies.view?company_id=`$company_id`"|fn_url}
				{/if}
				<div class="et-vendor-location et-vendor_detail-wrapper clearfix">
				  <div class="et-vendor_detail-title">{__('location')}:</div>
				  <div class="et-vendor_detail-content">
				  	<a href="{$et_contact_url}" class="company-location" target="_blank"><bdi>{$et_store_location}</bdi></a>
				  </div>
				</div>
			{/if}
			
			{if $vendor.phone|trim}
				<div class="et-vendor-rating et-vendor_detail-wrapper et-vendor-phone clearfix">
					<div class="et-vendor_detail-title">
						{__('phone')}:
					</div>
					<div class="et-vendor_detail-content">
						<a href="tel:{$vendor.phone}" class="company-phone">{$vendor.phone}</a>
					</div>
				</div>
			{/if}

		</div>
	</div>
{/if}
