{$et_image=$block.et_image}
{$block_data=$block.properties.et_settings}

<h4 class="subheader">
  {__("et_background_settings")}:
</h4>

<div id="et_testimonials_block_image_uploader" class="in collapse{if !$runtime.company_id && !fn_allowed_for('MULTIVENDOR') && !$runtime.simple_ultimate} disable-overlay-wrap{/if}">
  <div class="control-group">
    <label class="control-label" for="elm_et_testimonials_bkg">{__("theme_editor.background")}:</label>
    <div class="controls">
      {include file="common/attach_images.tpl" image_name="et_testimonials_bkg" image_object_type="et_testimonials_bkg" image_pair=$et_image no_thumbnail=true}
    </div>
  </div>
</div>

<div class="control-group">
  <label class="control-label">
    {__("et_overlay_settings")}:
  </label>
  <div class="controls">
    <select name="block_data[testimonials][et_colors][overlay_type]" onchange="Tygh.$('#{$id}_overlay_settings').toggle();">
      <option {if $block_data.overlay_type=="S"}selected="selected"{/if} value="S">Use style settings</option>
      <option {if $block_data.overlay_type=="C"}selected="selected"{/if} value="C">Custom settings</option>
    </select>
  </div>
</div>

<div id="{$id}_overlay_settings" class="{if $block_data.overlay_type|default:"S" != "C"}hidden{/if}">
  <div class="control-group">
    <label class="control-label cm-color">
    {__("et_use_bkg_overlay")}:
    </label>
    <div class="controls checkbox">
      <input type="hidden" name="block_data[testimonials][et_colors][use_bkg_overlay]" value="N"/>
      <input id="sw_use_bkg_overlay" class="cm-combination" name="block_data[testimonials][et_colors][use_bkg_overlay]" type="checkbox" {if (!isset($block_data.use_bkg_overlay)) || $block_data.use_bkg_overlay=="Y"}checked{/if} value="Y">
    </div>
  </div>

  <div id="use_bkg_overlay" class="control-group  {if $block_data.use_bkg_overlay=="N"}hidden{/if}">

    <div class="control-group">
      {$label_name="et_vivashop_settings.overlay"}
      <label class="control-label cm-color" for="elm_overlay">{__($label_name)}:</label>
      <div class="controls">
        <div class="te-colors clearfix">
        {$cp_value = ($block_data.overlay)|default:"#000000"}
          <div class="colorpicker">
            <div class="input-prepend">
              <input type="text"  maxlength="7"  name="block_data[testimonials][et_colors][overlay]" id="elm_overlay" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="control-group">
      {$label_name="et_vivashop_settings.overlay_alpha"}
      <label class="control-label" for="elm_overlay_alpha">{__($label_name)}:</label>
      <div class="controls">
        <input type="text"  maxlength="7"  name="block_data[testimonials][et_colors][overlay_alpha]" id="elm_overlay_alpha" value="{$block_data.overlay_alpha|default:70}" data-ca-view="input" class="input-mini">
      </div>
    </div>
  </div>
</div>

{* Color settings *}
<h4 class="subheader">Color settings:</h4>

<div class="control-group">
    <label class="control-label">
      Additional colors:
    </label>
    <div class="controls">
      <select name="block_data[testimonials][et_colors][additional_colors_type]" onchange="Tygh.$('#{$id}_additional_et_colors').toggle();">
        <option {if $block_data.additional_colors_type=="S"}selected="selected"{/if} value="S">Use style colors</option>
        <option {if $block_data.additional_colors_type=="C"}selected="selected"{/if} value="C">Custom colors</option>
      </select>
    </div>
</div>

{$colors="title_color box_color text_color icon_color icon_bkg"}
{$et_settings=explode(" ",$colors)}

<div id="{$id}_additional_et_colors" class="{if $block_data.additional_colors_type|default:"S" != "C"}hidden{/if}">

  {foreach from=$et_settings item=item key=key name=name}
    <div class="control-group">
      {$label_name="et_vivashop_settings.`$item`"}
      <label class="control-label cm-color" for="elm_{$item}">{__($label_name)}:</label>
      <div class="controls">
        <div class="te-colors clearfix">
        {$cp_value = ($block_data.$item)|default:"#ffffff"}
          <div class="colorpicker">
            <div class="input-prepend">
              <input type="text"  maxlength="7"  name="block_data[testimonials][et_colors][{$item}]" id="elm_{$item}" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
            </div>
          </div>
        </div>
      </div>
    </div>
  {/foreach}
</div>

<style>
.sp-container{
  top: 30px !important;
}
</style>