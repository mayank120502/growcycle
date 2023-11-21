{if $cp_order_attachments}
<div class="well orders-right-pane form-horizontal">
    <div class="control-group">
        <div class="cp-order-attachments-header control-label">
            {include file="common/subheader.tpl" title=__("cp_new_buying_types.attachments")}
        </div>
    </div>
    {foreach $cp_order_attachments as $file_name}
        {$url_file_name = $file_name|escape:"url"}
        <div class="cp-order-attachment">
            <a href="{"orders.cp_download_attachment?order_id=`$order_info.order_id`&file_name=`$url_file_name`"|fn_url}">{$file_name}</a>
        </div>
    {/foreach}
</div>
{/if}
