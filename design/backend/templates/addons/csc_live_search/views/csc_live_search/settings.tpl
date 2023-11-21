{capture name="mainbox"}
	<div id="clsWarningInstallation">
    {if !$install_is_success}
    	<div class="clsWarnBlock">
        	<div class="clsWarnIcon">&#9888;</div>
        	<div>{__('cls.installation_was_not_completed', ['[url]'=>fn_url('csc_live_search.install.fix'), '[download]'=>fn_url('csc_live_search.install.download')])}</div>        
        </div>
    {/if}
	<!--clsWarningInstallation--></div>


	    <form action="{""|fn_url}" method="post" name="settings_form" class="form-horizontal form-edit cm-check-changes {if fn_check_form_permissions("")}cm-hide-inputs{/if}" enctype="multipart/form-data">
        <input type="hidden" name="selected_section">
        <input type="hidden" name="return_url"value="{$config.current_url}">
        <input type="hidden" name="redirect_url"value="{$config.current_url}">
    
      
    {capture name="tabsbox"}
    	{if $allow_separate_storefronts && !$runtime.company_id}
           {assign var="disable_input" value=true}
           {assign var="show_update_for_all" value=true}          
        {/if}
        {if $fields}
        	{include file="addons/`$addon_base_name`/components/options.tpl" param_name="settings" _params=$fields prefix=$lp}       
        {else}
        	<p class="no-items">{__("no_data")}</p>       
        {/if}
    {/capture}
    {if $fields|count>1}
    	{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section track=true}
    {else}
    	{$smarty.capture.tabsbox nofilter}
    
    {/if}

	</form>    
    
    {capture name="buttons"}
    	{if $fields}
       		{include file="buttons/save.tpl" but_name="dispatch[`$addon_base_name`.settings]" but_role="submit-link" but_target_form="settings_form"}
        {/if}      
    {/capture}
{/capture}

{capture name="sidebar"}
	{if $runtime.mode=="search_motivation"}
	<div class="sidebar-row">
    <h6>{__('settings')}</h6>	
	 {include file="addons/`$addon_base_name`/views/`$addon_base_name`/components/status_field.tpl"
     	field_name=__('cls.clsm_status')
        field_name_ttl=__('cls.clsm_status_ttl')
        input_name='clsm_status'
        value=$options.clsm_status
        mode='set_setting'
     }
    </div>
    {/if}

	{include file="addons/`$addon_base_name`/components/submenu.tpl"}
    {include file="addons/`$addon_base_name`/components/reviews.tpl" addon=$addon_base_name prefix=$lp}      
{/capture}


{include file="common/mainbox.tpl" title=__("`$lp`.`$runtime.mode`") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons  content_id="`$addon_base_name`_`$runtime.mode`" mainbox_content_wrapper_class="csc-settings" sidebar=$smarty.capture.sidebar select_languages=$select_languages}