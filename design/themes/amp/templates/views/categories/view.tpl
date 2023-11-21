<amp-state id="products">
    <script type="application/json">
        {
            "filter": "high-low",
            "sort_by": "product",
            "sort_order": "asc",
            "currency": "{$secondary_currency}"
        }
    </script>
</amp-state>

<amp-state id="category">
    <script type="application/json">
        {
            "cid": {$category_data.category_id}
        }
    </script>
</amp-state>

<main id="content" role="main" class="main amp-listing">
    <section class="amp-listing-content mx-auto flex flex-wrap pb4">
        <div class="col-3 xs-hide sm-hide flex flex-column">
            <div class="amp-side-panel pt4 pr4 pl3 self-center">
                <h2 class="h5 mb2">{__("categories")}</h2>

                {foreach $subcategories as $category}
                    <!-- Start Radio -->
                    <div class="amp-input amp-input-radio inline-block relative m0 p0 mb3">
                        <input
                            type="radio"
                            value="{$category.category_id}"
                            name="category"
                            id="{$category.category_id}"
                            class="relative"
                            {if $category_data.category_id == $category.category_id}checked=""{/if}
                            role="button"
                            tabindex="0"
                            on="tap:AMP.navigateTo(url='{"categories.view?category_id=`$category.category_id`"|fn_url}')"
                        >
                            <label for="{$category.category_id}" aria-hidden="true">
                            {$category.category}
                        </label>
                    </div>
                    <!-- End Radio -->
                {/foreach}
            </div>
        </div>

        <div class="col-12 md-col-7 pt2 pb3 md-px4 md-pt1 md-pb7">
            <div class="md-amp-header relative md-flex flex-wrap items-center md-mx0 md-mb2">
                <h1 class="h3 mb2 md-mt2 md-mb2 md-ml0 flex-auto px2">{$category_data.category}</h1>
                <div class="amp-listing-filters pt2 pb2 mb3 md-mb0">
                    <div class="amp-select-wrapper inline-block md-mr1 pl2 md-hide lg-hide">
                        <label for="categories" class="bold caps h6 md-h7">Show:</label>
                        <select
                            name="categories"
                            id="categories"
                            class="amp-select h6 md-h7"
                            on="change:AMP.navigateTo(url=event.value)"
                        >
                            {if $category.parent_id}
                            <option
                                value="{"categories.view?category_id=`$category.parent_id`"|fn_url}"
                            >
                                {__("all")}
                            </option>
                            {/if}
                            {foreach $subcategories as $category}
                            <option
                                value='{"categories.view?category_id=`$category.category_id`"|fn_url}'
                                {if $category_data.category_id == $category.category_id} selected{/if}>
                                {$category.category}
                            </option>
                            {/foreach}
                        </select>
                    </div>

                    {include file="common/sorting.tpl"}
                </div>
            </div>

            <amp-list
                [src]="'?json&clientId=CLIENT_ID(myCookieId)&cid=' + category.cid + '&sort_by=' + products.sort_by + '&sort_order=' + products.sort_order"
                src="?json&clientId=CLIENT_ID(myCookieId)"
                class="mx1 md-mxn1"
                height="350"
                [height] = "auto"
                width="300"
                layout="responsive"
                items="products"
                binding="refresh"
                single-item
            >
                {literal}
                    <template type="amp-mustache">
                        <a href="{{ url }}" target="_self" class="amp-listing-product text-decoration-none inline-block col-6 md-col-4 lg-col-3 px1 mb2 md-mb4 relative">
                            <div class="flex flex-column justify-between">
                                <div>
                                    {{#images_data}}
                                    <amp-img
                                        class="amp-listing-product-image mb2"
                                        src="{{ medium.image_path }}"
                                        width="{{ medium.width }}"
                                        height="{{ medium.height }}"
                                        layout="responsive"
                                        alt="{{ product }}"
                                        noloading=""
                                        sizes="(max-width:52rem) 44vw, 8rem"
                                        srcset="{{ small.image_path }} {{ small.width }}w,
                                                {{ medium.image_path }} {{ medium.width }}w,
                                                {{ large.image_path }} {{ large.width }}w,
                                                {{ large2.image_path }} {{ large2.width }}w
                                                "
                                    >
                                        <div placeholder="" class="amp-loader"></div>
                                    </amp-img>
                                    {{/images_data}}
                                    <h2 class="amp-listing-product-name h6">{{ product }}</h2>
                                    <div class="h6 mt1">{{{ display_price }}} </div>
                                </div>
                            </div>
                        </a>
                    </template>
                {/literal}
                <div overflow></div>
            </amp-list>

            <a href="{"categories.view?category_id=`$category_data.category_id`"|fn_url|remote_amp_prefix}" class="amp-btn caps m1 show">{__("show_more")}</a>
        </div>
    </section>
</main>