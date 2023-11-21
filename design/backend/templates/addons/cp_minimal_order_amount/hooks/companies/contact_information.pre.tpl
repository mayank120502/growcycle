{if "MULTIVENDOR"|fn_allowed_for && !$auth.company_id}
    <div class="control-group">
        <label for="elm_cp_min_order_amount" class="control-label">
            {__('cp_minimal_order_amount.minimal_amount')} ({$currencies.$primary_currency.symbol nofilter}):
        </label>
        <div class="controls">
            <input type="text" class="input-big" name="company_data[cp_min_order_amount]" id="elm_cp_min_order_amount" value="{$company_data.cp_min_order_amount|default:"0.00"|fn_format_price:$primary_currency:null:false}"/>
            <p class="muted description">{__('cp_minimal_order_amount.ttc_minimal_amount')}</p>
        </div>
    </div>
{/if}
