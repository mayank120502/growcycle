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
									{$buying_types = $product.cp_buying_types|default:[]}
									{$buy_type = "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::BUY"|enum}
									{$buy = in_array($buy_type, $buying_types)}
									{$return_current_url = $config.current_url|escape:url}
									{$class = 'et-add-to-cart et-atc-icon-only cp-additional-buying-types'}
									{if $buy}
										{include file="buttons/button.tpl"
											but_id="button_cart_sticky_`$obj_prefix``$obj_id`"
											but_external_click_id="button_cart_{$obj_id}"
											but_name="dispatch[checkout.add..`$obj_id`]"
											but_role='et_icon'
											but_extra_class="$class cm-external-click"
											block_width=$block_width
											obj_id=$obj_id
											product=$product
											but_meta=$add_to_cart_meta
											et_icon="et-icon-btn-cart"
										}
									{/if}
									{foreach from=fn_cp_get_additional_product_buying_types(true) key=type item=but_text name=product_buying_types}
										{if in_array($type, $buying_types)}
											{$but_role = 'et_icon'}
											{$but_id = "cp_additional_add_btn_type_`$type`_`$obj_prefix``$obj_id`_sticky"}
											{$but_target_id = ''}
											{$but_onclick = ''}
											{$href = ''}
											{$but_title = $but_text}
											{$is_popup_opener = false}
											{$_class = $class}

											{if $type === "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::CONTACT_VENDOR"|enum}
												{$is_popup_opener = true}
												{$login_form = !$auth.user_id}
												{$icon = 'et-icon-mail'}
												{$href = "products.cp_contact_vendor?product_id=`$product.product_id`&obj=`$obj_prefix``$obj_id`&return_url=`$return_current_url`"|fn_url}
												{$redirect_url = $return_current_url}
												{$but_text = __('cp_new_buying_types.send_inquiry')}
											{else} {*"Addons\\CpNewBuyingTypes\\ProductBuyingTypes::START_ORDER"|enum*}
												{$login_form = !$auth.user_id && $settings.Checkout.disable_anonymous_checkout == "YesNo::YES"|enum}
												{$icon = 'et-icon-btn-cart4'}
												{$redirect_url = $href|urlencode}
												{$but_onclick = "\$.fn_cp_save_start_order_product_cart({$product.product_id}, \$(this));"}
											{/if}
											{if $login_form}
												{$is_popup_opener = true}
												{$href = "cp_nbt_login.start_login?redirect_url=`$redirect_url`"|fn_url}
												{$but_onclick = ''}
											{/if}

											{$contact_vendor_type = "Addons\\CpNewBuyingTypes\\ProductBuyingTypes::CONTACT_VENDOR"|enum}

											{if $is_popup_opener}
												{$_class = "$_class cm-dialog-opener cm-dialog-auto-size cm-dialog-destroy-on-close"}
												{$but_target_id = "content_$but_id"}
												{if $type != $contact_vendor_type}
													{$target_id = $but_id}
												{else}
													{$target_id = "opener_$but_id"}
												{/if}
												{$but_id = "opener_$but_id"}
											{/if}

											{if $type != $contact_vendor_type && !$auth.user_id}
												{$redirect_url = $return_current_url}
											{/if}

											{if !$auth.user_id}
												{$but_target_id = "cp_nbt_login_popup"}
												{if $type == $contact_vendor_type && $is_popup_opener}
													{$href = "cp_nbt_login.start_login?redirect_url=`$redirect_url`&target_id=`$target_id`&chph=Y&cp_msg=1"|fn_url}
												{else}
													{$href = "cp_nbt_login.start_login?redirect_url=`$redirect_url`&target_id=`$target_id`&cp_msg=2"|fn_url}
												{/if}
											{else}
												{if $type == $contact_vendor_type && fn_cp_nbt_is_phone_confirmed($auth.user_id) == 'N' && $is_popup_opener }
													{$but_target_id = "cp_nbt_login_popup"}
													{$href = "cp_nbt_login.start_login?redirect_url=`$redirect_url`&target_id=`$target_id`&chph=Y"|fn_url}
												{/if}
											{/if}

											{if $auth.user_id}
												{$dialog_class = "data-ca-dialog-class=send_lnquiry_popup "}
											{else}
												{$dialog_class = "data-ca-dialog-class=login_popup "}
											{/if}

											{include file="buttons/button.tpl"
												but_text=$but_text
												but_href=$href
												but_role=$but_role
												but_id=$but_id
												et_icon=$icon
												but_extra_class=$_class
												but_target_id=$but_target_id
												but_onclick=$but_onclick
												but_extra=$dialog_class
											}
										{/if}
									{/foreach}
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
