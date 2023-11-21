{hook name="index:ab__so_noindex"}
{if $cp_seo_index_rule}
    <meta name="robots" content="{$cp_seo_index_rule}" />
{elseif $cp_seo_filter_indexed}
    <meta name="robots" content="index,follow" />
{else}
    {if $seo_canonical.current}
        <link rel="canonical" href="{$seo_canonical.current}" />
    {/if}
    {if $seo_canonical.prev}
        <link rel="prev" href="{$seo_canonical.prev}" />
    {/if}
    {if $seo_canonical.next}
        <link rel="next" href="{$seo_canonical.next}" />
    {/if}
{/if}
{/hook}