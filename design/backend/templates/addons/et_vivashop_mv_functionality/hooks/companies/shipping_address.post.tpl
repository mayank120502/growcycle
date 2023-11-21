<h4 class="subheader">
    {__("et_contact_page")}
</h4>
<div class="control-group {if $share_dont_hide}cm-no-hide-input{/if}">
	<label class="control-label" for="elm_et_vendor_extra_details_M">
		{__("et_google_map")}:
	</label>
	<div class="controls">

		<textarea name="company_data[vendor_extra_details][M]" id="elm_et_extra_details_M" rows="5" cols="32" class="input-large" >{$vendor_extra_details.M}</textarea>

	</div>
</div>

<div class="control-group {if $share_dont_hide}cm-no-hide-input{/if}">
	<label class="control-label" for="elm_et_cit_block_{$data}">
		{__("description")}:
	</label>
	<div class="controls">
		<textarea name="company_data[vendor_extra_details][C]" cols="55" rows="4" class="span9 cm-wysiwyg" id="elm_et_cit_block_{$data}">{$vendor_extra_details.C}</textarea>
	</div>
</div>

