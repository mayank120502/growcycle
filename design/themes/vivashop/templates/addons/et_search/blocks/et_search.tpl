{* et - search *}
{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
<div class="ty-search-block">

    <form action="{""|fn_url}" name="search_form" method="get">
        <input type="hidden" name="subcats" value="Y" />
        <input type="hidden" name="pcode_from_q" value="Y" />
        <input type="hidden" name="pshort" value="Y" />
        <input type="hidden" name="pfull" value="Y" />
        <input type="hidden" name="pname" value="Y" />
        <input type="hidden" name="pkeywords" value="Y" />
        <input type="hidden" name="search_performed" value="Y" />

        {hook name="search:additional_fields"}{/hook}
        {assign var="o_spacer" value=$addons.et_search.o_spacer|default:""}
        {assign var="max_level" value=$addons.et_search.max_levels|default:"2"}

        {function name="search_subcategs" level=$level items=$cid spacer=$spacer}
        {foreach from=$items item="cat"}
            <option value="{$cat.category_id}" {if $runtime.mode == "search" && $smarty.request.cid == $cat.category_id}selected="selected"{elseif $smarty.request.category_id == $cat.category_id}selected="selected"{/if} title="{$cat.category nofilter}">
                    {$spacer nofilter}{$cat.category|truncate:100:"...":true nofilter}
            </option>
            {if $level<$max_level && $cat.has_children}
                {search_subcategs level=$level+1 items=$cat.subcategories spacer="`$spacer``$o_spacer`"}
            {/if}
        {/foreach}
        {/function}

        {if $smarty.const.ET_DEVICE == "D" || $et_traditional_resp}
        <select name="cid" class="energo-searchbox hidden">
            <option value="0">{__("all_categories")}</option>
            {search_subcategs level=1 items=$items spacer="`$o_spacer`"}
        </select>
        {/if}

        {strip}
            {if $settings.General.search_objects}
                {assign var="search_title" value=__("search")}
            {else}
                {assign var="search_title" value=__("search_products")}
                {if "MULTIVENDOR"|fn_allowed_for}
                    {assign var="search_title" value=__("et_search_marketplace_products")}
                {/if}
            {/if}
            <input type="text" name="q" value="{$search.q}" id="search_input{$smarty.capture.search_input_id}" title="{$search_title}" class="ty-search-block__input cm-hint" />
            {if $settings.General.search_objects}
                {include file="buttons/magnifier.tpl" but_name="search.results" alt=__("search")}
            {else}
                {include file="buttons/magnifier.tpl" but_name="products.search" alt=__("search")}
            {/if}
        {/strip}

        {capture name="search_input_id"}{$block.snapping_id}{/capture}

    </form>
</div>
