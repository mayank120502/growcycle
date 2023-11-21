{capture name="mainbox"}
{if defined('AJAX_REQUEST')}
	{$in_popup = true}
{/if}
{assign var=id value=$phrase_data.phrase_id|default:0}

<div id="content_group{$id}">
<form action="{""|fn_url}" method="post" name="update_faq_form_{$id}" class="form-horizontal form-edit cm-disable-empty-files {$hide_inputs_class}" enctype="multipart/form-data">
<input type="hidden" class="cm-no-hide-input" name="phrase_id" value="{$id}" />
{if !$in_popup}
    <input type="hidden" name="selected_section" id="selected_section" value="{$smarty.request.selected_section}" />
{/if}
<input type="hidden" class="cm-no-hide-input" name="redirect_url" value="{$return_url|default:$smarty.request.return_url}" />
<div class="cm-tabs-content" id="tabs_content_{$id}">  
    <fieldset>
    	<div class="control-group">
            <label class="control-label cm-required" for="phrase{$id}">{__("cls.phrase")}:</label>
            <div class="controls">            	
                <input type="text" id="phrase{$id}" class="input-large" name="phrase_data[phrase]" value="{$phrase_data.phrase}">
                            
            </div>
        </div>
         {if "MULTIVENDOR"|fn_allowed_for}
            {assign var="zero_company_id_name_lang_var" value="none"}
        {/if}
        {include file="views/companies/components/company_field.tpl"
            name="phrase_data[company_id]"
            id="elm_feature_data_`$id`"            
            selected=$phrase_data.company_id|default:$runtime.company_id
            zero_company_id_name_lang_var=$zero_company_id_name_lang_var
        }
        
        <div class="control-group">
            <label class="control-label" for="language{$id}">{__("language")}:</label>
            <div class="controls">
            	{$selected_lng = $phrase_data.lang_code|default:$smarty.const.DESCR_SL} 
            	<select name="phrase_data[lang_code]" class="input-large" id="language{$id}">
                	{foreach from=$languages item=lng}
                    	<option value="{$lng.lang_code}" {if $lng.lang_code==$selected_lng} selected{/if}>{$lng.name}</option>
                    {/foreach}                
                </select> 
            </div>
        </div>
       {include file="common/select_status.tpl" input_name="phrase_data[status]" id="elm_feature_status_{$id}" obj=$phrase_data hidden=false} 
       <h4>{__('cls.featured_products')}</h4>
	   
       <div class="control-group">
           {if (version_compare(PRODUCT_VERSION, '4.11', '>'))}
           		{include file="views/products/components/picker/block_manager_picker.tpl"
                	data_id="objects_`$id`"
                    item_ids=$phrase_data.product_ids                     
                    input_name="phrase_data[product_ids]"                   
                    view_mode="external"                    
                    multiple=true                    
                    show_positions=true
                   }
           
           {else}
           		{if $phrase_data.product_ids}
                	{$product_ids = ','|explode:$phrase_data.product_ids}
                {else}
               	 	{$product_ids=''}
                {/if}
                {include file="pickers/products/picker.tpl"
                	type="links"
                    aoc=false
                	data_id="objects_`$id`"
                    item_ids=$product_ids                             
                    input_name="phrase_data[product_ids]"
                    multiple=true                    
                    positions=true
                    hide_options=true
                   }
            {/if}
            
            
        </div>    
       
		
    </fieldset>
</div>

{if $in_popup}
    <div class="buttons-container">       
        {include file="buttons/save_cancel.tpl" but_name="dispatch[csc_live_search.update_phrase]" cancel_action="close" hide_first_button=$hide_first_button save=$id}
    </div>
{else}
    {capture name="buttons"}
        {include file="buttons/save_cancel.tpl" but_role="submit-link" but_name="dispatch[csc_live_search.update_phrase]" but_target_form="update_faq_form_{$id}" save=$id}
    {/capture}
{/if}


</form>
<!--content_group{$id}--></div>
{/capture}

{if $in_popup}
    {$smarty.capture.mainbox nofilter}
{else}
	{if $id}
    	{$title=$phrase_data.phrase}
    {else}
    	{$title=__("cls.new_phrase")}
    {/if}

    {include file="common/mainbox.tpl" title=$title title_end='' content=$smarty.capture.mainbox buttons=$smarty.capture.buttons select_languages=false}
{/if}