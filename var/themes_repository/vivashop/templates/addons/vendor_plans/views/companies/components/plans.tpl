<div class="et-vendor-plans">
<ul class="ty-vendor-plans{if $as_info} ty-vendor-plans-info cm-vendor-plans-info{/if}">
	{foreach from=$plans item=plan}
		{$hide = false}
		{if $as_info}
			{$hide = true}
			{if (!$plan_id && $plan.is_default) || $plan.plan_id == $plan_id}
				{$hide = false}
			{/if}
		{/if}
		<li class="ty-vendor-plans__item {if $plan.is_default} active{/if}{if $hide} hidden{/if}" data-ca-plan-id="{$plan.plan_id}">
			{if $plan.is_default}
				<div class="ty-vendor-plan-current-plan">
					{__("vendor_plans.best_choice")}
				</div>
			{/if}

			<div class="ty-vendor-plan-content {if $plan.is_default} vendor-plan-current{/if}">
				<div class="et-vendor-plan-header-wrapper">
					<h3 class="ty-vendor-plan-header">{$plan.plan}</h3>
					{if $plan.description}
						<div class="ty-vendor-plan-descr">
								<div class="et-vendor-plan-descr-span">{$plan.description nofilter}</div>
						</div>
					{/if}
				</div>
				{strip}
				<div class="et-vendor-plan-price-wrapper">
					<span class="ty-vendor-plan-price">
						{if floatval($plan.price)}
							{include file="common/price.tpl" value=$plan.price}
						{else}
								{__('free')}
						{/if}
					</span>
					{if $plan.periodicity != 'onetime'}
						<span class="ty-vendor-plan-price-period">{__("et_vendor_plans.per")}&nbsp;{__("vendor_plans.{$plan.periodicity}")}</span>
					{/if}</div>
				{/strip}

				<div class="ty-vendor-plan-params">
					{hook name="vendor_plans:vendor_plan_params"}
					<p>
						<i class="et-icon-check"></i>
						{if $plan.products_limit}
                            {__("vendor_plans.products_limit_value", [$plan.products_limit]) nofilter}
						{else}
                            {__("vendor_plans.products_limit_unlimited") nofilter}
						{/if}
					</p>
					<p>
						<i class="et-icon-check"></i>
						{if floatval($plan.revenue_limit)}
							{capture name="revenue"}
								{include file="common/price.tpl" value=$plan.revenue_limit}
							{/capture}
                            {__("vendor_plans.revenue_up_to_value", ["[revenue]" => $smarty.capture.revenue]) nofilter}
						{else}
                            {__("vendor_plans.revenue_up_to_unlimited") nofilter}
						{/if}
					</p>

					{$commissionRound = $plan->commissionRound()}

					{capture name="fee_value"}
					    {if $commissionRound > 0}
					        {$commissionRound}%
					    {/if}
					    
					    {if $plan->fixed_commission > 0.0}
					        {if $commissionRound > 0} + {/if}
					        {include file="common/price.tpl" value=$plan->fixed_commission}
					    {/if}
					{/capture}

					{if ($plan->fixed_commission > 0.0) || ($commissionRound > 0)}
						<p>
							<i class="et-icon-check"></i>
							    {__("vendor_plans.transaction_fee_value", [
							        "[value]" => "{$smarty.capture.fee_value nofilter}"
							    ]) nofilter}
						</p>
					{/if}
					
					{if $plan.vendor_store}
						<p class="et-vendor-plans-store">
							<i class="et-icon-check"></i>
							{__("vendor_plans.vendor_store")}
						</p>
					{else}
						<p class="et-vendor-plans-store">
							<i class="et-icon-blocked"></i>
							{__("et_vendor_plans.no_vendor_store")}
						</p>
					{/if}
					{/hook}
				</div>
				{if !$as_info}
					<div class="ty-vendor-plan-link">
						{include file="buttons/button.tpl" but_text=__("vendor_plans.choose") but_href="companies.apply_for_vendor?plan_id={$plan.plan_id}" but_role="text" but_meta="ty-btn__primary"}
					</div>
				{/if}
			</div>
		</li>
	{/foreach}
</ul>
</div>