{** block-description:block_vendor_information **}

<div class="ty-vendor-information">
	<div class="ty-center">
    <a class="vs_vendor_link" href="{"companies.view?company_id=`$vendor_info.company_id`"|fn_url}">{$vendor_info.company}</a><br/>
    </div>
    <div class="vs_vendor_info">{$vendor_info.company_description nofilter}</div>
</div>