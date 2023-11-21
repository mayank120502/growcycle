{script src="js/tygh/backend/pages_bulk_edit.js"}

{capture name="mainbox"}

{$pages_statuses=""|fn_get_default_statuses:true}
{$has_permission=fn_check_permissions("pages", "update", "admin", "POST")}


<form action="{""|fn_url}" method="post" name="pages_tree_form" id="pages_tree_form">
<input type="hidden" name="redirect_url" value="{$config.current_url}" />

{include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id=$smarty.request.content_id hide_position=$hide_position}

{capture name="pages_table"}
{if $search.page_type}
<input type="hidden" name="page_type" value="{$search.page_type}" />
{/if}

{if $page_types[$search.page_type].hide_fields && $page_types[$search.page_type].hide_fields.position}
    {$hide_position = true}
{/if}

{$come_from=$search.page_type}

{if $search.page_type == "V"}
{assign var="company_name" value=$runtime.et_company_name|truncate:43:"...":true}

{if $runtime.company_id==0}
  <div class="navbar navbar-inverse1">
  <div class="navbar-inner"><ul class="nav">
    {$et_dispatch=urlencode("pages.manage&page_type=V")}

    {include
        file="addons/et_vivashop_mv_functionality/components/et_ajax_select_object.tpl"
        data_url="companies.et_get_companies_list?show_all=Y&et_dispatch=`$et_dispatch`"
        text=$company_name
        dropdown_icon=false
        id="et_top_company_id_new"
        type="list"
        extra_content=$smarty.capture.extra_content
    }
   
  </ul></div></div>
{/if}
{/if}

<div class="items-container multi-level pages-tree__content">
    {if $pages_tree}
        {include file="views/pages/components/pages_tree.tpl" header=true show_id=true combination_suffix="_list" is_bulkedit_menu=true}
    {else}
        {if !$hide_show_all}
            <p class="no-items">{__("no_data")}</p>
        {/if}
    {/if}
</div>
{/capture}

{include file="common/context_menu_wrapper.tpl"
    has_permission=$has_permission
    form="pages_tree_form"
    object="pages"
    items=$smarty.capture.pages_table
}

{include file="common/pagination.tpl" div_id=$smarty.request.content_id}

{$rev=$smarty.request.content_id|default:"pagination_contents"}

{capture name="adv_buttons"}
    {if $has_permission}
    {if $page_types|sizeof == 1}
        {foreach from=$page_types key="_k" item="_p"}
            {include file="common/tools.tpl" tool_href="pages.add?page_type=`$_k`&come_from=`$come_from`" prefix="top" title=__($_p.add_name) hide_tools=true icon="icon-plus"}
        {/foreach}
    {else}
        {capture name="tools_list"}
            {foreach from=$page_types key="_k" item="_p"}
                <li>{btn type="list" text=__($_p.add_name) href="pages.add?page_type=`$_k`&come_from=`$come_from`"}</li>
            {/foreach}
        {/capture}
        {dropdown content=$smarty.capture.tools_list icon="icon-plus" no_caret=true placement="right"}
        {/if}
    {/if}
{/capture}

{capture name="buttons"}
    {if $pages_tree}
        {capture name="tools_list"}
            {hook name="pages:list_extra_links"}
            {/hook}
        {/capture}
        {dropdown content=$smarty.capture.tools_list class="mobile-hide bulkedit-dropdown--legacy hide"}
        {include file="buttons/save.tpl" but_name="dispatch[pages.m_update]" but_role="action" but_target_form="pages_tree_form" but_meta="cm-submit"}
    {/if}
{/capture}
</form>
{/capture}

{if $is_exclusive_page_type}
    {$title = __($page_types[$search.page_type].content)}
    {$view_type = "pages_`$search.page_type`"}
    {$view_suffix = "page_type=`$search.page_type`&get_tree=multi_level"}
{else}
    {$title = __("pages")}
    {$view_type = "pages"}
    {$view_suffix = ""}
{/if}

{capture name="sidebar"}
    {hook name="pages:manage_sidebar"}
    {include file="common/saved_search.tpl" dispatch="pages.manage" view_type=$view_type view_suffix=$view_suffix}
    {include file="views/pages/components/pages_search_form.tpl" dispatch="pages.manage" view_type=$view_type}
    {hook name="pages:sidebar"}
    {/hook}
    {/hook}
{/capture}


{include file="common/mainbox.tpl" title=$title content=$smarty.capture.mainbox  buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons sidebar=$smarty.capture.sidebar content_id="manage_pages"}