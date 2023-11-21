{assign var="product_detail_view_url" value="products.view?product_id=`$product.product_id`"}
{capture name="product_detail_view_url"}
{** Sets product detail view link *}
{hook name="products:product_detail_view_url"}
{$product_detail_view_url}
{/hook}
{/capture}

{$product_detail_view_url = $smarty.capture.product_detail_view_url|trim}

{if $addons.et_vivashop_mv_functionality.et_product_link=="vendor"}
	{if $product.company_id && $product.company_has_store}
	  {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
	  {if !$smarty.request.company_id}
	    {$et_add_blank='target="_blank"'}
	  {else}
	    {$et_add_blank=''}
	  {/if}
	{else}
	  {$product_detail_view_url="products.view&product_id=`$product.product_id`"}
	  {$et_add_blank=''}
	{/if}
{else}
	{$et_add_blank=''}
	{if $use_vendor_url}
		  {$product_detail_view_url="companies.product_view&product_id=`$product.product_id`&company_id=`$product.company_id`"}
	{else}
	  {$product_detail_view_url="products.view&product_id=`$product.product_id`"}
	{/if}
{/if}

{if !$image_width}
	{$image_width=$settings.Thumbnails.product_lists_thumbnail_width}
{/if}

{if !$image_height}
	{$image_height=$settings.Thumbnails.product_lists_thumbnail_height}
{/if}


{capture name="main_icon"}
	<a href="{"$product_detail_view_url"|fn_url}" {$et_add_blank nofilter}>
		{include file="common/image.tpl" obj_id=$obj_id_prefix images=$product.main_pair image_width=$image_width image_height=$image_height  et_lazy=true et_lazy_owl=false}
	</a>
{/capture}

{if $product.image_pairs && $show_gallery}
	<div class="ty-center-block">
		<div class="ty-thumbs-wrapper owl-carousel cm-image-gallery" data-ca-items-count="1" data-ca-items-responsive="true" id="icons_{$obj_id_prefix}">
			{if $product.main_pair}
				<div class="1 cm-gallery-item cm-item-gallery">
					{$smarty.capture.main_icon nofilter}
				</div>
			{/if}
			{foreach from=$product.image_pairs item="image_pair"}
				{if $image_pair}
					<div class="2 cm-gallery-item cm-item-gallery">
						<a href="{"$product_detail_view_url"|fn_url}" {$et_add_blank nofilter}>
							{include file="common/image.tpl" no_ids=true images=$image_pair image_width=$image_width image_height=$image_height lazy_load=true et_lazy=true et_lazy_owl=true}
						</a>
					</div>
				{/if}
			{/foreach}
		</div>
	</div>
{else}
	{$smarty.capture.main_icon nofilter}
{/if}