{capture name="mainbox"}

<div id="content_cp_company_tab">

{if !empty($company_tab_content)}

<form action="{""|fn_url}" method="POST" name="update_cp_company_tab_form">
{foreach from=$company_tab_content item=tab_inside key=section_id}

    {capture assign="section_status"}{if $tab_inside.status == "A"}{__("active")}{else}{__("disabled")}{/if}{/capture}

    {include file="common/subheader.tpl" title=$tab_inside.section_description additional_id=$section_status target="#section_{$section_id}"}
    <input type="hidden" name="company_tab_content[{$section_id}][section_description]" value="{$tab_inside.section_description nofilter}">
    <div class="in collapse" id="section_{$section_id}">
        <textarea id="tab_content_{$section_id}"
            name="company_tab_content[{$section_id}][tab_content]"
            cols="55"
            rows="18"
            class="cm-wysiwyg input-large"
        >{if $tab_inside.tab_content}{$tab_inside.tab_content}{/if}</textarea>
    </div>
{/foreach}
</form>

{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{capture name="buttons"}
    {include file="buttons/save.tpl" but_name="dispatch[cp_company_tab.manage]" but_role="action" but_target_form="update_cp_company_tab_form" but_meta="cm-submit btn-primary"}
{/capture}

<!--content_cp_company_tab--></div>

{/capture}
{include file="common/mainbox.tpl" title=__("cp_company_tab") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons}
