{script src="js/tygh/tabs.js"}

{capture name="mainbox"}
{if $vsb.vsb_id}
  {assign var="id" value=$vsb.vsb_id}
{else}
  {assign var="id" value=0}
{/if}

<form action="{""|fn_url}" method="post" name="update_vsb_form_{$id}" class="form-horizontal form-edit cm-disable-empty-files {$hide_inputs_class}" enctype="multipart/form-data">
  <input type="hidden" class="cm-no-hide-input" name="block_data[vsb_id]" value="{$vsb.vsb_id}" />
  <input type="hidden" class="cm-no-hide-input" name="vsb_id" value="{$vsb.vsb_id}" />
  <input type="hidden" class="cm-no-hide-input" name="redirect_url" value="{$return_url|default:$smarty.request.return_url}" />

  <input type="hidden" name="selected_section" id="selected_section" value="{$smarty.request.selected_section}" />
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
  
  <div class="tabs cm-j-tabs cm-track">
    <ul class="nav nav-tabs">
      <li id="tab_details_{$id}" class="cm-js {if $active_tab == "tab_details_`$id`"} active{/if}"><a>{__("general")}</a></li>
      <li id="tab_text_{$id}" class="cm-js {if $active_tab == "tab_products_`$id`"} active{/if} {if $vsb.settings.type != "T" && isset($vsb.settings.type)}hidden{/if}"><a>{__("Content")}</a></li>
      <li id="tab_products_{$id}" class="cm-js {if $active_tab == "tab_products_`$id`"} active{/if} {if $vsb.settings.type != "P"}hidden{/if}"><a>{__("products")}</a></li>
      <li id="tab_ban_{$id}" class="cm-js {if $active_tab == "tab_products_`$id`"} active{/if} {if $vsb.settings.type != "B"}hidden{/if}"><a>{__("Banners")}</a></li>
    </ul>
  </div>


  {* General tab *}
  <div id="content_tab_details_{$id}">

    <fieldset>


      {if $smarty.const.ACCOUNT_TYPE=='vendor'}
        {$vsb.company_id=$runtime.company_id}
      {elseif empty($vsb.company_id)}
        {if $runtime.company_id!=0}
          {$vsb.company_id=$runtime.company_id}
        {else}
          {$vsb.company_id=intval(fn_get_session_data('et_company_id'))}
        {/if}
      {/if}

      {include file="views/companies/components/company_field.tpl"
          name="block_data[company_id]"
          id="block_data_company_id"
          zero_company_id_name_lang_var="none"
          selected=$vsb.company_id
          js_action="fn_change_vendor_for_block(elm);"
          disable_company_picker=$disable_company_picker
      }
      

      {if $id}
        <input type="hidden" class="vsb-orig-type" name="block_data[settings][type]" value="{$vsb.settings.type}"/>
      {/if}
      <div class="control-group">
        <label class="control-label cm-required" for="elm_vsb_type_{$id}">{__("type")}</label>
        <div class="controls">
          <select name="block_data[settings][type]" id="elm_vsb_type_{$id}" data-ca-vsb-id="{$id}" class="cm-vsb-type" {if $id}disabled{/if}>
            <option value="T" {if $vsb.settings.type == "T"}selected="selected"{/if}>
              {__("Textarea")}
            </option>
            <option value="P" {if $vsb.settings.type == "P"}selected="selected"{/if}>
              {__("products")}
            </option>
            <option value="B" {if $vsb.settings.type == "B"}selected="selected"{/if}>
              {__("Banners")}
            </option>
          </select>
        </div>
      </div>

      <div class="control-group">
        <label class="control-label cm-required" for="elm_vsb_title_{$id}">{__("title")}</label>
        <div class="controls">
          <input class="span9" type="text" name="block_data[data][title]" value="{$vsb.data.title}" id="elm_vsb_title_{$id}" />
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="elm_vsb_sub_title_{$id}">{__("et_short_description")}</label>
        <div class="controls">
          <input class="span9" type="text" name="block_data[data][sub_title]" value="{$vsb.data.sub_title}" id="elm_vsb_sub_title_{$id}" />
        </div>
      </div>


      <div class="control-group">
        <label class="control-label" for="elm_vsb_position_{$id}">{__("position")}</label>
        <div class="controls">
          <input class="input-micro" type="text" name="block_data[position]" value="{$vsb.position}" id="elm_vsb_position_{$id}" />
        </div>
      </div>


      

      <div class="control-group">
        <label class="control-label" for="elm_vsb_show_title_{$id}">{__("et_show_title")}</label>
        <div class="controls">
        <input type="hidden" name="block_data[settings][show_title]" value="N" />
        <input id="elm_vsb_show_title_{$id}" type="checkbox" name="block_data[settings][show_title]" value="Y" {if $vsb.settings.show_title != "N"}checked="checked"{/if}/>
        </div>
      </div>

      <div class="control-group {if $vsb.settings.type != "B"}hidden{/if}" id="vsb_full_width_{$id}">
        <label class="control-label" for="elm_vsb_full_width_{$id}">{__("et_full_width")}</label>
        <div class="controls">
        <input type="hidden" name="block_data[settings][full_width]" value="N" />
        {if ($vsb.settings.type != "T" && $vsb.settings.type != "P")}
          <input id="elm_vsb_show_title_{$id}" type="checkbox" name="block_data[settings][full_width]" value="Y" {if $vsb.settings.full_width == "Y"}checked="checked"{/if}/>
        {/if}
        </div>
      </div>
    </fieldset>
  </div>

  {* Content tab *}
  <div id="content_tab_text_{$id}">
    <div class="control-group">
      <label class="control-label" for="elm_vsb_text_{$id}">{__("description")}</label>
      <div class="controls">
        <textarea name="block_data[text]" cols="55" rows="4" class="span9 cm-wysiwyg" id="elm_vsb_text_{$id}">{$vsb.text}</textarea>
      </div>
    </div>
  </div>

  {* Products tab *}
  <div id="content_tab_products_{$id}" class="">
    <fieldset>
        
      {if $vsb.settings.type == "P"}
        {$prod_ids=$vsb.settings.product_ids}
      {/if}
  
      <div id="product_filling_{$id}">
        {$filling=$vsb.settings.content.items.filling|default:"manually"}
        <div>
          <div class="control-group cm-no-hide-input">
            <label class="control-label" for="filling_select">{__("filling")}</label>
            <div class="controls">
              <select 
                id="filling_select" 
                name="block_data[settings][content][items][filling]" 
                onchange="fn_et_fillings(this.value);">
                {foreach from=$fillings item=v key=k}
                  <option value="{$k}" {if $filling == $k}selected="selected"{/if}>{__($k)}</option>
                {/foreach}
              </select>
            </div>
          </div>

          {if $filling == 'manually'}
            <div class="control-group cm-no-hide-input">
              {$prod_ids=explode(',',$vsb.settings.content.items.item_ids)}
              {include file="views/products/components/picker/picker.tpl"
                input_name="block_data[settings][content][items][item_ids]"
                item_ids=$prod_ids
                multiple=true
                view_mode="external"
                select_group_class="btn-toolbar"
                show_positions=true
              }
            </div>
          {/if}

          {if $fillings.$filling.settings|is_array}
            {foreach from=$fillings.$filling.settings item=setting_data key=setting_name}
              {include file="views/block_manager/components/setting_element.tpl" 
                option=$setting_data 
                name=$setting_name 
                block=$vsb 
                html_id="product_filling_`$id`_`$setting_name`" 
                html_name="block_data[settings][content][items][`$setting_name`]"
                editable=true 
                value=$vsb.settings.content.items.$setting_name}
            {/foreach}
          {/if}

        </div>
      <!--product_filling_{$id}--></div>
    </fieldset>
  </div>

  {* Banners tab *}
  {function name="banner_block" banner_nr=$banner_nr}
    <table class="table table-middle et-table" width="100%" id="box_add_banner_{$banner_nr}">
      <thead>
        <tr>
          <th colspan="2" class="et-title">
            <input type="hidden" class="cm-no-hide-input" name="block_data[banner][{$banner_nr}][banner_nr]" value="{$banner.banner_nr}" />
            <input type="hidden" class="cm-no-hide-input" name="block_data[banner][{$banner_nr}][banner_id]" value="{$banner.banner_id}" />
            {if empty($banner)}
              <input type="hidden" class="cm-no-hide-input" name="block_data[banner][{$banner_nr}][is_new]" value="Y" />
            {/if}
            <span>{__("banner")} {$banner_nr+1}</span>
          </th>
          <th class="cm-extended-feature right" width="5%">
            <span class="hidden-tools">
              {if $banner.banner_id}
                {include file="buttons/multiple_buttons.tpl" item_id="add_banner_`$banner_nr`" only_delete="Y"}
              {/if}
            </span>
          </th>
        </tr>
      </thead>

      <tbody class="" id="et_banner_{$banner_nr}">
        <tr><td colspan="3">
          <label class="control-label" for="elm_image_{$banner.banner_id}_{$banner_nr}">{__("position_short")}</label>
          <div class="controls">
            <input type="text" name="block_data[banner][{$banner_nr}][position]" value="{$banner.position}" size="4" class="input-micro" />
          </div>
        </td></tr>
        <tr><td colspan="3">
          <div class="control-group">
            <label class="control-label" for="elm_image_{$banner.banner_id}_{$banner_nr}">{__("image")}</label>
            <div class="controls">
              {include file="common/attach_images.tpl" image_name="vsb_banner" image_object_type="vsb_banner" image_key=$banner_nr hide_titles=true no_detailed=true image_pair=$banner.image}
            </div>
          </div>
        </td></tr>
        <tr><td colspan="3">
          <div class="control-group">
            <label class="control-label" for="block_banner_url_{$banner.banner_id}_{$banner_nr}">{__("url")}</label>
            <div class="controls">
            <input type="text" name="block_data[banner][{$banner_nr}][url]" id="block_banner_url_{$banner.banner_id}_{$banner_nr}" class="span7" value="{$banner.url}" />
            </div>
          </div>
        </td></tr>
      </tbody>
    <!-- box_add_banner_{$banner_nr} --></table>
  {/function}
  
  <div id="content_tab_ban_{$id}">
    {$banner_ids=$vsb.settings.banner_ids}
    {if empty($vsb.company_id)}
      {if $runtime.company_id!=0}
        {$company_id=$runtime.company_id}
      {else}
        {$company_id=intval(fn_get_session_data('et_company_id'))}
      {/if}
    {else}
      {$company_id=$vsb.company_id}
    {/if}

    {include 
        file="addons/banners/pickers/banners/picker.tpl" 
        input_name="block_data[settings][banner_ids]"
        type="links"
        picker_for="vendor_banner&et_company_id=`$company_id`"
        item_ids=$banner_ids
        placement=""
        positions=true}
     
  </div>

  {if $in_popup}
    <div class="buttons-container">
      {if "ULTIMATE"|fn_allowed_for && !$allow_save}
        {assign var="hide_first_button" value=true}
      {/if}
      {include file="buttons/save_cancel.tpl" but_name="dispatch[vendor_store_blocks.update]" cancel_action="close" hide_first_button=$hide_first_button save=$vsb.vsb_id}
    </div>
  {else}
    {capture name="buttons"}
      {include file="buttons/save_cancel.tpl" but_role="submit-link" but_name="dispatch[vendor_store_blocks.update]" but_target_form="update_vsb_form_{$id}" save=$id}
    {/capture}
  {/if}
</form>
{/capture}


{if $in_popup}
  {$smarty.capture.mainbox nofilter}
{else}
  {if empty($vsb.data.title)}
    {include file="common/mainbox.tpl" title="{__('vsb_new_home_block')}" content=$smarty.capture.mainbox buttons=$smarty.capture.buttons select_languages=true}
  {else}
    {include file="common/mainbox.tpl" title="{__("editing")}: `$vsb.data.title`" content=$smarty.capture.mainbox buttons=$smarty.capture.buttons select_languages=true}
  {/if}
{/if}


<script>
function et_product_filling(e){
  var value = $(e).val();
  console.log(value);
}

(function(_, $) {

  (function($) {

    var methods = {
      checkType: function() {
        var section_id = $(this).data('caVsbId');
        var value = $(this).prop('value');

        switch(value) {
          case 'P':
            $('#vsb_full_width_' + section_id).hide();
            $('#tab_products_' + section_id).show();
            $('#tab_ban_' + section_id).hide();
            $('#tab_text_' + section_id).hide();
            break;
          case 'B':
            $('#vsb_full_width_' + section_id).show();
            $('#tab_products_' + section_id).hide();
            $('#tab_ban_' + section_id).show();
            $('#tab_text_' + section_id).hide();
             break;
          case 'T':
            $('#vsb_full_width_' + section_id).hide();
            $('#tab_products_' + section_id).hide();
            $('#tab_ban_' + section_id).hide();
            $('#tab_text_' + section_id).show();
            break;
        }
      },
    };

    $.fn.ceProductFeature = function(method) {
      var args = arguments;

      return $(this).each(function(i, elm) {

        if (methods[method]) {
          return methods[method].apply(this, Array.prototype.slice.call(args, 1));
        } else if (typeof method === 'object' || !method) {
          return methods.init.apply(this, args);
        } else {
          $.error('ty.vsb: method ' + method + ' does not exist');
        }
      });
    };

  })($);

  $(document).ready(function() {
    $(_.doc).on('change', '.cm-vsb-type', function(e) {
      $(e.target).ceProductFeature('checkType');
    });
  });


}(Tygh, Tygh.$));
</script>

<script type="text/javascript">
function fn_et_fillings(val){
  var $ = Tygh.$;
  id = {$id};
  value=val;
  result_ids = 'product_filling_'+id;

  result=$.ceAjax('request', 
    fn_url('vendor_store_blocks.fillings?id='+id+'&value='+value),
    { result_ids: result_ids, skip_result_ids_check: true}
  );
}

</script>

{* custom clone node for multiple product tabs *}
<script type="text/javascript">
function fn_et_clone(){
  var $ = Tygh.$;
  id = $("#et_add_banner").data("etId");
  block_id=0;
  type = 'banner';
  box = "box_add_"+type+"_";
  next = id+1;
  new_banner = '<table class="table table-middle et-table" width="100%" id="'+box+next+'"> <!-- '+box+next+' --></table>';
  
  $("#"+box+id).after(new_banner);

  result=$.ceAjax('request', 
    fn_url('vendor_store_blocks.dynamic?new_id='+id+'&type='+type+'&block_id='+block_id),
    { result_ids: box+next, skip_result_ids_check: true}
  );

  $("#et_add_banner").data("etId",next);
}

</script>

<style type="text/css">
  .et-table:hover{
    background-color: #f5f5f5;
  }
  .et-table tbody tr:hover > td, 
  .et-table tbody tr:hover > th{
    background: none;
  }
  .et-table thead th a{
    color: #d33;
  }
  .et-table thead th .icon-plus{
    color: #0a0;
  }

  .et-title{
    font-size: 20px;
    line-height: 20px;
  }
  .et-title span{
    vertical-align: middle; 
  }
</style>

{if "MULTIVENDOR"|fn_allowed_for}
  <script>
    var fn_change_vendor_for_block = function(elm){
      $.ceAjax('request', Tygh.current_url, {
        data: {
          block_data: {
            company_id: $('[name="block_data[company_id]"]').val()
          }
        },
        result_ids: 'parent_page_selector'
      });
    };
  </script>
{/if}
