{capture name="mainbox"}
    {assign var="c_icon" value="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
    {assign var="c_dummy" value="<i class=\"icon-dummy\"></i>"}

    <form action="{""|fn_url}" method="post" name="cp_seo_templates_list_form">
        <input type="hidden" name="fake" value="1" />

        {include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id=$smarty.request.content_id}

        {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
        {assign var="r_url" value=$c_url|escape:"url"}
        {assign var="rev" value=$smarty.request.content_id|default:"pagination_contents"}

        <div class="items-container" id="cp_seo_templates_list">
        {if $seo_templates}
            <div class="table-wrapper">
                <table class="table table-middle table-objects table-striped">
                    <thead>
                        <tr>
                            <th width="1%" class="center">{include file="common/check_items.tpl"}</th>
                            <th width="15%" class="nowrap">
                                <a class="cm-ajax" href="{"`$c_url`&sort_by=priority&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("priority")}{if $search.sort_by == "priority"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a>
                            </th>
                            <th width="50%">
                                <a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("name")}{if $search.sort_by == "name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a>
                            </th>
                            <th width="15%">
                                <a class="cm-ajax" href="{"`$c_url`&sort_by=type&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("type")}{if $search.sort_by == "type"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a>
                            </th>
                            <th class="right">&nbsp;</th>
                            <th width="10%" class="right">
                                <a class="cm-ajax" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("status")}{if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$seo_templates item=template name="cp_seo_templates"}
                            {assign var="edit_href" value="cp_seo_templates.update?template_id=`$template.template_id`"|fn_url}
                            {assign var="id" value=$template.template_id}

                            <tr class="cm-row-item cm-row-status-{$template.status|lower}">
                                <td width="1%" class="center"><input type="checkbox" name="template_ids[]" value="{$template.template_id}" class="cm-item" /></td>
                                <td width="15%">
                                    <input type="hidden" name="seo_templates[{$id}][template_id]" size="8" value="{$id}">
                                    <input type="text" name="seo_templates[{$id}][priority]" size="8" value="{$template.priority|default:0}" class="input-mini">
                                </td>
                                <td width="50%">
                                    <div class="object-group-link-wrap">
                                        <a href="{$edit_href}" class="row-status cm-external-click link">{$template.name}</a>
                                    </div>
                                </td>
                                <td width="15%">
                                    {if $template_types[$template.type]}{$template_types[$template.type].title}{/if}
                                </td>
                                <td width="10%" class="right nowrap">
                                    <div class="pull-right hidden-tools">
                                        {capture name="items_tools"}
                                            <li>{btn type="list" text=__("edit") href="cp_seo_templates.update?template_id=`$template.template_id`"}</li>
                                            <li>{btn type="list" text=__("cp_apply_seo_template") href="cp_seo_templates.apply?template_id=`$template.template_id`" class="cm-confirm cm-ajax cm-comet cm-ajax-full-render" data=["data-ca-target-id" => cp_seo_templates_list] method="POST"}</li>
                                            <li>{btn type="list" text=__("clone") href="cp_seo_templates.clone?template_id=`$template.template_id`&return_url=`$r_url`" class="cm-confirm cm-ajax cm-ajax-full-render" data=["data-ca-target-id" => cp_seo_templates_list] method="POST"}</li>
                                            <li>{btn type="text" text=__("delete") href="cp_seo_templates.delete?template_id=`$template.template_id`" class="cm-confirm cm-ajax cm-ajax-full-render" data=["data-ca-target-id" => cp_seo_templates_list] method="POST"}</li>
                                        {/capture}
                                        {dropdown content=$smarty.capture.items_tools class="dropleft"}
                                    </div>
                                </td>
                                <td width="10%">
                                    <div class="pull-right nowrap">
                                        {include file="common/select_popup.tpl" popup_additional_class="dropleft" id=$id status=$template.status hidden=false object_id_name="template_id" table="cp_seo_templates"}
                                    </div>
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        {else}
            <p class="no-items">{__("no_data")}</p>
        {/if}
        <!--cp_seo_templates_list--></div>
        {include file="common/pagination.tpl" div_id=$smarty.request.content_id}

        {capture name="buttons"}
            {if $seo_templates}
                {capture name="tools_list"}
                    <li>{btn type="list" dispatch="dispatch[cp_seo_templates.m_apply]" text=__("cp_apply_seo_templates") form="cp_seo_templates_list_form" class="cm-ajax cm-comet"}</li>
                    <li>{btn type="list" dispatch="dispatch[cp_seo_templates.m_clone]" text=__("clone") form="cp_seo_templates_list_form"}</li>
                    <li>{btn type="delete_selected" dispatch="dispatch[cp_seo_templates.m_delete]" form="cp_seo_templates_list_form"}</li>
                {/capture}
                {dropdown content=$smarty.capture.tools_list}

                {include file="buttons/save.tpl" but_name="dispatch[cp_seo_templates.m_update]" but_role="action" but_target_form="cp_seo_templates_list_form" but_meta="btn-primary cm-submit"}
            {/if}
        {/capture}

        {capture name="adv_buttons"}
            {include file="common/tools.tpl" tool_href="cp_seo_templates.add" prefix="top" hide_tools="true" title=__("cp_new_seo_template") icon="icon-plus"}
        {/capture}

        {capture name="sidebar"}
            {include file="addons/cp_seo_templates/views/cp_seo_templates/components/search_form.tpl" dispatch="cp_seo_templates.manage"}
        {/capture}
    </form>
{/capture}

{include file="common/mainbox.tpl" title=__("cp_seo_templates") content=$smarty.capture.mainbox select_languages=true buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons sidebar=$smarty.capture.sidebar}
