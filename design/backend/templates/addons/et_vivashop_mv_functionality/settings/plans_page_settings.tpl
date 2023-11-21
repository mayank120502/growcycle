<div>
	<div class="setting-wide">
		{$colors="highlight_text price_bkg price_text best_bkg best_text best_outer_bkg best_outer_text"}
		{$et_settings=explode(" ",$colors)}

		{foreach from=$et_settings item=item key=key name=name}
		  <div class="control-group">
		    {$label_name="et_vivashop_mv_settings.`$item`"}
		    <label class="control-label cm-color" for="elm_{$item}">{__($label_name)}:</label>
		    <div class="controls">
		      <div class="te-colors clearfix">
		      {$cp_value = ($et_mv_settings.vendor_plans.$item)|default:"#ffffff"}
		        <div class="colorpicker">
		          <div class="input-prepend">
		            <input type="text"  maxlength="7"  name="et_mv_settings[vendor_plans][{$item}]" id="elm_{$item}" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
		          </div>
		        </div>
		      </div>
		    </div>
		  </div>
		{/foreach}

		<style>
		.sp-container{
		  top: 30px !important;
		}
		</style>
	</div>

</div>

<div>
	<div class="setting-wide">
		<div class="control-group">
			<label class="control-label" for="et_vendor_plans_footer_check">{__('et_vivashop_mv_settings.show_footer')}:</label>
			<div class="controls">
				<input id="et_vendor_plans_footer_check" name="et_mv_settings[vendor_plans][show_footer]" type="checkbox" onchange="$('#et_vendor_plans_footer').toggle()" {if $et_mv_settings.vendor_plans.show_footer}checked="checked"{/if}>
			</div>
		</div>    

		<div id="et_vendor_plans_footer" {if !$et_mv_settings.vendor_plans.show_footer}class="hidden"{/if}>
			<hr>
			{* Footer bkg *}
			<div class="setting-wide">
				{$colors="footer_text footer_bkg"}
				{$et_settings=explode(" ",$colors)}

				{foreach from=$et_settings item=item key=key name=name}
				  <div class="control-group">
				    {$label_name="et_vivashop_mv_settings.`$item`"}
				    <label class="control-label cm-color" for="elm_{$item}">{__($label_name)}:</label>
				    <div class="controls">
				      <div class="te-colors clearfix">
				      {$cp_value = ($et_mv_settings.vendor_plans.$item)|default:"#ffffff"}
				        <div class="colorpicker">
				          <div class="input-prepend">
				            <input type="text"  maxlength="7"  name="et_mv_settings[vendor_plans][{$item}]" id="elm_{$item}" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
				          </div>
				        </div>
				      </div>
				    </div>
				  </div>
				{/foreach}

			<div id="et_vendor_plans_footer_bkg_img" class="in collapse">
				<div class="control-group">
					<label class="control-label" for="et_vendor_plans_footer_bkg_img">{__('et_vivashop_mv_settings.footer_bkg_img')}:</label>
					<div class="controls">
						{include file="common/attach_images.tpl"
							image_name="et_vp_footer_img"
							image_object_type="et_vp_footer_img"
							image_pair=$et_mv_settings.main_pair
							no_thumbnail=true
							hide_alt=true
						}
					</div>
				</div>
			</div>
		</div>
	</div>
</div>