{include file="common/subheader.tpl" title=__("addons.sd_taxjar.taxjar") target="#acc_addon_sd_taxjar"}

<div id="acc_addon_sd_taxjar" class="collapsed in">
    {if $sd_taxjar_products_tax_codes}
        <div class="control-group">
            <label class="control-label" for="elm_sd_taxjar_product_tax_code">
                {__("addons.sd_taxjar.product_tax_code")}:
            </label>
            <div class="controls">
                <select
                    class="span3"
                    name="product_data[product_tax_code]"
                    id="elm_sd_taxjar_product_tax_code"
                    {if $disable_selectors}disabled="disabled"{/if}
                >
                    <option value="" {if !$product_data.product_tax_code}selected="selected"{/if}> -- </option>
                    {foreach from=$sd_taxjar_products_tax_codes item="code"}
                        <option
                            value="{$code.product_tax_code}"
                            {if $product_data.product_tax_code == $code.product_tax_code}selected="selected"{/if}
                        >
                            {$code.name}
                        </option>
                    {/foreach}
                </select>
            </div>
        </div>
    {/if}
    {if $show_get_taxjar_taxes}
        <div class="control-group">
            <label class="control-label" for="elm_sd_taxjar_product_tax_code">
                {__("addons.sd_taxjar.get_taxes")}:
            </label>
            <div class="controls">
                <span
                    class="cm-tooltip sd-taxjar-to-address"
                    title="{__("addons.sd_taxjar.info_to_country_and_state")}"
                >
                    {$_country = $settings.General.default_country}
                    {$_state = $value|default:$settings.General.default_state}
                    <select
                        id="elm_taxjar_to_country"
                        x-autocompletetype="country"
                        class="ty-profile-field__select-country cm-country cm-location-shipping"
                        name="taxjar[to_country]"
                    >
                        <option value="">- {__("select_country")} -</option>
                        {foreach from=$countries item="country" key="code"}
                            <option {if $_country == $code}selected="selected"{/if} value="{$code}">{$country}</option>
                        {/foreach}
                    </select>
                    <select
                        id="elm_taxjar_to_state"
                        x-autocompletetype="state"
                        class="ty-profile-field__select-state cm-state cm-location-shipping"
                        name="taxjar[to_state]"
                    >
                        {if $states && $states.$_country}
                            <option value="">- {__("select_state")} -</option>
                            {foreach from=$states.$_country item=state}
                                <option {if $_state == $state.code}selected="selected"{/if} value="{$state.code}">
                                    {$state.state}
                                </option>
                            {/foreach}
                        {/if}
                    </select>
                    <input
                        x-autocompletetype="state"
                        type="text" id="elm_taxjar_to_state_d"
                        name="taxjar[shipping_rate]"
                        size="32"
                        maxlength="64"
                        value="{$_state}"
                        class="cm-state cm-location-shipping ty-input-text hidden"
                    />
                </span>
                <span
                    class="cm-tooltip" title="{__("addons.sd_taxjar.info_to_zip")}">
                    <input
                        type="text"
                        name="taxjar[to_zip]"
                        placeholder="{__("addons.sd_taxjar.zip")}"
                        size="10"
                        value=""
                        class="input-mini"
                        id="taxjar_to_zip"
                    >
                </span>
                <span class="cm-tooltip" title="{__("addons.sd_taxjar.info_shipping")}">
                    <input
                        type="text"
                        name="taxjar[shipping_rate]"
                        size="10"
                        value=0
                        class="input-mini cm-numeric"
                        id="taxjar_shipping_rate"
                    >
                </span>
                <a class="btn" id="taxjar_get_taxes">{__("addons.sd_taxjar.get_taxes_button")}</a>
            </div>
        </div>
    {/if}

</div>

<div class="hidden" id="taxjar_get_taxes_popup" title="{__("addons.sd_taxjar.get_taxes_popup")}">
    <div class="control-group">
        <table width="100%" class="table">
            <thead>
            <tr>
                <th>&nbsp;</th>
                <th>{__("origination")}</th>
                <th>&nbsp;&nbsp;&nbsp;</th>
                <th>{__("destination")}</th>
            </tr>
            </thead>

            <tbody>
            <tr class="table-row">
                <td><span>{__("country")}</span>&nbsp;</td>
                <td>
                    <div id="taxjar_popup_from_country">
                        {$taxjar_taxes.vendor.from_country_name}
                    <!--taxjar_popup_from_country--></div>
                </td>
                <td>&nbsp;</td>
                <td>
                    <div id="taxjar_popup_to_country">
                        {$taxjar_taxes.customer.to_country_name}
                    <!--taxjar_popup_to_country--></div>
                </td>
            </tr>
            <tr class="table-row">
                <td><span>{__("state")}</span>&nbsp;</td>
                <td>
                    <div id="taxjar_popup_from_state">
                        {$taxjar_taxes.vendor.from_state_name}
                    <!--taxjar_popup_from_state--></div>
                </td>
                <td>&nbsp;</td>
                <td>
                    <div id="taxjar_popup_to_state">
                        {$taxjar_taxes.customer.to_state_name}
                    <!--taxjar_popup_to_state--></div>
                </td>
            </tr>
            <tr class="table-row">
                <td><span>{__("zip_postal_code")}</span>&nbsp;</td>
                <td>
                    <div id="taxjar_popup_from_zip">
                        {$taxjar_taxes.vendor.from_zip}
                    <!--taxjar_popup_from_zip--></div>
                </td>
                <td>&nbsp;</td>
                <td>
                    <div id="taxjar_popup_to_zip">
                        {$taxjar_taxes.customer.to_zip}
                    <!--taxjar_popup_to_zip--></div>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="control-group">
        <table width="100%" class="table">
            <thead>
            <tr>
                <th>&nbsp;</th>
                <th>{__("price")}</th>
                <th>&nbsp;&nbsp;&nbsp;</th>
                <th>{__("tax")}</th>
            </tr>
            </thead>
            <tbody>
            <tr class="table-row">
                <td>{__("product")}</td>
                <td>
                    <div id="taxjar_popup_product">
                        {include file="common/price.tpl" value=$taxjar_taxes.price}
                    <!--taxjar_popup_product--></div>
                </td>
                <td>&nbsp;</td>
                <td>
                    <div id="taxjar_popup_tax_product">
                        {if $taxjar_taxes.tax_product}
                            {include file="common/price.tpl" value=$taxjar_taxes.tax_product}
                        {else}
                            --
                        {/if}
                    <!--taxjar_popup_tax_product--></div>
                </td>
            </tr>
            <tr class="table-row">
                <td>{__("shipping")}</td>
                <td>
                    <div id="taxjar_popup_shipping">
                        {include file="common/price.tpl" value=$taxjar_taxes.shipping}
                    <!--taxjar_popup_shipping--></div>
                </td>
                <td>&nbsp;</td>
                <td>
                    <div id="taxjar_popup_tax_shipping">
                        {if $taxjar_taxes.tax_shipping}
                            {include file="common/price.tpl" value=$taxjar_taxes.tax_shipping}
                        {else}
                            --
                        {/if}
                    <!--taxjar_popup_tax_shipping--></div>
                </td>
            </tr>
            <tr class="table-row">
                <td><b>{__("total")}</b></td>
                <td>
                    <div id="taxjar_popup_total">
                        <b>{include file="common/price.tpl" value=$taxjar_taxes.total}</b>
                    <!--taxjar_popup_total--></div>
                </td>
                <td>&nbsp;</td>
                <td>
                    <div id="taxjar_popup_tax_total">
                        <b>{include file="common/price.tpl" value=$taxjar_taxes.tax_total}</b>
                    <!--taxjar_popup_tax_total--></div>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
<!--taxjar_get_taxes_popup--></div>

<script type="text/javascript">
;(function(_, $) {
    $.ceEvent('on', 'ce.commoninit', function(event) {
        $('#taxjar_get_taxes').unbind('click').on('click', function () {
            $.ceAjax('request', fn_url('sd_taxjar.get_taxes'), {
                data: {
                    to_country: $('#elm_taxjar_to_country').val(),
                    to_state: $('#elm_taxjar_to_state').val(),
                    to_zip: $('#taxjar_to_zip').val(),
                    shipping: $('#taxjar_shipping_rate').val(),
                    company_id: $('#product_data_company_id').val(),
                    product_id: $('input[name="product_id"]').val()
                },
                callback: function (data) {
                    var params = $.ceDialog('get_params', $('#taxjar_get_taxes_popup'));
                    $('#taxjar_get_taxes_popup').ceDialog('open', params);
                },
                result_ids: 'taxjar_popup_to_zip,taxjar_popup_from_zip,taxjar_popup_to_state,'
                    + 'taxjar_popup_from_state,taxjar_popup_to_country,taxjar_popup_from_country,'
                    + 'taxjar_popup_tax_product,taxjar_popup_tax_shipping,taxjar_popup_shipping,'
                    + 'taxjar_popup_product,taxjar_popup_tax_total,taxjar_popup_total'
            });
        });
    });
}(Tygh, Tygh.$));
</script>
