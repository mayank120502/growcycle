<div id="breadcrumbs_{$block.block_id}" class="et-breadcrumbs">

{if $breadcrumbs && $breadcrumbs|@sizeof > 1}
{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
<div class="et-container">
	<div class="ty-breadcrumbs clearfix">
		{strip}
			{foreach from=$breadcrumbs item="bc" name="bcn" key="key"}
				{if $key != "0"}
					<span class="et-breadcrumbs-separator"></span>
				{/if}
				{if $bc.link}
					<a href="{$bc.link|fn_url}" class="ty-breadcrumbs__a{if $additional_class} {$additional_class}{/if}"{if $bc.nofollow} rel="nofollow"{/if}>{$bc.title|strip_tags|escape:"html" nofilter}</a>
				{else}
          <span class="ty-breadcrumbs__current"><bdi>{$bc.title|strip_tags|escape:"html" nofilter}</bdi></span>
				{/if}
			{/foreach}
			{if $smarty.const.ET_DEVICE == "D" || $et_traditional_resp}
				<div class="visible-desktop">{include file="common/view_tools.tpl"}</div>
			{/if}
		{/strip}
	</div>
	{if $smarty.const.ET_DEVICE != "D" || $et_traditional_resp}
		<div class="hidden-desktop">{include file="common/view_tools.tpl"}</div>
	{/if}
</div>
{/if}
<!--breadcrumbs_{$block.block_id}--></div>