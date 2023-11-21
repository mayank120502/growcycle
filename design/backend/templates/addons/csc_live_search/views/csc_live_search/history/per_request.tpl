{if $search_history} 
     
  <div class="table-responsive-wrapper longtap-selection">
  <table width="100%" class="table table-sort table-middle table--relative table-responsive">
    <thead>
    <tr>
        <th class="left" width="1%">{include file="common/check_items.tpl"}</th>
        <th class="left" ><a class="cm-ajax" href="{"`$c_url`&sort_by=rid&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("id")}{if $search.sort_by == "rid"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        
        {if !fn_allowed_for('MULTIVENDOR') || !$runtime.company_id}
        <th class="left"></th> 
        {/if} 
        <th width="40%"><a class="cm-ajax" href="{"`$c_url`&sort_by=search_word&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('cls.phrase')}{if $search.sort_by == "search_word"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th  class="center"><a class="cm-ajax" href="{"`$c_url`&sort_by=timestamp&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('time')}{if $search.sort_by == "timestamp"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th  class="center"><a class="cm-ajax" href="{"`$c_url`&sort_by=ip&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('ip_address')}{if $search.sort_by == "ip"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th class="center" ><a class="cm-ajax" href="{"`$c_url`&sort_by=clicks&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("cls.clicks")}{if $search.sort_by == "clicks"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th class="center" ><a class="cm-ajax" href="{"`$c_url`&sort_by=found_products&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("cls.found")}{if $search.sort_by == "found_products"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th class="center" ><a class="cm-ajax" href="{"`$c_url`&sort_by=lang_code&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("language")}{if $search.sort_by == "lang_code"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    </tr>
    </thead>
    {foreach from=$search_history item="i"}
    <tbody>
        <tr class="cm-longtap-target">
            <td class="left mobile-hide"><input type="checkbox" name="rids[]" value="{$i.rid}" class="checkbox cm-item" /></td>
            <td data-th="{__("id")}" class="left">{$i.rid}</td>
            {if !fn_allowed_for('MULTIVENDOR') || !$runtime.company_id}
            <td data-th="{__("user")}" class="left">            
            {if $i.user_id }
                <a href="{fn_url("csc_live_search.history.per_request?user_id=`$i.user_id`&in_popup=Y")}" data-ca-target-id="search_history_per_request{$i.user_id}"
                data-ca-view-id="uid{$i.user_id}" 
                title="{__('cls.history_per_user')}: {$i.user_id|fn_get_user_name}" class="cm-ajax cm-dialog-opener">           
                <i class="icon-user cm-tooltip" title="{$i.user_id|fn_get_user_name}"></i></a>
             {else}
             	<span class="cm-tooltip" title="{__('cls.guest')}">           
                <i class="icon-user"></i></span>
             
             {/if}             
            </td>
            {/if}
            
            <td data-th="{__("cls.phrase")}">
            	{$i.q}
            	{include file="views/companies/components/company_name.tpl" object=$i}
            </td>  
             <td data-th="{__("time")}" class="center">
             {$i.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>  
              <td data-th="{__("ip_address")}" class="center"><div style="width:120px; word-break: break-word;">{$i.user_ip}</div></td>         
            <td data-th="{__("cls.clicks")}" class="center">
                {if $i.count>0}
                    <a title="{__('cls.search_word')}: {$i.q}" class="cm-ajax cm-dialog-opener" href="{"csc_live_search.history.per_product?pid=`$i.pids`&rid=`$i.rid`&in_popup=Y"|fn_url}" data-ca-target-id="clicked_products" data-ca-view-id="{$i.rid}">{$i.count}</a>
                {else}
                    0
                {/if}
            </td>
            <td data-th="{__("cls.found")}" class="center">
                {$i.found_products}
            </td>
            <td data-th="{__("language")}" class="center">{$i.lang_code}</td>          
        </tr>
    {/foreach}
    </tbody>
    </table>
    </div>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}    
