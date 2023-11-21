{if $in_popup}
    <div class="adv-search">
    <div class="group">
{else}
    <div class="sidebar-row">
    <h6>{__("search")}</h6>
{/if}

    <form action="{""|fn_url}{$_page_part}" name="cp_seo_templates_search_form" method="get" class="cm-disable-empty {$form_meta}">
        <input type="hidden" name="search_type" value="{$search_type|default:"simple"}" autofocus="autofocus" />
        {if $smarty.request.redirect_url}
            <input type="hidden" name="redirect_url" value="{$smarty.request.redirect_url}" />
        {/if}

        {capture name="simple_search"}
            <div class="sidebar-field">
                <label>{__("name")}</label>
                <input type="text" name="name" size="20" value="{$search.name}" />
                <input type="hidden" name="match" size="20" value="any" />
            </div>
            
            <div class="sidebar-field">
                <label>{__("type")}</label>
                <select id="elm_cp_seo_templates_type" name="type">
                    <option value="" {if empty($search.type)}selected="selected"{/if}>{__("all")}</option>
                    {foreach from=$template_types key="type_key" item="type"}
                        <option value="{$type_key}" {if $search.type == $type_key}selected="selected"{/if}>{$type.title}</option>
                    {/foreach}
                </select>
            </div>

            <div class="control-group">
                <label for="elm_cp_seo_templates_status" class="control-label">{__("status")}</label>
                <div class="controls">
                <select name="status" id="elm_cp_seo_templates_status">
                    <option value="">--</option>
                    <option value="A" {if $search.status == "A"}selected="selected"{/if}>{__("active")}</option>
                    <option value="D" {if $search.status == "D"}selected="selected"{/if}>{__("disabled")}</option>
                </select>
                </div>
            </div>
        {/capture}

        {include file="common/advanced_search.tpl" simple_search=$smarty.capture.simple_search  dispatch=$dispatch view_type="cp_seo_templates" in_popup=$in_popup not_saved=true}
    </form>

{if $in_popup}
    </div></div>
{else}
    </div><hr>
{/if}
