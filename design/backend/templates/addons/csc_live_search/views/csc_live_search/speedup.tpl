{capture name="mainbox"}
	
    
    {if $runtime.action=="settings"}
    <form action="{""|fn_url}" method="post" name="settings_form" class="form-horizontal form-edit cm-check-changes" enctype="multipart/form-data">
        <input type="hidden" name="selected_section">
        <input type="hidden" name="return_url"value="{$config.current_url}">
        <input type="hidden" name="redirect_url"value="{$config.current_url}">
    	{if $allow_separate_storefronts && !$runtime.company_id}
           {assign var="disable_input" value=true}
           {assign var="show_update_for_all" value=true}          
        {/if}
        {if $fields}
        	{include file="addons/`$addon_base_name`/components/options.tpl" param_name="settings" _params=$fields prefix=$lp}       
        {else}
        	<p class="no-items">{__("no_data")}</p>       
        {/if}

	</form> 
    {/if}
    {if $runtime.action=="indexation"}
    
   	 <iframe style="border:none;" src="{"csc_live_search.landing"|fn_url}" width="100%" height="950px"></iframe>
    {/if}  
    
    {capture name="buttons"}
    	{capture name="tools_list"}
           <li>{btn type="list" text=__("cls.clear_indexes") href="csc_live_search.clear_speedup?redirect_url={$config.current_url|urlencode}" class="cm-confirm cm-post"}</li>          
        {/capture}
        {dropdown content=$smarty.capture.tools_list}   
    
    	{if $fields}
       		{include file="buttons/save.tpl" but_name="dispatch[`$addon_base_name`.settings]" but_role="submit-link" but_target_form="settings_form"}
        {/if}      
    {/capture}
{/capture}

{capture name="sidebar"}
	<div class="sidebar-row">
    <h6>{__('settings')}</h6>	
	 {include file="addons/`$addon_base_name`/views/`$addon_base_name`/components/status_field.tpl"
     	field_name=__('cls.clss_status')
        field_name_ttl=__('cls.clss_status_ttl')
        input_name='clss_status'
        value=$options.clss_status
        mode='set_setting'
     }
     
     {include file="addons/`$addon_base_name`/views/`$addon_base_name`/components/status_field.tpl"
     	field_name=__('cls.clss_admin_status')
        field_name_ttl=__('cls.clss_admin_status_ttl')
        input_name='clss_admin_status'
        value=$options.clss_admin_status
        mode='set_setting'
     }
    </div>

	{include file="addons/`$addon_base_name`/components/submenu.tpl"}
    <div class="sidebar-row ">
    <h6>{__('css.cron_commands')}</h6>	
    <p>{__('css.cron_run_speedup_scaner')}:</p>
    <p class="cls-cmd">{fn_url("csc_live_search.cron?key=`$options.speedup_cron_key`", 'A')}</p>
	<p>{__('css.full_cron_run_speedup_scaner_with')}:</p>
    <p class="cls-cmd">{fn_url("csc_live_search.cron?key=`$options.speedup_cron_key`&full_scan=Y", 'A')}</p>
	
	<p>{__('css.example_run_php_script')}:</p>
    <p class="cls-cmd">/usr/bin/php {$smarty.const.DIR_ROOT}/{$config.admin_index} --key={$options.speedup_cron_key} --dispatch=csc_live_search.cron</p>
    
    </div>
    
    {include file="addons/`$addon_base_name`/components/reviews.tpl" addon=$addon_base_name prefix=$lp}      
{/capture}


{include file="common/mainbox.tpl" title=__("`$lp`.`$runtime.mode`") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons  content_id="`$addon_base_name`.`$runtime.mode`" mainbox_content_wrapper_class="csc-settings" sidebar=$smarty.capture.sidebar select_languages=$select_languages}