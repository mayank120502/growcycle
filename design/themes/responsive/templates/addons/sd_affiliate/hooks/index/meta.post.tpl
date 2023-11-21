{if $addons.seo.status != 'A' && $url_has_aff_id_parameter}
    {$aff_canonical_url = $config.current_url|fn_query_remove:"aff_id"}
    <link rel="canonical" href="{$aff_canonical_url}" />
{/if}
