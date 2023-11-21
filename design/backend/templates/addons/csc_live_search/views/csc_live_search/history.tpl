{capture name="mainbox"}
	{include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id="search_history_`$runtime.action``$search.user_id`"}
    {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
    {assign var="rev" value="search_history_`$runtime.action``$search.user_id`"}
    {assign var="c_icon" value="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
    {assign var="c_dummy" value="<i class=\"icon-dummy\"></i>"}    
    <form action="{""|fn_url}" method="post" name="history_form" class="form-horizontal form-edit cm-check-changes" enctype="multipart/form-data">        
        {include file="addons/`$addon_base_name`/views/`$addon_base_name`/history/`$runtime.action`.tpl"}
	</form>
    {include file="common/pagination.tpl" div_id="search_history_`$runtime.action``$search.user_id`"}   
{/capture}

{capture name="buttons"}
    {capture name="tools_list"}
        <li>{btn type="list" class="cm-confirm cm-post" text=__("delete_selected") dispatch="dispatch[csc_live_search.m_delete_history]" form="history_form" }</li>
        <li class="divider"></li>
        
        {if $runtime.action=="per_request"}
        	<li>{btn type="list" class="cm-confirm" text=__("cls.clear_all_requests") href="csc_live_search.clean_requests?days=0"}</li> 
            {foreach from=[30, 90, 180, 360] item="days"}
                <li>{btn type="list" class="cm-confirm" text=__("cls.days_clear", ['[days]'=>$days]) href="csc_live_search.clean_requests?days=`$days`"}</li> 
            {/foreach}
            <li class="divider"></li>
        {/if} 
        
        <li>{btn type="list" class="cm-confirm cm-post" text=__("cleanup_all_history") href="csc_live_search.delete_all"}</li>   
                
    {/capture}
    {dropdown content=$smarty.capture.tools_list}
{/capture}
{capture name="sidebar"}
	<div class="sidebar-row">
    <h6>{__('settings')}</h6>	
	 {include file="addons/`$addon_base_name`/views/`$addon_base_name`/components/status_field.tpl"
     	field_name=__('cls.enable_history')
        field_name_ttl=''
        input_name='enable_history'
        value=$options.enable_history
        mode='set_setting'
     }
     
     </div>

	{include file="addons/`$addon_base_name`/components/submenu.tpl"}
    {include file="addons/`$addon_base_name`/views/`$addon_base_name`/components/sales_reports_search_form.tpl" period=$search.period search=$search dispatch="`$runtime.controller`.`$runtime.mode`.`$runtime.action`"} 
    <div class="sidebar-row">    
       <h6>{__("information")}</h6> 
       <p class="cls-info">{__('cls.cron_job')}</p>
        <p class="cls-cmd">wget -O /dev/null "{"csc_live_search.clean_requests?days=30"|fn_url:"A"}"</p>
        <p class="cls-cmd">/usr/bin/php {$smarty.const.DIR_ROOT}/{$config.admin_index}  --dispatch=csc_live_search.clean_requests --days=30</p>
</div>
          
{/capture}

{if $in_popup}
    {$smarty.capture.mainbox nofilter}
{else}
    {include file="common/mainbox.tpl" title=__("cls.history_`$runtime.action`") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons   mainbox_content_wrapper_class="csc-settings" sidebar=$smarty.capture.sidebar}
{/if}
