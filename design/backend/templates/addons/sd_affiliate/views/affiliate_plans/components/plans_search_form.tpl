{if $in_popup}
    <div class="adv-search">
    <div class="group">
{else}
    <div class="sidebar-row">
    <h6>{__("search")}</h6>
{/if}

<form name="plans_search_form" action="{""|fn_url}" method="get" class="{$form_meta}">
    {if $put_request_vars}
        {array_to_fields data=$smarty.request skip=["callback"]}
    {/if}

    {$extra nofilter}
    {capture name="simple_search"}
        <div class="sidebar-field">
            <label for="elm_name">{__("name")}</label>
            <input type="text" name="plan_name" id="elm_name" value="{$plans.name}" />
        </div>
    {/capture}
    {include file="common/advanced_search.tpl" simple_search=$smarty.capture.simple_search advanced_search=$smarty.capture.advanced_search dispatch=$dispatch view_type="plans" in_popup=$in_popup}
</form>