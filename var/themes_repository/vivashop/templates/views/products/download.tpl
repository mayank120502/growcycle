{if $language_direction == "rtl"}
    {$direction = "right"}
{else}
    {$direction = "left"}
{/if}

<div class="ty-subheader">
    {if $product.ekey && $no_capture}
        <a href="{"orders.download?ekey=`$product.ekey`&product_id=`$product.product_id`"|fn_url}"></a>
    {/if}
        <strong>{$product.product nofilter}</strong>
    {if $product.ekey && $no_capture}</a>{/if}
    
    {if $no_capture && !$hide_order}
    &nbsp;(<a href="{"orders.details?order_id=`$product.order_id`"|fn_url}">{__("order")}# {$product.order_id}</a>)
    {/if}
</div>


<table class="ty-download__table ty-table">
    <thead>
        <tr>
            <th>
                {__("name")}
            </th>
            <th class="ty-download__size-col">{__("size")}</th>
        </tr>
    </thead>
{if $product.files_tree}
    {foreach from=$product.files_tree.folders item="folder"}
        {hook name="products:folder_tree"}
        <tr>
            <td>
                <div class="ty-hand">
                    <input type="hidden" name="folder_{$folder.folder_id}" value="{$folder.folder_name}" />
                    <div id="on_group_order_{$product.order_id}_folder_{$folder.folder_id}" class="cm-combination {if $expand_all} hidden{/if} ty-icon-folder"> {$folder.folder_name} {if !$folder.files}<span class="ty-download__empty">({__("folder_is_empty")}){/if}</span>
                    </div>
                    <div id="off_group_order_{$product.order_id}_folder_{$folder.folder_id}" class="cm-combination {if !$expand_all} hidden{/if} ty-icon-folder-open"> {$folder.folder_name} {if !$folder.files}<span class="ty-download__empty">({__("folder_is_empty")}){/if}</span>
                    </div>
                </div>
            </td>
            <td>
                {$folder.folder_size|number_format:0:"":" "}&nbsp;{__("bytes")}
            </td>
        </tr>

        <tr id=group_order_{$product.order_id}_folder_{$folder.folder_id} style="{if !$expand_all}display: none;{/if};">
            <td colspan="2" class="ty-download__nostyle">
                {if $folder.files}
                    <table class="ty-download__table-nomargin">
        {foreach from=$folder.files item="file"}
        	{hook name="products:folder_files_list_item"}
                            {include file="views/products/components/file_tree.tpl"
                                product_file=$file
                                level=1
                                direction=$direction
                            }
            {/hook}
                    {/foreach}
                    </table>
                {else}
                    <div class="ty-download__empty">
                        {__("no_files")}
                    </div>
                {/if}
                </td>
        {/hook}
    {/foreach}
    
    {if $product.files_tree.files}
        {foreach from=$product.files_tree.files item="file"}
            {hook name="products:files_list_item"}
            <tr>
                {include file="views/products/components/file_tree.tpl"
                    product_file=$file
                    direction=$direction
                }
            </tr>
            {/hook}
        {/foreach}
    {/if}


{else}
    <tr class="ty-table__no-items">
        <td colspan="2"><p class="ty-no-items">{__("no_items")}</p></td>
    </tr>
{/if}
</table>


{capture name="mainbox_title"}{__("download")}{/capture}