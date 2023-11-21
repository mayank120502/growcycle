<div>
	<div class="control-group">
	  <label class="control-label" for="filling_select">{__("filling")}</label>
	  <div class="controls">
	    <select 
	      id="filling_select" 
	      name="category_data[et_menu][products][content][items][filling]" 
	      onchange="fn_et_fillings(this.value);">
	      {foreach from=$fillings item=v key=k}
	        <option value="{$k}" {if $filling == $k}selected="selected"{/if}>{__($k)}</option>
	      {/foreach}
	    </select>
	  </div>
	</div>

  {if $filling == 'manually'}
    <div class="control-group cm-no-hide-input">

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

  {if $fillings.$filling.settings|is_array}
    {foreach from=$fillings.$filling.settings item=setting_data key=setting_name}
      {include file="views/block_manager/components/setting_element.tpl" 
        option=$setting_data 
        name=$setting_name 
        html_id="product_filling_`$id`_`$setting_name`" 
        html_name="category_data[et_menu][products][content][items][`$setting_name`]"
        editable=true}
    {/foreach}
  {/if}

</div>
