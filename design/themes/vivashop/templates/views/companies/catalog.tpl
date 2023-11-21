{hook name="companies:catalog"}
{$title=__("all_vendors")}
{include file="common/pagination.tpl"}
{include file="views/companies/components/sorting.tpl"}
{if $companies}
	{foreach $companies as $company}
		{$obj_id=$company.company_id}
		{$obj_id_prefix="`$obj_prefix``$obj_id`"}
		{$logo_height=0}
		{$logo_width=150}
		
		{include file="common/company_data.tpl" company=$company show_name=true show_descr=true show_rating=true show_vendor_rating=true show_logo=true show_links=true}
		<div class="et-companies">
			<div class="et-companies__img">
				{assign var="capture_name" value="logo_`$obj_id`"}
				{$smarty.capture.$capture_name nofilter}
				
			</div>

			<div class="et-companies__info">
				<a href="{"companies.view&company_id=`$company.company_id`"|fn_url}" class="ty-company-title" target="blank">{$company.company}</a>
				<div class="et-companies__info-details">
					{* Rating *}
					{capture name="et_vendor_rating"}
						{assign var="rating" value="rating_$obj_id"}
						<div class="grid-list__rating">
							<div class="et-rating-graph__trigger">
								{$show_rating=true}
								{$show_empty_rating=true}
								{$show_links=true}
								{hook name="companies:data_block"}
								{/hook}
							</div>
						</div>
					{/capture}
					{if $smarty.capture.et_vendor_rating|trim && $addons.discussion.status=="A" && $addons.discussion.company_discussion_type!="D"}
						<div class="et-vendor-header-top__block">
							<div class="et-vendor-info et-vendor-rating">
								{$smarty.capture.et_vendor_rating nofilter}
							</div>
						</div>
					{/if}
					{* /Rating *}

					{* Product count *}
					<div class="et-vendor-header-top__block">
						<div class="et-vendor-header-top__title">
							{__('products')}:
						</div>
						<div class="et-vendor-header-top__info">
							<a href="{"companies.products&company_id=`$company.company_id`"|fn_url}" class="" target="blank">{$company.product_count}</a>
						</div>
					</div>
					{* /Product count *}

					{* Location *}
					{if $company.city|trim || $company.country|trim}
						<div class="et-vendor-header-top__block">
							<div class="et-vendor-header-top__title">
								{__('location')}:
							</div>
							<div class="et-vendor-header-top__info">
								<a href="{"companies.contact&company_id=`$company.company_id`"|fn_url}" class="" target="blank">
									{$company.city|trim nofilter}{if $company.city|trim && $company.country|trim}, {/if}{$company.country|trim nofilter}
								</a>
							</div>
						</div>
					{/if}
					{* /Location *}

					{* Phone *}
					{if $company.phone|trim}
						<div class="et-vendor-header-top__block">
							<div class="et-vendor-header-top__title">
								{__('phone')}:
							</div>
							<div class="et-vendor-header-top__info">
								<a href="tel:{$company.phone}">
									{$company.phone}
								</a>
							</div>
						</div>
					{/if}
					{* /Phone *}

					{* Social links *}
					{capture name="et_vendor_social"}
						{foreach from=$company.vendor_extra_details item=item key=key name=name}
							{if $key|strtolower!="m" && $key|strtolower!="c" && $item}
								<a href="{$item|fn_et_addhttp}" class="et-social-icon et-social-icon-{$key|strtolower}" target="_blank">
									<i class="et-icon-social-{$key|strtolower}"></i>
								</a>
							{/if}
						{/foreach}
					{/capture}
					<div class="et-vendor-header-top__block et-vendor-header-top__social">
						{if $smarty.capture.et_vendor_social|trim}
							<div class="et-vendor-header-top__title">
								{__('et_vendor_header.social')}:
							</div>
							<div class="et-vendor-header-top__info">
									<div class="et-vendor-social-links et-social-links">
										{$smarty.capture.et_vendor_social nofilter}
									</div>
							</div>
						{/if}
					</div>
					{* /Social links *}
				</div>
				
				<div class="et-company__catalog-description">
					{assign var="vendor_rating" value="vendor_rating_$obj_id"}
        	{$smarty.capture.$vendor_rating nofilter}
					{assign var="company_descr" value="company_descr_`$obj_id`"}
					{$smarty.capture.$company_descr nofilter}
				</div>
			</div>
		</div>
	{/foreach}
{else}
	<p class="ty-no-items">{__("no_items")}</p>
{/if}
{include file="common/pagination.tpl"}
{capture name="mainbox_title"}{$title}{/capture}
{/hook}