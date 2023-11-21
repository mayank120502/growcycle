{$et_on_vs=(strpos($smarty.request.dispatch,'companies')===0)}
{if !$et_on_vs}
	{if !($addons.master_products.status == "A" && !$product.company_id)}

		{$company_id=$product.company_id}
		{$company_name=$product.company_name}
		{$vendor=fn_filter_company_data_by_profile_fields(fn_et_get_company_data($company_id))}
		{$et_count=fn_et_get_company_product_count($company_id)|default:"0"}

		<div class="et-grid-vendor et-categ-vendor-box clearfix">
			{$logo=fn_et_get_company_logo($company_id)}
			<div class="et-vendor-logo">
				<a href="{"companies.view?company_id=`$company_id`"|fn_url}" {if !$et_on_vs}target="_blank"{/if}>
					{include file="common/image.tpl" images=$logo.theme.image image_width="45" image_height="45" et_lazy=true}
				</a>
			</div>
			<div class="et-vendor-info">
				<div class="et-vendor-name-wrapper">
					<i class="et-icon-mobile-sold-by hidden"></i>
					<a href="{"companies.view?company_id=`$company_id`"|fn_url}" class="et-vendor-name" {if !$et_on_vs}target="_blank"{/if}>{$company_name}</a>
				</div>
				{if $vendor.city || $vendor.country}
					{if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_contact|default:"Y"=="Y"}
					  {$et_contact_url="companies.contact?company_id=`$company_id`"|fn_url}
					{else}
					  {$et_contact_url="companies.view?company_id=`$company_id`"|fn_url}
					{/if}
					<div class="ty-grid-list__item-location et-vendor-location">{strip}
					  <a href="{$et_contact_url}" class="company-location" {if !$et_on_vs}target="_blank"{/if}><i class="et-icon-footer-location"></i><bdi>{$vendor.city nofilter}{if $vendor.city && $vendor.country}, {/if}{$vendor.country nofilter}</bdi></a>
					{/strip}</div>
				{/if}

				<div class="et-vendor-products"><a href="{"companies.products?company_id=`$company_id`"|fn_url}" {if !$et_on_vs}target="_blank"{/if}><i class="et-icon-vendor-products" {if !$et_on_vs}target="_blank"{/if}></i><span>{$et_count} {__('products')}</span></a></div>
			</div>
		</div>

	{else}
		<div class="et-grid-vendor et-categ-vendor-box et-master-product-grid">
			<div class="et-vendor-info">
				<div class="et-vendor-name-wrapper">
					<i class="et-icon-mobile-sold-by hidden"></i>
					<span class="hidden-phone hidden-tablet">{__("et_pp_sold_by")}:</span>
					<a href="{"products.view?product_id=`$product.product_id`"|fn_url}" class="et-vendor-name">{$product.master_product_offers_count} {__('et_master_vendors',[$product.master_product_offers_count])}</a>
				</div>
			</div>
		</div>
	{/if}
{/if}