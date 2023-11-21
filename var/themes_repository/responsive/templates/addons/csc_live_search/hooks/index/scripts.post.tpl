{assign var=cls_settings value=fn_cls_get_settings()}
{script src="js/addons/csc_live_search/func.js"}
{$clsm_active = 'false'}
{if $cls_settings.clsm_status && !empty($cls_settings["clsm_motivation_text_`$smarty.const.CART_LANGUAGE`"])}
	{script src="js/addons/csc_live_search/theater.min.js"}
    {$clsm_active = 'true'}
{/if}
<script>
var cls_wishlist = JSON.parse('{fn_csc_ls_get_wishlist_products() nofilter}');
var cls_cart = JSON.parse('{fn_csc_ls_get_cart_products() nofilter}');
var cls_comp_list = JSON.parse('{fn_csc_ls_get_comparison_list() nofilter}');

$(document).ready(function(){	
	fn_cls_init_search($('html'));	
});
(function (_, $) {
  $.ceEvent('on', 'ce.commoninit', function (context) {
  	fn_cls_init_search(context);
  });
})(Tygh, Tygh.$);

function fn_cls_init_search(context){	
	$("form[name='search_form']", context).csc_live_search(
		{		
			block_enter: "{$cls_settings.block_enter_press}",
			characters_limit: {$cls_settings.characters_limit},		
			currency: "{$secondary_currency}",
			clsm_active: {$clsm_active},
			curl: "{$config.current_url nofilter}",
			runtime_company_id: "{$runtime.company_id|default:0}",
			runtime_storefront_id: "{$runtime.storefront_id|default:0}",
			runtime_uid: "{$auth.user_id}",
			sl: '{$smarty.const.CART_LANGUAGE}',
			url: '{fn_get_cls_url()}',
			clsm_redirect_category: "{$cls_settings.clsm_redirect_category}",
			check_promotion: '{fn_cls_is_active_promotions()}',
			{if $clsm_active}
			clsm_motivation: JSON.parse('{json_encode($cls_settings["clsm_motivation_text_`$smarty.const.CART_LANGUAGE`"]) nofilter}'),
			{/if}
			{if $addons.warehouses.status=="A"}
			warehouses: "1",
			{/if}
		}
	);	
}

(function($){	
    $.extend(Tygh.lang, {
        clsShowMore: "{__("cls.show_more")|strip}",
		clsShowAll: "{__("cls.show_all")|strip}",
		clsTotalFound: "{__("cls.total_found")}",
		clsFeaturedProducts: "{__("cls.featured_products")|strip}",
		clsFoundProducts: "{__("cls.found_products")|strip}",
		clsBrowseByCategories: "{__("cls.browse_products_by_category")|strip}",
		clsBackToCats: "{__("cls.back_to_all_cats")|strip}",
		clsStorefrontsCats: "{__("cls.storefronts_categories")|strip}",
		clsTextPages: "{__("cls.text_pages_and_blog")|strip}",
		clsBrands: "{__("cls.brand_pages")|strip}",
		clsVendors: "{__("cls.vendor_pages")|strip}",
		clsPorposeCorrection: "{__("cls.porpose_correction")|strip}",
		clsPopularSearchs: "{__("cls.popular_searches")|strip}",
		clsCategories: "{__("cls.found_categories")|strip}",
		clsProductCode: "{__("cls.product_code")|strip}",
		clsEnterSymbols: "{__("cls.enter_more_symbols", [{$cls_settings.characters_limit}])}",
		clsNothingFound: {if $cls_settings.search_products=="Y"}"{__("cls.nothing_found")|strip}"{else}"{__("search_results")|strip}:"{/if},
		clsQuickView: "{__("quick_view")|strip}",
    });
	
})(jQuery);

</script>
