<div class="control-group">
    <label class="control-label" for="elm_layout_show_to_affiliate_{$id}">{__("addons.sd_affiliate.show_to_affiliate")}</label>
    <div class="controls">
    	<input type="hidden" name="layout_data[show_to_affiliate]" value="N" />
        <input type="checkbox" id="elm_layout_show_to_affiliate_{$id}" name="layout_data[show_to_affiliate]" value="Y" {if $layout_data.show_to_affiliate == "Y"}checked="checked"{/if} />
    </div>
</div>