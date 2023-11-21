<div class="ty-vendor-plans__title et-vendor-plans__title">

	<div class="ty-vendor-plans__title-desc">{__("vendor_plans.select_plan_text")}</div>
</div>

<input type="hidden" name="{$name}" class="cm-vendor-plans-selector-value" />

{$et_vendor_plans=$et_mv_settings.vendor_plans}

<style>
	.et-vendor-plans .ty-vendor-plans__item .et-vendor-plan-price-wrapper{
		background: {$et_vendor_plans.price_bkg};
		color: {$et_vendor_plans.price_text};
	}
	.et-vendor-plans .ty-vendor-plans__item .et-vendor-plan-price-wrapper .ty-vendor-plan-price-period{
		color: {$et_vendor_plans.price_text};
	}

	.et-vendor-plans .ty-vendor-plans__item.active .et-vendor-plan-price-wrapper{
		background: {$et_vendor_plans.best_bkg};
		color: {$et_vendor_plans.best_text};
	}
	.et-vendor-plans .ty-vendor-plans__item.active .et-vendor-plan-price-wrapper .ty-vendor-plan-price-period{
		color: {$et_vendor_plans.best_text};	
	}
	.et-vendor-plans .ty-vendor-plans__item.active{
		border-color: {$et_vendor_plans.best_outer_bkg};
	}
	.et-vendor-plans .ty-vendor-plans__item .ty-vendor-plan-current-plan{
		border-color: {$et_vendor_plans.best_outer_bkg};
		background: {$et_vendor_plans.best_outer_bkg};
		color: {$et_vendor_plans.best_outer_text};
	}
	.ty-vendor-plans__title-desc .et-highlight{
		color: {$et_vendor_plans.highlight_text};
	}
	.et-vendor-plans__footer .et-vendor-plans_footer_big,
	.et-vendor-plans__footer .et-vendor-plans_footer_small{
		color: {$et_vendor_plans.footer_text};
	}
</style>
{include file="addons/vendor_plans/views/companies/components/plans.tpl" plans=$vendor_plans}


{if $et_vendor_plans.show_footer}
<style>
	.et-vendor-plans__footer{
		background-color: {$et_vendor_plans.footer_bkg};
		background-image: url({$et_mv_settings.main_pair.detailed.image_path});
		/*background-repeat: no-repeat;*/
		/*{if $et_mv_settings.main_pair.detailed.image_path}
			background-image: url({$et_mv_settings.main_pair.detailed.image_path});
		{/if}*/
	}
</style>
<div class="et-vendor-plans__footer">
	<div class="et-vendor-plans__footer-text">{__("et_vendor_plans.footer")}</div>

	<div class="et-vendor-plans__footer-btn">{$et_link=__("et_vendor_plans.footer_button_link")}
		{$href=fn_url($et_link)}
		
		{include file="buttons/button.tpl" but_text=__("et_vendor_plans.footer_button_text") but_href=$href but_role="text" but_meta="ty-btn__primary"}</div>
</div>
{/if}

{capture name="mainbox_title"}<span>{__("vendor_plans.choose_your_plan")}</span>{/capture}
