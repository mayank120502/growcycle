<div id="content_et_ved">
	{foreach from=$vendor_extra_details item=data key=key name=name}
		{if $key!="M" && $key!="C"}
			<div class="control-group {if $share_dont_hide}cm-no-hide-input{/if}">
				<label class="control-label" for="elm_et_vendor_extra_details_{$key}">{__("et_vendor_extra_details_{$key}")}:</label>
				<div class="controls">

					<input type="text" name="company_data[vendor_extra_details][{$key}]" id="elm_et_vendor_extra_details_{$key}" size="10" value="{$vendor_extra_details.$key}" class="input-long" />
				</div>
			</div>
		{/if}
	{/foreach}
</div>

<div id="content_et_pp_block">
	{foreach from=$et_pp_block.types item=data key=key name=name}
		<div class="control-group {if $share_dont_hide}cm-no-hide-input{/if}">
			<label class="control-label" for="elm_et_pp_block_{$key}">{__("et_pp_block_{$data}")}:</label>
			<div class="controls">
				<textarea name="company_data[et_pp_block_{$key}]" cols="55" rows="4" class="span9 cm-wysiwyg" id="elm_et_pp_block_{$key}">{$et_pp_block.data.$data.description}</textarea>
			</div>
		</div>
	{/foreach}
</div>

{function name="et_color_option" data=$data value=$value default_value=$default_value title=$title}
<div class="control-group">
  <div class="clearfix">
    <label class="control-label cm-color">
    	{$title}
    </label>
    <div class="controls">
      <div class="te-colors clearfix">
        {$cp_value = $value|default:$default_value}
        <div class="colorpicker et-picker">
          <div class="input-prepend">
            <input type="text"  maxlength="7"  name="{$data}" id="et_text_color" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
{/function}
<div id="content_et_vs">
	{$et_default_colors=$et_default_settings.vendor_colors}

	{include file="common/subheader.tpl" title="{__("header_colors")}" target="#et_header_colors"}
	<input type="hidden" name="company_data[et_vs][ved_id]" value="{$company_data.et_vs.ved_id}">
	<input type="hidden" name="company_data[et_vs][company_id]" value="{$company_data.et_vs.company_id}">

	<div id="et_header_colors" class="in collapse">

		{et_color_option 
			data="company_data[et_vs][data][bkg]" 
			value=$company_data.et_vs.data.bkg 
			default_value=$et_default_colors.header_bkg|default:"#ffffff" 
			title=__("theme_editor.background")
		}
		
		{et_color_option 
			data="company_data[et_vs][data][color]" 
			value=$company_data.et_vs.data.color 
			default_value=$et_default_colors.header_text|default:"#000000" 
			title=__("text")
		}

		{et_color_option 
			data="company_data[et_vs][data][header_hover]" 
			value=$company_data.et_vs.data.header_hover 
			default_value=$et_default_colors.header_hover|default:"#000000" 
			title=__("et_text_hover")
		}
	</div>
	
	{include file="common/subheader.tpl" title="{__("menu_colors")}" target="#et_menu_colors"}

	<div id="et_menu_colors" class="in collapse">
		{et_color_option 
			data="company_data[et_vs][data][bkg_menu]" 
			value=$company_data.et_vs.data.bkg_menu 
			default_value=$et_default_colors.menu_bkg|default:"#ffffff" 
			title=__("theme_editor.background")
		}
		
		{et_color_option 
			data="company_data[et_vs][data][color_menu]" 
			value=$company_data.et_vs.data.color_menu 
			default_value=$et_default_colors.menu_text|default:"#000000" 
			title=__("text")
		}
		
		{et_color_option 
			data="company_data[et_vs][data][bkg_menu_hover]" 
			value=$company_data.et_vs.data.bkg_menu_hover 
			default_value=$et_default_colors.menu_bkg_hover|default:"#000000" 
			title=__("et_background_hover")
		}
		
		{et_color_option 
			data="company_data[et_vs][data][color_menu_hover]" 
			value=$company_data.et_vs.data.color_menu_hover 
			default_value=$et_default_colors.menu_text_hover|default:"#ffffff" 
			title=__("et_text_hover")
		}
	</div>

	{include file="common/subheader.tpl" title="{__("store_category_settings")}" target="#et_category_settings"}

		<div class="control-group {if $share_dont_hide}cm-no-hide-input{/if}">
			{$filters=$company_data.et_vs.data.filters|default:$addons.et_vivashop_mv_functionality.et_vendor_filters}
			<label class="control-label">
				{__("et_product_filters")}:
			</label>
			<div class="controls">
				<select name="company_data[et_vs][data][filters]" id="">
					<option value="vertical" {if $filters=="vertical"}selected="selected"{/if}>{__("et_vertical")}</option>
					<option value="horizontal" {if $filters=="horizontal"}selected="selected"{/if}>{__("et_horizontal")}</option>
				</select>
			</div>
		</div>

		<div id="et_category_settings" class="in collapse">
			<div class="control-group {if $share_dont_hide}cm-no-hide-input{/if}">

				{$category=$company_data.et_vs.data.side_categ|default:$addons.et_vivashop_mv_functionality.et_vendor_categories}

				<label class="control-label">
					{__("et_sidebar_category")}:
				</label>
				<div class="controls">
					<select name="company_data[et_vs][data][side_categ]" id="">
						<option value="collapsed" {if $category=="collapsed"}selected="selected"{/if}>{__("et_collapsed")}</option>
						<option value="expanded" {if $category=="expanded"}selected="selected"{/if}>{__("et_expanded")}</option>
					</select>
				</div>
			</div>

	</div>
	
</div>