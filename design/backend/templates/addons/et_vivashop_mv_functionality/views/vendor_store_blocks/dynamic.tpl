{$banner_nr=$id+1}
<thead>
	<tr>
		<th colspan="2" class="et-title">
			<input type="hidden" class="cm-no-hide-input" name="block_data[banner][{$banner_nr}][banner_nr]" value="" />
			<input type="hidden" class="cm-no-hide-input" name="block_data[banner][{$banner_nr}][banner_id]" value="" />
			<input type="hidden" class="cm-no-hide-input" name="block_data[banner][{$banner_nr}][is_new]" value="Y" />
			<span>{__("banner")} {$banner_nr+1}</span>
		</th>
		<th class="cm-extended-feature right" width="5%">
			<span class="hidden-tools">
				{include file="buttons/multiple_buttons.tpl" item_id="add_banner_`$banner_nr`" only_delete="Y"}
			</span>
		</th>
	</tr>
</thead>

<tbody class="" id="et_banner_{$banner_nr}">
	<tr><td colspan="3">
		<label class="control-label" for="elm_image_{$banner.banner_id}_{$banner_nr}">{__("position_short")}</label>
		<div class="controls">
			<input type="text" name="block_data[banner][{$banner_nr}][position]" value="" size="4" class="input-micro" />
		</div>
	</td></tr>

	<tr><td colspan="3">
		<div class="control-group">
			<label class="control-label" for="elm_image_{$banner.banner_id}_{$banner_nr}">{__("image")}</label>
			<div class="controls">
			{include file="common/attach_images.tpl" image_name="vsb_banner" image_object_type="vsb_banner" image_key=$banner_nr hide_titles=true no_detailed=true image_pair=$banner.image}
			</div>
		</div>
	</td></tr>

	<tr><td colspan="3">
		<div class="control-group">
			<label class="control-label" for="block_banner_url_{$banner.banner_id}_{$banner_nr}">{__("url")}</label>
			<div class="controls">
			<input type="text" name="block_data[banner][{$banner_nr}][url]" id="block_banner_url_{$banner.banner_id}_{$banner_nr}" class="span7" value="" />
			</div>
		</div>
	</td></tr>

</tbody>
<!-- box_add_banner_{$banner_nr} -->