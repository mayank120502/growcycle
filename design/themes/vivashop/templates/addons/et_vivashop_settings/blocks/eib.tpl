{$title1=$block.content.et_eib_block_1_title}
{$title2=$block.content.et_eib_block_2_title}
{$title3=$block.content.et_eib_block_3_title}
{$title4=$block.content.et_eib_block_4_title}

{$text1=$block.content.et_eib_block_1_text}
{$text2=$block.content.et_eib_block_2_text}
{$text3=$block.content.et_eib_block_3_text}
{$text4=$block.content.et_eib_block_4_text}

{$settings=$block.properties.et_settings}

{if $settings.et_icon_position=="L"}
	{$et_icon_position="et-info-block__left"}
{else}
	{$et_icon_position="et-info-block__top"}
{/if}

{$et_block_id="et-block-`$block.snapping_id`_`$block.grid_id`_`$block.block_id`"}


{if $settings.additional_colors_type|default:"S"=="C"}
	<style>
		.eib-{$block.block_id}{
			background: {$settings.main_bkg_color};
		}
		#{$et_block_id} .title, 
		#{$et_block_id} .text{
			color: {$settings.text};
		}

	</style>
{/if}


{function name="eib_block" counter=$counter title=$title text=$text icon=$icon}{strip}
<div class="ty-column4 clearfix">
	{$icon="icon_`$counter`"}
	<div class="img">
		<i class="{$icon} {$settings.$icon.value}" {if $settings.$icon.color_type|default:"S"=="C"}style="color: {$settings.$icon.color}; background: {$settings.$icon.bkg};"{/if}></i>
	</div>
	<div class="content">
		<div class="title">
			{$title}
		</div>
		<div class="text">
			{$text}
		</div>
	</div>
</div>
{/strip}{/function}

<div class="clearfix et-info-block__inner-wrapper {$et_icon_position}" id="{$et_block_id}">
	{eib_block counter="1" title=$title1 text=$text1 icon=$icon1}
	{eib_block counter="2" title=$title2 text=$text2 icon=$icon2}
	{eib_block counter="3" title=$title3 text=$text3 icon=$icon3}
	{eib_block counter="4" title=$title4 text=$text4 icon=$icon4}
</div>