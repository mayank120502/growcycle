{hook name="companies:contact"}
{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
{assign var="obj_id" value=$company_data.company_id}
{assign var="obj_id_prefix" value="`$obj_prefix``$obj_id`"}
{include file="common/company_data.tpl" company=$company_data show_name=true show_descr=true show_rating=true hide_links=true}
{$map=$vendor_extra_details.M}
{capture name="vendor_map" assign="vendor_map"}
	{if $map && $map!="maps"}
			<iframe src="{$map}" width="100%" height="333" frameborder="0" style="border:0">
			</iframe>
	{/if}
{/capture}



<div class="et-company-contact ty-company-detail clearfix">
	<div id="block_company_{$company_data.company_id}" class="clearfix">
		{if $vendor_map|trim && ($smarty.const.ET_DEVICE != "D" || $et_traditional_resp)}
			<div class="et-google-maps hidden-desktop">
				{$vendor_map nofilter}
			</div>
		{/if}
		{if !empty($company_data.vendor_extra_details.C)}
				<div class="ty-wysiwyg-content">
					{$company_data.vendor_extra_details.C nofilter}
				</div>
		{/if}
		<div class="et-vendor-contact-wrapper">
			{if $vendor_map|trim && ($smarty.const.ET_DEVICE == "D" || $et_traditional_resp)}
				<div class="et-google-maps visible-desktop">
					{$vendor_map nofilter}
				</div>
			{/if}
			
			<div class="et-vendor-contact-details">
				<div class="et-vendor-contact-title">{__('et_contact_info')}</div>
				<div class="et-company-detail__control-group">
					<div class="et-company-detail__control-icon">
						<i class="et-icon-vendor-contact-address2"></i>
					</div>
					<div class="et-company-detail__info">{$company_data.address} {$company_data.city}, {$company_data.state|fn_get_state_name:$company_data.country} {$company_data.zipcode} {$company_data.country|fn_get_country_name}</div>
				</div>
				{if $company_data.email}
					<div class="et-company-detail__control-group">
						<div class="et-company-detail__control-icon">
							<i class="et-icon-vendor-contact-mail2"></i>
						</div>
						<div class="et-company-detail__info"><a href="mailto:{$company_data.email}">{$company_data.email}</a></div>
					</div>
				{/if}
				{if $company_data.phone}
					<div class="et-company-detail__control-group">
						<div class="et-company-detail__control-icon">
							<i class="et-icon-vendor-contact-phone2"></i>
						</div>
						<div class="et-company-detail__info">{$company_data.phone}</div>
					</div>
				{/if}
				{if $company_data.fax}
					<div class="et-company-detail__control-group">
						<div class="et-company-detail__control-icon">
							<i class="et-icon-vendor-contact-fax2"></i>
						</div>
						<div class="et-company-detail__info">{$company_data.fax}</div>
					</div>
				{/if}
				{if $company_data.url}
					<div class="et-company-detail__control-group">
						<div class="et-company-detail__control-icon">
							<i class="et-icon-vendor-contact-website2"></i>
						</div>
						<div class="et-company-detail__info"><a href="{fn_et_addhttp($company_data.url)}" target="_blank">{$company_data.url}</a></div>
					</div>
				{/if}
			</div>

		</div>
	</div>
</div>
{/hook}