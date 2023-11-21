{if $cp_json_ld_markups}
    {foreach from=$cp_json_ld_markups item="markup"}
        {if $markup.extra.special}
            {continue} {* you can add special markup via hook *}
        {/if}
        {if $markup.content}
            <script type="application/ld+json">
                {$markup.content nofilter}
            </script>
        {elseif $markup.alt_content}
            {$markup.alt_content nofilter}
        {/if}
    {/foreach}
{/if}

{hook name="cp_json_ld:footer_post"}
{/hook}