{hook name="categories:view"}
<div id="category_products_{$block.block_id}">

{if $products}
{assign var="layouts" value=""|fn_get_products_views:false:0}
{if $category_data.product_columns}
	{assign var="product_columns" value=$category_data.product_columns}
{else}
	{assign var="product_columns" value=$settings.Appearance.columns_in_products_list}
{/if}

{$is_selected_filters = $smarty.request.features_hash}

{if $layouts.$selected_layout.template}
	{include file="`$layouts.$selected_layout.template`" columns=$product_columns}
{/if}

{* {elseif !$subcategories || $show_no_products_block}
<p class="ty-no-items cm-pagination-container">{__("text_no_products")}</p> *}
{elseif !$show_not_found_notification && $is_selected_filters}
  {include file="common/no_items.tpl"
      text_no_found=__("text_no_products_found")
      no_items_extended=true
      reset_url=$config.current_url|fn_query_remove:"features_hash"
  }
{elseif !$subcategories || $show_no_products_block}
  {include file="common/no_items.tpl"
      text_no_found=__("text_no_products")
  }
{else}
{* <p class="ty-no-items cm-pagination-container">{__("text_no_products")}</p> *}
	{include file="common/no_items.tpl"
	    text_no_found=__("text_no_products")
	}
{/if}
<!--category_products_{$block.block_id}--></div>

{/hook}
