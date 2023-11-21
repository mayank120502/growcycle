{capture name="mainbox"}

    {include file="common/pagination.tpl"}
    {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
    {assign var="rev" value=$smarty.request.content_id|default:"pagination_contents"}
    {assign var="c_icon" value="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
    {assign var="c_dummy" value="<i class=\"icon-dummy\"></i>"}
    {assign var="r_url" value=$config.current_url|escape:url}
    {$show_in_popup=true}
   

    <form action="{""|fn_url}" method="post" name="manage_stop_words_form" id="manage_stop_words_form">
    <input type="hidden" name="return_url" value="{$config.current_url}">
    <div class="items-container{if ""|fn_check_form_permissions} cm-hide-inputs{/if}" id="update_customs_list">
        {if $stop_words}
            <div class="table-responsive-wrapper">
                <table width="100%" class="table table-middle table-objects table-responsive">
                    <thead>
                    <tr>
                        <th class="left mobile-hide" width="1%">
                            {include file="common/check_items.tpl" check_statuses=""}
                        </th>
                        <th width="5%"><a class="cm-ajax" href="{"`$c_url`&sort_by=stop_id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('id')}{if $search.sort_by == "stop_id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=phrase&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("cls.phrase")}{if $search.sort_by == "phrase"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>                       
                        <th width="50%"><a class="cm-ajax" href="{"`$c_url`&sort_by=stop_words&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("cls.stop_words")}{if $search.sort_by == "stop_words"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=timestamp&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("time")}</a></th>
                        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=lang_code&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("language")}</a></th>
                       <th class="mobile-hide" width="5%">&nbsp;</th>
                        <th><a class="cm-ajax" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("status")}{if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th> 
                        
                    </tr>
                    </thead>
                    <tbody>
                    {foreach from=$stop_words item="stop_word"}
                    	 {$href_edit="csc_live_search.update_stop_word?stop_id=`$stop_word.stop_id`&return_url=`$r_url`"}
                       	 {$href_delete="csc_live_search.m_delete_stop_words?stop_ids[]=`$stop_word.stop_id`&return_url=$r_url"}
                        <tr class="cm-row-item cm-row-status-{$stop_word.status|lower}" data-ct-product_customs="{$stop_word.stop_id}">
                            <td class="left mobile-hide">
                                <input type="checkbox" name="stop_ids[]" value="{$stop_word.stop_id}" class="cm-item cm-item-status-{$stop_word.status|lower}" />
                            </td>                           
                            <td data-th="{__('id')}">
                                <div class="object-group-link-wrap">#{$stop_word.stop_id}</div>
                            </td> 
                            <td data-th="{__('cls.phrase')}"><a class="cm-ajax cm-dialog-opener" data-ca-target-id="content_group{$stop_word.stop_id}" href="{$href_edit|fn_url}" title="{__("edit")}">{$stop_word.phrase}</a>
                            {include file="views/companies/components/company_name.tpl" object=$stop_word}
                            
                            </td>                           
                            <td data-th="{__("stop_words")}">
                            	{', '|implode:$stop_word.synonyms|truncate:200}
                            </td> 
                            <td data-th="{__("time")}">{$stop_word.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
                            <td data-th="{__("lang_code")}">{$languages[$stop_word.lang_code].name}</td>
                            <td class="nowrap mobile-hide"> 
                                <div class="hidden-tools">
                                    {capture name="tools_list"}
                                       <li>{include file="common/popupbox.tpl" id="group`$stop_word.stop_id`" title_start=__("edit") title_end=$stop_word.stop_word act="edit" href=$href_edit no_icon_link=true}  </li>
                                        <li>{btn type="text" text=__("delete") href=$href_delete class="cm-confirm cm-tooltip cm-ajax cm-ajax-force cm-ajax-full-render cm-delete-row" data=["data-ca-target-id" => "pagination_contents"] method="POST"}</li>                                        
                                    {/capture}
                                    {dropdown content=$smarty.capture.tools_list}
                                </div>
                            </td> 
                            <td data-th="{__("status")}">{include file="common/select_popup.tpl" popup_additional_class="dropleft" id=$stop_word.stop_id status=$stop_word.status hidden=false object_id_name="stop_id" table="csc_live_search_stop_words"}</td>             
                        </tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>
        {else}
            <p class="no-items">{__("no_data")}</p>
        {/if}
    <!--update_customs_list--></div>
    </form>

    {include file="common/pagination.tpl"}
    
    {capture name="buttons"}
    	{capture name="tools_items"}           
             <li>{btn type="delete_selected" dispatch="dispatch[csc_live_search.m_delete_stop_words]" form="manage_stop_words_form"}</li> 
             <li>{btn type="list" text=__("export_selected") dispatch="dispatch[csc_live_search.export_range]" form="manage_stop_words_form"}</li>
                           
        {/capture}
        {dropdown content=$smarty.capture.tools_items} 
    {/capture}    
    {capture name="adv_buttons"}
        {capture name="add_new_picker_2"}
            {include file="addons/`$addon_base_name`/views/`$addon_base_name`/update_stop_word.tpl" custom=[] in_popup=true return_url=$config.current_url question=[]}
        {/capture}
        {include file="common/popupbox.tpl" id="add_new_custom" text=__("cls.new_stop_word") title=__("cls.new_stop_word") content=$smarty.capture.add_new_picker_2 act="general" icon="icon-plus"}
    {/capture}
    
    
{/capture}

{capture name="sidebar"}
	<div class="sidebar-row">
    <h6>{__('settings')}</h6>	
	 {include file="addons/`$addon_base_name`/views/`$addon_base_name`/components/status_field.tpl"
     	field_name=__('cls.stop_words_status')
        field_name_ttl=__('cls.stop_words_status_ttl')
        input_name='use_stop_words'
        value=$options.use_stop_words
        mode='set_setting'
     }
     
     </div>

	{include file="addons/`$addon_base_name`/components/submenu.tpl"}  
    {include file="addons/`$addon_base_name`/views/`$addon_base_name`/components/sales_reports_search_form.tpl" period=$search.period search=$search dispatch="`$runtime.controller`.`$runtime.mode`.`$runtime.action`"}           
{/capture}


{include file="common/mainbox.tpl" title=__('cls.stop_words') content=$smarty.capture.mainbox buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons content_id="`$addon_base_name`.settings" mainbox_content_wrapper_class="csc-settings" sidebar=$smarty.capture.sidebar select_languages=false}