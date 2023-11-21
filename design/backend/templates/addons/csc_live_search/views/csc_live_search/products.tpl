{capture name="mainbox"}
    {include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id="clicked_products"}
    {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}

    {assign var="rev" value="clicked_products"}
    {assign var="c_icon" value="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
    {assign var="c_dummy" value="<i class=\"icon-dummy\"></i>"}    
    
    <form class="form-horizontal form-edit cm-ajax" action="{""|fn_url}" method="post" name="products_form"> 
    	<input type="hidden" name="items" value="{','|implode:($products|array_keys)}" />
        <input type="hidden" name="wid" value="{$search.wid}" />
        <input type="hidden" name="result_ids" value="clicked_products" />      
    {if $products}      
      <table width="100%" class="table table-sort table-middle">
        <thead>
        <tr>            
            <th class="left" >{__('product_id')}</th>  
            <th width="40%"><a class="cm-ajax" href="{"`$c_url`&sort_by=product&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__('product')}{if $search.sort_by == "product"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>             
           {if $search.wid}
           		<th class="center">{__("ls.products_clicks")}</th>
           		<th class="center"><a class="cm-ajax" href="{"`$c_url`&sort_by=ls_popularity&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("ls.product_popularity")}{if $search.sort_by == "ls_popularity"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                <th width="10%" class="center"></th>
           {/if}
        </tr>
        </thead>
        <tbody>
        {foreach from=$products item="product"}
        
            <tr id="box_product_popularity_{$product.product_id}">               
                <td class="left">
                <input type="hidden" name="products[{$product.product_id}][product_id]" value="{$product.product_id}" />
                <input type="hidden" name="products[{$product.product_id}][q_id]" value="{$search.wid}" />                
                {$product.product_id}</td>
                <td><a href="{"products.update?product_id=`$product.product_id`"|fn_url}">{$product.product|truncate:60}</a></td>  
                {if $search.wid}
                	<td class="center">{$product.clicks|default:0}</td>
                	<td class="center"><input class="input-mini" type="text" name="products[{$product.product_id}][popularity]" value="{$product.popularity|default:0}" /></td>
                    <td class="right">
                        <div class="hidden-tools">
                        {include file="buttons/multiple_buttons.tpl" item_id="product_popularity_`$product.product_id`" tag_level="2" only_delete="Y"}
                        </div>
                    </td>
                {/if}                    
            </tr>
        {/foreach}
        </tbody>        
		{if $search.wid}
        	{math equation="x + 1" assign="num" x=$num|default:0}
{$var = array()}
			<tbody>
            	<tr><td colspan="5"><b>{__('ls.add_products_to_popularity')}</b></td></tr>
            </tbody>
            <tbody class="hover" >
            <tr id="box_add_product_popularity_{$num}">
                <td></td>            
                <td>
                	<input type="hidden" name="new_products[{$num}][q_id]" value="{$search.wid}" class="input-mini" />
                	{assign var="product_ids" value=","|explode:$search.p_ids}                    
                    {include file="pickers/products/picker.tpl" positions="" input_name="new_products[`$num`][product_id]" data_id="add_product_`$num`" type="single"  product=''}
                   
                 </td>               
               <td></td>
               <td class="center"><input type="text" name="new_products[{$num}][popularity]" value="" class="input-mini" /></td>
                <td class="right">
                    <div class="">
                        {include file="buttons/multiple_buttons.tpl" item_id="add_product_popularity_`$num`" tag_level=1 hide_clone=true}
                    </div>
                </td>
            </tr>
           
            </tbody>
        {/if}
        
        
        </table>
    {else}
        <p class="no-items">{__("no_data")}</p>
    {/if}
    <div class="buttons-container">       
        {include file="buttons/save_cancel.tpl" but_name="dispatch[search_history.update_products]" cancel_action="close" hide_first_button=false save=true}
    </div>
    </form>   
    {include file="common/pagination.tpl" div_id="clicked_products"}
        
    
{/capture}

{include file="common/mainbox.tpl" title=__("clicked_products") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons sidebar=$smarty.capture.sidebar}
