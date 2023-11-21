{if isset($products)}

    {assign var="layouts" value=""|fn_get_products_views:false:0}
    {if $layouts.$selected_layout.template}
        {include file="`$layouts.$selected_layout.template`" columns=$settings.Appearance.columns_in_products_list}
    {/if}

    {if (empty($products))}
        <p class="ty-no-items cm-pagination-container">{__("text_no_products")}</p>
    {/if}

    {capture name="mainbox_title"}{__("products")}{/capture}
{elseif isset($banner_categories)}
    {include file="addons/sd_affiliate/views/aff_banners/components/categories_list.tpl"}
{/if}