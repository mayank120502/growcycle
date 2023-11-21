{** block-description:et_featured_vendors_sidebar **}
{$et_on_vs=(strpos($smarty.request.dispatch,'companies')===0)}

{assign var="obj_prefix" value="`$block.block_id`000"}
{if $items}
	<div class="et-featured-vendor-sidebar">
		{foreach from=$items item=v key=k}
			<div class="et-vendor-box__wrapper ty-column2">
			    <div class="et-vendor-box">
			    	<div class="ty-center scroll-vendor-image">
			    		<a href="{"companies.view?company_id=`$v.id`"|fn_url}"  {if !$et_on_vs}target="_blank"{/if}>
			    			{include file="common/image.tpl" images=$v.logo.theme.image image_width="108" image_height="108" et_lazy=true}
		    	    </a>
			    	</div>
			    </div>
			</div>
		{/foreach}
	</div>
{/if}
