{capture name="mainbox"}
{if defined('AJAX_REQUEST')}
	{$in_popup = true}
{/if}
{assign var=id value=$synonym_data.synonym_id|default:0}

<div id="content_group{$id}">
<form action="{""|fn_url}" method="post" name="update_faq_form_{$id}" class="form-horizontal form-edit cm-disable-empty-files {$hide_inputs_class}" enctype="multipart/form-data">
<input type="hidden" class="cm-no-hide-input" name="synonym_id" value="{$id}" />
{if !$in_popup}
    <input type="hidden" name="selected_section" id="selected_section" value="{$smarty.request.selected_section}" />
{/if}
<input type="hidden" class="cm-no-hide-input" name="redirect_url" value="{$return_url|default:$smarty.request.return_url}" />
<div class="cm-tabs-content" id="tabs_content_{$id}">  
    <fieldset>
    	<div class="control-group">
            <label class="control-label cm-required" for="phrase{$id}">{__("cls.phrase")}{include file="common/tooltip.tpl" tooltip=__('cls.synonyms_phrase_ttl')}:</label>
            <div class="controls">            	
                <input type="text" id="phrase{$id}" class="input-large" name="synonym_data[phrase]" value="{$synonym_data.phrase}">
                            
            </div>
        </div>
        
        {if "MULTIVENDOR"|fn_allowed_for}
            {assign var="zero_company_id_name_lang_var" value="none"}
        {/if}
        {include file="views/companies/components/company_field.tpl"
            name="synonym_data[company_id]"
            id="elm_feature_data_`$id`"            
            selected=$synonym_data.company_id|default:$runtime.company_id
            zero_company_id_name_lang_var=$zero_company_id_name_lang_var
        }
        
        <div class="control-group">
            <label class="control-label cm-required" for="synonyms{$id}">{__("cls.synonyms")}: {include file="common/tooltip.tpl" tooltip=__('cls.synonyms_ttl')}</label>
            <div class="controls">            
                <div class="cls-synonyms input-large" data-ca-name="synonym_data[synonyms]">         
                	 <input type="hidden" value="array(){json_encode($synonym_data.synonyms)}" class="tags_array" name="synonym_data[synonyms]" />
                    {foreach from=$synonym_data.synonyms item=phrase}			
                       <div class="tag">{$phrase}</div>
                    {/foreach}
                
                </div>
               
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="language{$id}">{__("language")}:</label>
            <div class="controls">
            	{$selected_lng = $synonym_data.lang_code|default:$smarty.const.DESCR_SL} 
            	<select name="synonym_data[lang_code]" class="input-large" id="language{$id}">
                	{foreach from=$languages item=lng}
                    	<option value="{$lng.lang_code}" {if $lng.lang_code==$selected_lng} selected{/if}>{$lng.name}</option>
                    {/foreach}                
                </select>
                            
            </div>
        </div>       
        
       {include file="common/select_status.tpl" input_name="synonym_data[status]" id="elm_feature_status_{$id}" obj=$synonym hidden=false}   
       
		
    </fieldset>
</div>

{if $in_popup}
    <div class="buttons-container">       
        {include file="buttons/save_cancel.tpl" but_name="dispatch[csc_live_search.update_synonym]" cancel_action="close" hide_first_button=$hide_first_button save=$id}
    </div>
{else}
    {capture name="buttons"}
        {include file="buttons/save_cancel.tpl" but_role="submit-link" but_name="dispatch[csc_live_search.update_synonym]" but_target_form="update_faq_form_{$id}" save=$id}
    {/capture}
{/if}


</form>
<!--content_group{$id}--></div>
{/capture}

{if $in_popup}
    {$smarty.capture.mainbox nofilter}
{else}
	{if $id}
    	{$title=$synonym_data.phrase}
    {else}
    	{$title=__("cls.new_synonym")}
    {/if}

    {include file="common/mainbox.tpl" title=$title title_end='' content=$smarty.capture.mainbox buttons=$smarty.capture.buttons select_languages=false}
{/if}