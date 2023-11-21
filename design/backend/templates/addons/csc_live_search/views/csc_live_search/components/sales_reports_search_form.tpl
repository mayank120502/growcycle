<div class="sidebar-row">
<form action="{""|fn_url}" method="get" name="report_form">
<h6>{__("search")}</h6>
    {capture name="simple_search"}
        <input type="hidden" name="report_id" value="{$report.report_id}">
        <input type="hidden" name="selected_section" value="">
       {if $runtime.action=="per_user"}
       <div class="sidebar-field">
            <label for="elm_name">{__("person_name")}</label>
            <div class="break">
                <input type="text" name="name" id="elm_name" value="{$search.name}" />
            </div>
        </div>
        {/if}
        
        <div class="sidebar-field">
            <label for="q">{__("cls.search_word")}</label>
            <input type="text" name="q" id="q" value="{$search.q}" size="30" />
        </div>
        
        
        {if $runtime.action=="per_request" || $runtime.action=="per_word"}
        {assign var=langs value=""|fn_get_translation_languages}      
        <div class="sidebar-field">
            <label for="lang_code">{__("language")}</label>
            <select name="lang_code" id="lang_code">
            	<option value="">{__('all')}</option>
            	{foreach from=$langs item=lang key=k}
            	<option value="{$k}" {if $search.lang_code==$k} selected="selected"{/if}>{$lang.name}</option>
                {/foreach}
            </select>            
        </div>
        {/if}
        
        {if $runtime.action=="per_request"}
         <div class="sidebar-field">
            <label for="ip">{__("ip_address")}</label>
            <input type="text" name="ip" id="ip" value="{$search.ip}" size="30" />
        </div>
        {/if}
        
        {include file="common/period_selector.tpl" period=$period display="form"}
    {/capture}
    {include file="common/advanced_search.tpl" no_adv_link=true simple_search=$smarty.capture.simple_search not_saved=true dispatch=$dispatch}
</form>
</div>