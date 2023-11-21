{if $type=="tab"}
{* Tab number *}
{$tab_nr=$id}

{* Position and Title *}
	<tr>
		{* Open/Collapse *}
		<td width="2%" class="cm-extended-feature">
			<span id="on_extra_feature_{$block_id}_{$tab_nr}" name="plus_minus" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand hidden cm-combination-features-{$block_id}"><span class="icon-caret-right"></span></span>
			<span id="off_extra_feature_{$block_id}_{$tab_nr}" name="minus_plus" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand cm-combination-features-{$block_id}"><span class="icon-caret-down"></span></span>
		</td>
		
		{* Position *}
		<td width="5%">
			<input type="hidden" class="cm-no-hide-input" name="block_data[tab][{$tab_nr}][tab_id]" value="" />
			<input type="hidden" class="cm-no-hide-input" name="block_data[tab][{$tab_nr}][data_id]" value="" />
			<input type="text" name="block_data[tab][{$tab_nr}][position]" size="4" class="input-micro" value="" />
		</td>

		{* Tab title *}
		<td>
			<input type="text" name="block_data[tab][{$tab_nr}][title]" class="span6" value="" />
		</td>

		<td>&nbsp;</td>

		{* Delete button *}
		<td class="right nowrap">
			<span class="hidden-tools">
				{include file="buttons/multiple_buttons.tpl" item_id="add_tab_`$tab_nr`" only_delete="Y"}
			</span>
		</td>
	</tr>

	<tr id="extra_feature_{$block_id}_{$tab_nr}">
		<td colspan="5">

      {* Products *}
      <div id="et_product_filling_{$tab_nr}">

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
					<input type="checkbox" id="sw_dropdown_prod_{$tab_nr}" class="cm-combination" name="block_data[tab][{$tab_nr}][custom_settings][active]" value="Y" {if $tab.custom_settings=="Y"}checked="checked"{/if}/>
				</div>
			</div>

			<div id="dropdown_prod_{$tab_nr}" class="hidden">

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
						<input type="text" id="elm_col_{$tab_nr}" name="block_data[tab][{$tab_nr}][custom_settings][columns]" class="input-micro" value="{$tab.columns|default:"8"}" />
					</div>
				</div>
				
				{* Thumbnail width *}
				<div class="control-group">
					<label class="control-label" for="elm_width_{$tab_nr}">
						{__("et_thumbnail_width")} <a class="cm-tooltip" title="{__("et_thumbnail_width_tooltip")}"><i class="icon-question-sign"></i></a>:
					</label>
					<div class="controls">
						<input type="text" id="elm_width_{$tab_nr}" name="block_data[tab][{$tab_nr}][custom_settings][image_width]" class="input-micro" value="{$tab.image_width|default:"178"}" />
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
          <input type="hidden" name="block_data[tab][{$tab_nr}][banner_1][banner_ids]" value="">

          {* Banner Picker *}
          {include 
            file="addons/banners/pickers/banners/picker.tpl" 
            input_name="block_data[tab][`$tab_nr`][banner_1][banner_ids]"
            type="links" 
            item_ids=""
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
          <input type="hidden" name="block_data[tab][{$tab_nr}][banner_2][banner_ids]" value="">

          {* Banner Picker *}
          {include 
            file="addons/banners/pickers/banners/picker.tpl" 
            input_name="block_data[tab][`$tab_nr`][banner_2][banner_ids]"
            type="links" 
            item_ids=""
            placement=""
            display="radio1"
            positions=true}
        </div>
      </div>
		</td>
	</tr>

{elseif $type=="tab1"}
{* Tab number *}
{$tab_nr=$id}
<thead>
	<tr>
		<th colspan="2" class="et-title">
			<input type="hidden" class="cm-no-hide-input" name="block_data[tab][{$tab_nr}][tab_id]" value="" />
			<input type="hidden" class="cm-no-hide-input" name="block_data[tab][{$tab_nr}][data_id]" value="" />
			<span>
				{__("tab")} {$tab_nr+1}
			</span>
			<span class="hidden-tools et-tab-tools">
				{include file="buttons/multiple_buttons.tpl" item_id="add_tab_`$tab_nr`" only_delete="Y"}
			</span>
		</th>
		<th class="cm-extended-feature right" width="5%">
			<div name="plus_minus" id="on_et_tab_{$tab_nr}" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand hidden exicon-expand cm-combination-features-{$tab_nr}"></div>
			<div name="minus_plus" id="off_et_tab_{$tab_nr}" alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" class="hand exicon-collapse cm-combination-features-{$tab_nr}"></div>
		</th>
	</tr>
</thead>

{* Position and Title *}
<tbody id="et_tab_{$tab_nr}">
	<tr>
		<th width="5%">{__("position_short")}</th>
		<th width="50%">{__("tab")}</th>
		<th>&nbsp;</th>
	</tr>
	<tr>
		<td width="5%">
			<input type="text" name="block_data[tab][{$tab_nr}][position]" size="4" class="input-micro" value="" /></td>
		<td colspan="2">
			<input type="text" name="block_data[tab][{$tab_nr}][title]" class="input-full" value="" /></td>
	</tr>

	{* Banners *}
	<tr>
		<td colspan="3">
			{$banner_key="`$tab_nr`1"}
			<div class="control-group">
				<label class="control-label">
					{__("banner")} 1 <a class="cm-tooltip" title="{__("et_language_specific")}"><i class="icon-question-sign"></i></a>:
				</label>
				<div class="controls">
					{include file="common/attach_images.tpl" image_name="et_fpbt_1" image_object_type="et_fpbt_1" image_key=$banner_key hide_titles=true no_detailed=true image_pair=""}
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="elm_url_{$banner_key}">
					{__("url")}:
				</label>
				<div class="controls">
					<input type="text" id="elm_url_{$banner_key}" name="block_data[tab][{$tab_nr}][url_banner_1]" class="input-full" value="" />
				</div>
			</div>

			{$banner_key="`$tab_nr`2"}
			<div class="control-group">
				<label class="control-label">
					{__("banner")} 2 <a class="cm-tooltip" title="{__("et_language_specific")}"><i class="icon-question-sign"></i></a>:
				</label>
				<div class="controls">
					{include file="common/attach_images.tpl" image_name="et_fpbt_2" image_object_type="et_fpbt_2" image_key=$banner_key hide_titles=true no_detailed=true image_pair=""}
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="elm_url_{$banner_key}">
					{__("url")}
				</label>
				<div class="controls">
					<input type="text" id="elm_url_{$banner_key}" name="block_data[tab][{$tab_nr}][url_banner_2]" class="input-full" value="" />
				</div>
			</div>
		</td>
	</tr>

	{* Advanced settings *}
	<tr>
		<td colspan="3">
			<div class="control-group">
				<label class="control-label">
					{__("et_product_display_options")}:
				</label>
				<div class="controls">
					<input type="hidden" name="block_data[tab][{$tab_nr}][custom_settings][active]" value="N"/>
					<input type="checkbox" id="sw_dropdown_prod_{$tab_nr}" class="cm-combination" name="block_data[tab][{$tab_nr}][custom_settings][active]" value="Y" {if $tab.custom_settings=="Y"}checked="checked"{/if}/>
				</div>
			</div>

			<div id="dropdown_prod_{$tab_nr}" class="{if $tab.custom_settings!="Y"}hidden{/if}">

				{* Product title rows *}
				<div class="control-group">
					<label class="control-label" for="elm_title_rows_{$tab_nr}">
						{__("et_product_title_rows")} <a class="cm-tooltip" title="{__("et_product_title_rows_tooltip")}"><i class="icon-question-sign"></i></a>:
					</label>
					<div class="controls">
						<input type="text" id="elm_col_{$tab_nr}" name="block_data[tab][{$tab_nr}][custom_settings][title_rows]" class="input-micro" value="{$tab.q_tabs.custom_settings.title_rows|default:"1"}" />
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="elm_col_{$tab_nr}">
						{__("et_columns")} <a class="cm-tooltip" title="{__("et_columns_tooltip")}"><i class="icon-question-sign"></i></a>:
					</label>
					<div class="controls">
						<input type="text" id="elm_col_{$tab_nr}" name="block_data[tab][{$tab_nr}][custom_settings][columns]" class="input-micro" value="{$tab.columns|default:"8"}" />
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="elm_width_{$tab_nr}">
						{__("et_thumbnail_width")} <a class="cm-tooltip" title="{__("et_thumbnail_width_tooltip")}"><i class="icon-question-sign"></i></a>:
					</label>
					<div class="controls">
						<input type="text" id="elm_width_{$tab_nr}" name="block_data[tab][{$tab_nr}][custom_settings][image_width]" class="input-micro" value="{$tab.image_width|default:"178"}" />
					</div>
				</div>
			</div>
			<div class="product-picker">
				{include 
					file="pickers/products/picker.tpl" 
					input_name="block_data[tab][{$tab_nr}][product_ids]"
					type="links" 
					item_ids=""
					placement="right"
					positions=true
					et_auto_size=true}
			</div>
		</td>
	</tr>
</tbody>
{/if}