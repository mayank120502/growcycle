<div id="content_et_quick_info_block">
	{foreach from=$et_quick_info_block item=data key=key name=name}
		<input type="hidden" name="company_data[et_quick_info][{$key}][block_id]" value="{$data.block_id}">
		<input type="hidden" name="company_data[et_quick_info][{$key}][content_id]" value="{$data.content_id}">
		<div class="control-group {if $share_dont_hide}cm-no-hide-input{/if}">
			<label class="control-label {if $data.settings.required.enabled=="Y"}cm-required{/if}" for="et_quick_info_{$data.block_id}">{$data.data.title}:
				<br/>({if $data.settings.type == "P"}Popup{else}Dropdown{/if})</label>
			<div class="controls">

					<textarea name="company_data[et_quick_info][{$key}][text]" cols="55" rows="4" class="span9 cm-wysiwyg" id="et_quick_info_{$data.block_id}">{$data.v_data.text}</textarea>

			</div>
		</div>

	{/foreach}
</div>