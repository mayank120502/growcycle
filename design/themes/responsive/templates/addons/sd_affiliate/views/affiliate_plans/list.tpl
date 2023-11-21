{include file="addons/sd_affiliate/common/affiliate_menu.tpl"}
<div>
    {if $affiliate_plan}
        {if $auth.user_type == 'AffiliateUserTypes::CUSTOMER'|enum}
            <p class="affiliate-plan-description"><b>{__("addons.sd_affiliate.customers_plan_description")}</b></p>
            {if $affiliate_plan.description}
                <p>{$affiliate_plan.description nofilter}</p>
            {/if}
        {/if}

        {capture name="sd_affiliate_link_plan"}
            {$href = "profiles.add?aff_id={$auth.user_id}"|fn_url:"C":"http"}
            <div>
                <input type="text" value="{$href}" onclick="this.select();" readonly="readonly" class="ty-input-display" >
            </div>
        {/capture}

        <div class="buttons-container">
            <div class="ty-input-append">
                <span>{__("sd_affiliate.affiliate_plan_text", [
                    "[user_id]" => $auth.user_id,
                    "[aff_id_?]" => "?aff_id={$auth.user_id}",
                    "[aff_id_&]" => "&aff_id={$auth.user_id}",
                    "[link]" => {$smarty.capture.sd_affiliate_link_plan nofilter}
                ])}</span>
                {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum}
                    <p>{__("addons.sd_affiliate.aff_id_note")}</p>
                {/if}
            </div>
        </div>
        {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum}
            {if !empty($aff_url_to_homepage)}
                {capture name="sd_affiliate_friendly_link"}
                    <div>
                        <input type="text" value="{$aff_url_to_homepage}" onclick="this.select();" readonly="readonly" class="ty-input-display" >
                    </div>
                {/capture}
                <div class="buttons-container">
                    <div class="ty-input-append">
                        <div>{__("sd_affiliate.friendly_link_text", [
                            "[link]" => {$smarty.capture.sd_affiliate_friendly_link nofilter}
                        ])}</div>
                    </div>
                </div>
            {elseif !empty($general_affiliate_parameter)}
                <div class="buttons-container">
                    {__("addons.sd_affiliate.empty_attractive_url_frontend_text")}
                </div>
            {/if}
            {if $addons.sd_affiliate.use_multiple_promotions == 'N' && $aff_coupon_code && $affiliate_plan.payout_types.use_coupon.value}
                <div class="buttons-container">
                    <div class="ty-input-append">
                        {__("addons.sd_affiliate.affiliate_coupon_text")}
                        <div class="affiliate-coupon-code">
                            <input type="text" value="{$aff_coupon_code}" onclick="this.select();" readonly="readonly" >
                        </div>
                    </div>
                </div>
            {/if}
        {/if}
        <div class="clearfix affiliate-plan-block">
            {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum}
                <div class="ty-affiliate-table-wrapper">
                    {include file="common/subheader.tpl" title=__("affiliate_plan")}
                    <table class="ty-affiliate-summary__table">
                        <tr class="ty-affiliate-summary__row">
                            {if $affiliate_plan.name}
                                <td>{$affiliate_plan.name}</td>
                            {/if}
                        </tr>
                        <tr class="ty-affiliate-summary__row">
                            <td>{__("aff_cookie_expiration")}:</td>
                            <td>{$affiliate_plan.cookie_expiration|default:0}</td>
                        </tr>
                        {if $affiliate_plan.payout_types.init_balance.value}
                            <tr class="ty-affiliate-summary__row">
                                <td>{__("set_initial_balance")}:</td>
                                <td>{include file="common/price.tpl" value=$affiliate_plan.payout_types.init_balance.value}</td>
                            </tr>
                        {/if}
                        <tr class="ty-affiliate-summary__row">
                            {if $affiliate_plan.min_payment}
                                <td>{__("minimum_commission_payment")}:</td>
                                {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum}
                                    <td>{include file="common/price.tpl" value=$affiliate_plan.min_payment}</td>
                                {else}
                                    <td>{$affiliate_plan.min_payment}</td>
                                {/if}
                            {/if}
                        </tr>
                    </table>
                </div>
            {/if}

            {if $affiliate_plan.payout_types && $show_commissions_rates}
                <div class="affiliate-rates float-left ty-affiliate-table-wrapper">
                    {include file="common/subheader.tpl" title=$commission_rates_title}
                    <table class="ty-affiliate-summary__table">
                        {foreach from=$payout_types key="payout_id" item=payout_data name=payout_type}
                            {if $payout_data.default=="Y" && $affiliate_plan.payout_types.$payout_id.value && !($payout_data.id == 'use_coupon' && !$aff_coupon_code && $addons.sd_affiliate.use_multiple_promotions == 'N')}
                                <tr class="ty-affiliate-summary__row">
                                    {assign var="lang_var" value=$payout_data.title}
                                    <td {if $smarty.foreach.payout_type.first}class="no-border"{/if}>{__($lang_var)}:</td>
                                    <td {if $smarty.foreach.payout_type.first}class="no-border"{/if}>
                                        {if $auth.user_type == 'AffiliateUserTypes::PARTNER'|enum || $affiliate_plan.payout_types.$payout_id.value_type == 'P'}
                                            {include file="common/modifier.tpl" mod_value=$affiliate_plan.payout_types.$payout_id.value mod_type=$affiliate_plan.payout_types.$payout_id.value_type} {$affiliate_plan.payout_types.$payout_id.percent_type_title}
                                        {elseif $auth.user_type == 'AffiliateUserTypes::CUSTOMER'|enum && $affiliate_plan.payout_types.$payout_id.value_type == 'A'}
                                            {$affiliate_plan.payout_types.$payout_id.value}
                                        {/if}
                                    </td>
                                </tr>
                            {/if}
                        {/foreach}
                    </table>
                </div>
            {/if}
            {if $affiliate_plan.payout_types && $vendors_and_rates}
                <div class="affiliate-rates float-left ty-affiliate-table-wrapper">
                    <table class="ty-affiliate-summary__table">
                        <tr class="ty-affiliate-summary__row">
                            <td>
                                {include file="common/subheader.tpl" title=__("invited_vendors")}
                            </td>
                            <td>
                                {include file="common/subheader.tpl" title=$rates_title}
                            </td>
                        </tr>
                        {foreach $vendors_and_rates as $vendor_and_rate}
                            <tr class="ty-affiliate-summary__row">
                                <td class="no-border">
                                	{$vendor_and_rate.company}
                                </td>
                                <td {if $smarty.foreach.payout_type.first}class="no-border"{/if}>
                                    {if $vendor_and_rate.affiliates.value_type == 'P'}
                                        {include file="common/modifier.tpl" mod_value=$vendor_and_rate.affiliates.value mod_type=$affiliate_plan.payout_types.affiliates.value_type} {$vendor_and_rate.affiliates.percent_type_title}
                                    {elseif $vendor_and_rate.affiliates.value_type == 'A'}
                                        {include file="common/price.tpl" value=$vendor_and_rate.affiliates.value}
                                    {/if}
                                </td>
                            </tr>
                        {/foreach}
                    </table>
                </div>
            {/if}

        </div>

        {if $linked_products}
            {include file="common/subheader.tpl" title=__("linked_products")}
            <table class="ty-table table-width">
                <thead>
                    <tr>
                        <th style="width: 70%">{__("product_name")}</th>
                        <th style="width: 30%">{__("sales_commission")}</th>
                    </tr>
                </thead>
                {foreach from=$linked_products item=product}
                    <tr {cycle values=" ,class=\"table-row\""}>
                        <td>{include file="common/popupbox.tpl" id="product_`$product.product_id`" link_text=$product.product text=__("product") href="banner_products.view?product_id=`$product.product_id`" content=""}</td>
                        <td>{include file="common/modifier.tpl" mod_value=$product.sale.value mod_type=$product.sale.value_type}</td>
                    </tr>
                {/foreach}
            </table>
        {/if}

        {if $linked_categories}
            {include file="common/subheader.tpl" title=__("linked_categories")}
            <table class="ty-table table-width">
                <thead>
                    <tr>
                        <th style="width: 70%">{__("category_name")}</th>
                        <th style="width: 30%">{__("sales_commission")}</th>
                    </tr>
                </thead>
                {foreach from=$linked_categories item=category}
                    <tr {cycle values=" ,class=\"table-row\""}>
                        <td><a href="{"categories.view?category_id=`$category.category_id`"|fn_url}" class="manage-root-item" target="_blank">{$category.category}</a></td>
                        <td>{include file="common/modifier.tpl" mod_value=$category.sale.value mod_type=$category.sale.value_type}</td>
                    </tr>
                {/foreach}
            </table>
        {/if}
        {if fn_allowed_for("MULTIVENDOR")}
            {hook name="affiliate_plans:linked_vendors"}
                {if $linked_vendors}
                    {include file="common/subheader.tpl" title=__("sd_affilate.linked_vendors")}
                    <table class="ty-table table-width">
                        <thead>
                            <tr>
                                <th style="width: 70%">{__("vendor_name")}</th>
                                <th style="width: 30%">{__("sales_commission")}</th>
                            </tr>
                        </thead>
                        {foreach from=$linked_vendors item=company}
                            <tr {cycle values=" ,class=\"table-row\""}>
                                <td><a href="{"companies.view?company_id=`$company.company_id`"|fn_url}" class="manage-root-item" target="_blank">{$company.company}</a></td>
                                <td>{include file="common/modifier.tpl" mod_value=$company.sale.value mod_type=$company.sale.value_type}</td>
                            </tr>
                        {/foreach}
                    </table>
                {/if}
            {/hook}
        {/if}
        {if $coupons && $addons.sd_affiliate.use_multiple_promotions == 'Y'}
            {include file="common/subheader.tpl" title=__("coupons")}
            {hook name="affiliate_plans:coupons"}
                <table class="ty-table table-width">
                    <thead>
                        <tr>
                            <th style="width: 35%">{__("coupon_code")}</th>
                            <th style="width: 15%">{__("valid")}</th>
                            <th style="width: 30%">{__("addons.sd_affiliate.use_coupons_commission")}</th>
                        </tr>
                    </thead>
                    {foreach from=$coupons item=coupon}
                        {foreach from=$coupon.coupon_code item=coupon_value}
                            <tr {cycle values=" ,class=\"table-row\""}>
                                <td>{$coupon_value}</td>
                                {if !$coupon.from_date && !$coupon.to_date}
                                    <td>{__("addons.sd_affiliate.coupon_period_not_set")}</td>
                                {else}
                                    <td class="nowrap{if $coupon.from_date <= $coupon.current_date && $coupon.to_date >= $coupon.current_date} strong{/if}">{if $coupon.from_date}{$coupon.from_date|date_format:"`$settings.Appearance.date_format`"} - {else}{__("avail_till")} {/if}{$coupon.to_date|date_format:"`$settings.Appearance.date_format`"}</td>
                                {/if}
                                <td>{include file="common/modifier.tpl" mod_value=$coupon.use_coupon.value mod_type=$coupon.use_coupon.value_type}</td>
                            </tr>
                        {/foreach}
                    {/foreach}
                </table>
            {/hook}
        {/if}

        {if $affiliate_plan.commissions}
            {include file="common/subheader.tpl" title=__("sd_affiliate.commissions")}
            <table class="ty-table table-width">
                <thead>
                    <tr>
                        <th style="width: 70%">{__("multi_tier_affiliates")}</th>
                        <th style="width: 30%">{__("commission")}</th>
                    </tr>
                </thead>
                {foreach from=$affiliate_plan.commissions key="com_id" item="commission"}
                    <tr {cycle values=" ,class=\"table-row\""}>
                        <td>{__("level")} {$com_id+1}</td>
                        <td>{include file="common/modifier.tpl" mod_value=$commission mod_type="P"}</td>
                    </tr>
                {/foreach}
            </table>
        {/if}
    {else}
        <p>{__("text_no_affiliate_assigned")}.</p>
    {/if}
    {hook name="affiliate_plans:become_pro_affiliate"}
    {if $auth.user_id && $auth.user_type == 'AffiliateUserTypes::CUSTOMER'|enum}
        {capture name=sd_affiliate_become_super_affiliate_button}
            <div class="buttons-container">
                {if $addons.sd_affiliate.allow_all_customers_be_affiliates == 'Y'}
                    {$link = "partners.become_super_affiliate?user_id={$auth.user_id}"}
                {else}
                    {$link = "profiles.update?user_type={"AffiliateUserTypes::PARTNER"|enum}"}
                {/if}
                {include
                    file="buttons/button.tpl"
                    but_text=__("addons.sd_affiliate.become_super_affiliate")
                    but_href=$link
                    but_role="text"
                    but_meta="ty-btn__secondary"}
            </div>
        {/capture}
        {__("addons.sd_affiliate.invitation_to_become_super_affiliate", [
            '[link]' => {$smarty.capture.sd_affiliate_become_super_affiliate_button nofilter}
        ])}
    {/if}
    {/hook}
</div>

{capture name="mainbox_title"}
    {__(affiliates_partnership)} <span class="subtitle">/ {__("affiliate_plan")}</span>
{/capture}

