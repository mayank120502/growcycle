{script src="js/tygh/tabs.js"}

{capture name="mainbox"}
{$block_id=0}
{if $block.block_id}
  {$block_id=$block.block_id}
{/if}

<form action="{""|fn_url}" method="post" name="update_block_form_{$block_id}" class="form-horizontal form-edit cm-disable-empty-files {$hide_inputs_class}" enctype="multipart/form-data">
  <input type="hidden" class="cm-no-hide-input" name="block_data[block_id]" value="{$block.block_id}" />
  <input type="hidden" class="cm-no-hide-input" name="block_id" value="{$block.block_id}" />
  <input type="hidden" class="cm-no-hide-input" name="redirect_url" value="{$return_url|default:$smarty.request.return_url}" />
  <input type="hidden" class="cm-no-hide-input" name="selected_section" value="{$smarty.request.selected_section|default:"detailed"}" />
  
  {if count(fn_seo_get_active_languages())>1}
    <div class="control-group">
      <label class="control-label">
        {__("et_update_for_all_languages")}:
      </label>
      <div class="controls">
        <input type="hidden" name="block_data[update_all_langs]" value="N" checked="checked"/>
        <input type="checkbox" name="block_data[update_all_langs]" value="Y"/>
      </div>
    </div>
  {/if}
  
  <fieldset>
    <h4 class="subheader  ">
      {__("general_settings")}
    </h4>

    {* Title *}
    <div class="control-group">
      <label class="control-label cm-required" for="elm_block_title_{$block_id}">
        {__("title")} <a class="cm-tooltip" title="{__("et_language_specific")}"><i class="icon-question-sign"></i></a>:
      </label>
      <div class="controls">
        <input class="input-long" type="text" name="block_data[title]" value="{$block.data.title}" id="elm_block_title_{$block_id}" />
      </div>
    </div>

    {* Position *}
    <div class="control-group">
      <label class="control-label" for="elm_pp_position_{$id}">{__("position")}</label>
      <div class="controls">
        <input class="input-micro" type="text" name="block_data[position]" value="{$block.position}" id="elm_pp_position_{$id}" />
      </div>
    </div>

    {* Type *}
    <div class="control-group">
        <label for="elm_pp_type" class="control-label cm-required">{__("type")}</label>
        <div class="controls">
        <select name="block_data[settings][type]" id="elm_pp_type" onchange="Tygh.$('#accordeon_expanded').toggle(); ">
            <option {if $block.settings.type == "P"}selected="selected"{/if} value="P">Popup</option>
            <option {if $block.settings.type == "A"}selected="selected"{/if} value="A">Dropdown</option>
        </select>
        </div>
    </div>

    {* Opened *}
    <div class="control-group {if $block.settings.type != "A"}hidden{/if}" id="accordeon_expanded">
      <label class="control-label cm-color">
        {__("et_pp_info_expanded")}:
      </label>
      <div class="controls">

        <label for="{$id}_et_quick_info_expanded" class="checkbox clearfix">
          <input type="hidden" name="block_data[settings][expanded][enabled]" value="N" />
          <input type="checkbox" name="block_data[settings][expanded][enabled]" id="{$id}_et_quick_info_expanded" {if $block.settings.expanded.enabled == "Y"}checked="checked"{/if} value="Y">
        </label>
      </div>
    </div>

    {if "MULTIVENDOR"|fn_allowed_for}
     
      {* Required *}
      <div class="control-group">
        <label class="control-label cm-color">
          {__("required")}:
        </label>
        <div class="controls">

          <label for="{$id}_pp_req" class="checkbox clearfix">
            <input type="hidden" name="block_data[settings][required][enabled]" value="N" />
            <input type="checkbox" name="block_data[settings][required][enabled]" id="{$id}_pp_req" {if $block.settings.required.enabled == "Y"}checked="checked"{/if} value="Y">
          </label>
        </div>
      </div>
    {else}
      <input type="hidden" name="block_data[settings][required][enabled]" value="N" />
    {/if}

    {* Text for Ultimate*}
    {if "ULTIMATE"|fn_allowed_for}
      {assign var="company" value=$runtime.company_id}

      {if !($company)}
        {$company=fn_get_default_company_id()}
      {/if}

      <input type="hidden" name="block_data[company_id]" value="{$company}" />
      <input type="hidden" name="block_data[content_id]" value="{$block.data.content_id}" />

      <div class="control-group">
        <label class="control-label cm-required" for="elm_page_descr">
          {__("description")} <a class="cm-tooltip" title="{__("et_language_specific")}"><i class="icon-question-sign"></i></a>:
        </label>
        <div class="controls">
          <textarea id="elm_page_descr"
                    name="block_data[text]"
                    cols="55"
                    rows="8"
                    class="cm-wysiwyg input-large"
          >{$block.data.text}</textarea>
        </div>
      </div>
    {/if}

    <h4 class="subheader  ">
      {__("et_pp_info_icon_and_color_settings")}
    </h4>

    {* Icon *}
    <div class="control-group">
      <label for="et_{$id}_et_menu_icon" class="control-label">{__("et_pp_info_use_icon")}:</label>
      <div class="controls mixed-controls cm-bs-group">

        {* Show/Hide checkbox *}
        <label for="{$id}_et_menu_icon_enabled" class="checkbox clearfix" onchange="Tygh.$('#{$id}_et_menu_icon_enabled_sw').toggle();">
          <input type="hidden" name="block_data[settings][icon][enabled]" value="N" />
          <input type="checkbox" name="block_data[settings][icon][enabled]" id="{$id}_et_menu_icon_enabled" {if $block.settings.icon.enabled == "Y"}checked="checked"{/if} value="Y">
        </label>

        <div id="{$id}_et_menu_icon_enabled_sw" class="{if $block.settings.icon.enabled != "Y"}hidden{/if}">
          
          {* Icon Set Dropdown *}
          {$i_type=$block.settings.icon.type|default:"F"}
          <div class="cm-bs-container form-inline clearfix">
            <label class="pull-left">{__("type")}:</label>
            <div class="pull-left">
              <select name="block_data[settings][icon][type]" id="et_icon_type" onchange="Tygh.$('#{$id}_et_fa_settings').toggle(); Tygh.$('#{$id}_et_custom_settings').toggle(); Tygh.$('#{$id}_et_menu_text_value').prop('disabled', function(i, v) { return !v; });">
                  <option {if !empty($block.settings.icon) && $block.settings.icon.type=="F"}selected="selected"{/if} value="F">FontAwesome</option>
                  <option {if !empty($block.settings.icon) && $block.settings.icon.type=="C"}selected="selected"{/if} value="C">Custom</option>
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
                  <input type="hidden" class="picker-target" name="block_data[settings][icon][value]" value="{if $block.settings.icon.value && $i_type == "F"} {$block.settings.icon.value}{else} fa fa-fw fa-heart{/if}" />
                  <i class="{if $block.settings.icon.value && $i_type == "F"} {$block.settings.icon.value}{else} fa fa-fw fa-heart{/if}"></i>
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
              <input type="text" id="{$id}_et_menu_text_value" name="block_data[settings][icon][value]" value="{$block.settings.icon.value}" class="input-text-large pull-left picker-target" {if $i_type != "C"}disabled{/if}>
            </div>
          </div>
          
          <div class="cm-bs-container form-inline clearfix">
            <label class="pull-left">
              Icon colors:
            </label>
            <div class="1controls pull-left">
              <select name="block_data[settings][icon][color_type]" onchange="Tygh.$('#et_custom_icon_colors').toggle();">
                <option {if $block.settings.icon.color_type=="S"}selected="selected"{/if} value="S">Use style colors</option>
                <option {if $block.settings.icon.color_type=="C"}selected="selected"{/if} value="C">Custom colors</option>
              </select>
            </div>
          </div>

          <div id="et_custom_icon_colors" class="{if $block.settings.icon.color_type|default:"S" != "C"}hidden{/if}">
            {* Color picker *}
            <div class="cm-bs-container form-inline clearfix">
              <label class="radio pull-left cm-color">{__("et_icon_color")}:
              </label>
              <div class="te-colors clearfix pull-left">
                {$cp_value = ($block.settings.icon.color)|default:"#ffffff"}
                <div class="colorpicker et-picker">
                  <div class="input-prepend">
                    <input type="text"  maxlength="7"  name="block_data[settings][icon][color]" id="et_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                  </div>
                </div>
              </div>
            </div>

            {* Color hover picker *}
            <div class="cm-bs-container form-inline clearfix">
              <label class="radio pull-left cm-color">
                {__("et_icon_color_hover")}:
                {* Icon color hover: *}
              </label>
              <div class="te-colors clearfix pull-left">
                {$cp_value = ($block.settings.icon.color_hover)|default:"#000000"}
                <div class="colorpicker et-picker">
                  <div class="input-prepend">
                    <input type="text"  maxlength="7"  name="block_data[settings][icon][color_hover]" id="et_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        Block colors:
      </label>
      <div class="controls">
        <select name="block_data[settings][color_type]" onchange="Tygh.$('#et_custom_block_colors').toggle();">
          <option {if $block.settings.color_type=="S"}selected="selected"{/if} value="S">Use style colors</option>
          <option {if $block.settings.color_type=="C"}selected="selected"{/if} value="C">Custom colors</option>
        </select>
      </div>
    </div>

    <div id="et_custom_block_colors" class="{if $block.settings.color_type|default:"S" != "C"}hidden{/if}">
      {* Block title color *}
      <div class="control-group">
        <label class="control-label cm-color">
          {__("et_block_title_color")}:
        </label>
        <div class="controls">
          <div class="te-colors clearfix">
            {$cp_value = ($block.settings.color)|default:"#ffffff"}
            <div class="colorpicker et-picker">
              <div class="input-prepend">
                <input type="text" maxlength="7" name="block_data[settings][color]" id="block_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
              </div>
            </div>
          </div>
        </div>
      </div>

      {* Block title background *}
      <div class="control-group">
        <label class="control-label cm-color">
          {__("et_block_title_background")}:
          {* Block title background: *}
        </label>
        <div class="controls">
          <div class="te-colors clearfix">
            {$bkg_cp_value = ($block.settings.bkg_color)|default:"#000000"}
            <div class="colorpicker et-picker">
              <div class="input-prepend">
                <input type="text" maxlength="7" name="block_data[settings][bkg_color]" id="block_bkg_color" value="{$bkg_cp_value}" data-ca-view="input" class="cm-colorpicker ">
              </div>
            </div>
          </div>
        </div>
      </div>

      {* Block title color Hover *}
      <div class="control-group">
        <label class="control-label cm-color">
          {__("et_block_title_color_hover")}:
          {* Block title hover color: *}
        </label>
        <div class="controls">
          <div class="te-colors clearfix">
            {$cp_value_hover = ($block.settings.color_hover)|default:"#000000"}
            <div class="colorpicker et-picker">
              <div class="input-prepend">
                <input type="text" maxlength="7" name="block_data[settings][color_hover]" id="block_color_hover" value="{$cp_value_hover}" data-ca-view="input" class="cm-colorpicker ">
              </div>
            </div>
          </div>
        </div>
      </div>

      {* Block title background Hover *}
      <div class="control-group">
        <label class="control-label cm-color">
          {__("et_block_title_background_hover")}:
          {* Block title background hover: *}
        </label>
        <div class="controls">
          <div class="te-colors clearfix">
            {$bkg_cp_value_hover = ($block.settings.bkg_color_hover)|default:"#ffffff"}
            <div class="colorpicker et-picker">
              <div class="input-prepend">
                <input type="text" maxlength="7" name="block_data[settings][bkg_color_hover]" id="block_bkg_color_hover" value="{$bkg_cp_value_hover}" data-ca-view="input" class="cm-colorpicker ">
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

      

    </fieldset>
  
  
  {capture name="buttons"}
    {include file="buttons/save_cancel.tpl" but_role="submit-link" but_name="dispatch[et_quick_info.update]" but_target_form="update_block_form_{$block_id}" save=$block_id}
  {/capture}
</form>
{/capture}

{if !$in_popup}
  {* {notes}
    {__("block_details_notes", ["[layouts_href]" => fn_url('et_featured_product_banner_tabs.note')])}
  {/notes} *}
{/if}

{if $block.data.title}
  {$title="{__("editing")}: `$block.data.title`"}
{else}
  {$title=__("et_quick_info.new_block")}
{/if}
{include file="common/mainbox.tpl" title="{$title}" content=$smarty.capture.mainbox buttons=$smarty.capture.buttons select_languages=true}



{script src="js/addons/et_quick_info/func.js"}
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