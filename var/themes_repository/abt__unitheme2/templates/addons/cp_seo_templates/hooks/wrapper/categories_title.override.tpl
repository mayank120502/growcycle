{hook name="wrapper:categories_title"}
    <span>
        {if $custom_h1 && $addons.cp_seo_templates.use_custom_h1 == "Y"}
            {$custom_h1 nofilter}
        {elseif $category_data.h1}
            {$category_data.h1 nofilter}
        {elseif $smarty.capture.title|trim}
            {$smarty.capture.title nofilter}
        {else}
            {$category_data.category nofilter}
        {/if}
    </span>
{/hook}