{$show_select_variations_button=$show_select_variations_button|default:true}
{$buying_types = $product.cp_buying_types|default:[]}
{$contact_vendor_type = "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::CONTACT_VENDOR"|enum}
{if
    $show_add_to_cart
    && !$et_scroller_buttons
    && (
        $show_qty
        || [$contact_vendor_type] === $buying_types
    ) && (
        $details_page
        || !$product.has_child_variations
        || !$show_select_variations_button
    )
}
    {$buy_type = "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::BUY"|enum}
    {$buy = in_array($buy_type, $buying_types)}
    {$add_to_cart = "add_to_cart_`$obj_id`"}
    {$return_current_url = $config.current_url|escape:url}

    {capture assign="product_buying_types_html"}
        {if !$et_variation_list}
            </div>
            {if $selected_layout === 'short_list' || $et_category_compact}
            </div>
            <div class="cp-additional-product-buying-btns__short-list">
            {/if}
            <div class="et-product-atc cp-additional-product-buying-btns">
        {/if}
    {/capture}
    {capture name=$add_to_cart}
        {if $buy}
            {$smarty.capture.$add_to_cart nofilter}

            {if $product.cp_buying_types !== [$buy_type]}
                {$product_buying_types_html nofilter}
            {/if}
        {/if}
        {$i = 0}
        {foreach from=fn_cp_get_additional_product_buying_types(true) key=type item=but_text name=product_buying_types}
            {if in_array($type, $buying_types)}
                {$i = $i + 1}
                {$but_role = 'et_icon_text'}

                {if !$buy}
                    {if $show_et_icon_buttons && $i == 1}
                        {$but_role = 'et_icon'}
                    {elseif $i == 2}
                        {$product_buying_types_html nofilter}
                    {/if}
                {/if}
                {if $et_variation_list}
                    {$but_role = 'et_icon'}
                {/if}
                {$class = 'et-add-to-cart cp-additional-buying-types et-in-stock'}
                {$but_id = "cp_additional_add_btn_type_`$type`_`$obj_prefix``$obj_id`"}
                {$but_target_id = ''}
                {$but_onclick = ''}
                {$href = ''}
                {$but_title = $but_text}
                {$is_popup_opener = false}

                {if $type === $contact_vendor_type}
                    {$is_popup_opener = true}
                    {$login_form = !$auth.user_id}
                    {$icon = 'et-icon-mail'}
                    {$href = "products.cp_contact_vendor?product_id=`$product.product_id`&obj=`$obj_prefix``$obj_id`&return_url=`$return_current_url`"|fn_url}
                    {$redirect_url = $return_current_url}
                    {$but_title = __('cp_new_buying_types.send_inquiry')}
                    {if
                        count($buying_types) > 2
                        && (
                            $selected_layout === 'products_multicolumns'
                            || $block.type === 'et_home_grid'
                        )
                    }
                        {$but_text = array_shift(explode(' ', trim($but_text)))}
                    {/if}
                {else} {*"Addons\\CpNewBuyingTypes\\ProductBuyingTypes::START_ORDER"|enum*}
                    {$login_form = !$auth.user_id && $settings.Checkout.disable_anonymous_checkout == "YesNo::YES"|enum}
                    {$icon = 'et-icon-btn-cart4'}
                    {$href = "$href?redirect_url=`$redirect_url`"}
                    {$redirect_url = $href|urlencode}
                    {$but_onclick = "\$.fn_cp_save_start_order_product_cart({$product.product_id}, \$(this));"}
                {/if}
                {if $login_form}
                    {$is_popup_opener = true}
                    {$href = "cp_nbt_login.start_login?redirect_url=`$redirect_url`"|fn_url}
                    {$but_onclick = ''}
                {/if}
                {if $is_popup_opener}
                    {$class = "$class cm-dialog-opener cm-dialog-auto-size cm-dialog-destroy-on-close"}
                    {if $type != $contact_vendor_type}
                        {$target_id = $but_id}
                    {else}
                        {$target_id = "opener_$but_id"}
                    {/if}
                    {$but_id = "opener_$but_id"}
                {/if}

                {if !$auth.user_id}
                    {$but_target_id = "cp_nbt_login_popup"}
                    {if $type == $contact_vendor_type && $is_popup_opener}
                        {$href = "cp_nbt_login.start_login?redirect_url=`$redirect_url`&target_id=`$target_id`&chph=Y&cp_msg=1"|fn_url}
                    {else}
                        {$href = "cp_nbt_login.start_login?redirect_url=`$redirect_url`&target_id=`$target_id`&cp_msg=2"|fn_url}
                    {/if}
                {else}
                    {if $type == $contact_vendor_type && fn_cp_nbt_is_phone_confirmed($auth.user_id) == 'N' && $is_popup_opener}
                        {$but_target_id = "cp_nbt_login_popup"}
                        {$href = "cp_nbt_login.start_login?redirect_url=`$redirect_url`&target_id=`$target_id`&chph=Y"|fn_url}
                    {/if}
                {/if}

                {if $auth.user_id}
                    {$dialog_class = "data-ca-dialog-class=send_lnquiry_popup"}
                {else}
                    {$dialog_class = "data-ca-dialog-class=login_popup"}
                {/if}

                {include file="buttons/button.tpl"
                    but_text=$but_text
                    but_href=$href
                    but_role=$but_role
                    but_id=$but_id
                    et_icon=$icon
                    but_extra_class=$class
                    but_target_id=$but_target_id
                    but_onclick=$but_onclick
                    but_extra=$dialog_class
                }
            {/if}
        {/foreach}
    {/capture}
{/if}
