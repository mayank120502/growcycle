{function name="store_header_top_mobile"}
<div class="et-vendor-header-mobile" style="background: {$et_vs.bkg|default:$et_default_colors.header_bkg};">
	<style>
		.et-vendor-store-header .et-vendor-header-mobile-logo a:hover{
			border-color: {$et_vs.bkg_menu_hover|default:$et_default_colors.menu_bkg};
		}

		.et-vendor-store-header .et-vendor-name a{
			color: {$et_vs.color|default:$et_default_colors.header_text};
		}
		.et-vendor-store-header .et-vendor-name a:hover{
			color: {$et_vs.bkg_menu_hover|default:$et_default_colors.menu_bkg_hover};
		}
	</style>
	{* Logo *}
	<div class="et-vendor-header-mobile-logo">
		<a href="{"companies.view?company_id=`$et_vendor_info.company_id`"|fn_url}">
			{include file="common/image.tpl" images=$et_vendor_info.logos.theme.image image_width="75" image_height="75"}
		</a>
	</div>
	{* Name/Rating/Location *}
	<div class="et-vendor-header-mobile-info">
		{* Name *}
		<div class="et-vendor-name" >
			<a href="{"companies.view?company_id=`$et_vendor_info.company_id`"|fn_url}">{$et_vendor_info.company}</a>
		</div>
		{* /Name *}

		{* Rating *}
		{hook name="companies:vendor_header_mobile"}{/hook}
		
		{* /Rating *}

		{* Location *}
		{if $et_vendor_info.city|trim || $et_vendor_info.country|trim}
			<div class="et-vendor-location-mobile">
				{$et_vendor_info.city|trim nofilter}{if $et_vendor_info.city|trim && $et_vendor_info.country|trim}, {/if}{$et_vendor_info.country|trim nofilter}
			</div>
		{/if}
		{* /Location *}

	</div>
	{* Contact button *}
	{if $addons.vendor_communication.status == "A" && "MULTIVENDOR"|fn_allowed_for && $addons.vendor_communication.show_on_vendor == "Y"}
		<div class="et-vendor-header-mobile-contact">
			<div class="et-vendor-header-top__block et-vendor-header-top__contact-us">
			    {include file="addons/vendor_communication/views/vendor_communication/components/new_thread_button.tpl" object_id="`$et_vendor_info.company_id`_`$block.grid_id`" show_form=true et_vendor_header_contact=true}
			    
			    {include
			        file="addons/vendor_communication/views/vendor_communication/components/new_thread_form.tpl"
			        object_type=$smarty.const.VC_OBJECT_TYPE_COMPANY
			        object_id="`$et_vendor_info.company_id`_`$block.grid_id`"
			        company_id=$et_vendor_info.company_id
			        vendor_name=$et_vendor_info.company_id|fn_get_company_name
			        et_vendor_header_contact=true
			    }
			</div>
		</div>
	{/if}
	{* /Contact Vendor *}
</div>
{/function}
<style>
	.et-vendor-header-mobile .et-vendor-header-mobile-contact a{
		background: {$et_vs.bkg_menu|default:$et_default_colors.menu_bkg};
		color: {$et_vs.color_menu|default:$et_default_colors.menu_text};
	}

	.et-vendor-header-mobile .et-vendor-rating .ty-stars a,
	.et-vendor-header-mobile .et-vendor-rating .et-rating-graph_average,
	.et-vendor-header-mobile .et-vendor-rating .ty-discussion__review-quantity,
	.et-vendor-header-mobile .et-vendor-rating .et-icon-menu-arrow,
	.et-vendor-location-mobile{
		color: {$et_vs.color|default:$et_default_colors.header_text};
	}
</style>
{if ($smarty.request.dispatch!="companies.discussion") || ($smarty.request.dispatch=="companies.discussion" && $object_type=="M")}
	<div class="et-vendor-store-header">
		{store_header_top_mobile}
	</div>
{/if}