{if $data}
    <ul>
        {foreach from=$data key="key_name" item="item_id" name="for_add_data"}
            {if $key_name=="O"}{assign var="order_status_data" value=$data.order_status|fn_get_status_data:$smarty.const.STATUSES_ORDER}
                <li>{__("order")}: #{$item_id}</li>
                <li>{__("status")}: {$order_status_data.description}</li>
            {elseif $key_name=="P" && $data.product_name}
                <li>{__("product")}: <a href="{"products.view?product_id=`$item_id`"|fn_url}">{$data.product_name}</a></li>
            {elseif $key_name=="D" && $data.coupon_code}
                <li>{__("coupon_code")}: {$data.coupon_code}</li>
            {elseif $key_name=="R" && $item_id}
                <li>{__("url")}: <a href="{$item_id|fn_url}" target="_blank">{$item_id}</a></li>
            {/if}
        {/foreach}
    </ul>
{/if}