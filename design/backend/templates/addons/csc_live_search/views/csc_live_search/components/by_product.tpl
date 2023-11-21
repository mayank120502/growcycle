    <input type="hidden" name="ls_q_items" value="{if $search_words}{','|implode:($search_words|array_keys)}{/if}" />
    
    {include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id="by_product" search=$w_search}    
    {if $search_words}      
      <table width="100%" class="table table-sort table-middle">
        <thead>
        <tr>           
            <th class="left" >{__('id')}</th>  
            <th >{__('ls.search_word')}</th>
            <th class="center">{__('ls.requests_count')}</th>
            <th class="center">{__('ls.products_clicks')}</th>
            <th class="center">{__("ls.product_popularity")}</th>
            <th class="center">{__("language")}</th>
            <th class="center"></th>
        </tr>
        </thead>
        <tbody>
        {foreach from=$search_words item="i"}
        
            <tr>                
                <td class="left">{$i.q_id}</td>
                <td>{$i.q}</td>  
                 <td class="center">
                 	{if $i.count_requests>0}
                    	<a title="{__('ls.requests')}: {$i.q} ({$i.count_requests})" class="cm-ajax cm-dialog-opener" href="{"search_history.view?wid=`$i.q_id`"|fn_url}" data-ca-target-id="search_history" data-ca-view-id="{$i.q_id}">{$i.count_requests}</a>
                	 	
                    {else}
                    	{$i.count_requests}
                    {/if}
                 </td>                         
                <td class="center">
                    {if $i.count_products>0}
                        {$i.count_products}
                    {else}
                        0
                    {/if}
                </td>
                <td class="center">
                <input type="hidden" name="ls_popularity[{$i.q_id}][q_id]" value="{$i.q_id}" />
                <input type="hidden" name="ls_popularity[{$i.q_id}][product_id]" value="{$product_data.product_id}" />
                <input class="input-mini" type="text" name="ls_popularity[{$i.q_id}][popularity]" value="{$i.popularity|default:0}" /></td>
                <td class="center">{$i.lang_code}</td>
                <td class="right">
                        <div class="hidden-tools">
                        {include file="buttons/multiple_buttons.tpl" item_id="product_popularity_`$product.product_id`" tag_level="2" only_delete="Y"}
                        </div>
                    </td>         
            </tr>
        {/foreach}
        </tbody>
        
        {math equation="x + 1" assign="num" x=$num|default:0}
{$var = array()}
          <tbody>
              <tr><td colspan="7"><b>{__('ls.add_phrases_for_popularity')}</b></td></tr>
          </tbody>
          <tbody class="hover" >
          <tr id="box_add_product_popularity_{$num}">
              <td></td>            
              <td>                 
                  <input type="text" name="new_q[{$num}][q]" value="" class="input-medium" placeholder="{__('enter_search_phrase')}" />
               </td>               
             <td class="center">-</td>
             <td class="center">-</td>               
             <td class="center"><input type="text" name="new_q[{$num}][popularity]" value="0" class="input-mini" /></td>
             <td class="center">{$smarty.const.DESCR_SL}</td>
              <td class="right">
                  <div class="">
                      {include file="buttons/multiple_buttons.tpl" item_id="add_product_popularity_`$num`" tag_level=1 hide_clone=true}
                  </div>
              </td>
          </tr>
         
          </tbody>
        
        </table>
    {else}
        <p class="no-items">{__("no_data")}</p>
    {/if}    
    {include file="common/pagination.tpl" div_id="by_product" search=$w_search}    
