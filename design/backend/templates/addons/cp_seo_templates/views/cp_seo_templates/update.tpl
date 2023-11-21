{if file_exists("js/tygh/email_templates.js")}
    {script src="js/tygh/email_templates.js"}
{else}
    {script src="js/tygh/template_editor.js"}
{/if}

{assign var="allow_save" value=true}

{$allow_save = $template|fn_allow_save_object:"cp_seo_templates"}
{$hide_inputs = ""|fn_check_form_permissions}

{script src="js/tygh/node_cloning.js"}
{script src="js/addons/cp_seo_templates/backend.js"}

{capture name="mainbox"}
    {if !$id}
        {assign var="id" value=$template.template_id|default:0}
    {/if}
    {assign var="c_url" value=$config.current_url|fn_query_remove}
    {assign var="r_url" value=$c_url|escape:"url"}

    <form action="{""|fn_url}" method="post" name="seo_templates_form_{$id}" enctype="multipart/form-data" class="conditions-tree form-horizontal form-edit {if !$allow_save || $hide_inputs} cm-hide-inputs{/if}">
        <input type="hidden" class="cm-no-hide-input" name="template_id" value="{$id}" />
        <input type="hidden" class="cm-no-hide-input" name="seo_template[company_id]" value="{$runtime.company_id}"/>
        <input type="hidden" class="cm-no-hide-input" name="selected_section" value="{$smarty.request.selected_section}" />
        <input type="hidden" class="cm-no-hide-input" name="return_url" value="{$r_url}" />

        {if $smarty.request.type}
            {$type = $smarty.request.type}
        {else}
            {$type = $template.type|default:"P"}
        {/if}
        
        {capture name="tabsbox"}
        <div id="content_general">
            {include file="common/subheader.tpl" title=__("settings")}
            <div class="control-group">
                <label for="cp_seo_template_name_{$id}" class="cm-required control-label">{__("name")}:</label>
                <div class="controls">
                    <input id="cp_seo_template_name_{$id}" type="text" class="input-large" name="seo_template[name]" value="{$template.name}">
                </div>
            </div>
            {if "ULTIMATE"|fn_allowed_for}
                {include file="views/companies/components/company_field.tpl"
                    name="seo_template[company_id]"
                    id="elm_post_data_company_id"
                    zero_company_id_name_lang_var=$zero_company_id_name_lang_var
                    selected=$template.company_id|default:$runtime.company_id
                    js_action=$js_action
                    disable_company_picker=$disable_company_picker
                }
            {/if}
            {assign var="t_url" value=$config.current_url|fn_query_remove:"type"}
            <div class="control-group">
                <label for="cp_seo_template_type_{$id}" class="control-label cm-required">{__("type")}:</label>
                <div class="controls">
                    <select id="cp_seo_template_type_{$id}" name="seo_template[type]" class="cm-cp-template-type"
                    onchange="Tygh.$.redirect('{"`$t_url`&type="|fn_url}' + this.value);">
                        {foreach from=$template_types key="type_key" item="template_type"}
                            <option value="{$type_key}" {if $type == $type_key}selected="selected"{/if}>{$template_type.title}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label for="cp_seo_template_priority_{$id}" class="control-label">{__("priority")}:</label>
                <div class="controls">
                    <input id="cp_seo_template_priority_{$id}" type="text" class="input-mini" name="seo_template[priority]" value="{$template.priority|default:100}">
                </div>
            </div>
           
            {include file="common/select_status.tpl" input_name="seo_template[status]" id="elm_seo_template_status_`$id`" obj_id=$id obj=$template}
            
            {if $fields}
                <div id="cp_seo_templates_content_{$id}">
                {foreach from=$fields key="field_key" item="field"}
                    <div class="control-group">
                        <label class="control-label" for="cp_elm_{$field_key}_{$id}">{$field.title}:</label>
                        <div class="controls">
                            <textarea name="seo_template{if $field.is_extra}[extra]{/if}[{$field_key}]" cols="{$field.html_params.cols|default:35}" rows="{$field.html_params.rows|default:2}" class="input-large cm-emltpl-set-active {$field.html_params.class}" id="cp_elm_{$field_key}_{$id}">{if $id}{$template.$field_key}{else}{$field.default_value.$type}{/if}</textarea>
                        </div>
                    </div>
                {/foreach}
                </div>
            {/if}
        </div>

        <div id="content_settings">
            <div class="control-group">
                <label class="control-label" for="cp_elm_override_{$id}">{__("cp_st_fields_override")}{include file="common/tooltip.tpl" tooltip=__("cp_st_fields_override_descr") params="ty-subheader__tooltip"}:</label>
                <div class="controls">
                    <select name="seo_template[settings][override]" id="cp_elm_override_{$id}">
                        <option value="Y" {if $template.settings.override == "Y"}selected="selected"{/if}>{__("cp_seo_override_all")}</option>
                        <option value="N" {if $template.settings.override == "N"}selected="selected"{/if}>{__("cp_seo_fill_if_empty")}</option>
                    </select>
                </div>
            </div>

            {foreach from=$fields key="field_key" item="field"}
                <div class="control-group">
                    <label class="control-label" for="cp_elm_update_{$field_key}_{$id}">{__("update")} "{$field.title}":</label>
                    <div class="controls">
                        <input type="checkbox" name="seo_template[settings][update][]" value="{$field_key}" id="cp_elm_update_{$field_key}_{$id}" {if $field_key|in_array:$template.settings.update}checked="checked"{/if} />
                    </div>
                </div>
            {/foreach}
        </div>

        <div id="content_condition">
            {include file="addons/cp_seo_templates/views/cp_seo_templates/components/group.tpl" prefix="seo_template[conditions]" conditions=$conditions group=$template.conditions root=true no_ids=true hide_add_buttons=!$allow_save}
        </div>
        {/capture}

        {include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox group_name=$runtime.controller active_tab=$smarty.request.selected_section track=true}

    </form>
{/capture}

{capture name="sidebar"}
    {$exists_dynamic=false}
    <div class="sidebar-row">
        <h6>{__("cp_seo_placeholders_title")}</h6>
        <ul class="nav nav-list variables-list variables-list--variables cm-cp-sidebar-variables" id="sidebar_variables">
            {foreach $variables as $var_key => $var}
                {if !$var.is_dynamic}
                    {if $var.is_group}
                        {if !$var.variables}
                            {continue}
                        {/if}
                        <span class="strong micro-note hand cm-external-click" data-ca-external-click-id="cp_var_list_{$var_key}">{$var.title}</span>
                        <span id="cp_var_list_{$var_key}" class="icon-plus hand nav-opener"></span>
                        <ul class="hidden nav nav-list">
                            {foreach $var.variables as $subvar_key => $subvar}
                                <li class="variables-list__item">
                                    <span class="cm-emltpl-insert-variable label hand" data-ca-template-value="{$subvar_key}">{$subvar_key}</span>
                                    <span class="micro-note">- {$subvar.title}</span>
                                </li>
                            {/foreach}
                        </ul>
                    {else}
                        <li class="variables-list__item">
                            <span class="cm-emltpl-insert-variable label hand {if $var.tooltip}cm-tooltip{/if}" {if $var.tooltip}title="{$var.tooltip}"{/if} data-ca-template-value="{$var_key}">{$var_key}</span>
                            <span class="micro-note">- {$var.title}</span>
                        </li>
                    {/if}
                {else}
                    {$exists_dynamic=true}
                {/if}
            {/foreach}
        </ul>
    </div>
    {if $exists_dynamic}
        <div class="sidebar-row">
            <h6>{__("cp_seo_dynamic_placeholders_title")}{include file="common/tooltip.tpl" tooltip=__("cp_seo_dynamic_placeholders_tooltip")}</h6>
            <ul class="nav nav-list variables-list variables-list--variables cm-cp-sidebar-variables" id="sidebar_variables">
                {foreach $variables as $var_key => $var}
                    {if $var.is_dynamic}
                        <li class="variables-list__item">
                            <span class="cm-emltpl-insert-variable label hand {if $var.tooltip}cm-tooltip{/if}" {if $var.tooltip}title="{$var.tooltip}"{/if} data-ca-template-value="{$var_key}">{$var_key}</span>
                            <span class="micro-note">- {$var.title}</span>
                        </li>
                    {/if}
                {/foreach}
            </ul>
        </div>
    {/if}
    <div class="sidebar-row">
        <h6>{__("cp_seo_twig_filters_title")}{include file="common/tooltip.tpl" tooltip=__("cp_seo_twig_filters_doc_info")}</h6>
        <p>{__("cp_seo_twig_filter_example")}</p>
        <ul class="nav nav-list variables-list variables-list--variables cm-cp-sidebar-variables" id="sidebar_variables">
            {foreach from=$twig_filters key="filt_key" item="filt_data"}
                <li class="variables-list__item">
                    <span class="cp-seo__filter-click label hand {if $filt_data.tooltip}cm-tooltip{/if}" {if $filt_data.tooltip}title="{$filt_data.tooltip}"{/if} data-ca-template-value="{$filt_key}">{$filt_key}</span>
                    <span class="micro-note" >- {$filt_data.title}</span>
                </li>
            {/foreach}
        </ul>
    </div>
{/capture}

{capture name="buttons"}
    {capture name="tools_list"}
        {if $id}
            <li>{btn type="list" href="cp_seo_templates.apply?template_id=`$id`&return_url=`$r_url`" class="cm-post cm-ajax cm-comet" text=__("cp_apply_seo_template")}</li>
            <li>{btn type="list" href="cp_seo_templates.clone?template_id=`$id`" class="cm-post" text=__("clone")}</li>
            <li>{btn type="delete" href="cp_seo_templates.delete?template_id=`$id`&return_url=`$r_url`" class="cm-post"}</li>
        {/if}
    {/capture}
    {dropdown content=$smarty.capture.tools_list}
    
    {if "ULTIMATE"|fn_allowed_for && !$allow_save}
        {$hide_first_button=true}
        {$hide_second_button=true}
    {/if}
    
    {include file="buttons/save_cancel.tpl" but_role="submit-link" but_target_form="seo_templates_form_`$id`" but_name="dispatch[cp_seo_templates.update]" save=$id hide_first_button=$hide_first_button hide_second_button=$hide_second_button}
{/capture}

{capture name="title"}{__("cp_seo_template")}: {$template.name}{/capture}

{include file="common/mainbox.tpl" title=$smarty.capture.title content=$smarty.capture.mainbox buttons=$smarty.capture.buttons sidebar=$smarty.capture.sidebar sidebar_position="right" select_languages=$id}


