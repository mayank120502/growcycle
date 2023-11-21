{$cp_rev_settings = fn_get_cp_discussion_settings()}
{$cp_date_reviews = $cp_rev_settings.general.cp_date_reviews}
<div class="control-group setting-wide cp_discussion">
    <label class="control-label" for="elm_date_holder_from">{__("start_date")}:</label>
    <div class="controls">
        <input type="hidden" name="cp_time_reviews[cp_date_reviews][cp_from_date]" value="0" />
        {include file="common/calendar.tpl" date_id="elm_date_holder_from" date_name="cp_time_reviews[cp_date_reviews][cp_from_date]" date_val=$cp_date_reviews.cp_from_date start_year="c-10"}
    </div>
</div>

<div class="control-group setting-wide cp_discussion">
    <label class="control-label" for="elm_date_holder_to">{__("end_date")}:</label>
    <div class="controls">
        <input type="hidden" name="cp_time_reviews[cp_date_reviews][cp_to_date]" value="0" />
        {include file="common/calendar.tpl" date_id="elm_date_holder_to" date_name="cp_time_reviews[cp_date_reviews][cp_to_date]" date_val=$cp_date_reviews.cp_to_date start_year=$settings.Company.company_start_year}
    </div>
</div>

{if $cp_date_reviews.cp_to_date && $cp_date_reviews.cp_from_date}
    <div class="control-group setting-wide cp_discussion">
        <div class="controls">
            <a class="btn btn-primary cm-ajax" href="{"cp_discussion.m_generate_time"|fn_url}" class="cm-ajax cm-post">
                {__("cp_discussion.run_manually")}
            </a>
        </div>
    </div>

    <div class="control-group setting-wide cp_discussion">
        <label class="control-label" for="elm_use_avail_period">{__("cp_discussion.rnd_time_storefront")}:</label>
        <div class="controls">
            <input type="checkbox" name="cp_time_reviews[cp_date_reviews][rnd_time_storefront]" id="elm_use_avail_period" {if $cp_date_reviews.rnd_time_storefront == "YesNo::YES"|enum}checked="checked"{/if} value="Y"/>
        </div>
    </div>
{/if}