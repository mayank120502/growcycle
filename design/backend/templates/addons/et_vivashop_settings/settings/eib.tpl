{$block_data=$block.properties.et_settings}

<h4 class="subheader">
  {__("et_settings")}:
</h4>

<div class="control-group">
  <label class="control-label">{__("et_icon_position")}:</label>
  <div class="controls">
    <select name="block_data[eib][eib_colors][et_icon_position]" class="user-success">
      <option value="T" {if $block_data.et_icon_position=="T"}selected="selected"{/if}>{__('et_top')}</option>
      <option value="L" {if $block_data.et_icon_position=="L"}selected="selected"{/if}>{__('left')}</option>
    </select>
  </div>
</div>

<div class="control-group">
    <label class="control-label">
      {__("et_colors")}:
    </label>
    <div class="controls">
      <select name="block_data[eib][eib_colors][additional_colors_type]" onchange="Tygh.$('#{$id}_additional_et_colors').toggle();">
        <option {if $block_data.additional_colors_type=="S"}selected="selected"{/if} value="S">Use style colors</option>
        <option {if $block_data.additional_colors_type=="C"}selected="selected"{/if} value="C">Custom colors</option>
      </select>
    </div>
</div>

{$colors="main_bkg_color text"}
{$et_settings=explode(" ",$colors)}

<div id="{$id}_additional_et_colors" class="{if $block_data.additional_colors_type|default:"S" != "C"}hidden{/if}">
{foreach from=$et_settings item=item key=key name=name}
  <div class="control-group">
    {if $item=="text"}
      {$label_name="et_vivashop_settings.`$item`_color"}
    {else}
      {$label_name="et_vivashop_settings.`$item`"}
    {/if}
    <label class="control-label cm-color" for="elm_{$item}">{__($label_name)}:</label>
    <div class="controls">
      <div class="te-colors clearfix">
      {$cp_value = ($block_data.$item)|default:"#ffffff"}
        <div class="colorpicker">
          <div class="input-prepend">
            <input type="text"  maxlength="7"  name="block_data[eib][eib_colors][{$item}]" id="elm_{$item}" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
          </div>
        </div>
      </div>
    </div>
  </div>    
{/foreach}
</div>

<h4 class="subheader">
  {__("et_icon_settings")}:
</h4>

{script src="js/addons/et_mega_menu/func.js"}

{for $i=1 to 4}

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

<div class="control-group mixed-controls cm-bs-group">
  <label class="control-label" for="elm_et_block_bkg">Icon {$i}:</label>
  <div class="controls">
    <div class="">
      
      {* Icon Set Dropdown *}
      {$index="icon_`$i`"}
      {$i_type=$block_data.$index.type|default:"F"}
      <div class="cm-bs-container form-inline clearfix">
        <label class="pull-left">{__("type")}:</label>
        <div class="pull-left">
          <select name="block_data[eib][eib_colors][{$index}][type]" id="et_icon_type" onchange="Tygh.$('#{$id}_et_fa_settings_{$index}').toggle(); Tygh.$('#{$id}_et_custom_settings_{$index}').toggle();Tygh.$('#{$id}_et_icon_value_{$index}').prop('disabled', function(i, v) { return !v; });">
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
              <input type="hidden" class="picker-target et-icon-{$i}" name="block_data[eib][eib_colors][{$index}][value]" value="{if $block_data.$index.value && $i_type == "F"} {$block_data.$index.value}{else} fa fa-fw fa-heart{/if}" />
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
          <input type="text" id="{$id}_et_icon_value_{$index}" name="block_data[eib][eib_colors][{$index}][value]" value="{$block_data.$index.value}" class="input-text-large pull-left picker-target et-icon-{$i}" {if $i_type != "C"}disabled{/if}>
        </div>
      </div>

      <div class="cm-bs-container form-inline clearfix">
          <label for="et_color_type" class="pull-left">
            {__("et_colors")}:
          </label>
          <div class="clearfix pull-left">
            <select name="block_data[eib][eib_colors][{$index}][color_type]" id="et_color_type" onchange="Tygh.$('#{$id}_et_icon_color_{$index}_wrapper').toggle();">
              <option {if $block_data.$index.color_type=="S"}selected="selected"{/if} value="S">Use style color</option>
              <option {if $block_data.$index.color_type=="C"}selected="selected"{/if} value="C">Custom color</option>
            </select>
          </div>
      </div>
      
      <div class="{if $block_data.$index.color_type|default:"S" != "C"}hidden{/if}" id="{$id}_et_icon_color_{$index}_wrapper">
        {* Color picker *}
        <div class="cm-bs-container form-inline clearfix">
          <label class="radio pull-left cm-color">{__("et_icon_color")}:
          </label>
          <div class="te-colors clearfix pull-left">
            {$cp_value = ($block_data.$index.color)|default:"#ffffff"}
            <div class="colorpicker et-picker">
              <div class="input-prepend">
                <input type="text"  maxlength="7"  name="block_data[eib][eib_colors][{$index}][color]" id="et_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
              </div>
            </div>
          </div>
        </div>

        {* Background color *}
        <div class="cm-bs-container form-inline clearfix">
          <label class="radio pull-left cm-color">Background color:
          </label>
          <div class="te-colors clearfix pull-left">
            {$cp_value = ($block_data.$index.bkg)|default:"#f6053e"}
            <div class="colorpicker et-picker">
              <div class="input-prepend">
                <input type="text"  maxlength="7"  name="block_data[eib][eib_colors][{$index}][bkg]" id="et_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>
{/for}
{* /Icons *}


<style>
.sp-container{
  top: 30px !important;
}
</style>