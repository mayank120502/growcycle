{if $show_enabled}

{if $banner.et_settings.$name.enabled|default:"N"=="Y"}
  {$enabled=true}
{else}
  {$enabled=false}

  {* copy from desktop *}
  {if $name=="phone"}
    {if !empty($banner.et_text)}
      {$banner.et_text.phone=$banner.et_text.desktop|default:array() scope=global}
    {/if}

    {$banner.et_settings.phone=$banner.et_settings.desktop|default:array() scope=global}
    {$banner.et_settings.phone.enabled="N" scope=global}
    {$banner.et_settings.phone.additional=array() scope=global}

    {$banner.et_settings.phone.target=$banner.target|default:"" scope=global}
    {$banner.et_settings.phone.url=$banner.url|default:"" scope=global}

  {* copy from phone *}
  {else if $name=="tablet"}
    {if !empty($banner.et_text)}
      {$banner.et_text.tablet=$banner.et_text.phone|default:array()}
    {/if}
    {$banner.et_settings.tablet=$banner.et_settings.phone|default:array()}

    {$banner.et_settings.tablet.enabled="N"}
    {$banner.et_settings.tablet.additional=array()}
    {$banner.et_settings.$name.main_pair=array()}
  {/if}

{/if}

{* Enabled *}
<div class="cm-bs-container">
  <div class="control-group" id="">
    <label class="control-label" for="">{__("enable")}</label>
    <div class="controls">
      <input type="hidden" name="banner_data[et_settings][{$name}][enabled]" value="N" />
      <input type="checkbox" name="banner_data[et_settings][{$name}][enabled]" class="cm-bs-trigger" id="" value="Y" {if $banner.et_settings.$name.enabled|default:"N" == "Y"}checked="checked"{/if} />
    </div>
  </div>

  <div class="cm-bs-block disable-overlay-wrap">

    {include file="common/subheader.tpl" title="{__("image")}" target="#et_image_{$name}" }
    <div id="et_image_{$name}" class="in">

      <div class="control-group" id="">
        <label class="control-label">{__("image")}</label>
        <div class="controls">
          {include file="common/attach_images.tpl"
            image_name="et_banners_`$name`"
            image_object_type="et_promo_`$name`"
            image_pair=$banner.et_settings.$name.main_pair|default:""
            image_object_id=$id
            no_detailed=true
            hide_titles=true
          }
        </div>
      </div>

      <div class="control-group">
        <label class="control-label cm-color">
          {__("et_image_background_color")}
        </label>
        <div class="controls">
          <div class="te-colors clearfix">
            {$cp_value = ($banner.et_settings.$name.bkg)|default:"#ffffff"}
            <div class="colorpicker et-picker">
              <div class="input-prepend">
                <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][bkg]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="control-group {if $b_type == "T"}hidden{/if}" id="">
        <label class="control-label" for="">{__("open_in_new_window")}</label>
        <div class="controls">
        <input type="hidden" name="banner_data[et_settings][{$name}][target]" value="T" />
        <input type="checkbox" name="banner_data[et_settings][{$name}][target]" id="" value="B" {if $banner.et_settings.$name.target|default:"" == "B"}checked="checked"{/if} />
        </div>
      </div>

      <div class="control-group {if $b_type == "T"}hidden{/if}" id="">
        <label class="control-label" for="">{__("url")}:</label>
        <div class="controls">
          <input type="hidden" name="banner_data[et_settings][{$name}][url]" value="{$banner.et_settings.$name.url|default:""}"/>
          <input type="text" name="banner_data[et_settings][{$name}][url]" id="" value="{$banner.et_settings.$name.url|default:""}" size="25" class="input-large" {if !$enabled}disabled{/if}/>
        </div>

      </div>
    </div>
{/if}

<div id="et_content_wrapper_{$name}" {if $et_hidden}class="hidden"{/if}>
  
  <hr>
  {* ADDITIONAL IMAGE *}
  {include file="common/subheader.tpl" title="{__("et_additional_image")}" target="#et_image_additional_{$name}" }
  <div id="et_image_additional_{$name}" class="in">

    <div class="control-group" id="">
      <label class="control-label">{__("image")}</label>
      <div class="controls">
        {include file="common/attach_images.tpl"
          image_name="et_banners_`$name`_extra"
          image_object_type="et_promo_`$name`_extra"
          image_pair=$banner.et_settings.$name.additional.main_pair|default:""
          image_object_id=$id
          no_detailed=true
          hide_titles=true
        }
      </div>
    </div>

    <div class="control-group">
      <label for="" class="control-label">{__("et_image_url")}</label>
      <div class="controls">
      <input type="text" name="banner_data[et_text][{$name}][image_url]" id="" value="{$banner.et_text.$name.image_url|default:""}" size="25" class="input-large" /></div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_image_position")}
      </label>
      <div class="controls">
        {$et_image_pos=$banner.et_settings.$name.image_pos|default:""}
        <select name="banner_data[et_settings][{$name}][image_pos]" id="elm_banner_type" onchange="et_img_pos_toggle_{$name}(this.value);">
          <option value="H" {if $et_image_pos=="H"}selected{/if}>{__("et_horizontal_with_info_block")}</option>
          <option value="V" {if $et_image_pos=="V"}selected{/if}>{__("et_vertical_with_info_block")}</option>
          <option value="I" {if $et_image_pos=="I"}selected{/if}>{__("et_inside_info_block")}</option>
        </select>
      </div>
    </div>

    <div class="control-group" id="{$name}_img_pos_horiz">
      <label class="control-label">
        {__("et_image_position_horizontal")}
      </label>
      <div class="controls">
        {$et_image_pos2=$banner.et_settings.$name.image_pos2|default:""}
        <select name="banner_data[et_settings][{$name}][image_pos2]" id="elm_banner_type">
          <option value="L" {if $et_image_pos2=="L"}selected{/if}>{__("et_left_of_info_block")}</option>
          <option value="R" {if $et_image_pos2=="R"}selected{/if}>{__("et_right_of_info_block")}</option>
        </select>
      </div>
    </div>

    <div class="control-group" id="{$name}_img_pos_vert">
      <label class="control-label">
        {__("et_image_position_vertical")}
      </label>
      <div class="controls">
        {$et_image_pos3=$banner.et_settings.$name.image_pos3|default:""}
        <select name="banner_data[et_settings][{$name}][image_pos3]" id="elm_banner_type">
          <option value="A" {if $et_image_pos3=="A"}selected{/if}>{__("et_above_info_block")}</option>
          <option value="B" {if $et_image_pos3=="B"}selected{/if}>{__("et_below_info_block")}</option>
        </select>
      </div>
    </div>

    <div class="control-group" id="{$name}_img_pos_inside">
      <label class="control-label">
        {__("et_image_position_inside")}
      </label>
      <div class="controls">
        {$et_image_pos4=$banner.et_settings.$name.image_pos4|default:""}
        <select name="banner_data[et_settings][{$name}][image_pos4]" id="elm_banner_type">
          <option value="T" {if $et_image_pos4=="T"}selected{/if}>{__("et_above_title")}</option>
          <option value="D" {if $et_image_pos4=="D"}selected{/if}>{__("et_above_description")}</option>
          <option value="B" {if $et_image_pos4=="B"}selected{/if}>{__("et_above_button")}</option>
          <option value="E" {if $et_image_pos4=="E"}selected{/if}>{__("et_below_button")}</option>
        </select>
      </div>
    </div>

    <div class="control-group" id="{$name}_img_pos_vert_align">
      <label for="elm_banner_type" class="control-label">
        {__("et_vertical_align")}
      </label>
      <div class="controls">
        {$et_vert=$banner.et_settings.$name.image_vert|default:""}
        <select name="banner_data[et_settings][{$name}][image_vert]" id="elm_banner_type">
          <option value="T" {if $et_vert=="T"}selected{/if}>{__("et_top")}</option>
          <option value="C" {if $et_vert=="C"}selected{/if}>{__("et_center")}</option>
          <option value="B" {if $et_vert=="B"}selected{/if}>{__("et_bottom")}</option>
        </select>
      </div>
    </div>

    <div class="control-group" id="{$name}_img_pos_horiz_align">
      <label for="elm_banner_type" class="control-label">
        {__("et_horizontal_align")}
      </label>
      <div class="controls">
        {$et_horiz=$banner.et_settings.$name.image_horiz|default:""}
        <select name="banner_data[et_settings][{$name}][image_horiz]" id="elm_banner_type">
          <option value="L" {if $et_horiz=="L"}selected{/if}>{__("left")}</option>
          <option value="C" {if $et_horiz=="C"}selected{/if}>{__("et_center")}</option>
          <option value="R" {if $et_horiz=="R"}selected{/if}>{__("right")}</option>
        </select>
      </div>
    </div>
    

    <div class="control-group">
      <label class="control-label">
        {__("et_image_margin")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][image_margin]" value="{$banner.et_settings.$name.image_margin|default:"0px 0px 0px 0px"}" size="3"/>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_image_animation")}
      </label>
      <div class="controls">
        {$et_image_anim=$banner.et_settings.$name.image_anim|default:""}
        <select name="banner_data[et_settings][{$name}][image_anim]" id="elm_banner_type">
          <option value="A" {if $et_image_anim=="A"}selected{/if}>{__("auto")}</option>
          <option value="L" {if $et_image_anim=="L"}selected{/if}>{__("left")}</option>
          <option value="R" {if $et_image_anim=="R"}selected{/if}>{__("right")}</option>
          <option value="T" {if $et_image_anim=="T"}selected{/if}>{__("et_top")}</option>
          <option value="B" {if $et_image_anim=="B"}selected{/if}>{__("et_bottom")}</option>
          <option value="O" {if $et_image_anim=="O"}selected{/if}>{__("off")}</option>
        </select>
      </div>
    </div>
  </div>
  
  <hr>

  {* TITLE *}
  {include file="common/subheader.tpl" title="{__("title")}" target="#et_title_{$name}"}
  <div id="et_title_{$name}" class="in">
    <div class="control-group" id="et_banner_text">
      <label class="control-label" for="">
        {__("et_title_text")}
      </label>
      <div class="controls">
        <textarea id="" name="banner_data[et_text][{$name}][title]" cols="35" rows="8" class="input-large ">{$banner.et_text.$name.title|default:""}</textarea>
      </div>
    </div>

    <div class="control-group" id="">
      <label class="control-label" for="">
        {__("et_add_title_text_shadow")}
      </label>
      <div class="controls">
      <input type="hidden" name="banner_data[et_settings][{$name}][title_shadow]" value="N" />
      <input type="checkbox" name="banner_data[et_settings][{$name}][title_shadow]" id="" value="Y" {if $banner.et_settings.$name.title_shadow|default:"N" == "Y"}checked="checked"{/if} />
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_title_line_height")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][title_lh]" value="{$banner.et_settings.$name.title_lh|default:"normal"}" size="3"/>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_title_font_size")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][title_size]" value="{$banner.et_settings.$name.title_size|default:"18"}" class="input-color" size="3"/>
        <span>px</span>
      </div>
    </div>

    <div class="control-group">
      <label for="elm_banner_type" class="control-label">
        {__("et_title_font_weight")}
      </label>
      <div class="controls">
        {$et_title_weight=$banner.et_settings.$name.title_weight|default:""}
        <select name="banner_data[et_settings][{$name}][title_weight]" id="elm_banner_type">
          <option value="N" {if $et_title_weight=="N"}selected{/if}>Normal</option>
          <option value="L" {if $et_title_weight=="L"}selected{/if}>Light</option>
          <option value="B" {if $et_title_weight=="B"}selected{/if}>Bold</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label for="elm_banner_type" class="control-label">
        {__("et_title_font_style")}
      </label>
      <div class="controls">
        {$et_title_style=$banner.et_settings.$name.title_style|default:""}
        <select name="banner_data[et_settings][{$name}][title_style]" id="elm_banner_type">
          <option value="N" {if $et_title_style=="N"}selected{/if}>Normal</option>
          <option value="I" {if $et_title_style=="I"}selected{/if}>Italic</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label cm-color">
        {__("et_title_text_color")}
      </label>
      <div class="controls">
        <div class="te-colors clearfix">
          {$cp_value = ($banner.et_settings.$name.title_color)|default:"#ffffff"}
          <div class="colorpicker et-picker">
            <div class="input-prepend">
              <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][title_color]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
            </div>
          </div>
        </div>
      </div>
    </div>

    {* background *}
    <div class="control-group">
      <label class="control-label cm-color">
        {__("et_title_text_background")}
      </label>
      <div class="controls mixed-controls">
        <div class="form-inline clearfix">
          <input type="hidden" name="banner_data[et_settings][{$name}][title_bkg_enabled]" value="N" />
          <input type="checkbox" name="banner_data[et_settings][{$name}][title_bkg_enabled]" id="" value="Y" {if $banner.et_settings.$name.title_bkg_enabled|default:"N" == "Y"}checked="checked"{/if} style="vertical-align: middle;"/ onchange="Tygh.$('#title_bkg_{$name}').toggle();">
        </div>
        <div id="title_bkg_{$name}" {if $banner.et_settings.$name.title_bkg_enabled|default:"N" != "Y"}class="hidden"{/if}>
          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("color")}
            </label>
            <div class="pull-left">
              <div class="te-colors clearfix">
                {$cp_value = ($banner.et_settings.$name.title_bkg_color)|default:"#000000"}
                <div class="colorpicker et-picker">
                  <div class="input-prepend">
                    <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][title_bkg_color]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_opacity")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][title_bkg_opacity]" value="{$banner.et_settings.$name.title_bkg_opacity|default:"100"}" class="input-color" size="3"/>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_padding")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][title_inner_padding]" value="{$banner.et_settings.$name.title_inner_padding|default:"0px 0px 0px 0px"}" class="" size="3"/>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_rounded_corners")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][title_bkg_round]" value="{$banner.et_settings.$name.title_bkg_round|default:"0"}" size="3"/>
            </div>
          </div>
        </div>
      </div>
    </div>


    <div class="control-group">
      <label class="control-label">
        {__("et_title_margin")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][title_padding]" value="{$banner.et_settings.$name.title_padding|default:"0px 0px 0px 0px"}"  size="3"/>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_text_align")}
      </label>
      <div class="controls">
        {$et_title_align=$banner.et_settings.$name.title_align|default:""}
        <select name="banner_data[et_settings][{$name}][title_align]">
          <option value="L" {if $et_title_align=="L"}selected{/if}>{__("left")}</option>
          <option value="C" {if $et_title_align=="C"}selected{/if}>{__("et_center")}</option>
          <option value="R" {if $et_title_align=="R"}selected{/if}>{__("right")}</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_title_animation")}
      </label>
      <div class="controls">
        {$et_title_anim=$banner.et_settings.$name.title_anim|default:""}
        <select name="banner_data[et_settings][{$name}][title_anim]">
          <option value="A" {if $et_title_anim=="A"}selected{/if}>{__("auto")}</option>
          <option value="L" {if $et_title_anim=="L"}selected{/if}>{__("left")}</option>
          <option value="R" {if $et_title_anim=="R"}selected{/if}>{__("right")}</option>
          <option value="T" {if $et_title_anim=="T"}selected{/if}>{__("et_top")}</option>
          <option value="B" {if $et_title_anim=="B"}selected{/if}>{__("et_bottom")}</option>
          <option value="O" {if $et_title_anim=="O"}selected{/if}>{__("off")}</option>
        </select>
      </div>
    </div>
  </div>
  
  <hr>
  {* Description *}
  {include file="common/subheader.tpl" title="{__("description")}" target="#et_description_{$name}"}
  <div id="et_description_{$name}" class="in">
    <div class="control-group" id="et_banner_text">
      <label class="control-label">
        {__("et_description_text")}
      </label>
      <div class="controls">
        <textarea id="elm_banner_description" name="banner_data[et_text][{$name}][text]" cols="35" rows="8" class="input-large">{$banner.et_text.$name.text|default:""}</textarea>
      </div>
    </div>

    <div class="control-group" id="">
      <label class="control-label" for="">
        {__("et_add_description_text_shadow")}
      </label>
      <div class="controls">
      <input type="hidden" name="banner_data[et_settings][{$name}][text_shadow]" value="N" />
      <input type="checkbox" name="banner_data[et_settings][{$name}][text_shadow]" id="" value="Y" {if $banner.et_settings.$name.text_shadow|default:"N" == "Y"}checked="checked"{/if} />
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_description_line_height")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][text_lh]" value="{$banner.et_settings.$name.text_lh|default:"normal"}" size="3"/>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_description_font_size")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][text_size]" value="{$banner.et_settings.$name.text_size|default:"18"}" class="input-color" size="3"/>
        <span>px</span>
      </div>
    </div>

    <div class="control-group">
      <label for="elm_banner_type" class="control-label">
        {__("et_description_font_weight")}
      </label>
      <div class="controls">
        {$et_text_weight=$banner.et_settings.$name.text_weight|default:""}
        <select name="banner_data[et_settings][{$name}][text_weight]" id="elm_banner_type">
          <option value="N" {if $et_text_weight=="N"}selected{/if}>Normal</option>
          <option value="L" {if $et_text_weight=="L"}selected{/if}>Light</option>
          <option value="B" {if $et_text_weight=="B"}selected{/if}>Bold</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label for="elm_banner_type" class="control-label">
        {__("et_description_font_style")}
      </label>
      <div class="controls">
        {$et_text_style=$banner.et_settings.$name.text_style|default:""}
        <select name="banner_data[et_settings][{$name}][text_style]" id="elm_banner_type">
          <option value="N" {if $et_text_style=="N"}selected{/if}>Normal</option>
          <option value="I" {if $et_text_style=="I"}selected{/if}>Italic</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label cm-color">
        {__("et_description_text_color")}
      </label>
      <div class="controls">
        <div class="te-colors clearfix">
          {$cp_value = ($banner.et_settings.$name.text_color)|default:"#ffffff"}
          <div class="colorpicker et-picker">
            <div class="input-prepend">
              <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][text_color]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
            </div>
          </div>
        </div>
      </div>
    </div>

    {* background *}
    <div class="control-group">
      <label class="control-label cm-color">
        {__("et_description_text_background")}
      </label>
      <div class="controls mixed-controls">
        <div class="form-inline clearfix">
          <input type="hidden" name="banner_data[et_settings][{$name}][descr_bkg_enabled]" value="N" />
          <input type="checkbox" name="banner_data[et_settings][{$name}][descr_bkg_enabled]" id="" value="Y" {if $banner.et_settings.$name.descr_bkg_enabled|default:"N" == "Y"}checked="checked"{/if} style="vertical-align: middle;"/ onchange="Tygh.$('#descr_bkg_{$name}').toggle();">
        </div>
        <div id="descr_bkg_{$name}" {if $banner.et_settings.$name.descr_bkg_enabled|default:"N" != "Y"}class="hidden"{/if}>
          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("color")}
            </label>
            <div class="pull-left">
              <div class="te-colors clearfix">
                {$cp_value = ($banner.et_settings.$name.descr_bkg_color)|default:"#000000"}
                <div class="colorpicker et-picker">
                  <div class="input-prepend">
                    <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][descr_bkg_color]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_opacity")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][descr_bkg_opacity]" value="{$banner.et_settings.$name.descr_bkg_opacity|default:"100"}" class="input-color" size="3"/>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_padding")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][text_inner_padding]" value="{$banner.et_settings.$name.text_inner_padding|default:"0px 0px 0px 0px"}" class="" size="3"/>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_rounded_corners")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][descr_bkg_round]" value="{$banner.et_settings.$name.descr_bkg_round|default:"0"}" size="3"/>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_description_margin")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][text_padding]" value="{$banner.et_settings.$name.text_padding|default:"0px 0px 0px 0px"}" size="3"/>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_text_align")}
      </label>
      <div class="controls">
        {$et_descr_align=$banner.et_settings.$name.descr_align|default:""}
        <select name="banner_data[et_settings][{$name}][descr_align]">
          <option value="L" {if $et_descr_align=="L"}selected{/if}>{__("left")}</option>
          <option value="C" {if $et_descr_align=="C"}selected{/if}>{__("et_center")}</option>
          <option value="R" {if $et_descr_align=="R"}selected{/if}>{__("right")}</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_description_animation")}
      </label>
      <div class="controls">
        {$et_descr_anim=$banner.et_settings.$name.descr_anim|default:""}
        <select name="banner_data[et_settings][{$name}][descr_anim]" id="elm_banner_type">
          <option value="A" {if $et_descr_anim=="A"}selected{/if}>{__("auto")}</option>
          <option value="L" {if $et_descr_anim=="L"}selected{/if}>{__("left")}</option>
          <option value="R" {if $et_descr_anim=="R"}selected{/if}>{__("right")}</option>
          <option value="T" {if $et_descr_anim=="T"}selected{/if}>{__("et_top")}</option>
          <option value="B" {if $et_descr_anim=="B"}selected{/if}>{__("et_bottom")}</option>
          <option value="O" {if $et_descr_anim=="O"}selected{/if}>{__("off")}</option>
        </select>
      </div>
    </div>
  </div>
  
  <hr>
  {* Button *}
  {include file="common/subheader.tpl" title="{__("et_button")}" target="#et_button_{$name}"}
  <div id="et_button_{$name}" class="in">

    <div class="control-group">
      <label for="" class="control-label">
        {__("et_button_text")}
      </label>
      <div class="controls">
      <input type="text" name="banner_data[et_text][{$name}][btn_text]" id="" value="{$banner.et_text.$name.btn_text|default:""}" size="25" class="input-large" /></div>
    </div>

    <div class="control-group">
      <label for="" class="control-label">
        {__("et_button_url")}
      </label>
      <div class="controls">
      <input type="text" name="banner_data[et_text][{$name}][btn_url]" id="" value="{$banner.et_text.$name.btn_url|default:""}" size="25" class="input-large" /></div>
    </div>

    <div class="control-group" id="">
      <label class="control-label" for="">
        {__("et_button_shadow")}
      </label>
      <div class="controls">
      <input type="hidden" name="banner_data[et_settings][{$name}][btn_shadow]" value="N" />
      <input type="checkbox" name="banner_data[et_settings][{$name}][btn_shadow]" id="" value="Y" {if $banner.et_settings.$name.btn_shadow|default:"N" == "Y"}checked="checked"{/if} />
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_button_font_size")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][btn_size]" value="{$banner.et_settings.$name.btn_size|default:"18"}" class="input-color" size="3"/>
        <span>px</span>
      </div>
    </div>

    <div class="control-group">
      <label for="elm_banner_type" class="control-label">
        {__("et_button_font_weight")}
      </label>
      <div class="controls">
        {$et_btn_weight=$banner.et_settings.$name.btn_weight|default:""}
        <select name="banner_data[et_settings][{$name}][btn_weight]" id="elm_banner_type">
          <option value="N" {if $et_btn_weight=="N"}selected{/if}>Normal</option>
          <option value="L" {if $et_btn_weight=="L"}selected{/if}>Light</option>
          <option value="B" {if $et_btn_weight=="B"}selected{/if}>Bold</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label for="elm_banner_type" class="control-label">
        {__("et_button_font_style")}
      </label>
      <div class="controls">
        {$et_btn_style=$banner.et_settings.$name.btn_style|default:""}
        <select name="banner_data[et_settings][{$name}][btn_style]" id="elm_banner_type">
          <option value="N" {if $et_btn_style=="N"}selected{/if}>Normal</option>
          <option value="I" {if $et_btn_style=="I"}selected{/if}>Italic</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_button_rounded_corners")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][btn_round]" value="{$banner.et_settings.$name.btn_round|default:"0"}" class="" size="3"/>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label cm-color">
        {__("et_button_text_color")}
      </label>
      <div class="controls">
        <div class="te-colors clearfix">
          {$cp_value = ($banner.et_settings.$name.btn_text_color)|default:"#ffffff"}
          <div class="colorpicker et-picker">
            <div class="input-prepend">
              <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][btn_text_color]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label cm-color">
        {__("et_button_background")}
      </label>
      <div class="controls mixed-controls">
        <div class="form-inline clearfix">
          <input type="hidden" name="banner_data[et_settings][{$name}][btn_bkg_enabled]" value="N" />
          <input type="checkbox" name="banner_data[et_settings][{$name}][btn_bkg_enabled]" id="" value="Y" {if $banner.et_settings.$name.btn_bkg_enabled|default:"N" == "Y"}checked="checked"{/if} style="vertical-align: middle;"/ onchange="Tygh.$('#btn_bkg_{$name}').toggle();">
        </div>
        <div id="btn_bkg_{$name}" {if $banner.et_settings.$name.btn_bkg_enabled|default:"N" != "Y"}class="hidden"{/if}>
          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("color")}
            </label>
            <div class="pull-left">
              <div class="te-colors clearfix">
                {$cp_value = ($banner.et_settings.$name.btn_bkg_color)|default:"#000000"}
                <div class="colorpicker et-picker">
                  <div class="input-prepend">
                    <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][btn_bkg_color]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_opacity")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][btn_bkg_opacity]" value="{$banner.et_settings.$name.btn_bkg_opacity|default:"100"}" class="input-color" size="3"/>
            </div>
          </div>
        </div>


      </div>
    </div>

    <div class="control-group">
      <label class="control-label cm-color">
        {__("et_button_hover_text_color")}
      </label>
      <div class="controls">
        <div class="te-colors clearfix">
          {$cp_value = ($banner.et_settings.$name.btn_text_color_hover)|default:"#000000"}
          <div class="colorpicker et-picker">
            <div class="input-prepend">
              <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][btn_text_color_hover]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label cm-color">
        {__("et_button_hover_background")}
      </label>
      <div class="controls mixed-controls">
        <div class="form-inline">
          <input type="hidden" name="banner_data[et_settings][{$name}][btn_hover_bkg_enabled]" value="N" />
          <input type="checkbox" name="banner_data[et_settings][{$name}][btn_hover_bkg_enabled]" id="" value="Y" {if $banner.et_settings.$name.btn_hover_bkg_enabled|default:"N" == "Y"}checked="checked"{/if} style="vertical-align: middle;"/ onchange="Tygh.$('#btn_hover_bkg_{$name}').toggle();">
        </div>
        <div id="btn_hover_bkg_{$name}" {if $banner.et_settings.$name.btn_hover_bkg_enabled|default:"N" != "Y"}class="hidden"{/if}>
          <div class="form-inline clearfix  control-group">
            <label class="pull-left">
              {__("color")}
            </label>
            <div class="pull-left">
              <div class="te-colors clearfix">
                {$cp_value = ($banner.et_settings.$name.btn_bkg_color_hover)|default:"#000000"}
                <div class="colorpicker et-picker">
                  <div class="input-prepend">
                    <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][btn_bkg_color_hover]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_opacity")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][btn_bkg_opacity_hover]" value="{$banner.et_settings.$name.btn_bkg_opacity_hover|default:"100"}" class="input-color" size="3"/>
            </div>
          </div>
        
        </div>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label cm-color">
        {__("et_button_border")}
      </label>
      <div class="controls mixed-controls">
        <div class="form-inline clearfix">
          <input type="hidden" name="banner_data[et_settings][{$name}][btn_border_enable]" value="N" />
          <input type="checkbox" name="banner_data[et_settings][{$name}][btn_border_enable]" id="" value="Y" {if $banner.et_settings.$name.btn_border_enable|default:"N" == "Y"}checked="checked"{/if} style="vertical-align: middle;"/ onchange="Tygh.$('#btn_border_{$name}').toggle();">
        </div>
        <div id="btn_border_{$name}" {if $banner.et_settings.$name.btn_border_enable|default:"N" != "Y"}class="hidden"{/if}>
          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_button_border_size")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][btn_border_size]" value="{$banner.et_settings.$name.btn_border_size|default:"1"}" class="input-color" size="3"/>
              <span>px</span>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_button_border_style")}
            </label>
            <div class="pull-left">
              {$et_btn_border_style=$banner.et_settings.$name.btn_border_style|default:""}
              <select name="banner_data[et_settings][{$name}][btn_border_style]" id="elm_banner_type">
                <option value="S" {if $et_btn_border_style=="S"}selected{/if}>Solid</option>
                <option value="D" {if $et_btn_border_style=="D"}selected{/if}>Dashed</option>
                <option value="T" {if $et_btn_border_style=="T"}selected{/if}>Dotted</option>
              </select>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("color")}
            </label>
            <div class="pull-left">
              <div class="te-colors clearfix">
                {$cp_value = ($banner.et_settings.$name.btn_border_color)|default:"#ffffff"}
                <div class="colorpicker et-picker">
                  <div class="input-prepend">
                    <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][btn_border_color]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="form-inline clearfix">
            <label class="pull-left">
              {__("et_opacity")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][btn_border_opacity]" value="{$banner.et_settings.$name.btn_border_opacity|default:"100"}" class="input-color" size="3"/>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_hover_color")}
            </label>
            <div class="pull-left">
              <div class="te-colors clearfix">
                {$cp_value = ($banner.et_settings.$name.btn_hover_border_color)|default:"#ffffff"}
                <div class="colorpicker et-picker">
                  <div class="input-prepend">
                    <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][btn_hover_border_color]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="form-inline clearfix">
            <label class="pull-left">
              {__("et_hover_opacity")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][btn_hover_border_opacity]" value="{$banner.et_settings.$name.btn_hover_border_opacity|default:"100"}" class="input-color" size="3"/>
            </div>
          </div>

        </div>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_button_padding")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][btn_padding]" value="{$banner.et_settings.$name.btn_padding|default:"6px 7px 6px 7px"}" size="3"/>
      </div>
    </div>

    <div class="control-group">
      <label for="elm_banner_type" class="control-label">
        {__("et_button_align")}
      </label>
      <div class="controls">
        {$et_btn_horiz=$banner.et_settings.$name.btn_horiz|default:""}
        <select name="banner_data[et_settings][{$name}][btn_horiz]" id="elm_banner_type">
          <option value="L" {if $et_btn_horiz=="L"}selected{/if}>{__("left")}</option>
          <option value="C" {if $et_btn_horiz=="C"}selected{/if}>{__("et_center")}</option>
          <option value="R" {if $et_btn_horiz=="R"}selected{/if}>{__("right")}</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_button_margin")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][btn_margin]" value="{$banner.et_settings.$name.btn_margin|default:"0px 0px 0px 0px"}" size="3"/>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_button_animation")}
      </label>
      <div class="controls">
        {$et_btn_anim=$banner.et_settings.$name.btn_anim|default:""}
        <select name="banner_data[et_settings][{$name}][btn_anim]" id="elm_banner_type">
          <option value="A" {if $et_btn_anim=="A"}selected{/if}>{__("auto")}</option>
          <option value="L" {if $et_btn_anim=="L"}selected{/if}>{__("left")}</option>
          <option value="R" {if $et_btn_anim=="R"}selected{/if}>{__("right")}</option>
          <option value="T" {if $et_btn_anim=="T"}selected{/if}>{__("et_top")}</option>
          <option value="B" {if $et_btn_anim=="B"}selected{/if}>{__("et_bottom")}</option>
          <option value="O" {if $et_btn_anim=="O"}selected{/if}>{__("off")}</option>
        </select>
      </div>
    </div>

  </div>

  <hr>
  {* Background Settings *}
  {include file="common/subheader.tpl" title="{__("et_info_block_settings")}" target="#et_content_settings_{$name}"}
  <div id="et_content_settings_{$name}" class="in">

    <div class="control-group">
      <label class="control-label">
        {__("et_info_block_width")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][wrapper_width]" value="{$banner.et_settings.$name.wrapper_width|default:"auto"}" size="3"/>
      </div>
    </div>
    <div class="control-group">
      <label for="elm_banner_type" class="control-label">
        {__("et_vertical_align")}
      </label>
      <div class="controls">
        {$et_vert=$banner.et_settings.$name.vert|default:""}
        <select name="banner_data[et_settings][{$name}][vert]" id="elm_banner_type">
          <option value="T" {if $et_vert=="T"}selected{/if}>{__("et_top")}</option>
          <option value="C" {if $et_vert=="C"}selected{/if}>{__("et_center")}</option>
          <option value="B" {if $et_vert=="B"}selected{/if}>{__("et_bottom")}</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label for="elm_banner_type" class="control-label">
        {__("et_horizontal_align")}
      </label>
      <div class="controls">
        {$et_horiz=$banner.et_settings.$name.horiz|default:""}
        <select name="banner_data[et_settings][{$name}][horiz]" id="elm_banner_type">
          <option value="L" {if $et_horiz=="L"}selected{/if}>{__("left")}</option>
          <option value="C" {if $et_horiz=="C"}selected{/if}>{__("et_center")}</option>
          <option value="R" {if $et_horiz=="R"}selected{/if}>{__("right")}</option>
        </select>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label">
        {__("et_info_block_margin")}
      </label>
      <div class="controls">
        <input type="text" name="banner_data[et_settings][{$name}][wrapper_margin]" value="{$banner.et_settings.$name.wrapper_margin|default:"0px 0px 0px 0px"}" size="3"/>
      </div>
    </div>

    <div class="control-group">
      <label class="control-label cm-color">
        {__("et_info_block_background")}
      </label>
      <div class="controls mixed-controls">
        <div class="form-inline clearfix">
          <input type="hidden" name="banner_data[et_settings][{$name}][wrapper_bkg_enabled]" value="N" />
          <input type="checkbox" name="banner_data[et_settings][{$name}][wrapper_bkg_enabled]" id="" value="Y" {if $banner.et_settings.$name.wrapper_bkg_enabled|default:"N" == "Y"}checked="checked"{/if} style="vertical-align: middle;"/ onchange="Tygh.$('#wrapper_bkg_{$name}').toggle();">
        </div>
        <div id="wrapper_bkg_{$name}" {if $banner.et_settings.$name.wrapper_bkg_enabled|default:"N" != "Y"}class="hidden"{/if}>
          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("color")}
            </label>
            <div class="pull-left">
              <div class="te-colors clearfix">
                {$cp_value = ($banner.et_settings.$name.wrapper_bkg_color)|default:"#000000"}
                <div class="colorpicker et-picker">
                  <div class="input-prepend">
                    <input type="text"  maxlength="7"  name="banner_data[et_settings][{$name}][wrapper_bkg_color]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_opacity")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][wrapper_bkg_opacity]" value="{$banner.et_settings.$name.wrapper_bkg_opacity|default:"100"}" class="input-color" size="3"/>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_padding")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][wrapper_padding]" value="{$banner.et_settings.$name.wrapper_padding|default:"0px 0px 0px 0px"}" class="" size="3"/>
            </div>
          </div>

          <div class="form-inline clearfix control-group">
            <label class="pull-left">
              {__("et_rounded_corners")}
            </label>
            <div class="pull-left">
              <input type="text" name="banner_data[et_settings][{$name}][wrapper_round]" value="{$banner.et_settings.$name.wrapper_round|default:"0"}" class="" size="3"/>
            </div>
          </div>
        </div>


      </div>
    </div>
  </div>

</div>

{if $show_enabled}
      <div class="disable-overlay cm-bs-off"></div>
    </div>
  </div>
{/if}

<style>
  .mixed-controls .form-inline label{
    min-width: 110px;
  }
</style>

<script>
  (function () {
    et_img_pos_toggle_{$name}("{$banner.et_settings.$name.image_pos|default:"H"}");
  })();
  
  function et_img_pos_hide_all_{$name}(){
    $('[id*="{$name}_img_pos_"').hide();
  }

  function et_img_pos_toggle_{$name}(type){
    et_img_pos_hide_all_{$name}();
    if (type=='H'){
      $("#{$name}_img_pos_horiz,#{$name}_img_pos_vert_align").show();
    }else if (type=='V') {
      $("#{$name}_img_pos_vert,#{$name}_img_pos_horiz_align").show();
    }else if (type=='I') {
      $("#{$name}_img_pos_inside,#{$name}_img_pos_horiz_align").show();
    }
  }
</script>