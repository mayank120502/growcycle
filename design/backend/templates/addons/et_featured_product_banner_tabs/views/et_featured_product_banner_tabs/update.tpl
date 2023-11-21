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
  {capture name="tabsbox"}
  {* General tab *}
  <div id="content_general" class="hidden">
    <fieldset>
      {* Title *}
      <div class="control-group">
        <label class="control-label cm-required" for="elm_block_title_{$block_id}">
          {__("title")} <a class="cm-tooltip" title="{__("et_language_specific")}"><i class="icon-question-sign"></i></a>:
        </label>
        <div class="controls">
          <input class="input-long" type="text" name="block_data[title]" value="{$block.q_blocks.title}" id="elm_block_title_{$block_id}" />
        </div>
      </div>

      <div class="control-group">
        <label for="et_color_type" class="control-label">
          {__("et_colors")}:
        </label>
        <div class="controls">
          <select name="block_data[settings][color_type]" id="et_color_type" onchange="Tygh.$('#et_custom_color').toggle();">
            <option {if $block.q_blocks_data.color_type=="S"}selected="selected"{/if} value="S">Use style colors</option>
            <option {if $block.q_blocks_data.color_type=="C"}selected="selected"{/if} value="C">Custom colors</option>
          </select>
        </div>
      </div>

      <div class="control-group {if $block.q_blocks_data.color_type|default:"S" != "C"}hidden{/if}" id="et_custom_color">
        {* Block title color *}
        <div class="control-group">
          <label class="control-label cm-color">
            {__("et_block_title_color")}:
          </label>
          <div class="controls">
            <div class="te-colors clearfix">
              {$cp_value = ($block.q_blocks_data.color)|default:"#ffffff"}
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
            {__("et_block_title_border")}:
          </label>
          <div class="controls">
            <div class="te-colors clearfix">
              {$bkg_cp_value = ($block.q_blocks_data.bkg_color)|default:"#000000"}
              <div class="colorpicker et-picker">
                <div class="input-prepend">
                  <input type="text" maxlength="7" name="block_data[settings][bkg_color]" id="block_bkg_color" value="{$bkg_cp_value}" data-ca-view="input" class="cm-colorpicker ">
                </div>
              </div>
            </div>
          </div>
        </div>

        {* Tabs title color *}
        <div class="control-group">
          <label class="control-label cm-color">
            {__("et_tab_title_color")}:
          </label>
          <div class="controls">
            <div class="te-colors clearfix">
              {$tabs_color_cp_value = ($block.q_blocks_data.tabs_color)|default:"#000000"}
              <div class="colorpicker et-picker">
                <div class="input-prepend">
                  <input type="text" maxlength="7" name="block_data[settings][tabs_color]" id="block_tabs_color" value="{$tabs_color_cp_value}" data-ca-view="input" class="cm-colorpicker ">
                </div>
              </div>
            </div>
          </div>
        </div>
      
        {* Tab title active color *}
        <div class="control-group">
          <label class="control-label cm-color">
            {__("et_tab_title_active_color")}:
          </label>
          <div class="controls">
            <div class="te-colors clearfix">
            {$tabs_color_active_cp_value = ($block.q_blocks_data.tabs_color_active)|default:"#ff0000"}
              <div class="colorpicker et-picker">
                <div class="input-prepend">
                  <input type="text" maxlength="7" name="block_data[settings][tabs_color_active]" id="block_tabs_color_active" value="{$tabs_color_active_cp_value}" data-ca-view="input" class="cm-colorpicker ">
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </fieldset>
  </div>

  {* Tabs *}
  {function name="new_tab_block" tab_nr=$tab_nr}
    {* Position and Title *}
    <tr>
      {* Open/Collapse *}
      <td width="2%" class="cm-extended-feature">
        <span id="on_extra_feature_{$block_id}_{$tab_nr}" name="plus_minus" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand hidden cm-combination-features-{$block_id}"><span class="icon-caret-right"></span></span>
        <span id="off_extra_feature_{$block_id}_{$tab_nr}" name="minus_plus" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand cm-combination-features-{$block_id}"><span class="icon-caret-down"></span></span>
      </td>

      {* Position *}
      <td width="5%">
        <input type="hidden" class="cm-no-hide-input" name="block_data[tab][{$tab_nr}][tab_id]" value="{$tab.tab_id}" />
        <input type="hidden" class="cm-no-hide-input" name="block_data[tab][{$tab_nr}][data_id]" value="{$tab.data_id}" />
        <input type="text" name="block_data[tab][{$tab_nr}][position]" size="4" class="input-micro {if isset($tab.position)}input-hidden{/if}" value="{$tab.position}" />
      </td>

      {* Tab title *}
      <td>
        <input type="text" name="block_data[tab][{$tab_nr}][title]" class="span6 {if isset($tab.q_tabs_data.title)}input-hidden{/if}" value="{$tab.q_tabs_data.title}" />
      </td>
      
      <td>&nbsp;</td>

      {* Delete button *}
      <td class="right nowrap">
        <span class="hidden-tools">
          {if $tab.tab_id}
            {include file="buttons/multiple_buttons.tpl" item_id="add_tab_`$tab_nr`" only_delete="Y"}
          {/if}
        </span>
      </td>
    </tr>
    
    <tr id="extra_feature_{$block_id}_{$tab_nr}">
      <td colspan="5">
        {* Products *}
        <div id="et_product_filling_{$tab_nr}">
          {* <pre>{print_r($tab.q_tabs,true)}</pre> *}

          {* block_data[tab][{$tab_nr}][product_ids] *}
          {* $tab.q_tabs.product_ids *}

          {$filling=$tab.q_tabs.content.items.filling|default:"manually"}
          <div>
            <div class="control-group cm-no-hide-input">
              <label class="control-label" for="filling_select_{$tab_nr}">{__("filling")}</label>
              <div class="controls">
                <select 
                  id="filling_select_{$tab_nr}" 
                  name="block_data[tab][{$tab_nr}][content][items][filling]" 
                  onchange="fn_et_fillings(this.value,{$tab_nr});">
                  {foreach from=$et_product_fillings item=v key=k}
                    <option value="{$k}" {if $filling == $k}selected="selected"{/if}>{__($k)}</option>
                  {/foreach}
                </select>
              </div>
            </div>

            {if $filling == 'manually'}
              <div class="control-group cm-no-hide-input">
                {$prod_ids=explode(',',$tab.q_tabs.content.items.item_ids)}
                {include file="views/products/components/picker/picker.tpl"
                  input_name="block_data[tab][{$tab_nr}][content][items][item_ids]"
                  item_ids=$prod_ids
                  multiple=true
                  view_mode="external"
                  select_group_class="btn-toolbar"
                  show_positions=true
                  for_current_storefront=true
                }
              </div>
            {/if}

            {if $et_product_fillings.$filling.settings|is_array}
              {foreach from=$et_product_fillings.$filling.settings item=setting_data key=setting_name}
                {include file="views/block_manager/components/setting_element.tpl" 
                  option=$setting_data 
                  name=$setting_name 
                  block=$tab 
                  html_id="et_product_filling_`$tab_nr`_`$setting_name`" 
                  html_name="block_data[tab][{$tab_nr}][content][items][`$setting_name`]"
                  editable=true 
                  value=$tab.q_tabs.content.items.$setting_name}
              {/foreach}
            {/if}

          </div>
        <!--et_product_filling_{$tab_nr}--></div>

        {* Advanced settings *}
        <div class="control-group">
          <label class="control-label">
            {__("et_product_display_options")}:
          </label>
          <div class="controls">
            <input type="hidden" name="block_data[tab][{$tab_nr}][custom_settings][active]" value="N"/>
            <input type="checkbox" id="sw_dropdown_prod_{$tab_nr}" class="cm-combination" name="block_data[tab][{$tab_nr}][custom_settings][active]" value="Y" {if $tab.q_tabs.custom_settings.active=="Y"}checked="checked"{/if}/>
          </div>
        </div>

        <div id="dropdown_prod_{$tab_nr}" class="{if $tab.q_tabs.custom_settings.active!="Y"}hidden{/if}">

          {* Product title rows *}
          <div class="control-group">
            <label class="control-label" for="elm_title_rows_{$tab_nr}">
              {__("et_product_title_rows")} <a class="cm-tooltip" title="{__("et_product_title_rows_tooltip")}"><i class="icon-question-sign"></i></a>:
            </label>
            <div class="controls">
              <input type="text" id="elm_col_{$tab_nr}" name="block_data[tab][{$tab_nr}][custom_settings][title_rows]" class="input-micro" value="{$tab.q_tabs.custom_settings.title_rows|default:"1"}" />
            </div>
          </div>

          {* Columns *}
          <div class="control-group">
            <label class="control-label" for="elm_col_{$tab_nr}">
              {__("et_columns")} <a class="cm-tooltip" title="{__("et_columns_tooltip")}"><i class="icon-question-sign"></i></a>:
            </label>
            <div class="controls">
              <input type="text" id="elm_col_{$tab_nr}" name="block_data[tab][{$tab_nr}][custom_settings][columns]" class="input-micro" value="{$tab.q_tabs.custom_settings.columns|default:"8"}" />
            </div>
          </div>
          
          {* Thumbnail width *}
          <div class="control-group">
            <label class="control-label" for="elm_width_{$tab_nr}">
              {__("et_thumbnail_width")} <a class="cm-tooltip" title="{__("et_thumbnail_width_tooltip")}"><i class="icon-question-sign"></i></a>:
            </label>
            <div class="controls">
              <input type="text" id="elm_width_{$tab_nr}" name="block_data[tab][{$tab_nr}][custom_settings][image_width]" class="input-micro" value="{$tab.q_tabs.custom_settings.image_width|default:"178"}" />
            </div>
          </div>
        </div>

        {* Banner 1 *}
        {$banner_key="`$tab_nr`1"}

        <div class="control-group">
          <label class="control-label">
            {__("banner")} 1 <a class="cm-tooltip" title="{__("et_language_specific")}"><i class="icon-question-sign"></i></a>:
          </label>
          <div class="controls">
            <input type="hidden" name="block_data[tab][{$tab_nr}][banner_1][banner_ids]" value="{$tab.q_tabs.banner_ids.banner_1}">

            {* Banner Picker *}
            {include 
              file="addons/banners/pickers/banners/picker.tpl" 
              input_name="block_data[tab][`$tab_nr`][banner_1][banner_ids]"
              type="links" 
              item_ids=$tab.q_tabs.banner_ids.banner_1
              extra_varxxx=$tab.q_tabs.banner_ids.banner_1
              placement=""
              display="radio1"
              positions=true}
          </div>
        </div>

        {* Banner 2 *}
        {$banner_key="`$tab_nr`2"}
        <div class="control-group">
          <label class="control-label">
            {__("banner")} 2 <a class="cm-tooltip" title="{__("et_language_specific")}"><i class="icon-question-sign"></i></a>:
          </label>
          <div class="controls">
            <input type="hidden" name="block_data[tab][{$tab_nr}][banner_2][banner_ids]" value="{$tab.q_tabs.banner_ids.banner_2}">

            {* Banner Picker *}
            {include 
              file="addons/banners/pickers/banners/picker.tpl" 
              input_name="block_data[tab][`$tab_nr`][banner_2][banner_ids]"
              type="links" 
              item_ids=$tab.q_tabs.banner_ids.banner_2
              extra_varxxx=$tab.q_tabs.banner_ids.banner_2
              placement=""
              display="radio1"
              positions=true}
          </div>
        </div>
        
      </td>
    </tr>
  {/function}
  
  <div id="content_tabs" class="hidden">
    {$tab_nr=0}
    {if $block.tabs}
      {$tab_count=count($block.tabs)}
    {else}
      {$tab_count=1}
    {/if}
    
    <table class="table table-middle" id="box_add_tab_{$tab_nr}">
      <thead>
        <tr class="cm-first-sibling">
          <th class="cm-extended-feature">
            <div id="on_st_{$block_id}" name="plus_minus" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand hidden cm-combinations-features-{$block_id} icon-caret-right"></div><div id="off_st_{$block_id}"name="minus_plus" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand cm-combinations-features-{$block_id} icon-caret-down"></div>
          </th>
          <th width="5%">{__("position_short")}</th>
          <th width="50%">{__("title")} <a class="cm-tooltip" title="{__("et_language_specific")}"><i class="icon-question-sign"></i></a></th>
          <th>&nbsp;</th>
        </tr>
      </thead>
      <tbody id="box_add_tab_{$tab_count}" class="hover">
        {if $block.tabs}
          {foreach from=$block.tabs item=tab}
            {new_tab_block tab_nr=$tab_nr}
            {$tab_nr=$tab_nr+1}
          {/foreach}
        {else}
          {new_tab_block tab_nr=$tab_nr}
        {/if}
      <!-- box_add_tab_{$tab_count} --></tbody>
    </table>

    <span class="et-tab-tools tab">
      <a class="btn" name="add" data-et-id="{$tab_count}" data-et-block-id="{$block_id}" title="{__("add")}" id="et_add_tab" onclick="fn_et_clone();"><i class="icon-plus"></i> {__("add_tab")}</a>
    </span>

  </div>

  {/capture}
  
  {include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section track=true}

  {capture name="buttons"}
    {include file="buttons/save_cancel.tpl" but_role="submit-link" but_name="dispatch[et_featured_product_banner_tabs.update]" but_target_form="update_block_form_{$block_id}" save=$block_id}
  {/capture}
</form>
{/capture}

{if !$in_popup}
  {* {notes}
    {__("block_details_notes", ["[layouts_href]" => fn_url('et_featured_product_banner_tabs.notes')])}
  {/notes} *}
{/if}

{if $block.q_blocks.title}
  {$title="{__("editing")}: `$block.q_blocks.title`"}
{else}
  {$title="New"}
{/if}
{include file="common/mainbox.tpl" title="{$title}" content=$smarty.capture.mainbox buttons=$smarty.capture.buttons select_languages=true}

{* custom clone node for multiple product tabs *}
<script type="text/javascript">
  function fn_et_fillings(val,id){
    var $ = Tygh.$;

    value=val;
    result_ids = 'et_product_filling_'+id;

    result=$.ceAjax('request', 
      fn_url('et_featured_product_banner_tabs.fillings?id='+id+'&value='+value),
      { result_ids: result_ids, skip_result_ids_check: true}
    );
  }
function fn_et_clone(){
  var $ = Tygh.$;
  id=$("#et_add_tab").data("etId");
  block_id=$("#et_add_tab").data("etBlockId");
  type='tab';

  box="box_add_"+type+"_";

  next=id+1;

  new_tab='<tbody class="hover" id="'+box+next+'"> <!-- box_add_tab'+box+next+' --></tbody>';

  
  $("#"+box+id).after(new_tab);

  result=$.ceAjax('request', 
    fn_url('et_featured_product_banner_tabs.dynamic?new_id='+id+'&type='+type+'&block_id='+block_id),
    { result_ids: box+next, skip_result_ids_check: true}

  );
  $("#et_add_tab").data("etId",next);
}
</script>