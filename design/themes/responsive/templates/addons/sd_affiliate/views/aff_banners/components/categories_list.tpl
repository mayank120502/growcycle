<table class="ty-table">
    <thead><tr><th  class="hidden-desktop"></th></tr></thead>
    <tbody>
    {foreach from=$banner_categories key="category_id" item="category" name="b_categories"}
        <tr>
            <td class="ty-valign-top" style="width: 100%">
                <span class="subcategories"><a href="{"categories.view?category_id=`$category.category_id`"|fn_url}">{$category.category}</a></span>
                <p><span class="category-description">{$category.description nofilter}</span></p>
            </td>
        </tr>
    {foreachelse}
        <tr class="ty-table__no-items">
            <td colspan="1"><p class="ty-no-items">{__("no_items")}</p></td>
        </tr>
    {/foreach}
    </tbody>
</table>

{capture name="mainbox_title"}{__("categories")}{/capture}