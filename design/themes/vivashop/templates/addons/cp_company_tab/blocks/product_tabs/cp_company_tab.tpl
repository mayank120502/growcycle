{** block-description:cp_company_profile **}

{if !empty($product.company_id)}
    {assign var="company_tab_content" value=$product.company_id|fn_cp_company_tab_content}
    {assign var="tab_names" value=$company_tab_content}
    {if !empty($company_tab_content) && $addons.cp_company_tab.enable_company_tab == "YesNo::YES"|enum}
        <div class="hidden-phone hidden-tablet ">
            <table border=0><tr>
                {assign var="first_visible" value="YesNo::YES"|enum}
                {foreach from=$tab_names item="tab_name" key="section_id" name="titles"}
                    {if $tab_name.tab_content != ""}
                        <td id="cpt_title_{$section_id}" class="{if $smarty.foreach.titles.first}ty-cpt-td-active{else}ty-cpt-td{/if}">
                            {$tab_name.section_description nofilter}
                        </td>
                    {/if}
                {/foreach}
            </tr></table>

            {foreach from=$company_tab_content item="tab_inside" key="this_section_id" name="contents"}
                {if $smarty.foreach.contents.first}{assign var="active_section_id" value=$tab_inside.section_id}{/if}
                <div id="cpt_content_{$tab_inside.section_id}" class="ty-wysiwyg-content content-description et-tab-content{if !$smarty.foreach.contents.first} hidden{/if}">
                    <div>{$tab_inside.tab_content nofilter}</div>
                </div>
            {/foreach}
        </div>

        <div class="ty-accordion cm-accordion ui-accordion ui-widget ui-helper-reset hidden-desktop" id="accordion_id_0" role="tablist">
            {foreach from=$tab_names item="tab_name" key="section_id" name="titles_mobile"}
                {if $tab_name.tab_content != ""}
                    <h3 id="cpt_header_{$tab_name.section_id}" 
                        class="ui-accordion-header ui-corner-top ui-state-default ui-accordion-icons active 
                        {if $smarty.foreach.titles_mobile.first}
                            ui-state-hover ui-accordion-header-active ui-state-active
                        {else}
                            ui-accordion-header-collapsed ui-corner-all
                        {/if}" 
                        role="tab" 
                        aria-controls="cpt_content_{$tab_inside.section_id}" 
                        aria-selected="{if $smarty.foreach.titles_mobile.first}true{else}false{/if}" 
                        aria-expanded="{if $smarty.foreach.titles_mobile.first}true{else}false{/if}" 
                        tabindex="0"
                    >
                        <span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-s"></span>{$tab_name.section_description nofilter}
                    </h3>
                    <div id="cpt_content_{$tab_inside.section_id}" 
                        class="ty-wysiwyg-content content-description ui-accordion-content ui-corner-bottom ui-helper-reset ui-widget-content
                        {if $smarty.foreach.titles_mobile.first} ui-accordion-content-active{/if}" 
                        data-ca-accordion-is-active-scroll-to-elm="1" 
                        style="{if !$smarty.foreach.titles_mobile.first}display: none;{/if}" 
                        aria-labelledby="cpt_content_{$tab_inside.section_id}" 
                        role="tabpanel" 
                        aria-hidden="{if $smarty.foreach.titles_mobile.first}true{else}false{/if}"
                    >
                        <div>{$company_tab_content.$section_id.tab_content nofilter}</div>
                    </div>
                    
                {/if}
            {/foreach}
        </div>

    {else}
        <div>{__("no_data")}</div>
    {/if}
{/if}