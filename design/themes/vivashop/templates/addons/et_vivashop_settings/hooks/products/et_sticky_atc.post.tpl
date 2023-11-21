<script>
function checkAtc(){
	hasAtc=$(".et-product-block__inner-wrapper .et-add-to-cart.et-in-stock").length;
	hasSoon=$(".et-product-block__inner-wrapper .ty-product-coming-soon").length;
	isOos=$(".et-product-block__inner-wrapper .et-add-to-cart.et-out-of-stock").length;

	if (hasAtc){
		$(".sticky-atc").show();
		if (isOos){
			$("#phone_sticky_atc").hide();
		}
		$(".sticky-oos").hide();
		$(".sticky-soon").hide();
	}else if (hasSoon){
		$(".sticky-atc").hide();
		$(".sticky-oos").hide();
		$(".sticky-soon").show();
	}else{
		$(".sticky-atc").hide();
		$(".sticky-oos").show();
		$(".sticky-soon").hide();
	}

	var content=$('.price-wrap').html();
	$('.sticky-price').html(content);

}

(function(_, $) {
	$.ceEvent('on', 'ce.ajaxdone', function(content) {
		// reload sticky add to cart
		checkAtc();
	});
}(Tygh, Tygh.$));
$( window ).load(function(){
	checkAtc();
	if ($(".et-product-atc").length){
		sticky_changer=$(".et-sticky-qty-changer");
		main_changer=$(".et-main-qty-changer");

		sticky_input=$(".ty-value-changer__input",sticky_changer);
		main_input=$(".ty-value-changer__input",main_changer);

		//arrow qty change
		$(".ty-value-changer__increase",sticky_changer).click(function(){
			x=main_input.val();
			sticky_input.val(x++);
			main_input.val(x++);
		});

		$(".ty-value-changer__increase",main_changer).click(function(){
			x=sticky_input.val();
			main_input.val(x++);
			sticky_input.val(x++);
		});

		$(".ty-value-changer__decrease",sticky_changer).click(function(){
			x=main_input.val();
			min=main_input.data('caMinQty');
			if (x>min){
				sticky_input.val(x--);
				main_input.val(x--);
			}
		});

		$(".ty-value-changer__decrease",main_changer).click(function(){
			x=sticky_input.val();
			min=main_input.data('caMinQty');
			if (x>min){
				main_input.val(x--);
				sticky_input.val(x--);
			}

		});

		//manual input qty change
		main_input.change(function(){
			x=main_input.val();
			sticky_input.val(x)
		});
		sticky_input.change(function(){
			x=sticky_input.val();
			main_input.val(x)
		});

	}
})

</script>


<div id="et-sticky-prod-wrapper" >
	{if !($addons.master_products.status == "A" && !$product.company_id) && !($addons.catalog_mode.status == "A" && $addons.catalog_mode.main_store_mode|default:"catalog"=="catalog")}
		<div class="button sticky-atc hidden-desktop" id="phone_sticky_atc">
			{$prefix="<span class='prefix'>+</span>"}
			{include file="buttons/button.tpl" 
				but_prefix=$prefix
				but_role="et_icon_text"
				but_external_click_id="button_cart_{$obj_id}"
				et_icon="et-icon-btn-cart"
				but_extra_class="et-add-to-cart cm-external-click et-atc-icon-only12"}
		<!--phone_sticky_atc--></div>
	{/if}
	<div class="et-sticky-content hidden-phone hidden-tablet">

		<div class="et-sticky-left">
			<div class="sticky-img">
				{if $product.main_pair.icon || $product.main_pair.detailed}
					{$et_thumb=$product.main_pair}
				{elseif $product.option_image_pairs}
					{$et_thumb=$product.image_pair_var|reset}
				{/if}
				<a class="cm-external-click" data-ca-scroll="et-product-page">
					{include file="common/image.tpl" images=$et_thumb image_width="53" image_height="53"}
					<span class="sticky-discount-label">
						{assign var="discount_label" value="discount_label_`$obj_id`"}
						{$smarty.capture.$discount_label nofilter}
					</span>
				</a>

			</div>
			<div class="sticky-title">
				<a class="cm-external-click et-product-title" data-ca-scroll="et-product-page">
					<bdi>{$product.product nofilter}</bdi>
				</a>
				<div class="et-flex">
					{if $smarty.capture.$product_amount|trim}
						<div class="ty-product-block__field-group et-stock">
							{$smarty.capture.$product_amount nofilter}
						</div>
					{/if}
					{$smarty.capture.et_rating nofilter}
				</div>
			</div>
		</div>

		<div class="et-sticky-right">
			<div class="sticky-price clearfix"></div>
			<div class="sticky-add-to-cart">
				{if $addons.master_products.status == "A"}
					{$is_allow_add_common_products_to_cart_list = $addons.master_products.allow_buy_default_common_product === "YesNo::YES"|enum}
				{/if}
				{if !(
							$addons.master_products.status == "A" 
							&& !$product.company_id
						) 
						|| (
							$addons.master_products.status == "A" && 
							($product.master_product_id || !$product.company_id) 
							&& $is_allow_add_common_products_to_cart_list
						)}
					<div class="sticky-soon hidden">
						<div class="et-product-atc">
							{if !($addons.catalog_mode.status == "A" && $addons.catalog_mode.main_store_mode|default:"catalog"=="catalog")}
								{include file="buttons/button.tpl" 
									but_text=$but_text|default:__("et_coming_soon")
									but_id=$but_id 
									but_href=$but_href 
									but_role="et_icon_text"
									but_target=$but_target 
									but_name=$but_name 
									but_onclick=$but_onclick 
									et_icon="et-icon-btn-clock"
									but_extra_class="et-add-to-cart et-btn-soon"}
							{/if}
						</div>
					</div>

					<div class="sticky-oos hidden">
						<div class="et-product-atc">
							<div class="et-atc-button-wrapper">{strip}
								{if !($addons.catalog_mode.status == "A" && $addons.catalog_mode.main_store_mode|default:"catalog"=="catalog") && $product.price>0}
									{include file="buttons/button.tpl" 
										but_text=__("text_out_of_stock")
										but_role="et_icon_text"
										et_icon="et-icon-btn-oos"
										but_extra_class="et-add-to-cart et-out-of-stock"}
								{/if}
									{if $smarty.capture.et_pp_wishlist|trim}
										<a class="text-button et-btn-icon-text et-add-to-wishlist et-button cm-external-click" data-ca-external-click-id="button_wishlist_{$product.product_id}"><i class="et-icon-btn-wishlist"></i></a>
									{/if}
									{$smarty.capture.et_pp_compare nofilter}
							{/strip}
							</div>
						</div>
					</div>

					<div class="sticky-atc hidden">
						<div class="et-product-atc">
							<div class="et-value-changer et-sticky-qty-changer et-small-value-changer1">
								{if $addons.master_products.status == "A" && ($product.master_product_id || !$product.company_id) && $is_allow_add_common_products_to_cart_list}
								  {$obj_id = $product.best_product_offer_id scope=parent}
									{$qty_no_id="qty_`$obj_id`_no_id"}
								{else}
									{$qty_no_id="`$qty`_no_id"}
								{/if}
								
								{$smarty.capture.$qty_no_id nofilter}
							</div>
							<div class="et-atc-button-wrapper">{strip}
								{if !($addons.catalog_mode.status == "A" && $addons.catalog_mode.main_store_mode|default:"catalog"=="catalog")}
									{include file="buttons/button.tpl" 
										but_text=__("add_to_cart") 
										but_role="et_icon_text"
										but_external_click_id="button_cart_{$obj_id}"
										et_icon="et-icon-btn-cart"
										but_extra_class="et-add-to-cart cm-external-click"}
								{/if}
									{if $smarty.capture.et_pp_wishlist|trim}
										<a class="text-button et-btn-icon-text et-add-to-wishlist et-button cm-external-click" data-ca-external-click-id="button_wishlist_{$product.product_id}"><i class="et-icon-btn-wishlist"></i></a>
									{/if}
									{$smarty.capture.et_pp_compare nofilter}
							{/strip}</div>
						</div>
					</div>
				{/if}
			</div>
		</div>
	</div>
</div>
