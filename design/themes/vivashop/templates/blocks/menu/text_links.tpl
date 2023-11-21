{** block-description:text_links **}

{if $block.properties.show_items_in_line == 'Y'}
    {assign var="inline" value=true}
{/if}

{if $items}
    <ul class="ty-text-links{if $inline && !$vs_submenu} ty-text-links_show_inline{/if}">
        {foreach from=$items item="menu" name="vs_menu"}
            <li class="ty-text-links__item ty-level-{$menu.level|default:0} level-{$menu.level|default:0}{if $menu.active} ty-text-links__active{/if}">
                <a {if $menu.href}href="{$menu.href|fn_url}"{/if} {if $menu.new_window === "YesNo::YES"|enum}target="_blank"{/if} class="item-{$smarty.foreach.vs_menu.index} ty-text-links__a">{$menu.item}</a> 
                {if $menu.subitems}
                    {include file="blocks/menu/text_links.tpl" items=$menu.subitems vs_submenu=true}
                {/if}
            </li>
        {/foreach}
    </ul>
{/if}