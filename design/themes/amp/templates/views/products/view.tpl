{$obj_id = $product.product_id}
{$is_inventory_tracking = $settings.General.inventory_tracking == "Y"}

{if $product.is_edp != "Y" && $is_inventory_tracking}
    {$product_amount = $product.inventory_amount|default:$product.amount}
{/if}

{$width = $addons.sd_accelerated_pages.product_details_thumbnail_width}
{$height = $addons.sd_accelerated_pages.product_details_thumbnail_height}

<amp-state id="product">
    <script type="application/json">
        {
            "selectedSlide": 0
        }
    </script>
</amp-state>

<main id="content" role="main" class="main">
    <section class="flex flex-wrap pb4 md-pb7">
        <div class="col-12 md-col-5 px2 pt2 pb1 md-pl7 md-pt4">
            {if $product.main_pair || $product.image_pairs}
                <amp-carousel id="product-carousel" width="{$width}" height="{$height}" loop layout="responsive" type="slides" [slide]="product.selectedSlide" {literal}on="slideChange: AMP.setState({product: {selectedSlide: event.index}})"{/literal}>
                    {if $product.main_pair}
                        {include file="common/image.tpl" image=$product.main_pair width=$width height=$height tabindex=0 type="product_image"}
                    {/if}

                    {foreach $product.image_pairs as $pair_id => $image}
                        {include file="common/image.tpl" image=$image width=$width height=$height tabindex=$image.position type="product_image"}
                    {/foreach}
                </amp-carousel>

                {if (!empty($product.image_pairs))}
                    <amp-carousel class="carousel-preview center"
                        width="auto"
                        height="100"
                        layout="fixed-height"
                        type="carousel">
                        {if $product.main_pair}
                            {$image_data = fn_image_to_display($product.main_pair, 200, 150)}
                            <button on="tap:product-carousel.goToSlide(index=0)">
                              <amp-img src="{$image_data.image_path}"
                                width="200"
                                height="150"
                                layout="responsive"
                                alt="{$image_data.alt}"></amp-img>
                            </button>
                        {/if}

                        {foreach $product.image_pairs as $pair_id => $image}
                            {$image_data = fn_image_to_display($image, 200, 150)}
                            <button on="tap:product-carousel.goToSlide(index={$image.position})">
                                {include
                                    file="common/image.tpl"
                                    image=$image
                                    width=200
                                    height=150
                                    tabindex=$image.position
                                    sizes="100px"
                                    type="product_image_thumb"
                                }
                            </button>
                        {/foreach}
                    </amp-carousel>
                {/if}
            {/if}
        </div>
        <div class="col-12 md-col-7 flex flex-wrap content-start px2 md-pl5 md-pr7 md-pt4">
            {hook name="products:main_info"}
                <div class="col-12 self-start pb2">
                    {hook name="products:main_info_title"}
                        <h1 class="h4 md-h3 pb2">{$product.product nofilter}</h1>
                    {/hook}
                    {if $product.price|floatval || $product.zero_price_action == 'P'}
                        <div class="h6 md-h4">{include file="common/price.tpl" value=$product.price class="ty-price-num"}</div>
                    {/if}
                </div>
            {/hook}

            <hr class="mb3">

            <div class="col-12 self-start mb3 amp-product-btn-wrapper">
                {if $settings.General.allow_anonymous_shopping == "allow_shopping" || $auth.user_id}
                    {if ($product_amount > 0 && $product_amount >= $product.min_qty && $product.price > 0) && $is_inventory_tracking}
                        <a 
                            id="button_cart"
                            class="amp-btn amp-btn-secondary caps"
                            href="{"products.view?product_id=`$obj_id`"|fn_url|remote_amp_prefix}"
                        >
                            {__("buy_now")}
                        </a>
                    {else}
                        <a
                            id="button_cart"
                            class="amp-btn amp-btn-secondary caps"
                            href="{"products.view?product_id=`$obj_id`"|fn_url|remote_amp_prefix}"
                        >
                            {__("sd_accelerated_pages.view_detailes")}
                        </a>
                    {/if}
                {else}
                    <a
                        id="button_cart"
                        class="amp-btn amp-btn-secondary caps"
                        href="{"products.view?product_id=`$obj_id`"|fn_url|remote_amp_prefix}"
                    >
                        {__("text_login_to_add_to_cart")}
                    </a>
                {/if}
            </div>

            {hook name="products:product_detail_bottom"}
            {/hook}

            <hr class="md-hide lg-hide">
        </div>

        <div class="col-12 flex flex-wrap pb3">
            <hr class="xs-hide sm-hide mt2">
            <div class="col-12 md-col-6 px2 md-pl7 amp-product-desc">
                <section class="pt3 md-pt6 md-px4">
                    {hook name="products:descriptions"}
                        {foreach $tabs as $tab}
                            {if $tab.html_id == "description" && ($product.full_description || $product.amp_description)}
                                <h2 class="h5 md-h4">{$tab.name}</h2>
                                <div class="mt2 mb3">
                                    {if $product.amp_description}
                                        {$product.amp_description nofilter}
                                    {else}
                                        {$product.full_description|amp_clear_html nofilter}
                                    {/if}
                                </div>
                                <hr>
                            {/if}
                        {/foreach}
                    {/hook}
                </section>
            </div>
            <div class="col-12 md-col-5 md-pr7 md-pl5">
                <section class="pt3 pb3 md-pb4 px2 md-pt6">
                    {foreach $tabs as $tab}
                        {if $tab.html_id == "features" && $product.product_features}
                            <h2 class="h5">{$tab.name}</h2>
                            <div class="mt2">
                                {include file="components/product_features.tpl" product_features=$product.product_features}
                            </div>
                        {/if}
                    {/foreach}
                </section>
            </div>
        </div>
    </section>
</main>
