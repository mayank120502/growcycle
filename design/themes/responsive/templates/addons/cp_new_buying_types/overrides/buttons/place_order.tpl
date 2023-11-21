<button class="litecheckout__submit-btn {$but_meta}"
        type="submit"
        name="{$but_name}"
        {if $but_onclick}onclick="{$but_onclick nofilter}"{/if}
        {if $but_id}id="{$but_id}"{/if}
        {if $but_disabled}disabled{/if}
>
    {if !$but_text}
        {* overrided *}
        {* {$but_text = __("lite_checkout.place_an_order_for", ["[amount]" => $smarty.capture.order_total])} *}
        {if $smarty.request.start_order}
            <input type="hidden" data-ca-lite-checkout-field="start_order" name="start_order" value="1"/>
            {$btn_replace = ["([amount])" => '']}
        {else}
            {capture name="order_total"}
                {if $cart.payment_surcharge && !$take_surcharge_from_vendor}
                    {$_total = $cart.total + $cart.payment_surcharge}
                {/if}

                {include file="common/price.tpl" value=$_total|default:$cart.total}
            {/capture}
            {$btn_replace = ["[amount]" => $smarty.capture.order_total]}
        {/if}
        {$but_text = __("lite_checkout.place_an_order_for", $btn_replace)}
        {* /overrided *}
    {/if}

    {$but_text nofilter}
{if $but_id}<!--{$but_id}-->{/if}</button>
