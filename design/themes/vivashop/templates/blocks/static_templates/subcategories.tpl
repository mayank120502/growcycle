{math equation="ceil(n/c)" assign="rows" n=$subcategories|count c=$columns|default:"2"}
{split data=$subcategories size=$rows assign="splitted_subcategories"}

{assign var="root_categ" value=$category_data.id_path|regex_replace:"/\/(.*)/":""}

<div class="vs-sidebox clearfix">
    <h2 class="vs-sidebox-title">
            <span>{__("browse_by_category")}</span>
            <span class="vs-title-toggle cm-combination visible-phone visible-tablet" id="sw_sidebox_{$block.block_id}">
                <i class="ty-sidebox__icon-open ty-icon-down-open"></i>
                <i class="ty-sidebox__icon-hide ty-icon-up-open"></i>
            </span>
    </h2>
    <div class="vs-toggle-body vs-sidebox-body vs-side-subcateg clearfix" id="sidebox_{$block.block_id}">

        {foreach from=0|fn_get_categories_tree item=item1 name=item1}
            {assign var="categ_path" value="/"|explode:$category_data.id_path}
            {assign var="item_path" value="/"|explode:$item1.id_path}
            {assign var="level" value=$item1.level}

            {if $categ_path.$level == $item_path.$level}
                {assign var="current" value=true}
            {else}
                {assign var="current" value=false}
            {/if}

            <div class="item1-wrapper">
                <a href="{"categories.view?category_id=`$item1.category_id`"|fn_url}" class="item1 {if $current}active{/if}">
                    {$item1.category}
                </a>
                {if $item1.subcategories && $current}
                    {include file="common/subcateg_list.tpl" categ_id=$item1.category_id limit=1}
                {/if}
            </div>
        {/foreach}

    </div>
</div>
