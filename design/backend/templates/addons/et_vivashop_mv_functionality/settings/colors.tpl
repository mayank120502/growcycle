<div class="setting-wide">
{$colors="header_bkg header_text header_hover"}
{$et_settings=explode(" ",$colors)}

{foreach from=$et_settings item=item key=key name=name}
  <div class="control-group">
    {$label_name="et_vivashop_mv_settings.`$item`"}
    <label class="control-label cm-color" for="elm_{$item}">{__($label_name)}:</label>
    <div class="controls">
      <div class="te-colors clearfix">
      {$cp_value = ($et_mv_settings.vendor_colors.$item)|default:"#ffffff"}
        <div class="colorpicker">
          <div class="input-prepend">
            <input type="text"  maxlength="7"  name="et_mv_settings[vendor_colors][{$item}]" id="elm_{$item}" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
          </div>
        </div>
      </div>
    </div>
  </div>    
{/foreach}

{$colors="menu_bkg menu_text menu_bkg_hover menu_text_hover"}
{$et_settings=explode(" ",$colors)}

{foreach from=$et_settings item=item key=key name=name}
  <div class="control-group">
    {$label_name="et_vivashop_mv_settings.`$item`"}
    <label class="control-label cm-color" for="elm_{$item}">{__($label_name)}:</label>
    <div class="controls">
      <div class="te-colors clearfix">
      {$cp_value = ($et_mv_settings.vendor_colors.$item)|default:"#ffffff"}
        <div class="colorpicker">
          <div class="input-prepend">
            <input type="text"  maxlength="7"  name="et_mv_settings[vendor_colors][{$item}]" id="elm_{$item}" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
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