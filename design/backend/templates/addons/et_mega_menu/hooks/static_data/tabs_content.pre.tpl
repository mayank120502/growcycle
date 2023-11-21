{if $static_data.parent_id==0}
<div class="cm-tabs-content" id="content_tab_et_menu_{$id}">
  <input type="hidden" name="static_data[et_menu_id]" value="{$static_data.et_menu_id}" />

  {* Custom menu colors *}
  <div class="control-group">
    <label for="et_{$id}_et_menu_color" class="control-label">{__("et_custom_menu_colors")}:</label>
    <div class="controls mixed-controls cm-bs-group">

      {* Show/Hide checkbox *}
      <label for="{$id}_et_menu_color_enabled" class="checkbox clearfix" onchange="Tygh.$('#{$id}_et_menu_color_enabled_sw').toggle();">
        <input type="hidden" name="static_data[et_menu][color][enabled]" value="N" />
        <input type="checkbox" name="static_data[et_menu][color][enabled]"  id="{$id}_et_menu_color_enabled" {if $static_data.et_menu.color.enabled == "Y"}checked="checked"{/if} value="Y">
        <span class="et-v-mid">
          {__("enabled")}
        </span>
      </label>

      <div id="{$id}_et_menu_color_enabled_sw" class="{if $static_data.et_menu.color.enabled != "Y"}hidden{/if}">
        <div class="cm-bs-container form-inline clearfix">
          <div class="1controls pull-left">
            <select name="static_data[et_menu][color][color_type]" id="et_icon_type" class="" onchange="Tygh.$('#{$id}_et_custom_menu_colors').toggle();">
              <option {if $static_data.et_menu.color.color_type=="S"}selected="selected"{/if} value="S">Use style colors</option>
              <option {if $static_data.et_menu.color.color_type=="C"}selected="selected"{/if} value="C">Custom colors</option>
            </select>
          </div>
        </div>

        <div id="{$id}_et_custom_menu_colors" class="{if $static_data.et_menu.color.color_type|default:"S" != "C"}hidden{/if}">


          {* Color picker *}
          <div class="cm-bs-container form-inline clearfix">
            <label class="radio pull-left cm-color">
              {__("et_text_color")}:
            </label>
            <div class="te-colors clearfix pull-left">
              {$cp_value = ($static_data.et_menu.color.color)|default:"#ffffff"}
              <div class="colorpicker et-picker">
                <div class="input-prepend">
                  <input type="text"  maxlength="7"  name="static_data[et_menu][color][color]" id="{$id}_et_menu_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                </div>
              </div>
            </div>
          </div>
          
          {* Background Color picker *}
          <div class="cm-bs-container form-inline clearfix">
            <label class="radio pull-left cm-color">
              {__("et_background_color")}:
            </label>
            <div class="te-colors clearfix pull-left">
              {$cp_value = ($static_data.et_menu.color.bkg)|default:"#000000"}
              <div class="colorpicker et-picker">
                <div class="input-prepend">
                  <input type="text"  maxlength="7"  name="static_data[et_menu][color][bkg]" id="{$id}_et_menu_text_bkg" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>

  {* Icon *}
  <div class="control-group">
    <label for="et_{$id}_et_menu_icon" class="control-label">{__("et_custom_icon_settings")}:</label>
    <div class="controls mixed-controls cm-bs-group">

      {* Show/Hide checkbox *}
      <label for="{$id}_et_menu_icon_enabled" class="checkbox clearfix" onchange="Tygh.$('#{$id}_et_menu_icon_enabled_sw').toggle();">
        <input type="hidden" name="static_data[et_menu][icon][enabled]" value="N" />
        <input type="checkbox" name="static_data[et_menu][icon][enabled]" id="{$id}_et_menu_icon_enabled" {if $static_data.et_menu.icon.enabled == "Y"}checked="checked"{/if} value="Y">
        <span class="et-v-mid">
          {__("enabled")}
        </span>
      </label>

      <div id="{$id}_et_menu_icon_enabled_sw" class="{if $static_data.et_menu.icon.enabled != "Y"}hidden{/if}">
        
        {* Icon Set Dropdown *}
        {$i_type=$static_data.et_menu.icon.type|default:"F"}
        <div class="cm-bs-container form-inline clearfix">
          <label class="pull-left">{__("type")}:</label>
          <div class="pull-left">
            <select name="static_data[et_menu][icon][type]" id="et_icon_type" onchange="Tygh.$('#{$id}_et_fa_settings').toggle(); Tygh.$('#{$id}_et_custom_settings').toggle(); Tygh.$('#{$id}_et_menu_text_value').prop('disabled', function(i, v) { return !v; });">
                <option {if !empty($static_data.et_menu.icon) && $static_data.et_menu.icon.type=="F"}selected="selected"{/if} value="F">FontAwesome</option>
                <option {if !empty($static_data.et_menu.icon) && $static_data.et_menu.icon.type=="C"}selected="selected"{/if} value="C">Custom</option>
            </select>
          </div>
        </div>

        <div id="{$id}_et_fa_settings" class="{if $i_type != "F"}hidden{/if}">
          {* Icon Picker *}
          <link href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" rel="stylesheet">

          <div class="cm-bs-container form-inline clearfix">
            <label class="pull-left">{__("icon")}:</label>
            <div class="btn-group pull-left">
              <button data-selected="graduation-cap" type="button"
                  class="icp icp-dd btn btn-default dropdown-toggle iconpicker-component"
                  data-toggle="dropdown" >
                <input type="hidden" class="picker-target" name="static_data[et_menu][icon][value]" value="{if $static_data.et_menu.icon.value && $i_type == "F"} {$static_data.et_menu.icon.value}{else} fa fa-fw fa-heart{/if}" />
                <i class="{if $static_data.et_menu.icon.value && $i_type == "F"} {$static_data.et_menu.icon.value}{else} fa fa-fw fa-heart{/if}"></i>
                <span class="caret"></span>
              </button>
              <div class="dropdown-menu"></div>
            </div>
          </div>
        </div>

        <div id="{$id}_et_custom_settings" class="{if $i_type != "C"}hidden{/if}">
          <div class="cm-bs-container form-inline clearfix">
            <label class="pull-left">
              {__("et_custom_class")}:
            </label>
            <input type="text" id="{$id}_et_menu_text_value" name="static_data[et_menu][icon][value]" value="{$static_data.et_menu.icon.value}" class="input-text-large pull-left picker-target" {if $i_type != "C"}disabled{/if}>
          </div>
        </div>

        {* Color *}
        <div class="cm-bs-container form-inline clearfix">
            <label for="et_icon_type" class="pull-left">
              {__("et_icon_color")}:
            </label>
            <div class="1controls pull-left">
              <select name="static_data[et_menu][icon][color_type]" id="et_icon_type" class="" onchange="Tygh.$('#{$id}_et_icon_custom_color').toggle();">
                <option {if !empty($static_data.et_menu.icon) && $static_data.et_menu.icon.color_type=="S"}selected="selected"{/if} value="S">Inherit color</option>
                <option {if !empty($static_data.et_menu.icon) && $static_data.et_menu.icon.color_type=="C"}selected="selected"{/if} value="C">Custom color</option>
              </select>
            </div>
        </div>
        
        {* Color picker *}
        <div class="cm-bs-container form-inline clearfix {$static_data.et_menu.icon.color_type|default:"S"} {if $static_data.et_menu.icon.color_type|default:"S" != "C"}hidden{/if}" id="{$id}_et_icon_custom_color">
          <label class="radio pull-left cm-color">
            {__("et_custom_color")}:
          </label>
          <div class="te-colors clearfix pull-left">
            {$cp_value = ($static_data.et_menu.icon.color)|default:"#000000"}
            <div class="colorpicker et-picker">
              <div class="input-prepend">
                <input type="text"  maxlength="7"  name="static_data[et_menu][icon][color]" id="et_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>

  {* Text *}
  <div class="control-group">
    <label for="et_{$id}_et_menu_text" class="control-label">{__("et_custom_label_settings")} {include file="common/tooltip.tpl" tooltip=__("et_custom_label_settings_tooltip")}:</label>
    <div class="controls mixed-controls cm-bs-group">
      
      {* Show/Hide checkbox *}
      <label for="{$id}_et_menu_text_enabled" class="checkbox clearfix" onchange="Tygh.$('#{$id}_et_menu_text_enabled_sw').toggle();">
        <input type="hidden" name="static_data[et_menu][text][enabled]" value="N" />
        <input type="checkbox" name="static_data[et_menu][text][enabled]" id="{$id}_et_menu_text_enabled" {if $static_data.et_menu.text.enabled == "Y"}checked="checked"{/if} value="Y">
        <span class="et-v-mid">
          {__("enabled")}
        </span>
      </label>

      <div id="{$id}_et_menu_text_enabled_sw" class="{if $static_data.et_menu.text.enabled != "Y"}hidden{/if}">
        
        {* Text input *}
        <div class="cm-bs-container form-inline clearfix">
          <label class="radio pull-left">
            {__("et_label_text")}:
          </label>
          <input type="text" id="{$id}_et_menu_text_value" name="static_data[et_menu][text][value]" value="{$static_data.et_menu.text.value}" class="input-text-large pull-left" />
        </div>

        <div class="cm-bs-container form-inline clearfix">
            <label for="et_icon_type" class="pull-left">
              {__("et_label_colors")}:
            </label>
            <div class="1controls pull-left">
              <select name="static_data[et_menu][text][color_type]" id="et_icon_type" class="" onchange="Tygh.$('#{$id}_et_custom_label_colors').toggle();">
                <option {if $static_data.et_menu.text.color_type=="S"}selected="selected"{/if} value="S">Use style colors</option>
                <option {if $static_data.et_menu.text.color_type=="C"}selected="selected"{/if} value="C">Custom colors</option>
              </select>
            </div>
        </div>

        <div id="{$id}_et_custom_label_colors" class="{if $static_data.et_menu.text.color_type|default:"S" != "C"}hidden{/if}">
          {* Color picker *}
          <div class="cm-bs-container form-inline clearfix">
            <label class="radio pull-left cm-color">{__("et_label_color")}:
            </label>
            <div class="te-colors clearfix pull-left">
              {$cp_value = ($static_data.et_menu.text.color)|default:"#ffffff"}
              <div class="colorpicker et-picker">
                <div class="input-prepend">
                  <input type="text"  maxlength="7"  name="static_data[et_menu][text][color]" id="{$id}_et_menu_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                </div>
              </div>
            </div>
          </div>
          
          {* Background Color picker *}
          <div class="cm-bs-container form-inline clearfix">
            <label class="radio pull-left cm-color">{__("et_background_color")}:
            </label>
            <div class="te-colors clearfix pull-left">
              {$cp_value = ($static_data.et_menu.text.bkg)|default:"#000000"}
              <div class="colorpicker et-picker">
                <div class="input-prepend">
                  <input type="text"  maxlength="7"  name="static_data[et_menu][text][bkg]" id="{$id}_et_menu_text_bkg" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>


<!--content_tab_et_menu_{$id}--></div>

{script src="js/addons/et_mega_menu/func.js"}
<script type="text/javascript">
  (function(_, $) {
    $.ceEvent('on', 'ce.ajaxdone', function(content) {
      $('.icp-dd').iconpicker({
        templates: {
          iconpickerItem: '<a role="button" href="#" onclick="event.preventDefault();" class="iconpicker-item"><i></i></a>',
        }
      });
      $('.icp-dd').on('iconpickerSelected', function (e) {
        $('.picker-target').val(e.iconpickerValue);
      });
    });
  }(Tygh, Tygh.$));
</script>
{/if}