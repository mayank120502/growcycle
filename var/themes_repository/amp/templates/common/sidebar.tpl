<!-- Start Sidebar -->
<amp-sidebar id="header-sidebar" class="amp-sidebar px3  md-flex flex-column justify-content items-center justify-center" layout="nodisplay">
    <div class="flex justify-start items-center amp-sidebar-header">
        <div role="button" aria-label="close sidebar" on="tap:header-sidebar.toggle" tabindex="0" class="amp-navbar-trigger items-start">✕</div>
    </div>
    <nav class="amp-sidebar-nav amp-nav">
        <ul class="list-reset m0 p0 amp-label">
            <li>
                <a href="{""|fn_url|remote_amp_prefix}" class="text-decoration-none block 22">
                    <amp-img src="{$logos.theme.image.image_path}" width="{$logos.theme.image.image_x}" height="{$logos.theme.image.image_y}" layout="responsive" class="amp-sidebar-nav-image inline-block mb4" alt="Company logo" noloading="">
                        <div placeholder="" class="amp-loader"></div>
                    </amp-img>
                </a>
            </li>

            {foreach $root_categories as $category}
                <li class="amp-nav-item ">
                    <a class="amp-nav-link" href="{"categories.view?category_id=`$category.category_id`"|fn_url}">{$category.category}</a>
                </li>
            {/foreach}
        </ul>
    </nav>
</amp-sidebar>
<!-- End Sidebar -->