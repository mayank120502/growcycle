{math equation="rand()" assign="rnd"}
{assign var="data_id" value="`$data_id`_`$rnd`"}
{assign var="view_mode" value=$view_mode|default:"mixed"}

{script src="js/tygh/picker.js"}

<div class="clearfix">
  <label class="control-label">{__("block")}</label>
  <div class="controls">
    <div class="choose-input">
      <div class="pull-right">
        <div class="choose-icon input-append">
          {$picker="et_featured_product_banner_tabs.picker?display=radio&checkbox_name=`$checkbox_name`&data_id=`$data_id``$extra_url`&company_id=`$company_id`&et_selected_id=`$item_ids`"}
          {include file="buttons/button.tpl" 
            but_id="opener_picker_`$data_id`" 
            but_href=$picker|fn_url 
            but_text="<i class='icon-plus'></i>"
            but_role="icon"
            but_target_id="content_`$data_id`" 
            but_meta="cm-dialog-opener add-on btn"}
        </div>
      </div>
    
      <div class="hidden" id="content_{$data_id}" title="{__("select_block")}"></div>
    
      <div id="{$data_id}" class="cm-display-radio">
        <input type="hidden" 
          id="{$data_id}_ids" 
          class="cm-picker-value" 
          name="{$input_name}" 
          value="{if $item_ids}{$item_ids}{/if}" />
    
        <div class="input-append">
          <div class="pull-left">
            {include file="addons/et_featured_product_banner_tabs/pickers/js.tpl" 
              et_block_id=$item_ids|default:""
              holder=$data_id 
              input_name=$input_name 
              hide_link=$hide_link 
              hide_delete_button=$hide_delete_button}
          </div>
        </div>
      </div>
    </div>
  </div>
</div>