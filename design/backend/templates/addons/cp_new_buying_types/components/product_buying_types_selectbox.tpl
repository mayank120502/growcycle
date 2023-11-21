{if $auth.user_type === "UserTypes::ADMIN"|enum}
    {$buying_types = $buying_types|default:[]}
    {$vendor_default = "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::VENDOR_DEFAULT"|enum}
    {$vendor_default_selected = in_array($vendor_default, $buying_types)}

    {include file="common/subheader.tpl" title=__("cp_new_buying_types.product_buying_types") target="#cp_buying_types_setting"}
    <fieldset>
    <div id="cp_buying_types_setting" class="in collapse">
        {if $product_page}
            <script>
            (function ($, _) {
                $('#cp_use_selected_buying_types').change(function () {
                    let checked = $(this).is(':checked');

                    $('#cp_buying_types_container').toggleClass('hidden', checked);
                    $('#cp_buying_types').attr('disabled', checked);
                });
            }(Tygh.$, Tygh));
            </script>
            <div class="control-group{if $no_hide_input} cm-no-hide-input{/if}">
                <label class="control-label"
                       for="cp_use_selected_buying_types">{__('cp_new_buying_types.use_selected_buying_types')}:</label>
                <div class="controls">
                    <input type="checkbox"
                           id="cp_use_selected_buying_types"
                           name="{$prefix}[cp_buying_types][]"
                           value="{$vendor_default}"
                            {if $vendor_default_selected} checked{/if}/>
                </div>
            </div>
        {/if}
        <div id="cp_buying_types_container"
             class="control-group{if $vendor_default_selected} hidden{/if}{if $no_hide_input} cm-no-hide-input{/if}">
            <label class="control-label" for="cp_buying_types">{__('cp_new_buying_types.buying_types')}:</label>
            <div class="controls">
                <select name="{$prefix}[cp_buying_types][]" id="cp_buying_types" multiple{if $vendor_default_selected} disabled{/if}>
                {foreach fn_cp_get_all_product_buying_types() as $type => $type_name}
                    <option value="{$type}"{if in_array($type, $buying_types)} selected{/if}>{$type_name}</option>
                {/foreach}
                </select>
                <div class="muted description">{__("multiple_selectbox_notice") nofilter}</div>
            </div>
        </div>
    </div>
    </fieldset>
{/if}
