{if $search_history}    
 <div class="table-responsive-wrapper longtap-selection">
  <table width="100%" class="table table-sort table-middle table--relative table-responsive">
    <thead>
    <tr>
        <th class="left" width="1%">{include file="common/check_items.tpl"}</th>
        <th class="left" >{__("id")}</th>  
        <th width="40%"><a class="cm-ajax" href="{"`$c_url`&sort_by=product&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('product')}{if $search.sort_by == "product"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                
        <th  class="center"><a class="cm-ajax" href="{"`$c_url`&sort_by=clicks&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('cls.clicks')}{if $search.sort_by == "clicks"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th class="center" ><a class="cm-ajax" href="{"`$c_url`&sort_by=phrases&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("cls.phrases")}{if $search.sort_by == "phrases"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>        
    </tr>
    </thead>
    {foreach from=$search_history item="i"}
    <tbody>
        <tr class="cm-longtap-target">
            <td class="left mobile-hide"><input type="checkbox" name="pids[]" value="{$i.product_id}" class="checkbox cm-item" /></td>
            <td data-th="{__("id")}" class="left">{$i.product_id}</td>
            <td data-th="{__("product")}"><a href="{fn_url("products.update?product_id=`$i.product_id`")}">{$i.product}</a>
            	{include file="views/companies/components/company_name.tpl" object=$i}
            </td> 
            <td data-th="{__("cls.click")}" class="center"><a title="{__('cls.click')}: {$i.product}" class="cm-ajax cm-dialog-opener" href="{"csc_live_search.history.per_request?pid=`$i.product_id`&in_popup=Y"|fn_url}" data-ca-target-id="search_history_per_request" data-ca-view-id="{$i.product_id}">{$i.clsClicks}</a></td>
            <td data-th="{__("cls.phrases")}" class="center">
                {if $i.clsPhrases>0}
                    <a title="{__('cls.phrases')}: {$i.product}" class="cm-ajax cm-dialog-opener" href="{"csc_live_search.history.per_word?pid=`$i.product_id`&in_popup=Y"|fn_url}" data-ca-target-id="search_history_per_word" data-ca-view-id="{$i.product_id}">{$i.clsPhrases}</a>
                {else}
                    0
                {/if}
            </td>
                  
        </tr>
    {/foreach}
    </tbody>
    </table>
    </div>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}    
    
