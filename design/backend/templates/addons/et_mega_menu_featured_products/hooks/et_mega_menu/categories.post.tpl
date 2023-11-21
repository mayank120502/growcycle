{* Menu Product *}
{if $et_menu.products.et_menu_product_status|default:"N" != "Y"}
  {assign var=et_menu_product_disabled value="disabled"}
{/if}

{include file="common/subheader.tpl" title="{__("et_mega_menu.products_settings")}" target="#et_menu_product_setting"}

<div id="et_menu_product_setting" class="in collapse">
  {* Activate settings *}
  <div class="control-group">
    <label class="control-label" for="et_menu_product_status">
      {__("enabled")}
    </label>
    <div class="controls checkbox">
      <input type="hidden" name="category_data[et_menu][products][enabled]" value="N" />
      <input type="checkbox" name="category_data[et_menu][products][enabled]" id="et_menu_product_status" value="Y" {if $et_menu.products.enabled == "Y"}checked="checked"{/if} onchange="Tygh.$('#et_menu_products_toggle').toggle();">
    </div>
  </div>

  <div id="et_menu_products_toggle" class="{if $et_menu.products.enabled|default:"N" != "Y"}hidden{/if}">

    {* Position *}
    <div class="control-group">
      <label class="control-label">{__("position")}</label>
      <div class="controls">
      <select id="et_menu_product_position" name="category_data[et_menu][products][position]">
        <option {if $et_menu.products.position=="R"}selected="selected"{/if} value="R">{__("right")}</option>
        <option {if $et_menu.products.position=="L"}selected="selected"{/if} value="L">{__("left")}</option>
        <option {if $et_menu.products.position=="T"}selected="selected"{/if} value="T">{__("et_top")}</option>
        <option {if $et_menu.products.position=="B"}selected="selected"{/if} value="B">{__("et_bottom")}</option>
      </select>
      </div>
    </div>

    {* Show Title *}
    <div class="control-group">
      <label class="control-label" for="et_menu_product_show_section_title">
        {__("et_show_title")}
      </label>
      <div class="controls checkbox">
        <input type="hidden" name="category_data[et_menu][products][show_title]" value="N" />
        <input id="sw_dropdown_et_section_title_colors" class="cm-combination" type="checkbox" name="category_data[et_menu][products][show_title]" {if $et_menu.products.show_title != "N"}checked{/if} value="Y">
      </div>
    </div>

    <div id="dropdown_et_section_title_colors" class="{if $et_menu.products.show_title == "N"}hidden{/if}">
      {* Title *}
      <div class="control-group">
        <label for="et_menu_descr" class="control-label">
          {__("et_title_text")}
        </label>
        <div class="controls">
          <input type="text" id="et_menu_descr" name="category_data[et_menu][products][title]" size="10" value="{$et_menu.products.title|default:""}" class="input-large">
        </div>
      </div>

      <div class="control-group">
          <label class="control-label">
            Title colors:
          </label>
          <div class="controls">
            <select name="category_data[et_menu][products][color_type]" onchange="Tygh.$('#et_custom_product_tab_colors').toggle();">
              <option {if $et_menu.products.color_type=="S"}selected="selected"{/if} value="S">Use style colors</option>
              <option {if $et_menu.products.color_type=="C"}selected="selected"{/if} value="C">Custom colors</option>
            </select>
          </div>
      </div>

      <div id="et_custom_product_tab_colors" class="{if $et_menu.products.color_type|default:"S" != "C"}hidden{/if}">
        <div class="control-group">
          <label class="control-label cm-color">
          {__("et_transparent_background")}
          </label>
          <div class="controls checkbox">
            <input type="hidden" name="category_data[et_menu][products][title_bkg_transparent]" value="N"/>
            <input id="sw_dropdown_et_section_title_bkg" class="cm-combination" name="category_data[et_menu][products][title_bkg_transparent]" type="checkbox" {if $et_menu.products.title_bkg_transparent=="Y"}checked{/if} value="Y">
          </div>
        </div>

        <div id="dropdown_et_section_title_bkg" class="control-group  {if $et_menu.products.title_bkg_transparent=="Y"}hidden{/if}">
          <label class="control-label">
            {__("et_title_background")}
          </label>
          <div class="controls clearfix">
            {$cp_value = ($et_menu.products.title_bkg)|default:"#000000"}
            <div  class="colorpicker et-picker">
              <div class="input-prepend">
                <input type="text" maxlength="7" name="category_data[et_menu][products][title_bkg]" id="et_section_title_bkg" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
              </div>
            </div>
          </div>
        </div>
     
        <div class="control-group">
          <label class="control-label cm-color">
            {__("et_title_color")}
          </label>
          <div class="controls">
            <div class="te-colors clearfix">
            {$cp_value = ($et_menu.products.title_color)|default:"#ffffff"}
              <div class="colorpicker et-picker">
                <div class="input-prepend">
                  <input type="text"  maxlength="7" name="category_data[et_menu][products][title_color]" id="et_section_title_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    {* Discount label *}
    <div class="control-group">
      <label class="control-label" for="et_menu_product_show_discount_label">
        {__("et_show_discount_label")}
      </label>
      <div class="controls checkbox">
        <input type="hidden" name="category_data[et_menu][products][show_discount_label]" value="N" />
        <input type="checkbox" name="category_data[et_menu][products][show_discount_label]" id="et_menu_product_show_discount_label" {if $et_menu.products.show_discount_label != "N"}checked="checked"{/if} value="Y">
      </div>
    </div>

    {* Product name *}
    <div class="control-group">
      <label class="control-label" for="et_menu_product_show_title">
        {__("et_show_product_name")}
      </label>
      <div class="controls checkbox">
        <input type="hidden" name="category_data[et_menu][products][show_name]" value="N" />
        <input type="checkbox" name="category_data[et_menu][products][show_name]" id="et_menu_product_show_title" {if $et_menu.products.show_name != "N"}checked="checked"{/if} value="Y">
      </div>
    </div>

    {* Price *}
    <div class="control-group">
      <label class="control-label" for="et_menu_product_show_price">
        {__("et_show_product_price")}
      </label>
      <div class="controls checkbox">
        <input type="hidden" name="category_data[et_menu][products][show_price]" value="N" />
        <input type="checkbox" name="category_data[et_menu][products][show_price]" id="et_menu_product_show_price" {if $et_menu.products.show_price != "N"}checked="checked"{/if} value="Y">
      </div>
    </div>

    {* Old price *}
    <div class="control-group">
      <label class="control-label" for="et_menu_product_show_old_price">
        {__("et_show_old_price")}
      </label>
      <div class="controls checkbox">
        <input type="hidden" name="category_data[et_menu][products][show_old_price]" value="N" />
        <input type="checkbox" name="category_data[et_menu][products][show_old_price]" id="et_menu_product_show_old_price" {if $et_menu.products.show_old_price != "N"}checked="checked"{/if} value="Y">
      </div>
    </div>

    {* Products *}
    <div id="et_menu_product_filling_{$id}">

      {$filling=$et_menu.products.content.items.filling|default:"manually"}
      <div>
        <div class="control-group cm-no-hide-input">
          <label class="control-label" for="filling_select">{__("filling")}</label>
          <div class="controls">
            <select 
              id="filling_select" 
              name="category_data[et_menu][products][content][items][filling]" 
              onchange="fn_et_fillings(this.value);">
              {foreach from=$et_menu_product_fillings item=v key=k}
                <option value="{$k}" {if $filling == $k}selected="selected"{/if}>{__($k)}</option>
              {/foreach}
            </select>
          </div>
        </div>

        {if $filling == 'manually'}
          <div class="control-group cm-no-hide-input">
            {$prod_ids=explode(',',$et_menu.products.content.items.item_ids)}
            {include file="views/products/components/picker/picker.tpl"
              input_name="category_data[et_menu][products][content][items][item_ids]"
              item_ids=$prod_ids
              multiple=true
              view_mode="external"
              select_group_class="btn-toolbar"
              show_positions=true
            }
          </div>
        {/if}

        {if $et_menu_product_fillings.$filling.settings|is_array}
          {foreach from=$et_menu_product_fillings.$filling.settings item=setting_data key=setting_name}
            {include file="views/block_manager/components/setting_element.tpl" 
              option=$setting_data 
              name=$setting_name 
              block=$vsb 
              html_id="et_menu_product_filling_`$id`_`$setting_name`" 
              html_name="category_data[et_menu][products][content][items][`$setting_name`]"
              editable=true 
              value=$et_menu.products.content.items.$setting_name}
          {/foreach}
        {/if}

      </div>
    <!--et_menu_product_filling_{$id}--></div>
  </div>

</div>

<script type="text/javascript">
function fn_et_fillings(val){
  var $ = Tygh.$;
  id = {$id};
  value=val;
  result_ids = 'et_menu_product_filling_'+id;

  result=$.ceAjax('request', 
    fn_url('categories.et_menu_product_fillings?id='+id+'&value='+value),
    { result_ids: result_ids, skip_result_ids_check: true}
  );
}

</script>