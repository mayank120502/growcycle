{if $order_info.points_info.price && $product}
    <div class="et-orders-reward-points product-list-field">
        <label class="ty-product-options-name ty-strong">{__("price_in_points")}:</label>
        <span class="ty-product-options-content">{$product.extra.points_info.price}</span>
    </div>
{/if}