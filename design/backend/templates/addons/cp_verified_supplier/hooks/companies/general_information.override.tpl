{if "ULTIMATE"|fn_allowed_for}
<div class="control-group">
    <label for="elm_company_name" class="control-label cm-required">{__("name")}:</label>
    <div class="controls">
        <input type="text" name="company_data[company]" id="elm_company_name" size="32" value="{$company_data.company}" class="input-large" />
    </div>
</div>

{hook name="companies:storefronts"}
<div class="control-group">
    <label for="elm_company_storefront" class="control-label cm-required">{__("storefront_url")}:</label>
    <div class="controls">
        {if $runtime.company_id}
            http://{$company_data.storefront|puny_decode}
        {else}
            <input type="text" name="company_data[storefront]" id="elm_company_storefront" size="32" value="{$company_data.storefront|puny_decode}" class="input-large" />
        {/if}
        <p class="muted description">{__("ttc_storefront_url")}</p>
    </div>
</div>
{/hook}

{hook name="companies:storefronts_design"}

{if $id}
{include file="views/storefronts/components/status.tpl"
    id=$id
    status=$company_data.storefront_status
    input_name="company_data[storefront_status]"
}

{include file="views/storefronts/components/access_key.tpl"
    id=$id
    access_key=$company_data.store_access_key
    input_name="company_data[store_access_key]"
}

{include file="views/storefronts/components/access_only_for_authorized_customers.tpl"
    id=$id
    is_accessible_for_authorized_customers_only=$company_data.is_accessible_for_authorized_customers_only
    input_name="company_data[is_accessible_for_authorized_customers_only]"
}

{include file="common/subheader.tpl" title=__("design")}
{/if}

{include file="views/storefronts/components/theme.tpl"
    id=$id
    theme_url="themes.manage?switch_company_id={$id}"
    theme=$theme
    current_theme=$current_theme
    current_style=$current_style
    input_name="company_data[theme_name]"
}

{if $id}
    {include file="common/subheader.tpl"
        title=__("localization")
    }

    {include file="views/storefronts/components/languages.tpl"
        id=$storefront_id
        all_languages=$all_languages
    }

    {include file="views/storefronts/components/currencies.tpl"
        id=$storefront_id
        all_currencies=$all_currencies
    }
{/if}
{/hook}

{/if}

{if "MULTIVENDOR"|fn_allowed_for}
    {include file="views/profiles/components/profile_fields.tpl" section="C" default_data_name="company_data" profile_data=$company_data include=["company"] nothing_extra=true}
    {if !$runtime.company_id}
        {include file="common/select_status.tpl"
            input_name="company_data[status]"
            id="company_data"
            obj=$company_data
            items_status="companies"|fn_get_predefined_statuses:$company_data.status
            display=$status_display
        }
        <div class="control-group">
            <label class="control-label" for="cp_verified_supplier">{__("cp_verified_supplier.is_verified")}:</label>
            <input type="hidden" name="company_data[cp_verified_supplier]" value="{"YesNo::NO"|enum}" />
            <div class="controls">
                <input id="cp_verified_supplier" type="checkbox" name="company_data[cp_verified_supplier]" value="{"YesNo::YES"|enum}" {if $company_data.cp_verified_supplier == "YesNo::YES"|enum}checked="checked" {/if} />
            </div>
        </div>
    {else}
        <div class="control-group">
            <label class="control-label">{__("status")}:</label>
            <div class="controls">
                <label class="radio cp-verified-supplier-wrap">
                    <input type="radio" checked="checked" id="elm_company_status"/>
                    {if $company_data.status === "ObjectStatuses::ACTIVE"|enum}
                        {__("active")}
                    {elseif $company_data.status === "ObjectStatuses::PENDING"|enum}
                        {__("pending")}
                    {elseif $company_data.status === "ObjectStatuses::NEW_OBJECT"|enum}
                        {__("new")}
                    {elseif $company_data.status === "ObjectStatuses::DISABLED"|enum}
                        {__("disabled")}
                    {/if}
                    {if $company_data.cp_verified_supplier == "YesNo::YES"|enum}
                        <span class="cp-verified-supplier cp-confirmed"><i class="icon-ok"></i>{__("cp_verified_supplier.is_verified")}</span>
                    {else}
                        <span class="cp-verified-supplier cp-unconfirmed"><i class="icon-remove"></i>{__("cp_verified_supplier.is_not_verified")}</span>
                    {/if}
                </label>
            </div>
        </div>
    {/if}
    
    <div class="control-group">
        <label class="control-label" for="elm_company_language">{__("language")}:</label>
        <div class="controls">
        <select name="company_data[lang_code]" id="elm_company_language">
            {foreach from=$languages item="language" key="lang_code"}
                <option value="{$lang_code}" {if $lang_code == $company_data.lang_code}selected="selected"{/if}>{$language.name}</option>
            {/foreach}
        </select>
        </div>
    </div>
{/if}


{if !$id}
    {literal}
    <script>
    function fn_switch_store_settings(elm)
    {
        jelm = Tygh.$(elm);
        var close = true;
        if (jelm.val() != 'all' && jelm.val() != '' && jelm.val() != 0) {
            close = false;
        }

        Tygh.$('#clone_settings_container').toggleBy(close);
    }

    function fn_check_dependence(object, enabled)
    {
        if (enabled) {
            Tygh.$('.cm-dependence-' + object).prop('checked', true).prop('readonly', true).on('click', function(e) {
                return false
            });
        } else {
            Tygh.$('.cm-dependence-' + object).prop('readonly', false).off('click');
        }
    }
    </script>
    {/literal}

    {if !"ULTIMATE"|fn_allowed_for}
        <div class="control-group">
            <label class="control-label" for="elm_company_vendor_admin">{__("create_administrator_account")}:</label>
            <div class="controls">
                <label class="checkbox">
                    <input type="checkbox" name="company_data[is_create_vendor_admin]" id="elm_company_vendor_admin" checked="checked" value="Y" />
                </label>
            </div>
        </div>
    {/if}
{/if}


{if "MULTIVENDOR"|fn_allowed_for}
    {$excluded_fields=["company", "company_description", "accept_terms", "admin_firstname", "admin_lastname"]}
    {hook name="companies:contact_information"}
    {include file="views/profiles/components/profile_fields.tpl" section="C" default_data_name="company_data" profile_data=$company_data exclude=$excluded_fields nothing_extra=true}
    {/hook}

    {hook name="companies:shipping_address"}
    {/hook}
{/if}

{if "ULTIMATE"|fn_allowed_for}
    {include file="common/subheader.tpl" title="{__("settings")}: {__("company")}" }

    {component
        name="settings.settings_section"
        subsection=$company_settings
        section="Company"
        html_id_prefix="field_"
        html_name="update"
    }{/component}
{/if}