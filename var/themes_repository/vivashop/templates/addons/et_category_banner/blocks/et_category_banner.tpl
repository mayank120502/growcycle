{if $et_category_banner.banner_data}
<div class="et-category-banner" id="et_category_banner_{$block.block_id}">
{include file="addons/banners/blocks/carousel.tpl" items=$et_category_banner.banner_data}
<!--et_category_banner_{$block.block_id}--></div>
{/if}