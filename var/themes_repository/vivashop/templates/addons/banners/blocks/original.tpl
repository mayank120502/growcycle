{** block-description:original **}
{foreach from=$items item="banner" key="key"}
	{if $banner.type == "G" && $banner.main_pair.image_id}
	<div class="ty-banner__image-wrapper">
		{if $banner.url != ""}<a href="{$banner.url|fn_url}" class=""{if $banner.target == "B"}target="_blank"{/if}>{/if}
			<div style="max-height: {$banner.main_pair.icon.image_y}px; overflow: hidden;" class="et-main-banner-img">
        {include 
            file="common/image.tpl"
            images=$banner.main_pair
            image_auto_size=true
            image_width=$block.content.width
            image_height=$block.content.height
        }
    	</div>
		{if $banner.url != ""}</a>{/if}
	</div>
	{else}
		<div class="ty-wysiwyg-content">
			{$banner.description nofilter}
		</div>
	{/if}
{/foreach}