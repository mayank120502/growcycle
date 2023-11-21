{$avail_sorting = $settings.Appearance.available_product_list_sortings}

<div class="amp-select-wrapper inline-block pl2">
    <label for="sort_by" class="bold caps h6 md-h7">{__("sd_accelerated_pages.sort_by")}:</label>
    <select
        name="sort_by"
        id="sort_by"
        class="amp-select h6 md-h7"
        {literal}on="change: AMP.setState({products: {sort_by: event.value.substr(0, event.value.indexOf('-')), sort_order: event.value.substr(event.value.indexOf('-') + 1)}})"{/literal}>
        {foreach $sorting as $option => $sort_data}
            {foreach $sorting_orders as $sort_order}
                {$sort_key = "`$option`-`$sort_order`"}

                {if !$avail_sorting || $avail_sorting[$sort_key] == 'Y'}
                <option value="{$option}-{$sort_order}" {if $search.sort_by == $option && $search.sort_order == $sort_order} selected{/if}>
                    {__("sd_accelerated_pages.sort_by_`$option`_`$sort_order`")}
                </option>
                {/if}
            {/foreach}
        {/foreach}
    </select>
</div>
