<fieldset>
    {if $settings.sd_taxjar.general.api_key}
        <div class="control-group setting-wide">
            <label class="control-label">{__("addons.sd_taxjar.update_product_tax_code")}:</label>
            <div class="controls">
                <a class="btn cm-ajax cm-post" href="{"sd_taxjar.update_product_tax_code"|fn_url}">
                    {__("update")}
                </a>
            </div>
        </div>
    {/if}
</fieldset>
