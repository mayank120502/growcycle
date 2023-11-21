{if $in_popup}
    <div class="adv-search">
    <div class="group">
{else}
    <div class="sidebar-row">
    <h6>{__("search")}</h6>
{/if}

    <form action="{""|fn_url}{$_page_part}" name="cp_seo_names_search_form" method="get" class="cm-disable-empty {$form_meta}">
        <input type="hidden" name="search_type" value="{$search_type|default:"simple"}" autofocus="autofocus" />
        {if $smarty.request.redirect_url}
            <input type="hidden" name="redirect_url" value="{$smarty.request.redirect_url}" />
        {/if}

        {capture name="simple_search"}
            <div class="sidebar-field">
                <label>{__("name")}:</label>
                <input type="text" name="name" size="32" maxlength="64" value="{$search.name}" class="input-large"/>
                <input type="hidden" name="match" size="20" value="any" />
            </div>
            <div class="sidebar-field">
                <label>{__("id")}:</label>
                <input type="text" name="object_id" size="32" maxlength="64" value="{$search.object_id}" class="input-large"/>
            </div>
            {if "ULTIMATE"|fn_allowed_for}
                <div class="sidebar-field">
                    <label>{__("company")}:</label>
                    <select name="company_id">
                        <option value="0" {if $search.company_id == 0} selected="selected" {/if}>-</option>
                        {foreach from=$companies item="company"}
                            <option value="{$company.company_id}" {if $company.company_id == $search.company_id} selected="selected" {/if}>{$company.company}</option>
                        {/foreach}
                    </select>
                </div>
            {/if}
            <div class="sidebar-field">
                <label>{__("type")}:</label>
                <select name="type" class="span2">
                    <option value="0" {if $search.type == 0} selected="selected" {/if}>-</option>
                    {foreach from=$types item="type" key="seo_type"}
                        <option value="{$seo_type}" {if $seo_type == $search.type} selected="selected" {/if}>{$type.name}</option>
                    {/foreach}
                </select>
            </div>
            <div class="sidebar-field">
                <label>{__("dispatch")}:</label>
                <input type="text" name="seo_dispatch" size="32" maxlength="64" value="{$search.seo_dispatch}" class="input-large"/>
            </div>
            <div class="sidebar-field">
                <label>{__("cp_so_parent_path")}:</label>
                <input type="text" name="path" size="32" maxlength="64" value="{$search.path}" class="input-large"/>
            </div>
            <div class="sidebar-field">
                <label>{__("cp_so_lang_code")}:</label>
                <select name="lang_code" class="span2">
                    <option value="" {if empty($search.lang_code)} selected="selected" {/if}>-</option>
                    {foreach from=$languages item="language"}
                        <option value="{$language.lang_code}" {if $language.lang_code == $search.lang_code} selected="selected" {/if}>{$language.name}</option>
                    {/foreach}
                </select>
            </div>
        {/capture}

        {include file="common/advanced_search.tpl" simple_search=$smarty.capture.simple_search  dispatch=$dispatch view_type="cp_seo_names" in_popup=$in_popup not_saved=true}
    </form>

{if $in_popup}
    </div></div>
{else}
    </div><hr>
{/if}
