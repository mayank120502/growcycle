{capture name="mainbox"}
    {include file="common/pagination.tpl"}

    {assign var="c_icon" value="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
    {assign var="c_dummy" value="<i class=\"icon-dummy\"></i>"}

    {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
    {assign var="rev" value=$smarty.request.content_id|default:"pagination_contents"}

    <form action="{""|fn_url}" method="post" name="cp_seo_names_form">
        <input type="hidden" name="return_url" value="{$config.current_url}">

        <div class="table-responsive-wrapper {if ""|fn_check_form_permissions}cm-hide-inputs{/if}" id="cp_update_seo_names_list">
            {if $seo_names}
                <table width="100%" class="table table-middle table-responsive">
                <thead>
                    <tr>
                        <th width="1%">{include file="common/check_items.tpl"}</th>
                        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("name")}{if $search.sort_by == "name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="10%"><a class="cm-ajax" href="{"`$c_url`&sort_by=object_id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("id")}{if $search.sort_by == "object_id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="10%"><a class="cm-ajax" href="{"`$c_url`&sort_by=type&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("type")}{if $search.sort_by == "type"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="10%"><a class="cm-ajax" href="{"`$c_url`&sort_by=dispatch&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("dispatch")}{if $search.sort_by == "dispatch"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="10%"><a class="cm-ajax" href="{"`$c_url`&sort_by=path&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("cp_so_parent_path")}{if $search.sort_by == "path"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="10%"><a class="cm-ajax" href="{"`$c_url`&sort_by=lang_code&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("cp_so_lang_code")}{if $search.sort_by == "lang_code"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="10%"><a class="cm-ajax" href="{"`$c_url`&sort_by=company&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("company")}{if $search.sort_by == "company"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th width="5%">&nbsp;</th>
                    </tr>
                </thead>
                <tbody>
                {foreach from=$seo_names item="seo_name" name="seo_names"}
                    {$seo_name_id = "`$seo_name.object_id`_`$seo_name.type`_`$seo_name.dispatch`_`$seo_name.lang_code`_`$seo_name.company_id`"}
                    {$key = $smarty.foreach.seo_names.index}
                    <tr class="cm-row-item">
                        <td class="mobile-hide">
                            <input type="checkbox" name="seo_name_ids[]" value="{$seo_name_id}" class="checkbox cm-item" />
                        </td>
                        <td data-th="{__("name")}">
                            <input type="hidden" name="seo_names[{$key}][seo_name_id]" value="{$seo_name_id}" />
                            <input type="hidden" name="seo_names[{$key}][old_name]" value="{$seo_name.name}" />
                            <input type="text" name="seo_names[{$key}][name]" size="8" value="{$seo_name.name}" class="input-medium" />
                        </td>
                        <td data-th="{__("id")}">
                            <input type="text" name="seo_names[{$key}][object_id]" size="8" value="{$seo_name.object_id}" class="input-mini" />
                        </td>
                        <td data-th="{__("type")}">
                            {$seo_types = array_keys($types)}
                            <select name="seo_names[{$key}][type]" class="input-small">
                                {foreach from=$types item="type" key="seo_type"}
                                    <option value="{$seo_type}" {if $seo_type == $seo_name.type} selected="selected" {/if}>{$type.name}</option>
                                {/foreach}
                                {if !in_array($seo_name.type, $seo_types)}
                                    <option value="{$seo_name.type}" selected="selected">{__('unknown')} ({$seo_name.type})</option>
                                {/if}
                            </select>
                        </td>
                        <td data-th="{__("dispatch")}">
                            <input type="text" name="seo_names[{$key}][dispatch]" size="8" value="{$seo_name.dispatch}" class="input-small" />
                        </td>
                        <td data-th="{__("cp_seo_parent_path")}">
                            <input type="text" name="seo_names[{$key}][path]" size="8" value="{$seo_name.path}" class="input-mini" />
                        </td>
                        <td data-th="{__("cp_seo_lang_code")}">
                            <select name="seo_names[{$key}][lang_code]" class="input-small">
                                {foreach from=$languages item="language"}
                                    <option value="{$language.lang_code}" {if $language.lang_code == $seo_name.lang_code} selected="selected" {/if}>{$language.lang_code}</option>
                                {/foreach}
                            </select>
                        </td>
                        <td data-th="{__("company")}">
                            <select name="seo_names[{$key}][company_id]" class="input-small">
                                <option value="0" {if $seo_name.company_id == 0}selected="selected"{/if}>-</option>                    
                                {foreach from=$companies item="company"}
                                    <option value="{$company.company_id}" {if $company.company_id == $seo_name.company_id} selected="selected" {/if}>{$company.company}</option>
                                {/foreach}
                            </select>
                        </td>
                        <td class="nowrap mobile-hide">
                            {capture name="tools_list"}
                                <li>{btn type="list" class="cm-confirm cm-post" text=__("delete") href="cp_seo_names.delete?seo_name_id=`$seo_name_id`"}</li>
                            {/capture}
                            <div class="hidden-tools">
                                {dropdown content=$smarty.capture.tools_list}
                            </div>
                        </td>
                    </tr>
                {/foreach}
                </tbody>
                </table>
            {else}
                <p class="no-items">{__("no_data")}</p>
            {/if}
        <!--cp_update_seo_names_list--></div>
    </form>

    {include file="common/pagination.tpl"}

    {capture name="sidebar"}
        {include file="addons/cp_seo_optimization/views/cp_seo_names/components/search_form.tpl" dispatch="cp_seo_names.manage"}
    {/capture}

    {capture name="buttons"}
        {capture name="tools_list"}
            {if $seo_names}
                <li>{btn type="delete_selected" dispatch="dispatch[cp_seo_names.m_delete]" form="cp_seo_names_form"}</li>
            {/if}
        {/capture}
        {dropdown content=$smarty.capture.tools_list}

        {if $seo_names}
            {include file="buttons/save.tpl" but_name="dispatch[cp_seo_names.m_update]" but_role="submit-link" but_target_form="cp_seo_names_form"}
        {/if}
    {/capture}
{/capture}

{include file="common/mainbox.tpl" title=__("cp_seo_names_editor") content=$smarty.capture.mainbox select_languages=false buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons sidebar=$smarty.capture.sidebar}
