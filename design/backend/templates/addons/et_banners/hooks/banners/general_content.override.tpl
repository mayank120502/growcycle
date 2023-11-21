{if count(fn_seo_get_active_languages())>1}
  <div class="control-group">
    <label class="control-label">
      {__('et_update_for_all_languages')}:
    </label>
    <div class="controls">
      <input type="hidden" name="banner_data[update_all_langs]" value="N" checked="checked"/>
      <input type="checkbox" name="banner_data[update_all_langs]" value="Y"/>
    </div>
  </div>
{/if}

<div class="control-group">
  <label for="elm_banner_name" class="control-label cm-required">{__("name")}</label>
  <div class="controls">
  <input type="text" name="banner_data[banner]" id="elm_banner_name" value="{$banner.banner}" size="25" class="input-large" /></div>
</div>

{if "ULTIMATE"|fn_allowed_for}
  {include file="views/companies/components/company_field.tpl"
    name="banner_data[company_id]"
    id="banner_data_company_id"
    selected=$banner.company_id
  }
{/if}


<div class="control-group">
  <label for="elm_banner_type" class="control-label cm-required">{__("type")}</label>
  <div class="controls">
  <select name="banner_data[type]" id="elm_banner_type" onchange="et_toggle(this.value);">
    <option {if $b_type == "G"}selected="selected"{/if} value="G">{__("graphic_banner")}</option>
    <option {if $b_type == "T"}selected="selected"{/if} value="T">{__("text_banner")}</option>
    <option {if $b_type == "E"}selected="selected"{/if} value="E">{__("et_banner")}</option>
  </select>
  </div>
</div>
<script>
  (function () {
    et_toggle("{$banner.type|default:"G"}");
  })();

  function hide_all(){
    $("#banner_graphic").hide();
    $("#banner_url").hide();
    $("#banner_target").hide();

    $("#banner_text").hide();

    $("#et_desktop_image_background").hide();
    $('[id*="et_content_wrapper_"').hide();
    $("#phone").hide();
    $("#tablet").hide();

  }

  function et_toggle(type){
    hide_all();
    if (type=='T'){
      $("#banner_text").show();
    }else if (type=='G') {
      $("#banner_graphic").show();
      $("#banner_url").show();
      $("#banner_target").show();
    }else if (type=='E'){
      $("#banner_graphic").show();
      $("#banner_url").show();
      $("#banner_target").show();

      $("#et_desktop_image_background").show();
      $("#phone").show();
      $("#tablet").show();
      $('[id*="et_content_wrapper_"').show();
    }
  }
</script>

<div class="control-group {if $b_type == "T"}hidden{/if}" id="banner_graphic">
  <label class="control-label">{__("image")}</label>
  <div class="controls">
    {include file="common/attach_images.tpl"
      image_name="banners_main"
      image_object_type="promo"
      image_pair=$banner.main_pair
      image_object_id=$id
      no_detailed=true
      hide_titles=true
    }
  </div>
</div>


<div class="control-group {if $b_type!="E"}hidden{/if}" id="et_desktop_image_background">
  <label class="control-label cm-color">
    {__("et_image_background_color")}
  </label>
  <div class="controls">
    <div class="te-colors clearfix">
      {$cp_value = ($banner.et_settings.desktop.bkg)|default:"#ffffff"}
      <div class="colorpicker et-picker">
        <div class="input-prepend">
          <input type="text"  maxlength="7"  name="banner_data[et_settings][desktop][bkg]" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
        </div>
      </div>
    </div>
  </div>
</div>

<div class="control-group {if $b_type != "T"}hidden{/if}" id="banner_text">
  <label class="control-label" for="elm_banner_description">{__("description")}:</label>
  <div class="controls">
    <textarea id="elm_banner_description" name="banner_data[description]" cols="35" rows="8" class="cm-wysiwyg input-large">{$banner.description}</textarea>
  </div>
</div>

<div class="control-group {if $b_type == "T"}hidden{/if}" id="banner_target">
  <label class="control-label" for="elm_banner_target">{__("open_in_new_window")}</label>
  <div class="controls">
  <input type="hidden" name="banner_data[target]" value="T" />
  <input type="checkbox" name="banner_data[target]" id="elm_banner_target" value="B" {if $banner.target == "B"}checked="checked"{/if} />
  </div>
</div>

<div class="control-group {if $b_type == "T"}hidden{/if}" id="banner_url">
  <label class="control-label" for="elm_banner_url">{__("url")}:</label>
  <div class="controls">
    <input type="text" name="banner_data[url]" id="elm_banner_url" value="{$banner.url}" size="25" class="input-large" />
  </div>
</div>

<div class="control-group">
  <label class="control-label" for="elm_banner_timestamp_{$id}">{__("creation_date")}</label>
  <div class="controls">
  {include file="common/calendar.tpl" date_id="elm_banner_timestamp_`$id`" date_name="banner_data[timestamp]" date_val=$banner.timestamp|default:$smarty.const.TIME start_year=$settings.Company.company_start_year}
  </div>
</div>

{include file="views/localizations/components/select.tpl" data_name="banner_data[localization]" data_from=$banner.localization}

{include file="common/select_status.tpl" input_name="banner_data[status]" id="elm_banner_status" obj_id=$id obj=$banner hidden=true}

{if $b_type!="E"}{$et_hidden=true}{/if}
{include file="addons/et_banners/views/banners/components/et_settings.tpl" name="desktop" show_enabled=false et_hidden=$et_hidden}