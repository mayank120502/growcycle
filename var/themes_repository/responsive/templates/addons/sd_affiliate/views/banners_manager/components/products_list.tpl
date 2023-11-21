{if $list_data}
    <ul class="bullets-list">
        {foreach from=$list_data key=product_id item=product_name}
            <li>
                <a class="cm-dialog-opener cm-dialog-auto-size" href="{"banner_products.view?product_id=`$product_id`"|fn_url}" data-ca-target-id="product_{$product_id}" >{$product_name}</a>
                <div id="product_{$product_id}" class="hidden"  title="{__("product")}"></div>
            <li>
        {/foreach}
    </ul>
{/if}