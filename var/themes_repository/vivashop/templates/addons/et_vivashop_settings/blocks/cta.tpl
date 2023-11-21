{$main_title=$block.content.et_cta_title_text} 

{$title1=$block.content.et_cta_step_1_title}
{$title2=$block.content.et_cta_step_2_title}
{$title3=$block.content.et_cta_step_3_title}

{$text1=$block.content.et_cta_step_1_text}
{$text2=$block.content.et_cta_step_2_text}
{$text3=$block.content.et_cta_step_3_text}

{$start=$block.content.et_cta_button_text}
{$url=$block.content.et_cta_button_url}

{$settings=$block.properties.et_settings}

<style>
	.cta-block-wrapper{
		background: url({$block.et_image_data.main_pair.detailed.image_path}) center right fixed {$settings.main_bkg_color};
		position: relative;
	}
	{if $settings.overlay_type|default:"S"=="C" && isset($settings.use_bkg_overlay) && $settings.use_bkg_overlay=="Y"}
	.cta-block-wrapper:before{
		{$bkg_overlay = implode(",",sscanf($settings.overlay, "#%02x%02x%02x"))}
		background: rgba({$bkg_overlay},{$settings.overlay_alpha/100});
	}
	{/if}

	{if $settings.additional_colors_type|default:"S"=="C"}
		.cta-title{
			color: {$settings.text_top};
		}
		.cta-circle{
			{$bkg = implode(",",sscanf($settings.circles_bkg, "#%02x%02x%02x"))}
			background: rgba({$bkg},0.80);
		}
		.cta-circle:hover{
			background: {$settings.circles_bkg};
		}
		.cta-step-nr{
			background: {$settings.circles_step_bkg};
			color: {$settings.circles_steps_txt};
		}
		.cta-step-title,
		.cta-step-text{
			color: {$settings.circles_text};
		}
		.cta-button a{
			background: {$settings.go_btn_bkg};
			color: {$settings.go_btn_txt};
		}
		.cta-button a:hover{
			background: {$settings.go_btn_bkg_hover};
			color: {$settings.go_btn_txt_hover};
		}
		.cta-arrow{
			{$bkg = implode(",",sscanf($settings.arrow, "#%02x%02x%02x"))}
			color: rgba({$bkg},0.75);
		}
	{/if}
</style>

{function name="cta_block" step=$step title=$title text=$text}{strip}
<div class="cta-circle cta-step-{$step}">
	<div>
		{$icon="icon_`$step`"}
		<i class="{$settings.$icon.value}" {if $settings.$icon.color_type|default:"S"=="C"}style="color: {$settings.$icon.color};"{/if}></i>
	</div>
	<div class="cta-step-title">
		<div class="cta-step-nr"><span>{$step}</span></div>
		<span>{$title}</span>
	</div>
	<div class="cta-step-text">
		{$text nofilter}
	</div>
</div>
<div class="cta-arrow"><i class="et-icon-cta-arrow"></i></div>
{/strip}{/function}

{strip}
<div class="cta-block-wrapper lazy">
	<div class="cta-text clearfix">
		<div class="cta-title">{$main_title}</div>
		
		<div class="cta-wrapper">
			{cta_block step="1" title=$title1 text=$text1}
			{cta_block step="2" title=$title2 text=$text2}
			{cta_block step="3" title=$title3 text=$text3}

			<div class="cta-circle cta-button-wrapper">
				<div class="cta-button"><a href='{$url|fn_url}'>{$start}</a></div>

			</div>
		</div>
	</div>
</div>
{/strip}