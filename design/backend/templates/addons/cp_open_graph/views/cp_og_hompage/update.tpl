{capture name="mainbox"}

<form action="{""|fn_url}" method="post" class="form-horizontal form-edit" name="cp_og_form" enctype="multipart/form-data">
    {if "MULTIVENDOR"|fn_allowed_for && !$selected_storefront_id}
        <p>{__("cp_og_select_storefront")}</p>
    {else}
        {include file="addons/cp_open_graph/views/components/meta_data_fields.tpl"
            input_prefix="homepage"
            only_manual=true
        }
        {if "MULTIVENDOR"|fn_allowed_for}
            <input type="hidden" value="{$selected_storefront_id}" name="homepage[cp_og_data][object_id]"/>
        {/if}
    {/if}

    {capture name="buttons"}
        {include file="buttons/save_cancel.tpl" but_name="dispatch[cp_og_hompage.update]" but_role="submit-link" but_target_form="cp_og_form" hide_first_button=$hide_first_button hide_second_button=true save=true}
    {/capture}
</form>

{/capture}
{if "MULTIVENDOR"|fn_allowed_for}
{include file="common/mainbox.tpl" 
    title=__("cp_og.for_homepage") 
    content=$smarty.capture.mainbox 
    buttons=$smarty.capture.buttons 
    adv_buttons=$smarty.capture.adv_buttons 
    select_storefront=true
    storefront_switcher_param_name="s_storefront"
    selected_storefront_id=$selected_storefront_id
    select_languages=true}
{else}
    {include file="common/mainbox.tpl" 
    title=__("cp_og.for_homepage") 
    content=$smarty.capture.mainbox 
    buttons=$smarty.capture.buttons 
    adv_buttons=$smarty.capture.adv_buttons 
    select_languages=true}
{/if}