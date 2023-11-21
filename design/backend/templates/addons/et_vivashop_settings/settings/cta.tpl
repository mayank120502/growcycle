{if $option.values}
  {$block_data=$option.values}
{else}
  {$block_data=$block.properties.et_settings}
  {$image_data=$block.et_additional_settings}
{/if}

<h4 class="subheader">
  {__("et_background_settings")}:
</h4>

<div class="control-group">
  {$label_name="et_vivashop_settings.main_bkg_color"}
  <label class="control-label cm-color" for="elm_main_bkg_color">{__($label_name)}:</label>
  <div class="controls">
    <div class="te-colors clearfix">
    {$cp_value = ($block_data.main_bkg_color)|default:"#ffffff"}
      <div class="colorpicker">
        <div class="input-prepend">
          <input type="text"  maxlength="7"  name="block_data[cta][cta_colors][main_bkg_color]" id="elm_main_bkg_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
        </div>
      </div>
    </div>
  </div>
</div>

<div id="et_block_image_uploader" class="in collapse{if !$runtime.company_id && !fn_allowed_for('MULTIVENDOR') && !$runtime.simple_ultimate} disable-overlay-wrap{/if}">
  <div class="control-group">
    <label class="control-label" for="elm_et_block_bkg">Background image:</label>
    <div class="controls">
      {include file="common/attach_images.tpl" image_name="et_block_bkg" image_object_type="et_block_bkg" image_pair=$image_data.main_pair no_thumbnail=true}
    </div>
  </div>
</div>

<div class="control-group">
  <label class="control-label">
    {__("et_overlay_settings")}:
  </label>
  <div class="controls">
    <select name="block_data[cta][cta_colors][overlay_type]" onchange="Tygh.$('#{$id}_overlay_settings').toggle();">
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
      <input type="hidden" name="block_data[cta][cta_colors][use_bkg_overlay]" value="N"/>
      <input id="sw_use_bkg_overlay" class="cm-combination" name="block_data[cta][cta_colors][use_bkg_overlay]" type="checkbox" {if (!isset($block_data.use_bkg_overlay)) || $block_data.use_bkg_overlay=="Y"}checked{/if} value="Y">
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
              <input type="text"  maxlength="7"  name="block_data[cta][cta_colors][overlay]" id="elm_overlay" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="control-group">
      {$label_name="et_vivashop_settings.overlay_alpha"}
      <label class="control-label" for="elm_overlay_alpha">{__($label_name)}:</label>
      <div class="controls">
        <input type="text"  maxlength="7"  name="block_data[cta][cta_colors][overlay_alpha]" id="elm_overlay_alpha" value="{$block_data.overlay_alpha|default:70}" data-ca-view="input" class="input-mini">
      </div>
    </div>
  </div>
</div>

{* Icons *}
<h4 class="subheader">Icon settings:</h4>

{script src="js/addons/et_mega_menu/func.js"}

{for $i=1 to 3}

<script type="text/javascript">
  (function(_, $) {
    $.ceEvent('on', 'ce.ajaxdone', function(content) {
      x=$('.icp-dd.et-icon-{$i}');
      x.iconpicker({
        templates: {
          iconpickerItem: '<a role="button" href="#" onclick="event.preventDefault();" class="iconpicker-item et-icon-{$i}"><i></i></a>',
        }
      });
      x.on('iconpickerSelected', function (e) {
        $('.picker-target.et-icon-{$i}').val(e.iconpickerValue);
      });
    });
  }(Tygh, Tygh.$));
</script>

<div class="control-group {* controls *} mixed-controls cm-bs-group">
  <label class="control-label" for="elm_et_block_bkg">Icon Step {$i}:</label>
  <div class="controls">
    <div class="">
      
      {* Icon Set Dropdown *}
      {$index="icon_`$i`"}
      {$i_type=$block_data.$index.type|default:"F"}
      <div class="cm-bs-container form-inline clearfix">
        <label class="pull-left">{__("type")}:</label>
        <div class="pull-left">
          <select name="block_data[cta][cta_colors][{$index}][type]" id="et_icon_type" onchange="Tygh.$('#{$id}_et_fa_settings_{$index}').toggle(); Tygh.$('#{$id}_et_custom_settings_{$index}').toggle();Tygh.$('#{$id}_et_icon_value_{$index}').prop('disabled', function(i, v) { return !v; });">
              <option {if !empty($block_data.$index) && $block_data.$index.type=="F"}selected="selected"{/if} value="F">FontAwesome</option>
              <option {if !empty($block_data.$index) && $block_data.$index.type=="C"}selected="selected"{/if} value="C">Custom</option>
          </select>
        </div>
      </div>
    
      <div id="{$id}_et_fa_settings_{$index}" class="{if $i_type != "F"}hidden{/if}">
        {* Icon Picker *}
        <link href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" rel="stylesheet">
    
        <div class="cm-bs-container form-inline clearfix">
          <label class="pull-left">{__("icon")}:</label>
          <div class="btn-group pull-left">
            <button data-selected="graduation-cap" type="button"
                class="icp icp-dd et-icon-{$i} btn btn-default dropdown-toggle iconpicker-component"
                data-toggle="dropdown" >
              <input type="hidden" class="picker-target et-icon-{$i}" name="block_data[cta][cta_colors][{$index}][value]" value="{if $block_data.$index.value && $i_type == "F"} {$block_data.$index.value}{else} fa fa-fw fa-heart{/if}" />
              <i class="{if $block_data.$index.value && $i_type == "F"} {$block_data.$index.value}{else} fa fa-fw fa-heart{/if}"></i>
              <span class="caret"></span>
            </button>
            <div class="dropdown-menu"></div>
          </div>
        </div>
      </div>
    
      <div id="{$id}_et_custom_settings_{$index}" class="{if $i_type != "C"}hidden{/if}">
        <div class="cm-bs-container form-inline clearfix">
          <label class="pull-left">
            {__("et_custom_class")}:
          </label>
          <input type="text" id="{$id}_et_icon_value_{$index}" name="block_data[cta][cta_colors][{$index}][value]" value="{$block_data.$index.value}" class="input-text-large pull-left picker-target et-icon-{$i}" {if $i_type != "C"}disabled{/if}>
        </div>
      </div>
      
      <div class="cm-bs-container form-inline clearfix">
          <label for="et_color_type" class="pull-left">{__("et_icon_color")}:</label>
          <div class="clearfix pull-left">
            <select name="block_data[cta][cta_colors][{$index}][color_type]" id="et_color_type" onchange="Tygh.$('#{$id}_et_icon_color_{$index}_wrapper').toggle();">
              <option {if $block_data.$index.color_type=="S"}selected="selected"{/if} value="S">Use style color</option>
              <option {if $block_data.$index.color_type=="C"}selected="selected"{/if} value="C">Custom color</option>
            </select>
          </div>
      </div>

      {* Color picker *}
      <div class="cm-bs-container form-inline clearfix {if $block_data.$index.color_type|default:"S" != "C"}hidden{/if}" id="{$id}_et_icon_color_{$index}_wrapper">
        <label class="radio pull-left cm-color">
          Custom color:
        </label>
        <div class="te-colors clearfix pull-left">
          {$cp_value = ($block_data.$index.color)|default:"#f6053e"}
          <div class="colorpicker et-picker">
            <div class="input-prepend">
              <input type="text"  maxlength="7"  name="block_data[cta][cta_colors][{$index}][color]" id="et_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
{/for}
{* /Icons *}


{* Additional color settings *}
<h4 class="subheader">
  {__("et_additional_settings")}:
</h4>



<div class="control-group">
    <label class="control-label">
      {__("et_additional_settings")}:
    </label>
    <div class="controls">
      <select name="block_data[cta][cta_colors][additional_colors_type]" onchange="Tygh.$('#{$id}_additional_et_colors').toggle();">
        <option {if $block_data.additional_colors_type=="S"}selected="selected"{/if} value="S">Use style colors</option>
        <option {if $block_data.additional_colors_type=="C"}selected="selected"{/if} value="C">Custom colors</option>
      </select>
    </div>
</div>

{$colors="text_top circles_bkg circles_text circles_steps_txt circles_step_bkg arrow go_btn_bkg go_btn_txt go_btn_bkg_hover go_btn_txt_hover"}
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
            <input type="text"  maxlength="7"  name="block_data[cta][cta_colors][{$item}]" id="elm_{$item}" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
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