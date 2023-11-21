{function name="store_header_top"}{strip}
<div class="et-vendor-header-top clearfix">
	{* Store *}
	<div class="et-vendor-header-top__block">
		<div class="et-vendor-header-top__title">
			{__('et_vendor_header.store')}:
		</div>
		<div class="et-vendor-header-top__info et-vendor-header-top__name">
			{if $addons.vendor_rating.status == "A"}
			    {include file="addons/vendor_rating/components/relative_vendor_rating.tpl" 
			        rating=$et_vendor_info.relative_vendor_rating
			    }
			{/if}
			{$et_vendor_info.company}
		</div>
	</div>
	{* /Store *}

	{* Feedback *}
	{hook name="companies:vendor_header"}{/hook}
	{* Feedback *}

	{* Location *}
	{if $et_vendor_info.city|trim || $et_vendor_info.country|trim}
		{if $addons.et_vivashop_mv_functionality.et_mv_menu_setting_contact|default:"Y"=="Y"}
		  {$et_contact_url="companies.contact?company_id=`$et_vendor_info.company_id`"|fn_url}
		{else}
		  {$et_contact_url="companies.view?company_id=`$et_vendor_info.company_id`"|fn_url}
		{/if}
		<div class="et-vendor-header-top__block">
			<div class="et-vendor-header-top__title">
				{__('location')}:
			</div>
			<div class="et-vendor-header-top__info et-vendor-header-top__location">
				<a href="{$et_contact_url}">{$et_vendor_info.city|trim nofilter}{if $et_vendor_info.city|trim && $et_vendor_info.country|trim}, {/if}{$et_vendor_info.country|trim nofilter}</a>
			</div>
		</div>
	{/if}
	{* /Location *}

	{* Phone *}
	{if $et_vendor_info.phone|trim}
		<div class="et-vendor-header-top__block">
			<div class="et-vendor-header-top__title">
				{__('phone')}:
			</div>
			<div class="et-vendor-header-top__info et-vendor-header-top__phone">
				<a href="tel:{$et_vendor_info.phone}" class="company-phone">{$et_vendor_info.phone}</a>
			</div>
		</div>
	{/if}
	{* /Phone *}
	
	{* Contact Vendor *}
	{if $addons.vendor_communication.status == "A"}
		<div class="et-vendor-header-top__block et-vendor-header-top__contact-us">
			{if "MULTIVENDOR"|fn_allowed_for && $addons.vendor_communication.show_on_vendor == "Y"}
			    {include file="addons/vendor_communication/views/vendor_communication/components/new_thread_button.tpl" object_id=$et_vendor_info.company_id show_form=true et_vendor_header_contact=true}
			    
			    {include
			        file="addons/vendor_communication/views/vendor_communication/components/new_thread_form.tpl"
			        object_type=$smarty.const.VC_OBJECT_TYPE_COMPANY
			        object_id=$et_vendor_info.company_id
			        company_id=$et_vendor_info.company_id
			        vendor_name=$et_vendor_info.company_id|fn_get_company_name
			        et_vendor_header_contact=true
			    }
			{/if}
		</div>
	{/if}
	{* /Contact Vendor *}

	{* Vendor social *}
	{capture name="et_vendor_social"}
		{foreach from=$et_vendor_info.vendor_extra_details item=item key=key name=name}
			{if $key|strtolower!="m" && $key|strtolower!="c" && $item}
				<a href="{$item|fn_et_addhttp}" class="et-social-icon et-social-icon-{$key|strtolower}" target="_blank">
					<i class="et-icon-social-{$key|strtolower}"></i>
				</a>
			{/if}
		{/foreach}
	{/capture}
	{if $smarty.capture.et_vendor_social|trim}
		<div class="et-vendor-header-top__block et-vendor-header-top__social">
				<div class="et-vendor-header-top__title">
					{__('et_vendor_header.social')}:
				</div>
				<div class="et-vendor-header-top__info">
						<div class="et-vendor-social-links et-social-links">
							{$smarty.capture.et_vendor_social nofilter}
						</div>
				</div>
		</div>
	{/if}
	{* /Vendor social *}

</div>
{/strip}
{/function}

{function name="store_header"}{strip}
	<div class="et-vendor-header-wrapper clearfix">
		<style>
			.et-vendor-store-header .et-vendor-logo a:hover{
				border-color: {$et_vs.bkg_menu_hover|default:$et_default_colors.menu_bkg};
			}

			.et-vendor-store-header .et-vendor-name a{
				color: {$et_vs.color|default:$et_default_colors.header_text};
			}
			.et-vendor-store-header .et-vendor-name a:hover{
				color: {$et_vs.header_hover|default:$et_default_colors.header_hover};
			}
		</style>
		<div class="et-vendor-logo">
			<a href="{"companies.view?company_id=`$et_vendor_info.company_id`"|fn_url}">
				{include file="common/image.tpl" images=$et_vendor_info.logos.theme.image image_width="175" image_height="175"}
			</a>
		</div>

		<div class="et-vendor-details-outer-wrapper">
			<div class="et-vendor-details-inner-wrapper">
				<div class="et-vendor-details et-vendor-details-left">

					{* Name *}
					<div class="et-vendor-name" >
						<a href="{"companies.view?company_id=`$et_vendor_info.company_id`"|fn_url}">{$et_vendor_info.company}</a>
					</div>
					{* /Name *}
				</div>
				{if $et_vendor_info.has_microstore}
				<div class="et-vendor-details et-vendor-details-right">
					{* Search *}
					<div class="ty-search-block et-vendor-search">
					  <form action="{""|fn_url}" name="search_form" method="get">
					    <input type="hidden" name="subcats" value="Y" />
					    <input type="hidden" name="status" value="A" />
					    <input type="hidden" name="pshort" value="Y" />
					    <input type="hidden" name="pfull" value="Y" />
					    <input type="hidden" name="pname" value="Y" />
					    <input type="hidden" name="pkeywords" value="Y" />
					    <input type="hidden" name="search_performed" value="Y" />
					    <input type="hidden" name="company_id" value="{$et_vendor_info.company_id}" />
					    <input type="hidden" name="category_id" value="{$category_data.category_id}"/> 
					    {hook name="vendor_search:additional_fields"}{/hook}
					    {strip}
					      <input type="text" name="q" value="{$search.q}" title="{__("block_vendor_search")}" class="ty-search-block__input cm-hint" style="color: {$et_vs.color|default:$et_default_colors.header_text}; border-color: {$et_vs.color|default:$et_default_colors.header_text};"/>
					      {include file="buttons/magnifier.tpl" but_name="companies.products" alt=__("search") et_icon="et-icon-vendor-search2" et_color=$et_vs.color|default:$et_default_colors.header_text}
					    {/strip}
					  </form>
					  <!-- ty-search-block et-vendor-search-->
					</div>
					{* /Search *}

				</div>
				{/if}
				<!-- et-vendor-details-inner-wrapper -->
			</div>
			<!-- et-vendor-details-outer-wrapper -->
		</div>
		<!-- et-vendor-header-wrapper clearfix -->
	</div>                                
{/strip}{/function}

{if ($smarty.request.dispatch!="companies.discussion") || ($smarty.request.dispatch=="companies.discussion" && $object_type=="M")}
	<div class="et-vendor-store-header" style="background: {$et_vs.bkg|default:$et_default_colors.header_bkg};">
		<div class="et-vendor-header-top-outer">
			<div class="et-container">
				{store_header_top}
			</div>
		</div>
		<div class="et-vendor-header-outer">
			<div class="et-container">
				{store_header}
			</div>
		</div>
	</div>
{/if}