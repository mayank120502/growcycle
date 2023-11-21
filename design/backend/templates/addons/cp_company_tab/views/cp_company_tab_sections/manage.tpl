{capture name="mainbox"}

<div id="content_translations" class="content page-content  no-sidebar ">

<form action="{""|fn_url}" method="post" name="tab_sections_form" id="cp_company_tab_sections_form">

{$c_url = $config.current_url|escape:url}

{if $sections_data}
    {capture name="cp_company_tab_sections_list"}
        <div class="table-responsive-wrapper longtap-selection">
            <table class="table table-sort table-middle table--relative table-responsive" width="100%">
                <thead
                        data-ca-bulkedit-default-object="true"
                        data-ca-bulkedit-component="defaultObject"
                >
                    <tr>
                        <th width="1%">
                            {include file="common/check_items.tpl"}

                            <input type="checkbox"
                                   class="bulkedit-toggler hide"
                                   data-ca-bulkedit-disable="[data-ca-bulkedit-default-object=true]"
                                   data-ca-bulkedit-enable="[data-ca-bulkedit-expanded-object=true]"
                            />
                        </th>
                        <th width="5%">{__("position")}</th>
                        <th width="90%">{__("description")}</th>
                        <th width="5%">{__("status")}</th>
                    </tr>
                </thead>
                <tbody>
                {foreach $sections_data as $key => $section}
                    <tr  class="cm-row-status-{$section.status|lower} cm-longtap-target"
                        data-ca-longtap-action="setCheckBox"
                        data-ca-longtap-target="input.cm-item"
                        data-ca-id="{$section.section_id}"
                    >
                        <td>
                            <input type="checkbox" name="delete[]" value="{$section.section_id}" class="checkbox cm-item hide">
                        </td>
                        <td class="row-status" data-th="{__("position")}">
                            <input type="text" name="section_data[{$section.section_id}][position]" value="{$section.position}" class="input-small input-hidden">
                        </td>
                        </td>
                        <td data-th="{__("description")}">
                            <input type="text" name="section_data[{$section.section_id}][description]" value="{$section.description}" class="input-long input-hidden">
                        </td>
                        <td data-th="{__("status")}">
                            {include file="common/select_popup.tpl" id=$section.section_id status=$section.status items_status="cp_company_tab"|fn_get_predefined_statuses object_id_name="section_id" table="cp_company_tab_sections"}
                        </td>
                    </tr>
                {/foreach}
                </tbody>
            </table>
        </div>
    {/capture}

    {include file="common/context_menu_wrapper.tpl"
        form="cp_company_tab_sections_form"
        object="cp_company_tab_sections"
        items=$smarty.capture.cp_company_tab_sections_list
        is_check_all_shown=true
    }

    {capture name="add_button"}
        {$smarty.capture.add_button}
        <span class="cm-tab-tools btn-group" id="tools_translations_save_button">
            {include file="buttons/save.tpl" but_name="dispatch[cp_company_tab_sections.update]" but_role="action" but_target_form="tab_sections_form" but_meta="cm-submit"}
        </span>
    {/capture}
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}
</form>

{capture name="cp_add_company_tab_section"}

<form action="{""|fn_url}" method="post" name="add_section">

<div class="table-responsive-wrapper">
    <table class="table table--relative table-responsive">
    <thead>
        <tr class="cm-first-sibling">
            <th width="10%">{__("position")}</th>
            <th width="40%">{__("description")}</th>
            <th width="30%">{__("status")}</th>
            <th width="20%">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        <tr id="box_new_lang_tag" valign="top">
            <td data-th="{__("position")}">
                <input type="text" size="2" name="new_section_data[0][position]" value="0" class="input-mini"/>
            </td>
            <td data-th="{__("description")}">
                <input type="text" size="30" name="new_section_data[0][description]" value=""/>
            </td>
            <td data-th="{__("status")}">
                {include file="common/select_status.tpl" input_name="new_section_data[0][status]" id="elm_page_status" obj=$section display="popup"}
            </td>
            <td data-th="{__("tools")}">
                {include file="buttons/multiple_buttons.tpl" item_id="new_lang_tag"}</td>
        </tr>
    </tbody>
    </table>
</div>

<div class="buttons-container">
    {include file="buttons/save_cancel.tpl" but_name="dispatch[cp_company_tab_sections.add]" cancel_action="close"}
</div>

</form>

{/capture}

</div>

{/capture}

{capture name="adv_buttons"}
    {include file="common/popupbox.tpl" id="cp_add_company_tab_section" text=__("cp_add_company_tab_section") title=__("cp_add_company_tab_section") content=$smarty.capture.cp_add_company_tab_section act="general" icon="icon-plus"}
{/capture}

{capture name="buttons"}
    {$smarty.capture.add_button nofilter}
{/capture}

{include file="common/mainbox.tpl" title=__("cp_company_tab") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons select_languages=true}
