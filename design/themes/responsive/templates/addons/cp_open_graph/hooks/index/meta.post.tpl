{if $cp_graph_meta_data}
    {foreach $cp_graph_meta_data key="meta_name" item="meta_value"}
        {if $meta_value|is_array}
            {foreach from=$meta_value item="val"}
                <meta property="{$meta_name}" content="{$val}" />
            {/foreach}
        {else}
            <meta {if strpos($meta_name,  "product:") !== false}prefix="product: http://ogp.me/ns/product#"{/if} property="{$meta_name}" content="{$meta_value}" />
        {/if}
    {/foreach}
    <meta name="twitter:card" content="summary" />
    {if $addons.cp_open_graph.fb_app_id}
        <meta property="fb:app_id" content="{$addons.cp_open_graph.fb_app_id}">
    {/if}
{/if}
