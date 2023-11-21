{if (fn_allowed_for('ULTIMATE') && $runtime.company_id) || $runtime.simple_ultimate || fn_allowed_for('MULTIVENDOR')}
<div class="hidden" id="content_et_menu">


<input type="hidden" name="category_data[et_menu][et_menu_id]" value="{$et_menu.et_menu_id}">

{if ($category_data.parent_id==0)}
  {if count(fn_seo_get_active_languages())>1}
    <div class="control-group">
      <label class="control-label">
        {__("et_update_for_all_languages")}:
      </label>
      <div class="controls">
        <input type="hidden" name="category_data[et_menu][update_all_langs]" value="N" checked="checked"/>
        <input type="checkbox" name="category_data[et_menu][update_all_langs]" value="Y"/>
      </div>
    </div>
  {/if}

  {* Menu Settings *}
  {include file="common/subheader.tpl" title="{__("et_mega_menu.size_settings")}" target="#et_menu_setting"}

  <div id="et_menu_setting" class="in collapse">

    {* Menu width settings *}
    <div class="control-group">
      <label for="et_menu_width" class="control-label">
        {__("et_width")}:
      </label>
      <div class="controls">
        <input type="text" name="category_data[et_menu][size][width]" size="10" maxlength="4" value="{$et_menu.size.width|default:"0"}" class="input-color">
        <span> &nbsp; px</span>
      </div>
    </div>
    
    {* Menu min height settings *}
    <div class="control-group">
      <label for="et_menu_min_height" class="control-label">
        {__("et_min_height")}:
      </label>
      <div class="controls">
        <input type="text" name="category_data[et_menu][size][height]" size="10" maxlength="4" value="{$et_menu.size.height|default:"0"}" class="input-color">
        <span> &nbsp; px</span>
      </div>
    </div>
  </div>

  {* Menu subcategories thumbnails *}
  {include file="common/subheader.tpl" title="{__("et_mega_menu.subcategory_thumbnails")}" target="#et_menu_thumb_setting"}

  <div id="et_menu_thumb_setting" class="in collapse">
    <div class="control-group">
      <label class="control-label" for="et_menu_thumbnails_enabled">
        {__("enabled")}:
      </label>
      <div class="controls checkbox">
        <input type="hidden" name="category_data[et_menu][thumbnails][enabled]" value="N" />
        <input type="checkbox" name="category_data[et_menu][thumbnails][enabled]" id="et_menu_thumbnails_enabled" value="Y" {if $et_menu.thumbnails.enabled == "Y"}checked="checked"{/if}>
      </div>
    </div>
  </div>
    

  {* Menu Icon *}
  {include file="common/subheader.tpl" title="{__("et_mega_menu.icon_settings")}" target="#et_menu_icon_setting"}

  <div id="et_menu_icon_setting" class="in collapse">
    {$i_type=$et_menu.icon.type|default:"G"}

    <div class="control-group">
      <label class="control-label" for="et_menu_icon_enabled">
        {__("enabled")}:
      </label>
      <div class="controls checkbox">
        <input type="hidden" name="category_data[et_menu][icon][enabled]" value="N" />
        <input type="checkbox" name="category_data[et_menu][icon][enabled]" id="et_menu_icon_enabled" value="Y" {if $et_menu.icon.enabled == "Y"}checked="checked"{/if} onchange="Tygh.$('#et_menu_icon_toggle').toggle();">
      </div>
    </div>


    <div id="et_menu_icon_toggle" class="{if $et_menu.icon.enabled|default:"N" != "Y"}hidden{/if}">

      {* Type *}
      <div class="control-group">
        <label for="et_icon_type" class="control-label">
          {__("type")}:
        </label>
        <div class="controls">
          <select name="category_data[et_menu][icon][type]" id="et_icon_type" {* onchange="Tygh.$('#et_menu_icon_img').toggle(); Tygh.$('#et_menu_icon_icon').toggle();" *}>
            <option {if !empty($et_menu.icon) && $et_menu.icon.type=="G"}selected="selected"{/if} value="G">Image</option>
            <option {if !empty($et_menu.icon) && $et_menu.icon.type=="I"}selected="selected"{/if} value="I">FontAwesome Icon</option>
            <option {if !empty($et_menu.icon) && $et_menu.icon.type=="C"}selected="selected"{/if} value="C">Custom Icon</option>
          </select>
        </div>
      </div>
      
      {* Image *}
      <div class="et_icon_options G {if $i_type != "G"}hidden{/if}" id="et_menu_icon_img">
        <div class="control-group">
          <label class="control-label">
            {__("image")}:
          </label>
          <div class="controls">
            {include file="common/attach_images.tpl" image_name="et_menu_icon" image_object_type="et_menu_icon" image_pair=$et_menu.icon.img no_detailed=true hide_titles=true}
          </div>
        </div>

        <div class="control-group">
          <label class="control-label">
            {__("et_hover_image")}:
          </label>
          <div class="controls">
            {include file="common/attach_images.tpl" image_name="et_menu_icon_hover" image_object_type="et_menu_icon_hover" image_pair=$et_menu.icon.img_hover no_detailed=true hide_titles=true}
          </div>
        </div>
      </div>

      {* Icon *}
      <div class="et_icon_options I C {if $i_type != "I" && $i_type != "C"}hidden{/if}" id="et_menu_icon_icon">
        <div class="control-group et_icon_options I {if $i_type != "I"}hidden{/if}">
          {* Icon Picker *}
          <link href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" rel="stylesheet">

          <label class="control-label">
            {__("icon")}:
          </label>
          <div class="controls">
            <button data-selected="graduation-cap" type="button" class="icp icp-dd btn btn-default dropdown-toggle iconpicker-component" data-toggle="dropdown" >
              <input type="hidden" class="picker-target" name="category_data[et_menu][icon][value]" value="{if !empty($et_menu.icon) && $et_menu.icon.value} {$et_menu.icon.value}{else} fa fa-fw fa-heart{/if}" />
                <i class="{if !empty($et_menu.icon) && $et_menu.icon.value} {$et_menu.icon.value}{else} fa fa-fw fa-heart{/if}"></i>
                <span class="caret"></span>
            </button>
            <div class="dropdown-menu"></div>
          </div>
        </div>

        <div class="control-group et_icon_options C {if $i_type != "C"}hidden{/if}">
          <label class="control-label">
            {__("et_custom_class")}:
          </label>
          <div class="controls">
            <input type="text" id="{$id}_et_menu_text_value" name="category_data[et_menu][icon][value]" value="{if !empty($et_menu.icon) && $et_menu.icon.value} {$et_menu.icon.value|trim}{/if}" class="input-text-large pull-left picker-target et_custom_icon_input" {if $i_type != "C"}disabled{/if}>
          </div>
        </div>

        {* Color *}
        <div class="control-group">
            <label for="et_color_type" class="control-label">
              {__("color")}:
            </label>
            <div class="controls">
              <select name="category_data[et_menu][icon][color_type]" id="et_color_type" onchange="Tygh.$('#et_custom_color').toggle();">
                <option {if !empty($et_menu.icon) && $et_menu.icon.color_type=="S"}selected="selected"{/if} value="S">Use style color</option>
                <option {if !empty($et_menu.icon) && $et_menu.icon.color_type=="C"}selected="selected"{/if} value="C">Custom color</option>
              </select>
            </div>
        </div>

        {* Color picker *}
        <div class="control-group {if $et_menu.icon.color_type|default:"S" != "C"}hidden{/if}" id="et_custom_color">
          <div class="clearfix">
            <label class="control-label cm-color">
              {__("et_custom_color")}:
            </label>
            <div class="controls">
              <div class="te-colors clearfix">
                {$cp_value = ($et_menu.icon.color)|default:"#ffffff"}
                <div class="colorpicker et-picker">
                  <div class="input-prepend">
                    <input type="text"  maxlength="7"  name="category_data[et_menu][icon][color]" id="et_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>

  </div>
{/if}

  {* Menu Text *}

  {include file="common/subheader.tpl" title="{__("et_mega_menu.category_settings")}" target="#et_menu_text_setting"}
  <div id="et_menu_text_setting" class="in collapse">
    {* Label *}
    <div class="control-group">
      <label for="et_{$id}_et_menu_text" class="control-label">
        {__("et_category_label")}:
      </label>
      <div class="controls mixed-controls cm-bs-group">
          
        {* Enabled checkbox *}
        <label for="{$id}_et_menu_text_enabled" class="checkbox clearfix">
          <input type="hidden" name="category_data[et_menu][text][enabled]" value="N" />
          <input type="checkbox" name="category_data[et_menu][text][enabled]" id="{$id}_et_menu_text_enabled" {if !empty($et_menu.text) && $et_menu.text.enabled == "Y"}checked="checked"{/if} value="Y" onchange="Tygh.$('#et_menu_label_toggle').toggle();">{__("enabled")}
        </label>

        <div id="et_menu_label_toggle" class="{if $et_menu.text.enabled|default:"N" != "Y"}hidden{/if}">
          {* Text input *}
          <div class="cm-bs-container form-inline clearfix">
            <label class="radio pull-left">
              {__("text")}:
            </label>
            <input type="text" id="{$id}_et_menu_text_value" name="category_data[et_menu][text][label]" value="{$et_menu.text.label|default:""}" class="input-text-large pull-left" />
          </div>

          {if ($category_data.parent_id==0)}
            <div class="cm-bs-container form-inline clearfix">
                <label class="pull-left">
                  {__("et_label_colors")}:
                </label>
                <div class="1controls pull-left">
                  <select name="category_data[et_menu][text][color_type]" onchange="Tygh.$('#et_custom_label_colors').toggle();">
                    <option {if $et_menu.text.color_type=="S"}selected="selected"{/if} value="S">Use style colors</option>
                    <option {if $et_menu.text.color_type=="C"}selected="selected"{/if} value="C">Custom colors</option>
                  </select>
                </div>
            </div>
          {/if}

          {if ($category_data.parent_id==0)}
            <div id="et_custom_label_colors" class="{if $et_menu.text.color_type|default:"S" != "C"}hidden{/if}">
          {/if}          
              {* Color picker *}
              <div class="cm-bs-container form-inline clearfix">
                <label class="radio pull-left cm-color">{__("et_text_color")}:
                </label>
                <div class="te-colors clearfix pull-left">
                  {$cp_value = ($et_menu.text.color)|default:"#ffffff"}
                  <div class="colorpicker et-picker">
                    <div class="input-prepend">
                      <input type="text"  maxlength="7"  name="category_data[et_menu][text][color]" id="{$id}_et_menu_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                    </div>
                  </div>
                </div>
              </div>
            
              {* Background Color picker *}
              <div class="cm-bs-container form-inline clearfix">
                <label class="radio pull-left cm-color">{__("et_background_color")}:
                </label>
                <div class="te-colors clearfix pull-left">
                  {$cp_value = ($et_menu.text.bkg)|default:"#000000"}
                  <div class="colorpicker et-picker">
                    <div class="input-prepend">
                      <input type="text"  maxlength="7"  name="category_data[et_menu][text][bkg]" id="{$id}_et_menu_text_bkg" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                    </div>
                  </div>
                </div>
              </div>
          {if ($category_data.parent_id==0)}
            </div>
          {/if}
        </div>

      </div>
    </div>

  {if ($category_data.parent_id==0)}

    {* Mini description *}
    <div class="control-group">
      <label for="et_menu_descr" class="control-label">
        {__("et_short_description")}: 
      </label>
      <div class="controls">
        <input type="text" id="et_menu_descr" name="category_data[et_menu][text][descr]" size="10" value="{$et_menu.text.descr|default:""}" class="input-large">
      </div>
    </div>
  {/if}

  </div>

{if ($category_data.parent_id==0)}
  {* Menu Banner *}
  {include file="common/subheader.tpl" title="{__("et_mega_menu.banner_settings")}" target="#et_menu_image_setting"}

  <div id="et_menu_image_setting" class="in collapse">

    {* Enabled settings *}
    <div class="control-group">
      <label class="control-label" for="et_menu_image_status">
        {__("enabled")}:
      </label>
      <div class="controls checkbox">
        <input type="hidden" name="category_data[et_menu][banner][enabled]" value="N" />
        <input type="checkbox" name="category_data[et_menu][banner][enabled]" id="et_menu_image_status" value="Y" {if $et_menu.banner.enabled == "Y"}checked="checked"{/if} onchange="Tygh.$('#et_menu_banner_toggle').toggle();">
      </div>
    </div>

    <div id="et_menu_banner_toggle" class="{if $et_menu.banner.enabled|default:"N" != "Y"}hidden{/if}">
      {* Image *}
      <div class="control-group">
        <label class="control-label">
          {__("image")}:
        </label>
        <div class="controls">
          {include file="common/attach_images.tpl" image_name="et_menu_image" image_object_type="et_menu_image" image_pair=$et_menu.banner.img no_detailed=true hide_titles=true}
        </div>
      </div>

      {* URL *}
      <div class="control-group">
        <label for="et_menu_image_url" class="control-label">
          {__("url")}:
        </label>
        <div class="controls">
          <input type="text" id="et_menu_image_url" name="category_data[et_menu][banner][url]" size="10" value="{$et_menu.banner.url|default:""}" class="input-large">
        </div>
      </div>
  
      {* Push menu items *}
      <div class="control-group">
        <label class="control-label" for="et_menu_image_push_menu_items">
          {__("et_push_items")}: 
        </label>
        <div class="controls checkbox">
          <input type="hidden" name="category_data[et_menu][banner][push_menu]" value="N" />
          <input type="checkbox" name="category_data[et_menu][banner][push_menu]" id="et_menu_image_push_menu_items" value="Y" {if $et_menu.banner.push_menu == "Y"}checked="checked"{/if}>
        </div>
      </div>

      {* Offset Image settings *}
      <div class="control-group">
        <label for="et_menu_image_offset_right" class="control-label">
          {__("et_offset_right")}:
        </label>
        <div class="controls">
          <input type="text" id="et_menu_image_offset_right" name="category_data[et_menu][banner][offset_right]" size="10" maxlength="4" value="{$et_menu.banner.offset_right|default:"0"}" class="input-micro">
          <span> &nbsp; px</span>
        </div>
      </div>

      <div class="control-group">
        <label for="image_height" class="control-label">
          {__("et_offset_bottom")}:
        </label>
        <div class="controls">
          <input type="text" id="et_menu_image_offset_bottom" name="category_data[et_menu][banner][offset_bottom]" size="10" maxlength="4" value="{$et_menu.banner.offset_bottom|default:"0"}" class="input-micro">
          <span> &nbsp; px</span>
        </div>
      </div>
    </div>
  </div>
  {hook name="et_mega_menu:categories"}
  {/hook}

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
    $("#et_icon_type").change(function(){
      var selected = $(this).children("option:selected").val();

      $(".et_icon_options").addClass('hidden');
      $(".et_icon_options."+selected).removeClass('hidden');
      if (selected=="C"){
        $(".et_custom_icon_input").attr("disabled",false);
      }else{
        $(".et_custom_icon_input").attr("disabled",true);
      }
    })
  }(Tygh, Tygh.$));
</script>
{/if}

</div>
{/if}