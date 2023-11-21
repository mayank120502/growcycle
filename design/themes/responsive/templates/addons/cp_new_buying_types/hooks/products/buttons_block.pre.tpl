{if $show_add_to_cart && $et_scroller_buttons && $show_et_icon_buttons && !$show_select_variations_button}
{capture name="buttons_product"}
    {hook name="products:add_to_cart"}
    {if $product.has_options && !$show_product_options && !$details_page}
        {include file="buttons/button.tpl"
            but_id="button_cart_`$obj_prefix``$obj_id`"
            but_text=__("select_options")
            but_href=$product_url
            but_role="et_icon"
            but_name=""
            et_icon="et-icon-btn-opt"
            but_extra_class="et-add-to-cart et-atc-icon-only"
        }
    {else}
        {$buying_types = $product.cp_buying_types|default:[]}
        {$buy_type = "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::BUY"|enum}
        {$buy = in_array($buy_type, $buying_types)}
        {$return_current_url = $config.current_url|escape:url}
        {if $buy}
            {include file="buttons/add_to_cart.tpl"
                but_id="button_cart_`$obj_prefix``$obj_id`"
                but_name="dispatch[checkout.add..`$obj_id`]"
                but_role=$but_role
                block_width=$block_width
                obj_id=$obj_id
                product=$product
                but_meta=$add_to_cart_meta
            }
        {/if}
        {foreach from=fn_cp_get_additional_product_buying_types(true) key=type item=but_text name=product_buying_types}
            {if in_array($type, $buying_types)}
                {$but_role = 'et_icon'}
                {$class = 'et-add-to-cart et-atc-icon-only cp-additional-buying-types'}
                {$but_id = "cp_additional_add_btn_type_`$type`_`$obj_prefix``$obj_id`"}
                {$but_target_id = ''}
                {$but_onclick = ''}
                {$href = ''}
                {$but_title = $but_text}
                {$is_popup_opener = false}

                {if $type === "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::CONTACT_VENDOR"|enum}
                    {$is_popup_opener = true}
                    {$login_form = !$auth.user_id}
                    {$icon = 'et-icon-mail'}
                    {$href = "products.cp_contact_vendor?product_id=`$product.product_id`&obj=`$obj_prefix``$obj_id`&return_url=`$return_current_url`"|fn_url}
                    {$redirect_url = $return_current_url}
                    {$but_text = __('cp_new_buying_types.send_inquiry')}
                {else} {* "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::START_ORDER"|enum *}
                    {$login_form = !$auth.user_id && $settings.Checkout.disable_anonymous_checkout == "YesNo::YES"|enum}
                    {$icon = 'et-icon-btn-cart4'}
                    {$redirect_url = $href|urlencode}
                    {$href = "$href?redirect_url=`$redirect_url`"}
                    {$but_onclick = "\$.fn_cp_save_start_order_product_cart({$product.product_id}, \$(this));"}
                {/if}
                {if $login_form}
                    {$is_popup_opener = true}
                    {$href = "cp_nbt_login.start_login?redirect_url=`$redirect_url`"|fn_url}
                    {$but_onclick = ''}
                {/if}

                {$contact_vendor_type = "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::CONTACT_VENDOR"|enum}

                {if $is_popup_opener}
                    {$class = "$class cm-dialog-opener cm-dialog-auto-size cm-dialog-destroy-on-close"}
                    {if $type != $contact_vendor_type}
                        {$target_id = $but_id}
                    {else}
                        {$target_id = "opener_$but_id"}
                    {/if}
                    {$but_id = "opener_$but_id"}
                {/if}


                {if $type != $contact_vendor_type && !$auth.user_id}
                    {$redirect_url = $return_current_url}
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
                    {$dialog_class = "data-ca-dialog-class=send_lnquiry_popup "}
                {else}
                    {$dialog_class = "data-ca-dialog-class=login_popup "}
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
        {assign var="cart_button_exists" value=true}
    {/if}
    {/hook}
{/capture}
{/if}
