{if $search_history}      
 <div class="table-responsive-wrapper longtap-selection">
  <table width="100%" class="table table-sort table-middle table--relative table-responsive">
    <thead>
    <tr>
        <th class="left" width="1%">{include file="common/check_items.tpl"}</th>
        <th class="left" ><a class="cm-ajax" href="{"`$c_url`&sort_by=qid&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('id')}{if $search.sort_by == "qid"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>  
        <th width="40%"><a class="cm-ajax" href="{"`$c_url`&sort_by=q&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('cls.phrase')}{if $search.sort_by == "q"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th class="center"><a class="cm-ajax" href="{"`$c_url`&sort_by=count&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('cls.requests')}{if $search.sort_by == "count"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th class="center"><a class="cm-ajax" href="{"`$c_url`&sort_by=clicks&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('cls.clicks')}{if $search.sort_by == "clicks"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th class="center"><a class="cm-ajax" href="{"`$c_url`&sort_by=lang_code&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("language")}{if $search.sort_by == "lang_code"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
    </tr>
    </thead>
     <tbody>
    {foreach from=$search_history item="i"}
   
        <tr class="cm-longtap-target">
            <td class="left mobile-hide"><input type="checkbox" name="qids[]" value="{$i.qid}" class="checkbox cm-item" /></td>
            <td data-th="{__("id")}" class="left">{$i.qid}</td>
            <td data-th="{__("cls.phrase")}">{$i.q}
            {include file="views/companies/components/company_name.tpl" object=$i}</td>  
             <td data-th="{__("cls.requests")}" class="center">
                {if $i.count_requests>0}
                    <a title="{__('ls.requests')}: {$i.q}" class="cm-ajax cm-dialog-opener" href="{"csc_live_search.history.per_request?qid=`$i.qid`&in_popup=Y"|fn_url}" data-ca-target-id="search_history_per_request" data-ca-view-id="{$i.qid}">{$i.count_requests}</a>
                    
                {else}
                    {$i.count_requests}
                {/if}
             </td>                         
            <td data-th="{__("cls.clicks")}" class="center">
                {if $i.count_products>0}
                    <a title="{__('cls.phrase')}: {$i.q}" class="cm-ajax cm-dialog-opener" href="{"csc_live_search.history.per_product?qid=`$i.qid`&in_popup=Y"|fn_url}" data-ca-target-id="clicked_products" data-ca-view-id="{$i.qid}">{$i.count_products}</a>
                {else}
                    0
                {/if}
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
    