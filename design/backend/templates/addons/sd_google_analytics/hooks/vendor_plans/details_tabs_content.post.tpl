<div id="content_addons_{$id}">
    <div class="control-group">
        <label for="" class="control-label">&nbsp;</label>
        <div class="controls cm-toggle-button">
            <div class="select-field">
                <label class="checkbox" for="ga_vendors_tracking_{$id}">
                    <input type="hidden"
                        name="plan_data[ga_vendors_tracking]"
                        value="{"YesNo::NO"|enum}"
                    />
                    <input type="checkbox"
                        id="ga_vendors_tracking_{$id}"
                        name="plan_data[ga_vendors_tracking]"
                        size="10"
                        value="{"YesNo::YES"|enum}"
                        {if $plan.ga_vendors_tracking == "YesNo::YES"|enum}
                            checked="checked"
                        {/if}
                    />
                    {__("sd_google_analytics.ga_vendors_tracking")}
                </label>
            </div>
        </div>
    </div>
</div>
