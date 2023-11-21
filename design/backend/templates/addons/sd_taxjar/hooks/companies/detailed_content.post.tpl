{if $company_data.company_id}
    {assign var="id" value=$company_data.company_id}
{else}
    {assign var="id" value=0}
{/if}

{include file="common/subheader.tpl" title=__("addons.sd_taxjar.taxjar") target="#acc_addon_sd_taxjar"}

<div id="acc_addon_sd_taxjar" class="collapsed in">
    <div class="control-group {if $share_dont_hide}cm-no-hide-input{/if}">
        <label
            class="
                control-label
                {if $addons.sd_taxjar.required_api == 'Y'}cm-required{/if}
            "
            for="elm_sd_taxjar_key"
        >
            {__("addons.sd_taxjar.api_key")}:
        </label>
        <div class="controls">
            <input
                type="text"
                name="company_data[taxjar_key]"
                id="elm_sd_taxjar_key"
                size="32"
                value="{$company_data.taxjar_key}"
                class="input-large"
            >
        </div>
    </div>
</div>

{if $id}
    {include file="common/subheader.tpl"
        title=__("addons.sd_taxjar.taxjar_csv_export")
        target="#acc_addon_sd_taxjar_csv_export"
    }
    <div id="acc_addon_sd_taxjar_csv_export" class="collapsed in">
        <fieldset>
            {$r_url = $config.current_url|urlencode}
            <input type="hidden" name="r_url" value="{$r_url}">
            <div class="control-group setting-wide">
                <label class="control-label">{__("addons.sd_taxjar.items_per_file")}:</label>
                <div class="controls">
                    <input
                        type="text"
                        name="company_data[taxjar_export_csv_data][items_per_file]"
                        size="15"
                        value="{$company_data.taxjar_export_csv_data.items_per_file|default:2500}"
                    />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">{__("select_dates")}:</label>
                <div class="controls">
                    {include file="common/calendar.tpl"
                        date_id="f_date"
                        date_name="company_data[taxjar_export_csv_data][time_from]"
                        date_val=$company_data.taxjar_export_csv_data.time_from
                        start_year=$settings.Company.company_start_year
                    }
                    &nbsp;&nbsp;-&nbsp;&nbsp;
                    {include file="common/calendar.tpl"
                        date_id="t_date"
                        date_name="company_data[taxjar_export_csv_data][time_to]"
                        date_val=$company_data.taxjar_export_csv_data.time_to
                        start_year=$settings.Company.company_start_year
                    }
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">{__("order_status")}:</label>
                <div class="controls checkbox-list">
                    {include file="common/status.tpl"
                        status=$company_data.taxjar_export_csv_data.export_csv_statuses
                        display="checkboxes"
                        name="company_data[taxjar_export_csv_data][export_csv_statuses]"
                        columns=5
                    }
                </div>
            </div>
            <div class="control-group setting-wide">
                <label class="control-label">{__("addons.sd_taxjar.export_orders")}:</label>
                <div class="controls">
                    <a class="btn btn-primary cm-submit" data-ca-dispatch="dispatch[sd_taxjar.export]">
                        {__("export")}
                    </a>
                </div>
            </div>
        </fieldset>
    </div>

    {include file="common/subheader.tpl"
        title=__("addons.sd_taxjar.taxjar_order_transactions")
        target="#acc_addon_sd_taxjar_order_transactions"
    }
    <div id="acc_addon_sd_taxjar_order_transactions" class="collapsed in">
        <div class="control-group">
            <label class="control-label">{__("addons.sd_taxjar.order_statuses")}:</label>
            <div class="controls checkbox-list">
                {include file="common/status.tpl"
                    status=$company_data.taxjar_export_statuses
                    display="checkboxes"
                    name="company_data[taxjar_export_statuses]"
                    columns=5
                }
            </div>
        </div>
    </div>
{/if}
