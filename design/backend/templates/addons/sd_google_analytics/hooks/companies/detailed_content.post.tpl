{foreach $vendor_plans as $plan}
    {if $company_data.plan_id == $plan.plan_id && $plan.ga_vendors_tracking == "YesNo::YES"|enum}
        {include file="common/subheader.tpl" title=__("sd_ga_google_analytics_section") target="#acc_addon_sd_google_analytics"}
        <div id="acc_addon_sd_google_analytics" class="collapse in">
            <div class="control-group" id="condition_ga">
                <label class="control-label" for="sd_google_analytics_vendor_tracking_code">
                    {__("sd_ga_tracking_code")}
                    <i class="icon-question-sign cm-tooltip" title="{__("sd_ga_tracking_code_tooltip")}"></i>:
                </label>
                <div class="controls">
                    <input type="text"
                        name="company_data[sd_ga_tracking_code]"
                        value="{$company_data.sd_ga_tracking_code}"
                        class="input-text"
                        size="60"
                    />
                </div>
            </div>
        </div>
    {/if}
{/foreach}
